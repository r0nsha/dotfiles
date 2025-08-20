return {
  "otavioschwanck/arrow.nvim",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    show_icons = true,
    leader_key = "'",
    buffer_leader_key = ";",
    mappings = {
      edit = "e",
      delete_mode = "d",
      clear_all_items = "C",
      toggle = "a", -- used as save if separate_save_and_remove is true
      open_vertical = "v",
      open_horizontal = "_",
      quit = "q",
      remove = "x", -- only used if separate_save_and_remove is true
      next_item = "]",
      prev_item = "[",
    },
    window = {
      border = "single",
      zindex = 999,
    },
    save_key = "git_root",
    index_keys = "sfghjkl'zcbwrtyuiopnm,./123456789ASDFGHJKLZXVBQWERTYUIOPNM",
  },
}
