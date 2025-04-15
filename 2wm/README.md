2wm - stereo window manager
===========================
2wm is an extremely fast, small, and dynamic window manager for X. It is the
little brother of dwm.


Requirements
------------
In order to build 2wm you need the Xlib header files.


Installation
------------
Edit config.mk to match your local setup (2wm is installed into
the /usr/local namespace by default).

Afterwards enter the following command to build and install 2wm (if
necessary as root):

    make clean install


Running 2wm
-----------
Add the following line to your .xinitrc to start 2wm using startx:

    exec 2wm

In order to connect 2wm to a specific display, make sure that
the DISPLAY environment variable is set correctly, e.g.:

    DISPLAY=foo.bar:1 exec 2wm

(This will start 2wm on display :1 of the host foo.bar.)

Configuration
-------------
The configuration of 2wm is done by creating a custom config.h
and (re)compiling the source code.

[Man page section follows...]
