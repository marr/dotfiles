" ---------------------------------------------------------------------------
" General
" ---------------------------------------------------------------------------
set nocompatible                      " essential
set history=1000                      " lots of command line history
set cf                                " error files / jumping
set ffs=unix,dos,mac                  " support these files
set isk+=_,$,@,%,#,-                  " none word dividers
set viminfo='1000,f1,:100,@100,/20
set modeline                          " make sure modeline support is enabled
set autoread                          " reload files (no local changes only)
set tabpagemax=50                     " open 50 tabs max
set listchars=trail:.,tab:▸\ ,eol:⤦   " line endings and trailing whitespace

" ----------------------------------------------------------------------------
" Run node and jslint per:
" https://technotales.wordpress.com/2011/05/21/node-jslint-and-vim/
" Leader modes
" ----------------------------------------------------------------------------
nmap <F4> :w<CR>:make<CR>:cw<CR>

let mapleader = ","
"nmap <leader>l :set list!<CR>
"nnoremap <leader>l :ls<CR>:b<space>
:map <C-j> cw<C-r>0<ESC>

" ---------------------------------------------------------------------------
"  Diff
" ---------------------------------------------------------------------------

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
    \ | wincmd p | diffthis
endif

" ---------------------------------------------------------------------------
"  Highlight
" ---------------------------------------------------------------------------

highlight Comment         ctermfg=DarkGrey guifg=#444444
highlight StatusLineNC    ctermfg=Black ctermbg=DarkGrey cterm=bold
highlight StatusLine      ctermbg=Black ctermfg=LightGrey
highlight SpecialKey      ctermfg=DarkGray ctermbg=Black

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
" ----------------------------------------------------------------------------
"  UI
" ----------------------------------------------------------------------------

" Indentation
set cindent
set hlsearch
set ignorecase
set incsearch
set nocompatible
set relativenumber
set softtabstop=4
set shiftwidth=4
set tabstop=4
set ruler                  " show the cursor position all the time
set noshowcmd              " don't display incomplete commands
set nolazyredraw           " turn off lazy redraw
set number                 " line numbers
set wildmenu               " turn on wild menu
set wildmode=list:longest,full
set ch=2                   " command line height
set backspace=2            " allow backspacing over everything in insert mode
set whichwrap+=<,>,h,l,[,] " backspace and cursor keys wrap to
set shortmess=filtIoOA     " shorten messages
set report=0               " tell us about changes
set nostartofline          " don't jump to the start of line when scrolling

" ----------------------------------------------------------------------------
" Visual Cues
" ----------------------------------------------------------------------------

set showmatch              " brackets/braces that is
set mat=5                  " duration to show matching brace (1/10 sec)
set incsearch              " do incremental searching
set laststatus=2           " always show the status line
set ignorecase             " ignore case when searching
set nohlsearch             " don't highlight searches
set visualbell             " shut the fuck up

" ----------------------------------------------------------------------------
" Text Formatting
" ----------------------------------------------------------------------------

set autoindent             " automatic indent new lines
set smartindent            " be smart about it
set nowrap                 " do not wrap lines
set expandtab              " expand tabs to spaces
set nosmarttab             " fuck tabs
set formatoptions+=n       " support for numbered/bullet lists
set textwidth=0            " wrap at 80 chars by default
set virtualedit=block      " allow virtual edit in visual block ..

" Pathogen
execute pathogen#infect()
filetype plugin indent on
syntax enable

let g:project_use_nerdtree = 1
let g:project_disable_tab_title = 1
let g:syntastic_perl_lib_path = [ './lib' ]
let g:syntastic_javascript_checkers = ['eslint']

" vim-project
call project#rc()
Project '.vimrc', 'My Vim'
"Project 'src/phormat', 'My Library'

" Styling
colorscheme snazzy
set gfn=MonacoForPowerline:h12
let g:airline_powerline_fonts = 1

" Leader
let mapleader = ","
" ----------------------------------------------------------------------------
"  Mappings
" ----------------------------------------------------------------------------

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
" quickfix mappings
map <F7>  :cn<CR>
map <S-F7> :cp<CR>
map <A-F7> :copen<CR>

:nnoremap <leader>n :NERDTreeToggle<CR>

" emacs movement keybindings in insert mode
imap <C-a> <C-o>0
imap <C-e> <C-o>$
map <C-e> $
map <C-a> 0

" reflow paragraph with Q in normal and visual mode
nnoremap Q gqap
vnoremap Q gq

" sane movement with wrap turned on
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk

" do not menu with left / right in command line
cnoremap <Left> <Space><BS><Left>
cnoremap <Right> <Space><BS><Right>

" ----------------------------------------------------------------------------
"  Auto Commands
" ----------------------------------------------------------------------------

" Ack for visual selection
vnoremap <Leader>av :<C-u>call <SID>VAck()<CR>:exe "Ack! ".@z.""<CR>
" jump to last position of buffer when opening
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") |
                         \ exe "normal g'\"" | endif

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" Ack for word under cursor
nnoremap <Leader>av :Ack!<cr>
" Open Ack
nnoremap <Leader>ao :Ack! -i
" Start NERDTree when vim is opened
" autocmd VimEnter * NERDTree

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
" Code folding with space
nnoremap <Space> za
" don't use cindent for javascript

" Open multiplely selected files in a tab by default
let g:ctrlp_open_multi = '10t'

" ----------------------------------------------------------------------------
"  dbext  - connect to any database and do crazy shit
" ----------------------------------------------------------------------------

