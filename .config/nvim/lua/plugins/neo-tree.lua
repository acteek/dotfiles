return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      close_if_last_window = true,
      filesystem = {
        hide_dotfiles = false,
        hide_gitignored = false,
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
        },
      },
      default_component_config = {
        git_status = {
          -- Change type
          added = "✚",
          deleted = "✖",
          modified = "",
          renamed = "󰁕",
          -- Status type
          untracked = "",
          ignored = "",
          unstaged = "", --"󰄱"
          staged = "",
          conflict = "",
        },
        align = "right",
      },
    })
    vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", {})
  end,
}
