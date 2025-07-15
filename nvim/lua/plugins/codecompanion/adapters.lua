return {
  "olimorris/codecompanion.nvim",
  opts = {
    strategies = {
      chat = { adapter = "gemini" },
      inline = { adapter = "gemini" },
      cmd = { adapter = "gemini" },
    },
    adapters = {
      tavily = function()
        return require("codecompanion.adapters").extend("tavily", {
          raw = { "--http1.1" },
        })
      end,
    },
  },
}