let g:dbext_default_buffer_lines = 20            " result buffer size
let g:dbext_default_use_result_buffer = 1
let g:dbext_default_use_sep_result_buffer = 1    " multiple result buffers
let g:dbext_default_type = 'pgsql'
let g:dbext_default_replace_title = 1
let g:dbext_default_history_file = '~/.dbext_history'
let g:dbext_default_history_size = 200

" ----------------------------------------------------------------------------
"  LookupFile
" ----------------------------------------------------------------------------

" Relative on focus
au FocusLost * :set number
au FocusGained * :set relativenumber
let g:LookupFile_TagExpr = '".ftags"'
let g:LookupFile_MinPatLength = 2
let g:LookupFile_ShowFiller = 0                  " fix menu flashiness
let g:LookupFile_PreservePatternHistory = 1      " preserve sorted history?
let g:LookupFile_PreserveLastPattern = 0         " start with last pattern?

" undotree viewer
nnoremap <Leader>u :UndotreeToggle<CR>
if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif

nmap <unique> <silent> <D-f> <Plug>LookupFile
imap <unique> <silent> <D-f> <C-O><Plug>LookupFile

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

" ----------------------------------------------------------------------------
"  PATH on MacOS X
" ----------------------------------------------------------------------------

if system('uname') =~ 'Darwin'
  let $PATH = $HOME .
    \ '/usr/local/bin:/usr/local/sbin:' .
    \ '/usr/pkg/bin:' .
    \ '/opt/local/bin:/opt/local/sbin:' .
    \ $PATH
endif

" ---------------------------------------------------------------------------
"  sh config
" ---------------------------------------------------------------------------

au Filetype sh,bash set ts=4 sts=4 sw=4 expandtab
let g:is_bash = 1

" ---------------------------------------------------------------------------
"  Misc mappings
" ---------------------------------------------------------------------------

" duplicate current tab with same file+line
map ,t :tabnew %<CR>

" open directory dirname of current file, and in new tab
map ,d :e %:h/<CR>
map ,dt :tabnew %:h/<CR>

" open gf under cursor in new tab
map ,f :tabnew <cfile><CR>

autocmd Filetype html,xml,xsl,php,smarty,htmldjango imap <S-CR> <C-R>=GetCloseTag()<CR>

function! Browser ()
    let line0 = getline (".")
    let line = matchstr (line0, "http[^ )]*")
    let line = escape (line, "#?&;|%")
    exec ':silent !open ' . "\"" . line . "\""
endfunction

map ,w :call Browser ()<CR>

function! EditConflictedArgs()
    call ProcessConflictFiles( argv() )
endfunction

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

" ---------------------------------------------------------------------------
"  Strip all trailing whitespace in file
" ---------------------------------------------------------------------------

function! StripWhitespace ()
    exec ':%s/ \+$//gc'
endfunction

map <leader>s :call StripWhitespace ()<CR>

" Toggle mouse for easier copy/pasting
fun! ToggleMouse()
  if &mouse == 'a'
    set mouse=
    echo 'mouse='
  else
    set mouse=a
    echo 'mouse=a'
  endif
endf
map <F6> :call ToggleMouse()<CR>

" ---------------------------------------------------------------------------
" File Types
" ---------------------------------------------------------------------------

au BufRead,BufNewFile *.py         set ft=python tw=80 ts=4 sw=4 expandtab
au BufRead,BufNewFile *.rpdf       set ft=ruby
au BufRead,BufNewFile *.rxls       set ft=ruby
au BufRead,BufNewFile *.ru         set ft=ruby
au BufRead,BufNewFile *.god        set ft=ruby
au BufRead,BufNewFile *.rtxt       set ft=html spell
au BufRead,BufNewFile *.sql        set ft=pgsql
au BufRead,BufNewFile *.rl         set ft=ragel
au BufRead,BufNewFile *.svg        set ft=svg
au BufRead,BufNewFile *.haml       set ft=haml
au BufRead,BufNewFile *.md         set ft=mkd tw=80 ts=2 sw=2 expandtab
au BufRead,BufNewFile *.markdown   set ft=mkd tw=80 ts=2 sw=2 expandtab
au BufRead,BufNewFile *.ronn       set ft=mkd tw=80 ts=2 sw=2 expandtab
au BufRead,BufNewFile *.tt2        set ft=tt2html
au BufRead,BufNewFile *.js.tt      set ft=tt2js
au BufRead,BufNewFile *.tt         set ft=tt2html
au BufRead,BufNewFile .jshintrc    set ft=javascript
au BufRead,BufNewFile *.psgi       set ft=perl
au BufRead,BufNewFile *.t          set ft=perl
au BufRead,BufNewFile *.css,*.scss,*.less setlocal foldmethod=marker foldmarker={,}

au Filetype gitcommit set tw=68  spell
au Filetype ruby      set tw=80  ts=2
au Filetype html,xml,xsl,php,smarty,htmldjango imap <S-CR> <C-R>=GetCloseTag()<CR>

" Highlight trailing whitespace in vim on non empty lines, but not while typing in insert mode!
highlight ExtraWhitespace ctermbg=red guibg=Brown
au ColorScheme * highlight ExtraWhitespace guibg=red
au BufEnter * match ExtraWhitespace /\S\zs\s\+$/
au InsertEnter * match ExtraWhitespace /\S\zs\s\+\%#\@<!$/
au InsertLeave * match ExtraWhiteSpace /\S\zs\s\+$/

" --------------------------------------------------------------------------
" ManPageView
" --------------------------------------------------------------------------

let g:manpageview_pgm= 'man -P "/usr/bin/less -is"'
let $MANPAGER = '/usr/bin/less -is'

" make file executable
command -nargs=* Xe !chmod +x <args>
command! -nargs=0 Xe !chmod +x %
