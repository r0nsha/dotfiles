local commit_staged_instructions = [[
You are an expert at following the Conventional Commit specification. You follow these important rules:
- You always start at the first line of the file.
- You write concise commit messages that are to the point.
- You don't use capitalization for sentences. This doesn't apply to code blocks and code snippets, since they must be correct.
- You do use capitalizations in code blocks and code snippets. Again, they must be correct.
- Your description must be concise, technical and to the point. Don't use unnecessary jargon.
- You only write a description if there are more than 2 change topics.
- You don't use markdown formatting.
- The maximum length of each line in the description is 80 characters, you must respect this rule.
- Use don't use periods at the end of the commit message or description.
]]

return {
  "olimorris/codecompanion.nvim",
  opts = {
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
              return "@insert_edit_into_file #buffer"
                .. " "
                .. commit_staged_instructions
                .. " Given the git diff listed below, please generate a commit message for me the follows my instructions:"
                .. "\n\n```diff\n"
                .. vim.fn.system("git diff --staged")
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
