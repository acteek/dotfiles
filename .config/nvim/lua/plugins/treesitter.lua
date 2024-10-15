return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				sync_install = false,
				ensure_installed = {},
				ignore_install = {},
				modules = {},
				auto_install = true,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
}
