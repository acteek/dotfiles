return {
	{
		"navarasu/onedark.nvim",
		lazy = false,
		name = "onedark",
		priority = 1000,
		config = function()
			local onedark = require("onedark")
			onedark.setup({
				style = "dark",
			})
			onedark.load()
		end,
	},
}
