set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath
if !exists('g:vscode')
source ~/.vimrc

lua << EOF

require("zen-mode").setup { }
EOF
endif

set clipboard=unnamedplus
set completeopt=menuone,noselect

set termguicolors

" :terminal change normal mode keybind
:tnoremap <Esc> <C-\><C-n>
" :T open terminal under current window
command! -nargs=* T split | wincmd j | resize 20 | terminal <args>
" インサートモードでスタート
autocmd TermOpen * startinsert
