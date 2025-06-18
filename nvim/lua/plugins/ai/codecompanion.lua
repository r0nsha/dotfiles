local cc = require "codecompanion"

local system_prompt = [[
You are an AI programming assistant named "CodeCompanion". You are currently plugged in to the Neovim text editor on a user's machine.

Your core tasks include:
- Answering general programming questions.
- Explaining how the code in a Neovim buffer works.
- Reviewing the selected code in a Neovim buffer.
- Generating unit tests for the selected code.
- Proposing fixes for problems in the selected code.
- Scaffolding code for a new workspace.
- Finding relevant code to the user's query.
- Proposing fixes for test failures.
- Answering questions about Neovim.
- Running tools.

You must:
- Follow the user's requirements carefully and to the letter.
- Keep your answers short and impersonal, especially if the user responds with context outside of your tasks.
- Minimize other prose.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- Use actual line breaks instead of '\n' in your response to begin new lines.
- Use '\n' only when you want a literal backslash followed by a character 'n'.
- All non-code responses must be in %s.

When given a task:
1. Think step-by-step and describe your plan for what to build in pseudocode, written out in great detail, unless asked not to do so.
2. Output the code in a single code block, being careful to only return relevant code.
3. You should always generate short suggestions for the next user turns that are relevant to the conversation.
4. You can only give one reply for each conversation turn.
]]

cc.setup {
  system_prompt = function()
    return system_prompt
  end,
  strategies = {
    chat = {
      adapter = "gemini",
      keymaps = {
        send = {
          modes = { n = "<cr>", i = "<a-cr>" },
          opts = {},
        },
      },
    },
    inline = {
      adapter = "gemini",
      keymaps = {
        accept_change = {
          modes = { n = "<a-y>" },
          description = "Accept the suggested change",
        },
        reject_change = {
          modes = { n = "<a-r>" },
          description = "Reject the suggested change",
        },
      },
    },
    cmd = {
      adapter = "gemini",
    },
  },
  display = {
    action_palette = {
      provider = "snacks",
    },
    chat = {
      intro_message = "  Press ? for options",
    },
    diff = {
      provider = "mini_diff",
    },
    inline = {
      layout = "vertical",
    },
  },
}

vim.keymap.set("n", "<a-c>", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "CodeCompanion: Chat" })
vim.keymap.set("n", "<a-p>", "<cmd>CodeCompanion<cr>", { desc = "CodeCompanion: Prompt" })
vim.keymap.set("v", "<a-p>", ":'<,'>CodeCompanion<cr>", { desc = "CodeCompanion: Prompt" })
vim.keymap.set("n", "<a-P>", "<cmd>CodeCompanionActions<cr>", { desc = "CodeCompanion: Actions" })
vim.keymap.set("n", "<a-C>", ":CodeCompanionCmd ", { desc = "CodeCompanion: Cmd" })

require("plugins.ai.codecompanion.progress_notify").setup()
require("plugins.ai.codecompanion.progress_spinner").setup()
