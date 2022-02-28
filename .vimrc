set nocompatible

" Skip initialization for vim-tiny or vim-small
if 0 | endif

let g:polyglot_disabled = ['handlebars']

let s:true  = 1
let s:false = 0

" platform
" https://github.com/b4b4r07/dotfiles/blob/master/.vimrc
let s:is_windows = has('win16') || has('win32') || has('win64')
let s:is_cygwin = has('win32unix')
let s:is_mac = !s:is_windows && !s:is_cygwin
      \ && (has('mac') || has('macunix') || has('gui_macvim') ||
      \    (!executable('xdg-open') &&
      \    system('uname') =~? '^darwin'))
let s:is_linux = !s:is_mac && has('unix')

"if has('nvim')
"    let g:vim_home = expand('~/.nvim')
"    let g:rc_dir = expand('~/.nvim/rc')
"else
    let g:vim_home = expand('~/.vim')
    let g:rc_dir = expand('~/.vim/rc')
"endif

" rcファイル読み込み関数
" call s:source_rc('init.rc.vim')
" -> .vim/rc/init.rc.vimが読み込まれる
function! s:source_rc(rc_file_name)
    let rc_file = expand(g:rc_dir . '/' . a:rc_file_name)
    if filereadable(rc_file)
        execute 'source' rc_file
    endif
endfunction

call plug#begin('~/.vim/plugged')
" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" coc.nvim
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" coc-fzf
Plug 'antoinemadec/coc-fzf'

" Defx
if has('nvim')
  Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/defx.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" if has('nvim')
"   Plug 'neovim/nvim-lspconfig'
"   Plug 'ojroques/nvim-lspfuzzy'
"   Plug 'hrsh7th/nvim-compe'
"   Plug 'ray-x/lsp_signature.nvim'
"   Plug 'nvim-lua/lsp-status.nvim'
" else
"   " vim-lsp
"   Plug 'prabirshrestha/vim-lsp'
"   Plug 'mattn/vim-lsp-settings'
"   Plug 'prabirshrestha/asyncomplete.vim'
"   Plug 'prabirshrestha/asyncomplete-lsp.vim'
" endif

Plug 'sheerun/vim-polyglot'
Plug 'fnune/base16-vim'
" Plug 'bronson/vim-trailing-whitespace'
" Plug 'wakatime/vim-wakatime'

" vim-fugitive
Plug 'tpope/vim-fugitive'

" Plug 'hsanson/vim-android'

Plug 'machakann/vim-sandwich'

if has('nvim')
  Plug 'folke/zen-mode.nvim'
endif

Plug 'vim-denops/denops.vim'
Plug 'vim-denops/denops-helloworld.vim'
Plug 'vim-skk/skkeleton'

" Haskell Formatting
" Plug 'sdiehl/vim-ormolu'
call plug#end()

filetype plugin indent on
syntax enable
set hlsearch

set ignorecase
set smartcase

set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set smarttab
set smartindent
set expandtab
set nofixeol

set backspace=2
set wrapscan
set showmatch
set wildmenu
set formatoptions+=mM

set number
set ruler
set wrap
set laststatus=2
set cmdheight=2
set showcmd
set notitle

set nobackup
set noswapfile
set autowriteall

set clipboard^=unnamed,unnamedplus

let base16colorspace=256
" colorscheme base16-material
colorscheme base16-onedark
" colorscheme default

function! s:base16_customize() abort
  " call Base16hi("MatchParen", g:base16_gui05, g:base16_gui03, g:base16_cterm05, g:base16_cterm03, "bold,italic", "")
  " call Base16hi("Operator", g:base16_gui0E, g:base16_gui00, g:base16_cterm0E, g:base16_cterm00, "", "")
  hi clear ErrorHighlight
  hi clear WarningHighlight
  hi clear InfoHighlight
  hi clear HintHighlight
  call Base16hi("ErrorHighlight",   "", "", "", "", "underline", g:base16_gui08)
  call Base16hi("WarningHighlight", "", "", "", "", "underline", g:base16_gui09)
  call Base16hi("InfoHighlight",    "", "", "", "", "underline", g:base16_gui0D)
  call Base16hi("HintHighlight",    "", "", "", "", "underline", g:base16_gui0C)

endfunction

augroup on_change_colorschema
  autocmd!
  " autocmd ColorScheme * call s:base16_customize()
augroup END

set background=dark

set statusline^=[%n]\ %<%f%h%m

noremap <Space> <Nop>
sunmap <Space>
let mapleader = "\<Space>"

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" from: https://vcavallo.github.io/vim/markdown/how_to/2017/02/28/vim-function-to-visually-center-a-plaintext-file.html

" centers the current pane as the middle 2 of 4 imaginary columns
" should be called in a window with a single pane

 function CenterPane()
   lefta vnew
   wincmd w
   exec 'vertical resize '. string(&columns * 0.75)
 endfunction

" optionally map it to a key:
" nnoremap <leader>c :call CenterPane()<cr>

" syntax highlight for malgo
au BufRead,BufNewFile *.mlg set filetype=malgo

" %% shortcut
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h') . '/' : '%%'

" .vimrc.local
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

" :JunkFile
" From: https://vim-jp.org/vim-users-jp/2010/11/03/Hack-181.html
" Open junk file.
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
  let l:junk_dir = $HOME . '/.vim_junk'. strftime('/%Y/%m')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction

" :Diary
" Open diary.adoc
" Set $DIARY_PATH to the directory your diary in.
command! -nargs=0 Diary call s:open_diary_file()
function! s:open_diary_file()
  let l:diary_dir = $DIARY_PATH
  let l:diary_file = $DIARY_PATH . '/diary.md'
  execute 'edit ' . l:diary_file
endfunction


" Highlighting whitespaces with a search
command! TrailSpaceCheck /\s\+$

let g:android_sdk_path = expand("$ANDROID_HOME")
let g:gradle_loclist_show = 0
let g:gradle_show_signs = 0

" coc.nvim
call s:source_rc('coc.nvim.vim')

" Defx
call s:source_rc('defx.vim')

" vim-trailing-whitespace
call s:source_rc('vim-trailing-whitespace.vim')

" vim-lsp
" if !has("nvim")
"   call s:source_rc('vim-lsp.vim')
" endif

" settings for go
autocmd BufNewFile,BufRead *.go setlocal noexpandtab tabstop=4 shiftwidth=4

" skkeleton
call skkeleton#config({ 'globalJisyo': '~/.skk/SKK-JISYO.L' })
imap <C-j> <Plug>(skkeleton-enable)
cmap <C-j> <Plug>(skkeleton-enable)
