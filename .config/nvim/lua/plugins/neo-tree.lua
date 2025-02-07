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
		})
		vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", {})
		local events = require("neo-tree.events")
		events.fire_event(events.GIT_EVENT)
	end,
}
