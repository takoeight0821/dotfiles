" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')

" vim-lsp
let g:lsp_diagnostics_float_cursor = 1
let g:lsp_diagnostics_highlights_enabled = 0

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    inoremap <buffer> <expr><c-f> lsp#scroll(+4)
    inoremap <buffer> <expr><c-d> lsp#scroll(-4)

    " Remap keys for applying codeAction to the current buffer.
    nmap <leader>ac  <Plug>(lsp-code-action)
    nmap <leader>cl  <Plug>(lsp-code-lens)
    nmap <leader>gf :<c-u>call lsp#internal#document_formatting#format({ 'bufnr': bufnr('%') })<cr>

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Haskell
" if executable('haskell-language-server-wrapper')
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'haskell-language-server-wrapper',
"         \ 'cmd': {server_info->['haskell-language-server-wrapper', '--lsp']},
"         \ 'root_uri':{server_info->lsp#utils#path_to_uri(
"         \     lsp#utils#find_nearest_parent_file_directory(
"         \         lsp#utils#get_buffer_path(),
"         \         ['.cabal', 'stack.yaml', 'cabal.project', 'package.yaml', 'hie.yaml', '.git'],
"         \     ))},
"         \ 'whitelist': ['haskell', 'lhaskell'],
"         \ })
" endif

" Malgo
if executable('malgo')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'malgo',
        \ 'cmd': {server_info->['malgo', 'lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(
        \     lsp#utils#find_nearest_parent_file_directory(
        \         lsp#utils#get_buffer_path(),
        \         ['.git'],
        \     ))},
        \ 'whitelist': ['malgo'],
        \ })
endif
