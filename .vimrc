imap <C-S> <Esc>:w<CR>
" ----------------------------------------------------------------------------
" Run node and jslint per:
" https://technotales.wordpress.com/2011/05/21/node-jslint-and-vim/
" ----------------------------------------------------------------------------
nmap <F4> :w<CR>:make<CR>:cw<CR>

" ----------------------------------------------------------------------------
"  Backups
" ----------------------------------------------------------------------------

set nobackup                           " do not keep backups after close
set nowritebackup                      " do not keep a backup while working
set noswapfile                         " don't keep swp files either
set backupdir=$HOME/.vim/backup        " store backups under ~/.vim/backup
set backupcopy=yes                     " keep attributes of original file
set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
set directory=~/.vim/swap,~/tmp,.      " keep swp files under ~/.vim/swap

" Indentation
set cindent
set hlsearch
set ignorecase
set incsearch
set nocompatible
set relativenumber
set softtabstop=4          " stick with convention
set shiftwidth=4           " ..
set tabstop=4
set expandtab              " expand tabs to spaces

" Pathogen
execute pathogen#infect()
filetype plugin indent on
syntax enable

let g:project_use_nerdtree = 1
let g:project_disable_tab_title = 1
let g:syntastic_perl_lib_path = [ './lib' ]

" vim-project
call project#rc("~")
Project 'src/status', 'Status Library'
Project 'projects/demo', 'Dancer + React Demo'
Project 'projects/phormat', 'Phormat'
Project 'projects/seedbox', 'Seedbox'
Project 'myapp', 'Authenticated app perl Dancer'
Project 'src/Plack', "Plack"
Project 'src/Dancer', "Dancer"

" Styling
colorscheme jellybeans
set gfn=MonacoForPowerline:h12
let g:airline_powerline_fonts = 1

" Leader
let mapleader = ","

" Set Ctrl-P to show match at top of list instead of at bottom, which is so
" stupid that it's not default
let g:ctrlp_match_window_reversed = 0

" Tell Ctrl-P to keep the current VIM working directory when starting a
" search, another really stupid non default
let g:ctrlp_working_path_mode = 0

" Ctrl-P ignore target dirs so VIM doesn't have to! Yay!
let g:ctrlp_custom_ignore = {
    \ 'dir': '\.git$\|\.hg$\|\.svn$\|target$\|built$\|.build$\|node_modules\|\.sass-cache',
    \ 'file': '\.ttc$',
    \ }

" Visual ack, used to ack for highlighted text
function! s:VAck()
  let old = @"
  norm! gvy
  let @z = substitute(escape(@", '\'), '\n', '\\n', 'g')
  let @" = old
endfunction

" Pasting doesnt clobber undo chunk
"inoremap <D-v> <esc>isplat-v

" Ack for visual selection
vnoremap <Leader>av :<C-u>call <SID>VAck()<CR>:exe "Ack! ".@z.""<CR>

" Ack for word under cursor
nnoremap <Leader>av :Ack!<cr>
" Open Ack
nnoremap <Leader>ao :Ack! -i

" Code folding with space
nnoremap <Space> za

" Open multiplely selected files in a tab by default
let g:ctrlp_open_multi = '10t'

" Highlight files nicely
au BufRead,BufNewFile *.tt2 setf tt2html
au BufRead,BufNewFile *.js.tt setf tt2js
au BufRead,BufNewFile *.tt setf tt2html
au BufRead,BufNewFile .jshintrc setf javascript
au BufRead,BufNewFile *.psgi setf perl

" For test files
au BufRead,BufNewFile *.t setfiletype perl
autocmd BufRead,BufNewFile *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,}

" Relative on focus
au FocusLost * :set number
au FocusGained * :set relativenumber

" Gundo tree viewer
nnoremap <Leader>u :GundoToggle<CR>

" Status bar
set laststatus=2
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " file name
set statusline+=%h%m%r%w                     " flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}, " filetype
set statusline+=%{&encoding},                " encoding
set statusline+=%{&fileformat}]              " file format
set statusline+=%{fugitive#statusline()}
set statusline+=%=                           " right align
set statusline+=%-10.(%l,%c%V%)\ %<%P        " offset

" Highlight trailing whitespace in vim on non empty lines, but not while typing in insert mode!
highlight ExtraWhitespace ctermbg=red guibg=Brown
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\S\zs\s\+$/
au InsertEnter * match ExtraWhitespace /\S\zs\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\S\zs\s\+$/

function! EditConflictFiles()
    let filter = system('git diff --name-only --diff-filter=U')
    let conflicted = split( filter, '\n')
    let massaged = []

    for conflict in conflicted
        let tmp = substitute(conflict, '\_s\+', '', 'g')
        if len( tmp ) > 0
            call add( massaged, tmp )
        endif
    endfor

    call ProcessConflictFiles( massaged )
endfunction

function! EditConflictedArgs()
    call ProcessConflictFiles( argv() )
endfunction

" Experimental function to load vim with all conflicted files
function! ProcessConflictFiles( conflictFiles )
    " These will be conflict files to edit
    let conflicts = []

    " Read git attributes file into a string
    let gitignore = readfile('.gitattributes')
    let ignored = []
    for ig in gitignore
        " Remove any extra things like -diff (this could be improved to
        " actually use some syntax to know which files ot ignore, like check
        " if [1] == 'diff' ?
        let spl = split( ig, ' ' )
        if len( spl ) > 0
            call add( ignored, spl[0] )
        endif
    endfor

    " Loop over each file in the arglist (passed in to vim from bash)
    for conflict in a:conflictFiles

        " If this file is not ignored in gitattributes (this could be improved)
        if index( ignored, conflict ) < 0

            " Grep each file for the starting error marker
            let cmd = system("grep -n '<<<<<<<' ".conflict)

            " Remove the first line (grep command) and split on linebreak
            let markers = split( cmd, '\n' )

            for marker in markers
                let spl = split( marker, ':' )

                " If this line had a colon in it (otherwise it's an empty line
                " from command output)
                if len( spl ) == 2

                    " Get the line number by removing the white space around it,
                    " because vim is a piece of shit
                    let line = substitute(spl[0], '\_s\+', '', 'g')
                    
                    " Add this file to the list with the data format for the quickfix
                    " window
                    call add( conflicts, {'filename': conflict, 'lnum': line, 'text': spl[1]} )
                endif
            endfor
        endif
        
    endfor

    " Set the quickfix files and open the list
    call setqflist( conflicts )
    execute 'copen'
    execute 'cfirst'

    " Highlight diff markers and then party until you shit
    highlight Conflict guifg=white guibg=red
    match Conflict /^=\{7}.*\|^>\{7}.*\|^<\{7}.*/
    let @/ = '>>>>>>>\|=======\|<<<<<<<'
endfunction

