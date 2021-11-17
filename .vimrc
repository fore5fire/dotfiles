set number
set title
set clipboard=unnamedplus
syntax on
set shiftwidth=4
set softtabstop=4
set expandtab                     " use spaces, not tab characters
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set incsearch                     " show search results as I type
set smartcase                     " pay attention to case when caps are used
set ruler                         " show row and column in footer
set autochdir
" let g:netrw_banner = 0
" let g:netrw_liststyle = 3
" let g:netrw_browse_split = 4
" let g:netrw_altv = 1
" let g:netrw_winsize = 25
" augroup ProjectDrawer
"   autocmd!
"   autocmd VimEnter * :Vexplore
" augroup END

function SmoothScroll(scroll_direction, n_scroll)
    let n_scroll = a:n_scroll
    if a:scroll_direction == 1
        let scrollaction=""
    else 
        let scrollaction=""
    endif
    exec "normal " . scrollaction
    redraw
    let counter=1
    while counter<&scroll*n_scroll
        let counter+=1
        sleep 5m " ms per line
        redraw
        exec "normal " . scrollaction
    endwhile
endfunction

" smoothly scroll the screen for some scrolling operations
nnoremap <C-U> :call SmoothScroll(1,1)<cr>
nnoremap <C-D> :call SmoothScroll(2,1)<cr>
nnoremap <C-B> :call SmoothScroll(1,2)<cr>
nnoremap <C-F> :call SmoothScroll(2,2)<cr>
