vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.background = "dark"

vim.opt.swapfile = false

-- line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- break lines at word boundaries
vim.opt.linebreak = true

-- use spaces instead of tabs
vim.opt.expandtab = true

-- number of spaces for identation
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- number of spaces used for <tab>
vim.opt.tabstop = 2

-- languages for spell checking
vim.opt.spelllang = { 'en', 'ru' }

-- lang map
vim.opt.langmap = {
  'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ',
  'фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz',
}

-- Diagnostics setup
vim.diagnostic.config({
  virtual_lines = {
    current_line = true,
  },
})

-- clear Cmd after command
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = “someGroup”,
  callback = function()
    vim.fn.timer_start(500, function()
      vim.cmd [[ echon ' ' ]]
    end)
  end
})


-- LSP's setup 
vim.lsp.config['gopls'] = {
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

vim.lsp.config['tsls'] = {
  cmd = { "typescript-language-server", "--stdio" },
  filetypes = { "typescript" },
  root_markers = { "tsconfig.json", "package.json" },
  settings = {},
}

vim.lsp.config['luals'] = {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' },
      },
      runtime = {
        version = 'LuaJIT',
      }
    }
  }
}

vim.lsp.enable('luals')
vim.lsp.enable('gopls')
vim.lsp.enable('tsls')


vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover information" })
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Code format" })
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Code Rename" })

vim.keymap.set('n', '<esc>', '<cmd>nohlsearch<cr>')

vim.keymap.set("n", "<C-j>", ":m +1<CR>", {})
vim.keymap.set("n", "<C-k>", ":m -2<CR>", {})


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
    "nvim-telescope/telescope-ui-select.nvim",
  },
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          file_ignore_patterns = {
            "node_modules",
            "dist",
            "coverage",
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { desc = "Go to definition" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader>fo", builtin.oldfiles, {})
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, {})

      require("telescope").load_extension("ui-select")
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
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      current_line_blame = true,
      current_line_blame_formatter = ' <author>, <author_time:%d/%m/%Y> - <summary>',
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')

        local function map(l, r, desc)
          vim.keymap.set('n', l, r, { buffer = bufnr, desc = 'Gitsigns: ' .. desc })
        end

        map('<leader>ph', gitsigns.preview_hunk, 'Preview hunk')
        map('<leader>rh', gitsigns.reset_hunk, 'Reset hunk')
        map('<leader>lb', function() gitsigns.blame_line({ full = true }) end, 'Blame line')
        map(']h', gitsigns.next_hunk, 'Next hunk')
        map('[h', gitsigns.prev_hunk, 'Prev hunk')
      end,
      worktrees = {
        {
          toplevel = vim.env.HOME,
          gitdir = vim.env.HOME .. '/.dotfiles'
        }
      }
    },
  },
  {
    'linrongbin16/gitlinker.nvim',
    cmd = 'GitLink',
    config = function()
      require('gitlinker').setup({
        router = {
          browse = {
            ["^git%.ringcentral%.com"] = require('gitlinker.routers').gitlab_browse,
          },
          blame = {
            ["^git%.ringcentral%.com"] = require('gitlinker.routers').gitlab_blame,
          },
        },
      })
    end,
  },
})
