vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.linebreak = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.scrolloff = 8
vim.opt.breakindent = true
vim.opt.showmode = false
vim.opt.ignorecase = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.clipboard:append("unnamedplus") -- Use system clipboard
vim.opt.iskeyword:append("-") -- Treat dash as part of a word
vim.opt.undofile = true -- Persistent undo
vim.opt.autoread = true -- Auto-reload file if changed outside
vim.opt.foldmethod = "expr" -- Use expression for folding
vim.opt.foldlevel = 99 -- Keep all folds open by default
vim.opt.splitbelow = true -- Horizontal splits open below
vim.opt.splitright = true -- Vertical splits open to the right

vim.opt.langmap = {
	"ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ",
	"фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
}

vim.opt.autocomplete = false
vim.opt.completeopt = { "menu", "menuone", "noinsert", "noselect", "fuzzy", "popup" }

vim.opt.winborder = "rounded"
vim.opt.wildmode = {
	"longest:full",
	"full",
}

-- Diagnostics setup
vim.diagnostic.config({
	virtual_lines = {
		current_line = true,
	},
})

-- Auto cmds
-- Highlight the yanked text for 200ms
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
	group = highlight_yank_group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({
			higroup = "IncSearch",
			timeout = 200,
		})
	end,
})

-- LSP setup
-- Extend LSP configs for nvim-lspconfig plugin
vim.lsp.config("lua_ls", {
	root_markers = { "lazy-lock.json" },
	settings = {
		Lua = {
			workspace = {
				library = {
					"${3rd}/love2d/library",
					vim.fn.expand("$VIMRUNTIME/lua"),
					vim.fn.stdpath("config") .. "/lua",
				},
			},
			diagnostics = {
				globals = { "vim" },
			},
			runtime = {
				version = "LuaJIT",
			},
		},
	},
})

vim.lsp.enable({ "lua_ls", "gopls", "ts_ls", "protols", "pyright", "yamlls" })

--  LSP code actions
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
vim.keymap.set("n", "gca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "gcr", vim.lsp.buf.rename, { desc = "Code Rename" })
vim.keymap.set("n", "cf", vim.lsp.buf.format, { desc = "Code format" })
-- Moving and searching
vim.keymap.set("n", "<C-j>", "<cmd>m +1<cr>", { desc = "Move line down" })
vim.keymap.set("n", "<C-k>", "<cmd>m -2<cr>", { desc = "Move line up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
-- Other keymaps
vim.keymap.set("n", "<esc>", "<cmd>nohl<cr>", { desc = "Clear highlight" })
vim.keymap.set("n", "<leader>rc", "<cmd>e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>q", "<cmd>cclose<cr>", { desc = "Close Quick list" })

-- Plugins configuration
-- Common
vim.pack.add({
	{ src = "git@github.com:nvim-tree/nvim-web-devicons.git" },
	{ src = "git@github.com:nvim-lua/plenary.nvim.git" },
	{ src = "git@github.com:neovim/nvim-lspconfig.git" },
	{ src = "git@github.com:mbbill/undotree.git" },
	{ src = "git@github.com:mplusp/pack-manager.nvim.git" },
})

vim.keymap.set("n", "<leader>p", "<cmd>PackMenu<cr>", { desc = "Plugin Maganer" })
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- Treesitter
vim.pack.add({
	{ src = "git@github.com:nvim-treesitter/nvim-treesitter.git", version = "main" },
	{ src = "git@github.com:MeanderingProgrammer/treesitter-modules.nvim.git" },
})

-- local parsers = { "typescript", "javascript", "python", "go", "yaml", "java", "scala", "sbt", "json" }

-- require("nvim-treesitter").install(parsers)

-- vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = parsers,
-- 	callback = function()
-- 		vim.treesitter.start()
-- 	end,
-- })

require("treesitter-modules").setup({
	incremental_selection = {
		enable = true,
		keymaps = {
			node_incremental = "v",
			node_decremental = "V",
		},
	},
	auto_install = true,
	fold = {
		enable = true,
	},
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	},
	indent = { enable = true },
})

-- Colorscheme
vim.pack.add({
	{ src = "git@github.com:navarasu/onedark.nvim.git", name = "onedark" },
})
local onedark = require("onedark")
onedark.setup({
	style = "dark",
	transparent = false,
})
onedark.load()
vim.cmd.colorscheme("onedark")

-- Alpha dashboard
vim.pack.add({
	{ src = "git@github.com:goolord/alpha-nvim.git" },
})

local alpha = require("alpha")
local dashboard = require("alpha.themes.startify")
dashboard.file_icons.provider = "devicons"
alpha.setup(dashboard.config)

-- Lualine
vim.pack.add({
	{ src = "git@github.com:nvim-lualine/lualine.nvim.git" },
})

require("lualine").setup({
	options = {
		theme = "onedark",
	},
})

-- Mason
vim.pack.add({
	{ src = "git@github.com:williamboman/mason.nvim.git" },
	{ src = "git@github.com:williamboman/mason-lspconfig.nvim.git" },
})
require("mason").setup()

