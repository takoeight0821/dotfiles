-- Set options
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Tabs and indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Line wrapping
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true

-- Cursor line
opt.cursorline = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"

-- Backspace
opt.backspace = "indent,eol,start"

-- Clipboard
opt.clipboard:append("unnamedplus")

-- Split windows
opt.splitright = true
opt.splitbelow = true

-- Consider - as part of word
opt.iskeyword:append("-")

-- Disable swapfile
opt.swapfile = false

-- Enable mouse
opt.mouse = "a"

-- Set completeopt for better completion experience
opt.completeopt = "menu,menuone,noselect"

-- Persistent undo
opt.undofile = true

-- Interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- Set timeout for mapped sequences
opt.timeoutlen = 300