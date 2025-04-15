# Ocean Depths theme for qutebrowser
# Optimized for eye comfort during extended browsing sessions

# Load autoconfig
config.load_autoconfig(False)

# Set start page to blank
c.url.start_pages = ["about:blank"]
c.url.default_page = "about:blank"

# Hide unnecessary UI elements for a minimal experience
c.statusbar.show = "in-mode"  # Only show status bar when in command mode
c.tabs.show = "switching"     # Only show tabs when switching between them
c.scrolling.bar = "never"     # Hide scrollbar
c.tabs.favicons.show = "never"  # Hide favicons
c.tabs.padding = {"bottom": 1, "left": 5, "right": 5, "top": 1}
c.window.hide_decoration = True  # Hide window decorations

# Hide most of the status bar indicators
c.statusbar.widgets = ["keypress", "url", "scroll", "progress"]

# Define Ocean Depths color palette
ocean_depths = {
    'background': '#2E3134',
    'background_alt': '#363B41',
    'foreground': '#D8D8D8',
    'foreground_dim': '#888888',
    'teal_bright': '#53C1CC',
    'teal_deep': '#026464',
    'teal_medium': '#04B0A0',
    'teal_green': '#03B395',
    'accent_warm': '#EDBC59',
    'accent_purple': '#956FD0',
    'error': '#E45649',
    'warning': '#FFAD66',
    'success': '#04D1A5'
}

# Apply Ocean Depths colors to qutebrowser
c.colors.completion.category.bg = ocean_depths['background_alt']
c.colors.completion.category.border.bottom = ocean_depths['background']
c.colors.completion.category.border.top = ocean_depths['background']
c.colors.completion.category.fg = ocean_depths['teal_bright']
c.colors.completion.fg = ocean_depths['foreground']
c.colors.completion.item.selected.bg = ocean_depths['teal_deep']
c.colors.completion.item.selected.border.bottom = ocean_depths['teal_deep']
c.colors.completion.item.selected.border.top = ocean_depths['teal_deep']
c.colors.completion.item.selected.fg = ocean_depths['foreground']
c.colors.completion.match.fg = ocean_depths['accent_warm']
c.colors.completion.odd.bg = ocean_depths['background']
c.colors.completion.even.bg = ocean_depths['background_alt']
c.colors.completion.scrollbar.bg = ocean_depths['background']
c.colors.completion.scrollbar.fg = ocean_depths['foreground_dim']

c.colors.contextmenu.menu.bg = ocean_depths['background']
c.colors.contextmenu.menu.fg = ocean_depths['foreground']
c.colors.contextmenu.selected.bg = ocean_depths['teal_deep']
c.colors.contextmenu.selected.fg = ocean_depths['foreground']

c.colors.downloads.bar.bg = ocean_depths['background']
c.colors.downloads.error.bg = ocean_depths['error']
c.colors.downloads.error.fg = ocean_depths['foreground']
c.colors.downloads.start.bg = ocean_depths['teal_deep']
c.colors.downloads.start.fg = ocean_depths['foreground']
c.colors.downloads.stop.bg = ocean_depths['teal_green']
c.colors.downloads.stop.fg = ocean_depths['foreground']

c.colors.hints.bg = ocean_depths['accent_warm']
c.colors.hints.fg = ocean_depths['background']
c.colors.hints.match.fg = ocean_depths['teal_bright']

c.colors.keyhint.bg = ocean_depths['background_alt']
c.colors.keyhint.fg = ocean_depths['foreground']
c.colors.keyhint.suffix.fg = ocean_depths['accent_warm']

c.colors.messages.error.bg = ocean_depths['error']
c.colors.messages.error.border = ocean_depths['error']
c.colors.messages.error.fg = ocean_depths['foreground']
c.colors.messages.info.bg = ocean_depths['teal_deep']
c.colors.messages.info.border = ocean_depths['teal_deep']
c.colors.messages.info.fg = ocean_depths['foreground']
c.colors.messages.warning.bg = ocean_depths['warning']
c.colors.messages.warning.border = ocean_depths['warning']
c.colors.messages.warning.fg = ocean_depths['background']

c.colors.prompts.bg = ocean_depths['background']
c.colors.prompts.border = "1px solid " + ocean_depths['background_alt']
c.colors.prompts.fg = ocean_depths['foreground']
c.colors.prompts.selected.bg = ocean_depths['teal_deep']

c.colors.statusbar.caret.bg = ocean_depths['accent_purple']
c.colors.statusbar.caret.fg = ocean_depths['foreground']
c.colors.statusbar.caret.selection.bg = ocean_depths['accent_purple']
c.colors.statusbar.caret.selection.fg = ocean_depths['foreground']
c.colors.statusbar.command.bg = ocean_depths['background_alt']
c.colors.statusbar.command.fg = ocean_depths['foreground']
c.colors.statusbar.command.private.bg = ocean_depths['background_alt']
c.colors.statusbar.command.private.fg = ocean_depths['foreground']
c.colors.statusbar.insert.bg = ocean_depths['teal_green']
c.colors.statusbar.insert.fg = ocean_depths['background']
c.colors.statusbar.normal.bg = ocean_depths['background']
c.colors.statusbar.normal.fg = ocean_depths['foreground']
c.colors.statusbar.passthrough.bg = ocean_depths['accent_purple']
c.colors.statusbar.passthrough.fg = ocean_depths['foreground']
c.colors.statusbar.private.bg = ocean_depths['background_alt']
c.colors.statusbar.private.fg = ocean_depths['foreground']
c.colors.statusbar.progress.bg = ocean_depths['teal_bright']
c.colors.statusbar.url.error.fg = ocean_depths['error']
c.colors.statusbar.url.fg = ocean_depths['foreground']
c.colors.statusbar.url.hover.fg = ocean_depths['teal_bright']
c.colors.statusbar.url.success.http.fg = ocean_depths['foreground_dim']
c.colors.statusbar.url.success.https.fg = ocean_depths['teal_green']
c.colors.statusbar.url.warn.fg = ocean_depths['warning']

