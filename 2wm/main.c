/* (C)opyright MMVI-MMVII Anselm R. Garbe <garbeam at gmail dot com>
 * See LICENSE file for license details.
 */

#include "2wm.h"
#include <errno.h>
#include <locale.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/select.h>
#include <X11/cursorfont.h>
#include <X11/keysym.h>
#include <X11/Xatom.h>
#include <X11/Xproto.h>

/* extern */

int screen, sx, sy, sw, sh;
unsigned int master, nmaster, numlockmask;
unsigned long normcol, selcol;
Atom wmatom[WMLast], netatom[NetLast];
Bool running = True;
Bool selscreen = True;
Bool view = True;
Client *clients = NULL;
Client *sel = NULL;
Client *stack = NULL;
Cursor cursor[CurLast];
Display *dpy;
Window root;

/* static */

static int (*xerrorxlib)(Display *, XErrorEvent *);
static Bool otherwm;

static unsigned long
getcolor(const char *colstr) {
	Colormap cmap = DefaultColormap(dpy, screen);
	XColor color;

	if(!XAllocNamedColor(dpy, cmap, colstr, &color, &color))
		eprint("error, cannot allocate color '%s'\n", colstr);
	return color.pixel;
}

static void
cleanup(void) {
	close(STDIN_FILENO);
	while(stack) {
		resize(stack, True);
		unmanage(stack);
	}
	XUngrabKey(dpy, AnyKey, AnyModifier, root);
	XFreeCursor(dpy, cursor[CurNormal]);
	XFreeCursor(dpy, cursor[CurResize]);
	XFreeCursor(dpy, cursor[CurMove]);
	XSetInputFocus(dpy, PointerRoot, RevertToPointerRoot, CurrentTime);
	XSync(dpy, False);
}

static void
scan(void) {
	unsigned int i, num;
	Window *wins, d1, d2;
	XWindowAttributes wa;

	wins = NULL;
	if(XQueryTree(dpy, root, &d1, &d2, &wins, &num)) {
		for(i = 0; i < num; i++) {
			if(!XGetWindowAttributes(dpy, wins[i], &wa))
				continue;
			if(wa.override_redirect || XGetTransientForHint(dpy, wins[i], &d1))
				continue;
			if(wa.map_state == IsViewable)
				manage(wins[i], &wa);
		}
	}
	if(wins)
		XFree(wins);
}

/*
 * Startup Error handler to check if another window manager
 * is already running.
 */
static int
xerrorstart(Display *dsply, XErrorEvent *ee) {
	otherwm = True;
	return -1;
}

/* extern */

void
sendevent(Window w, Atom a, long value) {
	XEvent e;

	e.type = ClientMessage;
	e.xclient.window = w;
	e.xclient.message_type = a;
	e.xclient.format = 32;
	e.xclient.data.l[0] = value;
	e.xclient.data.l[1] = CurrentTime;
	XSendEvent(dpy, w, False, NoEventMask, &e);
	XSync(dpy, False);
}

void
quit(Arg *arg) {
	running = False;
}

/* There's no sy to check accesses to destroyed windows, thus those cases are
 * ignored (especially on UnmapNotify's).  Other types of errors call Xlibs
 * default error handler, which may call exit.
 */
int
xerror(Display *dpy, XErrorEvent *ee) {
	if(ee->error_code == BadWindow
	|| (ee->request_code == X_SetInputFocus && ee->error_code == BadMatch)
	|| (ee->request_code == X_PolyText8 && ee->error_code == BadDrawable)
	|| (ee->request_code == X_PolyFillRectangle && ee->error_code == BadDrawable)
	|| (ee->request_code == X_PolySegment && ee->error_code == BadDrawable)
	|| (ee->request_code == X_ConfigureWindow && ee->error_code == BadMatch)
	|| (ee->request_code == X_GrabKey && ee->error_code == BadAccess)
	|| (ee->request_code == X_CopyArea && ee->error_code == BadDrawable))
		return 0;
	fprintf(stderr, "2wm: fatal error: request code=%d, error code=%d\n",
		ee->request_code, ee->error_code);
	return xerrorxlib(dpy, ee); /* may call exit */
}

