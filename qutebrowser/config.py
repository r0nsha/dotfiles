config.load_autoconfig(False)

# Spoof User-Agent for Google domains
google_domains = ["https://accounts.google.com/*", "https://*.google.com/*"]
for domain in google_domains:
    config.set(
        "content.headers.user_agent",
        "Mozilla/5.0 ({os_info}; rv:130.0) Gecko/20100101 Firefox/130",
        domain,
    )
