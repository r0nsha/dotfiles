import importlib.util
import os

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
c.content.notifications.enabled = "ask"
c.content.tls.certificate_errors = "ask-block-thirdparty"
c.confirm_quit = ["downloads"]
c.downloads.position = "bottom"
c.downloads.remove_finished = 5 * 60 * 1000  # 5 minutes

# Adblock
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://secure.fanboy.co.nz/fanboy-social.txt",
]

# Search engines
c.url.searchengines["DEFAULT"] = "https://duckduckgo.com/?q={}"
c.url.searchengines["g"] = (
    "http://www.google.com/search?hl=en&source=hp&ie=ISO-8859-l&q={}"
)
c.url.searchengines["y"] = "https://youtube.com/search?q={}"
c.url.searchengines["yt"] = "https://youtube.com/search?q={}"
c.url.searchengines["r"] = "https://reddit.com/search/?q={}"
c.url.searchengines["w"] = "https://en.wikipedia.org/w/index.php?search={}"
c.url.searchengines["a"] = "https://wiki.archlinux.org/?search={}"
c.url.searchengines["ap"] = "https://www.archlinux.org/packages/?sort=&q={}"
c.url.searchengines["aur"] = "https://aur.archlinux.org/packages/?K={}"
c.url.searchengines["gh"] = "https://github.com/search?q={}&type=Code"
c.url.searchengines["pdb"] = "https://www.protondb.com/search?q={}"

cache_path = os.path.expanduser("~/.cache/hellwal/qutebrowser.py")

if os.path.isfile(cache_path):
    spec = importlib.util.spec_from_file_location("my_module", cache_path)
    if spec and spec.loader:
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        palette = module.palette
else:
    palette = {
        "bg0": "black",
        "bg1": "darkslategrey",
        "fg": "white",
        "active": "cyan",
        "success": "green",
        "error": "red",
        "private": "darkred",
    }

# Colors
c.colors.tabs.selected.odd.bg = palette["bg0"]
c.colors.tabs.selected.even.bg = palette["bg0"]
c.colors.tabs.selected.odd.fg = palette["fg"]
c.colors.tabs.selected.even.fg = palette["fg"]
c.colors.tabs.bar.bg = palette["bg1"]
c.colors.tabs.indicator.error = palette["error"]
c.colors.tabs.indicator.start = palette["success"]
c.colors.tabs.indicator.stop = palette["success"]
c.colors.tabs.indicator.system = "none"
c.colors.tabs.odd.bg = palette["bg1"]
c.colors.tabs.even.bg = palette["bg1"]
c.colors.tabs.odd.fg = palette["fg"]
c.colors.tabs.even.fg = palette["fg"]
c.colors.tabs.pinned.odd.bg = palette["active"]
c.colors.tabs.pinned.even.bg = palette["active"]
c.colors.tabs.pinned.odd.fg = palette["fg"]
c.colors.tabs.pinned.even.fg = palette["fg"]
c.colors.tooltip.bg = palette["bg0"]
c.colors.tooltip.fg = palette["fg"]
c.colors.webpage.bg = palette["bg0"]
c.colors.statusbar.private.bg = palette["private"]
c.colors.statusbar.private.fg = palette["fg"]
c.colors.statusbar.command.private.bg = palette["error"]
c.colors.statusbar.command.private.fg = palette["fg"]
c.colors.hints.fg = palette["bg0"]

c.colors.hints.bg = "qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 rgba(255, 247, 133, 0.8), stop:1 rgba(255, 197, 66, 0.8))"
c.colors.hints.match.fg = palette["success"]
c.hints.border = "1px solid #E3BE23"
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.contrast = 0.0
c.colors.webpage.darkmode.policy.page = "smart"
c.colors.webpage.darkmode.policy.images = "smart"
c.colors.webpage.darkmode.threshold.background = 128
c.colors.webpage.darkmode.threshold.foreground = 128
c.colors.webpage.preferred_color_scheme = "dark"

# Keybindings
config.bind("J", "tab-prev")
config.bind("K", "tab-next")
config.bind("gJ", "tab-move -")
config.bind("gK", "tab-move +")
config.bind("<Ctrl-n>", "completion-item-focus next", mode="command")
config.bind("<Ctrl-p>", "completion-item-focus prev", mode="command")
config.bind("<Ctrl-y>", "command-accept", mode="command")
config.unbind("r")
config.bind("<Ctrl-r>", "reload")
config.bind("<Ctrl-Shift-r>", "config-source ;; message-info 'Reloaded config'")
config.unbind("<Ctrl-v>")
config.bind("<Ctrl-Shift-p>", "mode-enter passthrough")
config.bind("aa", "set-cmd-text -s :quickmark-add {url} {title}")

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