-- Telescope
vim.pack.add({
	{ src = "git@github.com:nvim-telescope/telescope.nvim.git", version = vim.version.range("^0.2") },
	{ src = "git@github.com:natecraddock/telescope-zf-native.nvim.git" },
	{ src = "git@github.com:nvim-telescope/telescope-ui-select.nvim.git" },
})

local telescope = require("telescope")
require("telescope").setup({
	defaults = {
		file_ignore_patterns = {
			"node_modules",
			"dist",
			"coverage",
		},
	},
	pickers = {
		buffers = {
			sort_mru = true,
			sort_lastused = true,
			show_all_buffers = true,
			mappings = {
				i = {
					["<c-d>"] = "delete_buffer",
				},
			},
		},
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "grr", builtin.lsp_references, { desc = "Go to references" })
vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to definition" })
vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Go to implementation" })
vim.keymap.set("n", "gs", builtin.lsp_document_symbols, { desc = "Go document symbol" })
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>gc", builtin.git_commits, {})
vim.keymap.set("n", "<leader>gb", builtin.git_bcommits, {})
vim.keymap.set("n", "<leader>gg", builtin.git_branches, {})
vim.keymap.set("n", "<leader><leader>", builtin.find_files, {})

telescope.load_extension("zf-native")
telescope.load_extension("ui-select")

-- Oil
vim.pack.add({
	{ src = "git@github.com:stevearc/oil.nvim.git" },
})

require("oil").setup({
	default_file_explorer = true,
	win_options = {
		wrap = true,
	},
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name)
			return name == ".git" or name == ".."
		end,
	},
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Oil: Open file in browser" })

-- None-ls
vim.pack.add({
	{ src = "git@github.com:nvimtools/none-ls.nvim.git", name = "null-ls" },
	{ src = "git@github.com:nvimtools/none-ls-extras.nvim.git" },
})

local null_ls = require("null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettier,
		null_ls.builtins.formatting.gofmt,
		null_ls.builtins.formatting.goimports_reviser,
		null_ls.builtins.formatting.golines,
		null_ls.builtins.formatting.buf,
		null_ls.builtins.formatting.black,
	},
	on_attach = function(client, bufnr)
		if client:supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({
				group = augroup,
				buffer = bufnr,
			})
			-- formating on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr, id = client.id, timeout_ms = 1000 })
				end,
			})
		end
	end,
})

-- Blink completion
vim.pack.add({
	{ src = "git@github.com:saghen/blink.cmp.git", version = vim.version.range("^1") },
	{ src = "git@github.com:rafamadriz/friendly-snippets.git" },
})

require("blink.cmp").setup({
	-- See :h blink-cmp-config-keymap for defining your own keymap
	keymap = { preset = "enter" },
	signature = {
		enabled = true,
	},
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 500 },
		menu = {
			auto_show = true,
			draw = {
				treesitter = { "lsp" },
				columns = {
					{ "kind_icon", "label", "label_description", gap = 1 },
					{ "source_id" },
				},
			},
		},
		list = {
			selection = { preselect = true, auto_insert = false },
		},
	},
})

-- Copilot
vim.pack.add({
	{ src = "git@github.com:github/copilot.vim.git" },
})

vim.g.copilot_filetypes = {
	yaml = true,
}

-- GitSigns
vim.pack.add({
	{ src = "git@github.com:lewis6991/gitsigns.nvim.git" },
})

require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_formatter = " <author>, <author_time:%d/%m/%Y> - <summary>",
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(l, r, desc)
			vim.keymap.set("n", l, r, { buffer = bufnr, desc = "Gitsigns: " .. desc })
		end

		map("<leader>ph", gitsigns.preview_hunk, "Preview hunk")
		map("<leader>rh", gitsigns.reset_hunk, "Reset hunk")
		map("<leader>lb", function()
			gitsigns.blame_line({ full = true })
		end, "Blame line")
		map("]h", gitsigns.next_hunk, "Next hunk")
		map("[h", gitsigns.prev_hunk, "Prev hunk")
	end,
	worktrees = {
		{
			toplevel = vim.env.HOME,
			gitdir = vim.env.HOME .. "/.dotfiles",
		},
	},
})

-- GitLink
vim.pack.add({
	{ src = "git@github.com:linrongbin16/gitlinker.nvim.git" },
})

require("gitlinker").setup({
	cmd = "GitLink",
	router = {
		browse = {
			["^git%.ringcentral%.com"] = require("gitlinker.routers").gitlab_browse,
		},
		blame = {
			["^git%.ringcentral%.com"] = require("gitlinker.routers").gitlab_blame,
		},
	},
})

-- Scala metals
vim.pack.add({
	{ src = "git@github.com:scalameta/nvim-metals.git" },
})

local metals = require("metals")
local metals_config = metals.bare_config()
metals_config.init_options.statusBarProvider = "on"
metals_config.settings = {
	showImplicitArguments = true,
	showImplicitConversionsAndClasses = true,
	showInferredType = true,
}

local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "scala", "sbt", "java" },
	group = nvim_metals_group,
	callback = function()
		metals.initialize_or_attach(metals_config)
	end,
})