c.colors.tabs.bar.bg = ocean_depths['background']
c.colors.tabs.even.bg = ocean_depths['background']
c.colors.tabs.even.fg = ocean_depths['foreground_dim']
c.colors.tabs.indicator.error = ocean_depths['error']
c.colors.tabs.indicator.start = ocean_depths['teal_bright']
c.colors.tabs.indicator.stop = ocean_depths['teal_green']
c.colors.tabs.odd.bg = ocean_depths['background_alt']
c.colors.tabs.odd.fg = ocean_depths['foreground_dim']
c.colors.tabs.selected.even.bg = ocean_depths['teal_deep']
c.colors.tabs.selected.even.fg = ocean_depths['foreground']
c.colors.tabs.selected.odd.bg = ocean_depths['teal_deep']
c.colors.tabs.selected.odd.fg = ocean_depths['foreground']

c.colors.webpage.bg = "#FFFFFF"  # Keep webpages with their default background

# Set custom fonts
c.fonts.default_family = ["Triplicate T4c", "monospace"]
c.fonts.default_size = "12pt"
c.fonts.statusbar = "11pt Triplicate T4c"
c.fonts.tabs.selected = "11pt Triplicate T4c"
c.fonts.tabs.unselected = "11pt Triplicate T4c"

# Useful custom keybindings
# Navigation bindings
config.bind('J', 'tab-prev')
config.bind('K', 'tab-next')
config.bind('H', 'back')
config.bind('L', 'forward')
    
# Quick access
config.bind(',r', 'config-source')  # Reload config
config.bind(',p', 'set-cmd-text -s :open -p')  # Open in private window

# Content navigation
config.bind('j', 'scroll-px 0 75')  # Smoother scrolling
config.bind('k', 'scroll-px 0 -75')  # Smoother scrolling
config.bind('d', 'scroll-page 0 0.5')  # Half page down
config.bind('u', 'scroll-page 0 -0.5')  # Half page up

# Tab management
config.bind(',t', 'set-cmd-text -s :open -t')  # New tab with command
config.bind('xt', 'tab-close')  # Close current tab
config.bind('T', 'tab-focus last')  # Go to last focused tab

# Quick URLs (adjust to your needs)
config.bind(',g', 'open -t https://github.com')
config.bind(',m', 'open -t https://mail.google.com')
config.bind(',n', 'open -t https://news.ycombinator.com')
config.bind(',w', 'open -t https://wikipedia.org')

# Toggle UI elements
config.bind(',b', 'config-cycle statusbar.show always never')
config.bind(',s', 'config-cycle statusbar.show always never')
config.bind(',t', 'config-cycle tabs.show always never')

# Reader mode and page styling
config.bind(',f', 'hint links spawn mpv {hint-url}')  # Open video in mpv
config.bind(',R', 'open javascript:(%28function%28%29%7Bvar%20e%3Ddocument.createElement%28%27style%27%29%3Be.innerHTML%3D%27html%7Bbackground%3A%23efefef%3B%7Dbody%7Bmax-width%3A800px%3Bmargin%3A0%20auto%3Bpadding%3A10px%3Bfont-family%3A%20%22Triplicate%20T4c%22%2C%20monospace%3Bfont-size%3A18px%3Bline-height%3A1.5%3Bcolor%3A%23333%3B%7D%27%3Bdocument.head.appendChild%28e%29%3B%7D%29%28%29')  # Simple reader mode

# Performance settings
c.content.javascript.enabled = True  # Keep JavaScript enabled for modern sites
c.content.cookies.accept = "no-3rdparty"  # Only allow first-party cookies
c.content.blocking.method = "both"  # Use both blocking methods
c.content.blocking.enabled = True  # Enable ad blocking

# Use less memory
c.content.cache.size = 1024 * 1024 * 32  # 32MB cache
c.tabs.background = True  # Don't focus new tabs
c.tabs.last_close = "close"  # Close window when closing last tab

# Privacy settings
c.content.headers.do_not_track = True
c.content.headers.referer = "same-domain"
c.content.cookies.store = True
c.content.webrtc_ip_handling_policy = "default-public-interface-only"

# Set search engine
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "g": "https://google.com/search?q={}",
    "w": "https://en.wikipedia.org/wiki/Special:Search?search={}",
    "gh": "https://github.com/search?q={}",
}

# Disable unwanted features
c.content.notifications.enabled = False  # Disable notifications
c.content.autoplay = False  # Disable autoplay media