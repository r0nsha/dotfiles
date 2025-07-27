config.load_autoconfig(False)

# Options
c.auto_save.session = True
c.content.blocking.method = "adblock"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://secure.fanboy.co.nz/fanboy-social.txt",
]

# Keybindings
config.bind("<Ctrl-r>", "config-source ;; message-info 'Reloaded config'")

# Spoof User-Agent for Google domains
google_domains = ["https://accounts.google.com/*", "https://*.google.com/*"]
for domain in google_domains:
    config.set(
        "content.headers.user_agent",
        "Mozilla/5.0 ({os_info}; rv:130.0) Gecko/20100101 Firefox/130",
        domain,
    )
