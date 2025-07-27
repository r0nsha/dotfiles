config.load_autoconfig(True)

# Options
c.fonts.default_family = ["Iosevka Nerd Font Propo"]
c.fonts.default_size = "10pt"
c.auto_save.interval = 15000
c.auto_save.session = True
c.tabs.position = "top"
c.tabs.show = "multiple"
c.editor.command = ["kitty", "nvim", "{file}", "+{line}"]
c.new_instance_open_target = "tab-bg"
c.new_instance_open_target_window = "last-focused"
c.input.insert_mode.auto_load = True
c.prompt.filebrowser = False
c.completion.height = "30%"
c.completion.web_history.max_items = -1
c.completion.use_best_match = True
c.hints.mode = "letter"
c.hints.min_chars = 1
c.content.pdfjs = True

# Search engines
c.url.searchengines["DEFAULT"] = "https://duckduckgo.com/?q={}"
c.url.searchengines["g"] = (
    "http://www.google.com/search?hl=en&source=hp&ie=ISO-8859-l&q={}"
)
c.url.searchengines["y"] = "https://youtube.com/search?q={}"
c.url.searchengines["yt"] = "https://youtube.com/search?q={}"
c.url.searchengines["w"] = "https://en.wikipedia.org/w/index.php?search={}"
c.url.searchengines["a"] = "https://wiki.archlinux.org/?search={}"
c.url.searchengines["ap"] = "https://www.archlinux.org/packages/?sort=&q={}"
c.url.searchengines["gh"] = "https://github.com/search?q={}&type=Code"

# Aliases
c.aliases["jellyfin"] = "open -t http://localhost:8096"

# Theme
modus_vivendi = {
    "bg": "#000000",
    "bg_dim": "#303030",
    "fg": "#ffffff",
    "fg_dim": "#989898",
    "red": "#ff5f59",
    "green": "#44bc44",
    "yellow": "#d0bc00",
    "cyan": "#00d3d0",
}

colors = modus_vivendi

c.colors.tabs.selected.odd.bg = colors["bg"]
c.colors.tabs.selected.even.bg = colors["bg"]
c.colors.tabs.selected.odd.fg = colors["fg"]
c.colors.tabs.selected.even.fg = colors["fg"]
c.colors.tabs.bar.bg = colors["bg_dim"]
c.colors.tabs.indicator.error = colors["red"]
c.colors.tabs.indicator.start = colors["green"]
c.colors.tabs.indicator.stop = colors["green"]
c.colors.tabs.indicator.system = "none"
c.colors.tabs.odd.bg = colors["bg_dim"]
c.colors.tabs.even.bg = colors["bg_dim"]
c.colors.tabs.odd.fg = colors["fg"]
c.colors.tabs.even.fg = colors["fg"]
c.colors.tabs.pinned.odd.bg = colors["cyan"]
c.colors.tabs.pinned.even.bg = colors["cyan"]
c.colors.tabs.pinned.odd.fg = colors["fg"]
c.colors.tabs.pinned.even.fg = colors["fg"]
c.colors.tooltip.bg = colors["bg"]
c.colors.tooltip.fg = colors["fg"]
c.colors.webpage.bg = colors["bg"]
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.contrast = 0.0
c.colors.webpage.darkmode.policy.page = "smart"
c.colors.webpage.darkmode.policy.images = "smart"
c.colors.webpage.darkmode.threshold.background = 128
c.colors.webpage.darkmode.threshold.foreground = 128
c.colors.webpage.preferred_color_scheme = "dark"
c.content.notifications.enabled = False
c.content.tls.certificate_errors = "ask-block-thirdparty"
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://secure.fanboy.co.nz/fanboy-social.txt",
]

# Keybindings
config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.bind("gJ", "tab-move -")
config.bind("gK", "tab-move +")
config.bind("<Ctrl-n>", "completion-item-focus next", mode="command")
config.bind("<Ctrl-p>", "completion-item-focus prev", mode="command")
config.bind("<Ctrl-y>", "command-accept", mode="command")
config.bind("<Ctrl-r>", "config-source ;; message-info 'Reloaded config'")

# Spoof User-Agent for Google domains
google_domains = [
    "https://accounts.google.com/*",
    "https://*.google.com/*",
]
for domain in google_domains:
    config.set(
        "content.headers.user_agent",
        "Mozilla/5.0 ({os_info}; rv:130.0) Gecko/20100101 Firefox/130",
        domain,
    )