int
main(int argc, char *argv[]) {
	int i, j;
	unsigned int mask;
	Window w;
	XEvent ev;
	XModifierKeymap *modmap;
	XSetWindowAttributes wa;

	if(argc == 2 && !strncmp("-v", argv[1], 3))
		eprint("2wm-"VERSION", (C)opyright MMVII Anselm R. Garbe\n");
	else if(argc != 1)
		eprint("usage: 2wm [-v]\n");
	setlocale(LC_CTYPE, "");
	dpy = XOpenDisplay(0);
	if(!dpy)
		eprint("2wm: cannot open display\n");
	screen = DefaultScreen(dpy);
	root = RootWindow(dpy, screen);
	otherwm = False;
	XSetErrorHandler(xerrorstart);
	/* this causes an error if some other window manager is running */
	XSelectInput(dpy, root, SubstructureRedirectMask);
	XSync(dpy, False);
	if(otherwm)
		eprint("2wm: another window manager is already running\n");

	XSync(dpy, False);
	XSetErrorHandler(NULL);
	xerrorxlib = XSetErrorHandler(xerror);
	XSync(dpy, False);

	/* init atoms */
	wmatom[WMProtocols] = XInternAtom(dpy, "WM_PROTOCOLS", False);
	wmatom[WMDelete] = XInternAtom(dpy, "WM_DELETE_WINDOW", False);
	wmatom[WMState] = XInternAtom(dpy, "WM_STATE", False);
	netatom[NetSupported] = XInternAtom(dpy, "_NET_SUPPORTED", False);
	netatom[NetWMName] = XInternAtom(dpy, "_NET_WM_NAME", False);
	XChangeProperty(dpy, root, netatom[NetSupported], XA_ATOM, 32,
			PropModeReplace, (unsigned char *) netatom, NetLast);
	/* init cursors */
	cursor[CurNormal] = XCreateFontCursor(dpy, XC_left_ptr);
	cursor[CurResize] = XCreateFontCursor(dpy, XC_sizing);
	cursor[CurMove] = XCreateFontCursor(dpy, XC_fleur);
	/* init modifier map */
	numlockmask = 0;
	modmap = XGetModifierMapping(dpy);
	for (i = 0; i < 8; i++) {
		for (j = 0; j < modmap->max_keypermod; j++) {
			if(modmap->modifiermap[i * modmap->max_keypermod + j] == XKeysymToKeycode(dpy, XK_Num_Lock))
				numlockmask = (1 << i);
		}
	}
	XFreeModifiermap(modmap);
	/* select for events */
	wa.event_mask = SubstructureRedirectMask | SubstructureNotifyMask
		| EnterWindowMask | LeaveWindowMask;
	wa.cursor = cursor[CurNormal];
	XChangeWindowAttributes(dpy, root, CWEventMask | CWCursor, &wa);
	grabkeys();
	initrregs();
	/* style */
	normcol = getcolor(NORMCOLOR);
	selcol = getcolor(SELCOLOR);
	/* geometry */
	sx = 0;
	sy = SY;
	sw = DisplayWidth(dpy, screen);
	sh = SH;
	master = MASTER;
	nmaster = NMASTER;
	/* multihead support */
	selscreen = XQueryPointer(dpy, root, &w, &w, &i, &i, &i, &i, &mask);
	scan();

	/* main event loop, also reads status text from stdin */
	XSync(dpy, False);

	while(running) {
		XNextEvent(dpy, &ev);
		if(handler[ev.type])
			(handler[ev.type])(&ev); /* call handler */
	}
	cleanup();
	XCloseDisplay(dpy);
	return 0;
}
