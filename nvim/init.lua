if vim.g.vscode then
    -- VSCode extension
    -- https://github.com/vscode-neovim/vscode-neovim/issues/298
    vim.opt.clipboard:append("unnamedplus")
    return
end

vim.api.nvim_set_option('ignorecase', true)
vim.api.nvim_set_option('smartcase', true)

vim.api.nvim_buf_set_option(0, 'tabstop', 4)
vim.api.nvim_buf_set_option(0, 'shiftwidth', 4)
vim.api.nvim_buf_set_option(0, 'autoindent', true)
vim.api.nvim_set_option('smarttab', true)
vim.api.nvim_buf_set_option(0, 'smartindent', true)
vim.api.nvim_buf_set_option(0, 'expandtab', true)

vim.api.nvim_win_set_option(0, 'number', true)
vim.api.nvim_set_option('cmdheight', 2)

vim.opt.clipboard = { 'unnamed', 'unnamedplus' }

vim.o.statusline = '[%n] %<%f%h%m'

vim.api.nvim_set_option('updatetime', 300)

vim.api.nvim_set_keymap('', '<Space>', '', {})
vim.g.mapleader = ' '

-- require('plugins')

-- vim.cmd.colorscheme('onedark')
vim.api.nvim_set_option('termguicolors', true)
