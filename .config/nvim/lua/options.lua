vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.g.mapleader = " "
vim.g.background = "dark"
vim.opt.swapfile = false
vim.wo.number = true
vim.wo.relativenumber = true
-- clear Cmd after command
vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = “someGroup”,
  callback = function()
    vim.fn.timer_start(500, function()
      vim.cmd [[ echon ' ' ]]
    end)
  end
})

vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})
vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {})
