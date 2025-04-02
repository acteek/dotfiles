vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.background = "dark"

vim.opt.swapfile = false

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- break lines at word boundaries
vim.opt.linebreak = true

-- use spaces instead of tabs
vim.opt.expandtab = true

-- number of spaces for identation
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- number of spaces used for <tab>
vim.opt.tabstop = 2

-- language map
vim.opt.langmap = {
	"ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ",
	"фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz",
}

vim.opt.completeopt = { "menuone", "noinsert" }
vim.opt.shortmess:append("c")

-- Diagnostics setup
vim.diagnostic.config({
	virtual_lines = {
		current_line = true,
	},
})

-- clear Cmd after command
vim.api.nvim_create_autocmd("CmdlineLeave", {
	group = vim.api.nvim_create_augroup("cleanUp", {}),
	callback = function()
		vim.fn.timer_start(500, function()
			vim.cmd([[ echon ' ' ]])
		end)
	end,
})

--
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("myLSP", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local telescope = require("telescope.builtin")
		-- Go to lsp mapping
		vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
		vim.keymap.set("n", "gr", telescope.lsp_references, { desc = "Go to definition" })
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
		vim.keymap.set("n", "gi", telescope.lsp_implementations, { desc = "Go to implementation" })
		--  Code lsp mapping
		vim.keymap.set("n", "ca", vim.lsp.buf.code_action, { desc = "Code action" })
		vim.keymap.set("n", "cf", vim.lsp.buf.format, { desc = "Code format" })
		vim.keymap.set("n", "cr", vim.lsp.buf.rename, { desc = "Code Rename" })

		-- if client:supports_method("textDocument/formatting") then
		--   vim.api.nvim_create_autocmd("BufWritePre", {
		--     group = vim.api.nvim_create_augroup("myLSP", { clear = false }),
		--     buffer = args.buf,
		--     callback = function()
		--       vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
		--     end,
		--   })
		-- end
	end,
})

-- LSPs setup
vim.lsp.config["gopls"] = {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedparams = true,
			},
		},
	},
}

vim.lsp.config["tsls"] = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "typescript" },
	root_markers = { "tsconfig.json", "package.json" },
	settings = {},
}

vim.lsp.config["protols"] = {
	cmd = { "protols", "-i", "proto,protobuf" },
	filetypes = { "proto" },
	root_markers = { "proto", "protobuf" },
	settings = {},
}

vim.lsp.config["luals"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			runtime = {
				version = "LuaJIT",
			},
		},
	},
}

vim.lsp.enable({ "luals", "gopls", "tsls", "protols" })

-- Clenup highlight
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>")

-- Ability to move lines up and down
vim.keymap.set("n", "<C-j>", ":m +1<CR>", { desc = "Move line down" })
vim.keymap.set("n", "<C-k>", ":m -2<CR>", { desc = "Move line up" })

-- Quickfix list navigate
vim.keymap.set("n", "m", ":cnext<CR>", { desc = "Next line in QF list" })
vim.keymap.set("n", "M", ":cprev<CR>", { desc = "Prev line in QF list " })
vim.keymap.set("n", "<leader>mm", ":cclose<CR>", { desc = "Close QF list" })

-- Plugins setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{
		"goolord/alpha-nvim",
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.startify")
			alpha.setup(dashboard.opts)
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
			})
			onedark.load()
		end,
	},
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					theme = "dracula",
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
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})

			telescope.load_extension("ui-select")
			telescope.load_extension("zf-native")
		end,
	},
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
	{
		"github/copilot.vim",
		init = function()
			vim.g.copilot_filetypes = {
				yaml = true,
			}
		end,
	},

	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{
		"hrsh7th/nvim-cmp",
		config = function()
			local cmp = require("cmp")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" }, -- For luasnip users.
				}, {
					{ name = "buffer" },
				}),
			})
		end,
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
					null_ls.builtins.diagnostics.eslint_d,
					null_ls.builtins.diagnostics.buf,
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
		dependencies = {
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},
		ft = { "scala", "sbt", "java" },
		opts = function()
			local metals_config = require("metals").bare_config()
			metals_config.init_options.statusBarProvider = "on"
			metals_config.settings = {
				showImplicitArguments = true,
				showImplicitConversionsAndClasses = true,
				showInferredType = true,
			}
			metals_config.on_attach = function(client, _bufnr)
				-- metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()
				metals_config.capabilities = client.server_capabilities
			end
			return metals_config
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
		"yorickpeterse/nvim-pqf",
		config = function()
			require("pqf").setup()
		end,
	},
})
