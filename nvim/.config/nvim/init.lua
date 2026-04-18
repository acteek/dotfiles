require("kotlin-lsp-fix")

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.colorcolumn = "120"
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

vim.opt.encoding = "UTF-8" -- Set encoding
vim.opt.clipboard:append("unnamedplus") -- Use system clipboard
vim.opt.iskeyword:append("-") -- Treat dash as part of a word
vim.opt.undofile = true -- Persistent undo
vim.opt.autoread = true -- Auto-reload file if changed outside
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

-- Enable new UI
require("vim._core.ui2").enable({})

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

-- restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
		local line_count = vim.api.nvim_buf_line_count(args.buf)
		if mark[1] > 0 and mark[1] <= line_count then
			vim.api.nvim_win_set_cursor(0, mark)
			-- defer centering slightly so it's applied after render
			vim.schedule(function()
				vim.cmd("normal! zz")
			end)
		end
	end,
})

-- open help in vertical split
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

-- LSP setup
-- Extend LSP configs for nvim-lspconfig plugin
vim.lsp.config("lua_ls", {
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

vim.lsp.config("metals", {
	filetypes = { "scala", "sbt" },
})

vim.lsp.config("jdtls", {
	settings = {
		java = {
			configuration = {
				runtimes = {
					{
						name = "Java-25",
						path = "$HOME/.local/share/mise/installs/java/25",
						default = true,
					},
				},
			},
		},
	},
})

vim.lsp.enable({
	"lua_ls",
	"gopls",
	"ts_ls",
	"protols",
	"pyright",
	"yamlls",
	"metals",
	"kotlin_lsp",
	"jdtls",
})

--  LSP code actions
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
vim.keymap.set("n", "ga", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "cr", vim.lsp.buf.rename, { desc = "Code Rename" })
-- Moving and searching
vim.keymap.set("n", "<M-j>", "<cmd>m +1<cr>", { desc = "Move line down" })
vim.keymap.set("n", "<M-k>", "<cmd>m -2<cr>", { desc = "Move line up" })
vim.keymap.set("n", "<C-j>", "<cmd>t.<cr>", { desc = "Duplicate line" })
vim.keymap.set("n", "<leader>a", "ggVG", { desc = "Select All" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "}", "}zz", { desc = "Move to next paragraph" })
vim.keymap.set("n", "{", "{zz", { desc = "Move to previous paragraph" })
vim.keymap.set("i", "<C-h>", "<Left>", { desc = "Move cursor left" })
vim.keymap.set("i", "<C-l>", "<Right>", { desc = "Move cursor right" })
vim.keymap.set("n", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("n", "k", "gk", { noremap = true, silent = true })
-- Other keymaps
vim.keymap.set("n", "<esc>", "<cmd>nohl<cr>", { desc = "Clear highlight" })
vim.keymap.set("n", "<leader>rc", "<cmd>e ~/.config/nvim/init.lua<CR>", { desc = "Edit config" })
vim.keymap.set("n", "<leader>q", "<cmd>cclose<cr>", { desc = "Close Quick list" })
vim.keymap.set("n", "q:", "<Nop>")

-- BuildIn plugins
vim.cmd.packadd("nvim.undotree")
vim.cmd.packadd("nvim.tohtml")
vim.cmd.packadd("nvim.difftool")
vim.keymap.set("n", "<leader>u", vim.cmd.Undotree)

-- Plugins configuration
-- Common
vim.pack.add({
	{ src = "git@github.com:nvim-tree/nvim-web-devicons.git" },
	{ src = "git@github.com:nvim-lua/plenary.nvim.git" },
	{ src = "git@github.com:neovim/nvim-lspconfig.git" },
	{ src = "git@github.com:dimtion/guttermarks.nvim" },
})

vim.keymap.set("n", "<leader>p", vim.pack.update, { desc = "Update dashboard" })

-- Treesitter
vim.pack.add({
	{ src = "git@github.com:nvim-treesitter/nvim-treesitter.git", version = "main" },
})
-- ensure installed
require("nvim-treesitter").install({
	"java",
	"scala",
	"javascript",
	"typescript",
	"kotlin",
	"python",
	"go",
	"rust",
	"yaml",
	"proto",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter.setup", {}),
	callback = function(args)
		local filetype = args.match
		local buf = args.buf
		local lang = vim.treesitter.language.get_lang(filetype) or filetype

		if vim.treesitter.language.add(lang) then
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo.foldmethod = "expr"

			vim.treesitter.start(buf, lang)
		end
	end,
})

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			vim.cmd("TSUpdate")
		end
	end,
})

-- incremental selection
local ts_select = require("vim.treesitter._select")
vim.keymap.set({ "n", "x", "o" }, "<A-o>", function()
	if vim.treesitter.get_parser() then
		ts_select.select_parent(vim.v.count1)
	end
end, { desc = "Select parent treesitter node" })

vim.keymap.set({ "n", "x", "o" }, "<A-i>", function()
	if vim.treesitter.get_parser() then
		ts_select.select_child(vim.v.count1)
	end
end, { desc = "Select child treesitter node" })

-- Colorscheme
vim.pack.add({
	{ src = "git@github.com:navarasu/onedark.nvim.git" },
	{ src = "git@github.com:neanias/everforest-nvim.git" },
	{ src = "git@github.com:ellisonleao/gruvbox.nvim.git" },
})

require("everforest").setup({
	background = "medium",
	transparent_background_level = 1,
})
vim.cmd.colorscheme("everforest")

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
	sections = {
		lualine_c = {
			{ "filename", path = 1 },
		},
	},
	options = {
		theme = "auto",
		disabled_filetypes = { "alpha", "dashboard", "oil", "gitsigns-blame" },
	},
})

