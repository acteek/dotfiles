vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.linebreak = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
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
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
vim.opt.foldlevel = 99 -- Keep all folds open by default
vim.opt.splitbelow = true -- Horizontal splits open below
vim.opt.splitright = true -- Vertical splits open to the right

vim.opt.langmap = {
	"ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ",
	"фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
}

vim.opt.completeopt = {
	"menuone", -- show menu even for single match
	"noinsert", -- do not insert automatically
	"noselect", -- do not select automatically
}

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

-- LSP go to
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to definition" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
--  LSP code actions
vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "cf", vim.lsp.buf.format, { desc = "Code format" })
vim.keymap.set("n", "cr", vim.lsp.buf.rename, { desc = "Code Rename" })
-- Moving and searching
vim.keymap.set("n", "<C-j>", "<cmd>m +1<cr>", { desc = "Move line down" })
vim.keymap.set("n", "<C-k>", "<cmd>m -2<cr>", { desc = "Move line up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
-- Other keymaps
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to Clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste to Clipboard" })
vim.keymap.set("n", "<esc>", "<cmd>nohl<cr>", { desc = "Clear highlight" })
vim.keymap.set("n", "<leader>rc", "<cmd>e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })

-- Plugins setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	install = { colorscheme = { "onedark" } },
	checker = { enabled = true },
	{ "neovim/nvim-lspconfig" },
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.startify")
			dashboard.file_icons.provider = "devicons"
			alpha.setup(dashboard.config)
		end,
	},
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
	},
	{
		"navarasu/onedark.nvim",
		lazy = false,
		name = "onedark",
		priority = 1000,
		config = function()
			local onedark = require("onedark")
			onedark.setup({
				style = "dark",
				transparent = false,
			})
			onedark.load()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("lualine").setup({
				options = {
					theme = "onedark",
				},
			})
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"natecraddock/telescope-zf-native.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
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
			vim.keymap.set("n", "<leader>b", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
			vim.keymap.set("n", "<leader>s", builtin.lsp_document_symbols, {})
			vim.keymap.set("n", "<leader>gc", builtin.git_commits, {})
			vim.keymap.set("n", "<leader>gb", builtin.git_bcommits, {})
			vim.keymap.set("n", "<leader>gg", builtin.git_branches, {})
			vim.keymap.set("n", "<leader><leader>", builtin.find_files, {})

			telescope.load_extension("zf-native")
			telescope.load_extension("ui-select")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local config = require("nvim-treesitter.configs")
			config.setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
							["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
						},
					},
				},
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
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		after = "nvim-treesitter",
		requires = "nvim-treesitter/nvim-treesitter",
	},
	{
		"github/copilot.vim",
		init = function()
			vim.g.copilot_filetypes = {
				yaml = true,
			}
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		opts = {
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = { preset = "enter" },
			completion = {
				documentation = { auto_show = true, auto_show_delay_ms = 0 },
				list = {
					selection = { preselect = true, auto_insert = false },
				},
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		event = "VeryLazy",
		opts = {
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
		},
	},
	{
		"linrongbin16/gitlinker.nvim",
		cmd = "GitLink",
		config = function()
			require("gitlinker").setup({
				router = {
					browse = {
						["^git%.ringcentral%.com"] = require("gitlinker.routers").gitlab_browse,
					},
					blame = {
						["^git%.ringcentral%.com"] = require("gitlinker.routers").gitlab_blame,
					},
				},
			})
		end,
	},
	{
		"stevearc/oil.nvim",
		config = function()
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
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvimtools/none-ls-extras.nvim",
		},
		config = function()
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
					if client.supports_method("textDocument/formatting") then
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
		end,
	},
	{
		"scalameta/nvim-metals",
		ft = { "scala", "sbt", "java" },
		opts = function()
			local metals_config = require("metals").bare_config()
			metals_config.init_options.statusBarProvider = "on"
			metals_config.settings = {
				showImplicitArguments = true,
				showImplicitConversionsAndClasses = true,
				showInferredType = true,
			}
		end,
		config = function(self, metals_config)
			local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				pattern = self.ft,
				group = nvim_metals_group,
				callback = function()
					require("metals").initialize_or_attach(metals_config)
				end,
			})
		end,
	},
	{
		"stevearc/quicker.nvim",
		event = "FileType qf",
		opts = {},
	},
	{
		"numToStr/FTerm.nvim",
		config = function()
			local fterm = require("FTerm")
			fterm.setup({
				dimensions = {
					height = 0.7,
					width = 0.6,
				},
				blend = 25,
			})

			vim.api.nvim_create_user_command("YarnTest", function()
				local param = { "yarn", "test" }
				local path = vim.api.nvim_buf_get_name(0)
				local buf_name = path:match("([^/]+)%.%w+$")
				if buf_name then
					table.insert(param, "--")
					table.insert(param, buf_name)
				end
				require("FTerm").run(param)
			end, { bang = true })

			vim.api.nvim_create_user_command("FTermOpen", fterm.open, { bang = true })
			vim.api.nvim_create_user_command("FTermClose", fterm.close, { bang = true })
			vim.api.nvim_create_user_command("FTermExit", fterm.exit, { bang = true })

			vim.keymap.set("n", "<leader>T", "<cmd>YarnTest<cr>")
			vim.keymap.set("n", "<leader>t", fterm.open)
			-- vim.keymap.set("n", "<leader>t", "<cmd>vsp<cr><C-w>l<cmd>term<cr>i")
			vim.keymap.set("t", "<esc>", "<C-\\><C-n><cmd>FTermClose<cr>")
		end,
	},
	{
		"mbbill/undotree",

		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},
})
