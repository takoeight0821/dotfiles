" Skip initialization for vim-tiny or vim-small
if 0 | endif

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

let s:vimrc = expand("<sfile>:p")
let $MYVIMRC = s:vimrc

" NeoBundle path
if s:is_windows
  let $DOTVIM = expand('~/vimfiles')
else
  let $DOTVIM = expand('~/.vim')
endif

" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" プラグインリストを収めた TOML ファイル
let s:toml      = $DOTVIM . '/rc/dein.toml'
let s:lazy_toml = $DOTVIM . '/rc/dein_lazy.toml'

" 設定開始
call dein#begin(s:dein_dir, [expand('<sfile>'), s:toml, s:lazy_toml])

call dein#load_toml(s:toml,      {'lazy': 0})
call dein#load_toml(s:lazy_toml, {'lazy': 1})

call dein#end()
call dein#save_state()

if has('vim_starting') && dein#check_install()
  call dein#install()
endif

filetype plugin indent on

set number
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set smartindent
set pastetoggle=<F11>

set nobackup
set noundofile
set noswapfile

set background=dark
let base16colorspace=256
colorscheme base16-railscasts

let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

let g:slimv_lisp = 'ros run'
let g:slimv_impl = 'sbcl'
