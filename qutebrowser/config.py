config.load_autoconfig(False)

# Options
c.auto_save.session = True
c.tabs.position = "top"

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

# Adblock
c.content.blocking.method = "adblock"
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
config.bind("<Ctrl-r>", "config-source ;; message-info 'Reloaded config'")

# Spoof User-Agent for Google domains
google_domains = ["https://accounts.google.com/*", "https://*.google.com/*"]
for domain in google_domains:
    config.set(
        "content.headers.user_agent",
        "Mozilla/5.0 ({os_info}; rv:130.0) Gecko/20100101 Firefox/130",
        domain,
    )