-- Mason
vim.pack.add({
	{ src = "git@github.com:williamboman/mason.nvim.git" },
	{ src = "git@github.com:williamboman/mason-lspconfig.nvim.git" },
})
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"gopls",
		"ts_ls",
		"protols",
		"pyright",
		"yamlls",
		"kotlin_lsp",
		"copilot",
		"jdtls",
	},
})

-- Telescope
vim.pack.add({
	{ src = "git@github.com:nvim-telescope/telescope.nvim.git", version = vim.version.range("^0.2") },
	{ src = "git@github.com:natecraddock/telescope-zf-native.nvim.git" },
	{ src = "git@github.com:nvim-telescope/telescope-ui-select.nvim.git" },
})

local telescope = require("telescope")
local builtin = require("telescope.builtin")

telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<esc>"] = "close",
			},
		},
		sorting_strategy = "ascending",
		layout_config = {
			prompt_position = "top",
		},
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

vim.keymap.set("n", "grr", builtin.lsp_references, { desc = "Go to references" })
vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Go to definition" })
vim.keymap.set("n", "gi", builtin.lsp_implementations, { desc = "Go to implementation" })
vim.keymap.set("n", "gs", builtin.lsp_document_symbols, { desc = "Go document symbol" })
vim.keymap.set("n", "<leader>b", builtin.buffers, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
vim.keymap.set("n", "<leader>gc", builtin.git_commits, {})
vim.keymap.set("n", "<leader>gb", builtin.git_bcommits, {})
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

-- Conform formaters
vim.pack.add({
	{ src = "git@github.com:stevearc/conform.nvim.git" },
})

local conform = require("conform")
vim.keymap.set("n", "cf", conform.format, { desc = "Code format" })
conform.setup({
	format_on_save = {
		timeout_ms = 2000,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		go = { "goimports", "gofmt" },
		lua = { "stylua" },
		python = { "black" },
		typescript = { "prettier" },
	},
	default_format_opts = {
		lsp_format = "fallback",
	},
})

-- Blink completion
vim.pack.add({
	{ src = "git@github.com:saghen/blink.cmp.git", version = vim.version.range("^1") },
	{ src = "git@github.com:rafamadriz/friendly-snippets.git" },
	{ src = "git@github.com:fang2hou/blink-copilot.git" },
})

require("blink.cmp").setup({
	-- See :h blink-cmp-config-keymap for defining your own keymap
	keymap = { preset = "enter" },
	sources = {
		default = { "lsp", "copilot", "buffer", "snippets", "path" },
		providers = {
			copilot = {
				name = "copilot",
				module = "blink-copilot",
				score_offset = 100,
				async = true,
				enabled = false,
				opts = {
					max_completions = 3,
				},
			},
		},
	},
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

-- GitSigns
vim.pack.add({
	{ src = "git@github.com:lewis6991/gitsigns.nvim.git" },
})

require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_formatter = " <author>, <author_time:%d/%m/%Y> - <summary>",
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk_inline, { buffer = bufnr })
		vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk, { buffer = bufnr })
		vim.keymap.set("n", "<leader>hR", gitsigns.reset_buffer, { buffer = bufnr })
		vim.keymap.set("n", "]h", gitsigns.next_hunk, { buffer = bufnr })
		vim.keymap.set("n", "[h", gitsigns.prev_hunk, { buffer = bufnr })
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
	{ src = "git@github.com:claydugo/browsher.nvim.git" },
})

require("browsher").setup({
	allow_line_numbers_with_uncommitted_changes = true,
	providers = {
		["git.ringcentral.com"] = {
			url_template = "%s/-/blob/%s/%s",
			single_line_format = "#L%d",
			multi_line_format = "#L%d-%d",
		},
	},
})

vim.keymap.set("n", "<leader>B", "<cmd>Browsher commit<cr>", { silent = true })
vim.keymap.set("v", "<leader>B", ":'<,'>Browsher commit<cr>gv", { silent = true })

-- Autopairs
vim.pack.add({
	{ src = "git@github.com:windwp/nvim-autopairs.git" },
})

require("nvim-autopairs").setup({ check_ts = true })

-- Java Stuff
vim.pack.add({
	{ src = "git@github.com:JavaHello/spring-boot.nvim.git" },
	{ src = "git@github.com:MunifTanjim/nui.nvim.git" },
	{ src = "git@github.com:nvim-java/nvim-java.git" },
})

require("java").setup({
	java_test = {
		enable = false,
	},
	java_debug_adapter = {
		enable = false,
	},
	jdk = {
		auto_install = false,
	},
	spring_boot_tools = {
		enable = true,
	},
})

-- LazyGit
vim.pack.add({
	{ src = "git@github.com:kdheepak/lazygit.nvim.git" },
})

vim.keymap.set("n", "<leader>gg", vim.cmd.LazyGit)
vim.keymap.set("n", "<leader>gl", vim.cmd.LazyGitFilter)
