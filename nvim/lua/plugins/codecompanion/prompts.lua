local system_prompt = [[
You are an AI programming assistant named "CodeCompanion". You are currently plugged in to the Neovim text editor on a user's machine.
The user's name is Ron.

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
- You don't overuse capitalization, you answer in simple, understandable words that are down to earth.
- Use Markdown formatting in your answers.
- Include the programming language name at the start of the Markdown code blocks.
- Avoid including line numbers in code blocks.
- Avoid wrapping the whole response in triple backticks.
- Only return code that's relevant to the task at hand. You may not need to return all of the code that the user has shared.
- Use actual line breaks instead of '\n' in your response to begin new lines.
- Use '\n' only when you want a literal backslash followed by a character 'n'.
- All non-code responses must be in %s.

When given a task:
2. Output the code in a single code block, being careful to only return relevant code.
3. You should always generate short suggestions for the user's next turns. The suggestions must be relevant to the conversation.
4. You can only give one reply for each conversation turn.
]]

return {
  "olimorris/codecompanion.nvim",
  opts = {
    opts = {
      language = "english",
      system_prompt = function(opts)
        return string.format(system_prompt, opts.language)
      end,
    },
    prompt_library = {
      ["Generate a Commit Message for Staged Files"] = {
        strategy = "inline",
        description = "staged file commit messages",
        opts = {
          index = 15,
          is_default = false,
          is_slash_cmd = true,
          short_name = "commit_staged",
          auto_submit = true,
        },
        prompts = {
          {
            role = "user",
            contains_code = true,
            content = function()
              local flags = "@insert_edit_into_file #buffer"
              local instructions =
                "You are an expert at following the Conventional Commit specification. Important: You write concise commit messages that are to the point and don't have capitalization for sentences. Important: you do use capitalizations in code blocks and code snippets!"

              return flags
                .. " "
                .. instructions
                .. " Given the git diff listed below, please generate a commit message for me the follows my instructions:"
                .. "\n\n```diff\n"
                .. vim.fn.system "git diff --staged"
                .. "\n```"
            end,
          },
        },
      },
    },
    ["Add Documentation"] = {
      strategy = "inline",
      description = "Add documentation to the selected code",
      opts = {
        index = 16,
        is_default = false,
        modes = { "v" },
        short_name = "doc",
        is_slash_cmd = true,
        auto_submit = true,
        user_prompt = false,
        stop_context_insertion = true,
      },
      prompts = {
        {
          role = "system",
          content = "When asked to add documentation, follow these steps:\n"
            .. "1. **Identify Key Points**: Carefully read the provided code to understand its functionality.\n"
            .. "2. **Review the Documentation**: Ensure the documentation:\n"
            .. "  - Includes necessary explanations.\n"
            .. "  - Helps in understanding the code's functionality.\n"
            .. "  - Follows best practices for readability and maintainability.\n"
            .. "  - Is formatted correctly.\n\n"
            .. "For C/C++ code: use Doxygen comments using `\\` instead of `@`.\n"
            .. "For Python code: Use Docstring numpy-notypes format.",
          opts = {
            visible = false,
          },
        },
        {
          role = "user",
          content = function(context)
            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
            return "Please document the selected code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```\n\n"
          end,
          opts = {
            contains_code = true,
          },
        },
      },
    },
    ["Refactor"] = {
      strategy = "chat",
      description = "Refactor the selected code for readability, maintainability and performances",
      opts = {
        index = 17,
        is_default = false,
        modes = { "v" },
        short_name = "refactor",
        is_slash_cmd = true,
        auto_submit = true,
        user_prompt = false,
        stop_context_insertion = true,
      },
      prompts = {
        {
          role = "system",
          content = "When asked to optimize code, follow these steps:\n"
            .. "1. **Analyze the Code**: Understand the functionality and identify potential bottlenecks.\n"
            .. "2. **Implement the Optimization**: Apply the optimizations including best practices to the code.\n"
            .. "3. **Shorten the code**: Remove unnecessary code and refactor the code to be more concise.\n"
            .. "3. **Review the Optimized Code**: Ensure the code is optimized for performance and readability. Ensure the code:\n"
            .. "  - Maintains the original functionality.\n"
            .. "  - Is more efficient in terms of time and space complexity.\n"
            .. "  - Follows best practices for readability and maintainability.\n"
            .. "  - Is formatted correctly.\n\n"
            .. "Use Markdown formatting and include the programming language name at the start of the code block.",
          opts = {
            visible = false,
          },
        },
        {
          role = "user",
          content = function(context)
            local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

            return "Please optimize the selected code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```\n\n"
          end,
          opts = {
            contains_code = true,
          },
        },
      },
    },
    ["Spell"] = {
      strategy = "inline",
      description = "Correct grammar and reformulate",
      opts = {
        index = 19,
        is_default = false,
        short_name = "spell",
        is_slash_cmd = true,
        auto_submit = true,
        adapter = {
          name = "copilot",
          model = "gpt-4o",
        },
      },
      prompts = {
        {
          role = "user",
          contains_code = false,
          content = function(context)
            local text = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
            return "Correct grammar and reformulate:\n\n" .. text
          end,
        },
      },
    },
  },
}
