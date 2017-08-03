""""""""""
" @kaiuhl's vim configuration, 2017
"
" Depedencies
"   - Plug.vim (https://github.com/junegunn/vim-plug)
"   - Silver searcher (https://github.com/ggreer/the_silver_searcher)
"   - Alt (https://github.com/uptech/alt)


""""""""""
" Basic Config
"
syntax on
filetype on
filetype indent on
filetype plugin on

set nocompatible
set nohidden 
set confirm
set ic
set linespace=2
set shiftwidth=2
set tabstop=2
set number
set noswapfile
set showtabline=0
set colorcolumn=90
set ignorecase
set hlsearch
set updatetime=1000
set list
set nowrap
set guioptions=
set fillchars=vert:\ 
set splitright
set noexpandtab "tabs, sigh


""""""""""
" Edit and source this vim config
"

nnoremap <leader><leader>v :e ~/.vimrc<cr>
nnoremap <leader><leader>vs :source ~/.vimrc<cr>


""""""""""
" Aesthetics
"

set listchars=tab:..,nbsp:␣,trail:•,extends:⟩,precedes:⟨
set guifont=LetterGothicMono\ Light:h15
colorscheme kyle
let macvim_skip_colorscheme=1
let g:airline_theme = 'distinguished'
set laststatus=2


""""""""""
" Code Navigation
"

" Jump between current file and previously edited
nnoremap <leader><leader><leader> :b#<cr>

" Unhighlight all instances of search term by pressing enter
noremap <cr> :nohlsearch<cr>

" Jump to beginning of line, end of line
noremap H ^
noremap L $

" Move lines of code up and down
nnoremap - ddp
nnoremap + ddkP

" Jump to matching paren or brace
noremap <leader>] %

" Navigate through changes (<alt+j, alt+k)
nnoremap ˚ g;
nnoremap ∆ g,

" Move between splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Split views vertically, adding previous buffer to other split
nmap <leader>v :vsplit<cr><c-l><leader><leader><leader><c-h>

" Find the alternate file for the current path and open it
nnoremap <leader>a :w<cr>:call AltCommand(expand('%'), ':e')<cr>

" use emacs-style tab completion when selecting files, etc
set wildmode=list
set wildmenu


""""""""""
" Plugin configuration
"

" Ruby configuration
let g:ruby_indent_assignment_style = 'variable'

" Silver Searcher configuration
noremap <D-F> :Ack! ""<left>
set grepprg=ag\ --nogroup\ --nocolor
let g:ackprg = 'ag --vimgrep --smart-case'

" CtrlP configuration
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
let g:ctrlp_max_files = 99999
nmap <D-O> <c-p>

" NERDTree configuration
let g:NERDTreeChDirMode = 2
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
noremap <c-o> :NERDTreeToggle<cr>
noremap <c-f> :NERDTreeFind<cr>

" Syntastic configuration
let g:syntastic_mode_map = { 'mode': 'active',
                            \ 'active_filetypes': ['ruby', 'javascript'],
                            \ 'passive_filetypes': [] }

let g:syntastic_html_checkers=['']
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']

" Find word under cursor
nnoremap <leader>f :Ack! "<cword>"<cr>

" Toggle word wrap
noremap <leader>tw :set wrap!<cr>


""""""""""
" Code manipulation
"

" Comment out code with <⌘ +/>
let g:NERDSpaceDelims = 1
map <D-/> <leader>c<space>


""""""""""
" Shell command mappings
"

" RSpec.vim mappings
noremap <leader>rs :call RunNearestSpec()<cr>
noremap <leader>rf :call RunCurrentSpecFile()<cr>
noremap <leader>r :call RunAllSpecs()<cr>

" Git shortcuts
nnoremap <leader>gb :Gblame<cr>
nnoremap <leader>gh :Gbrowse<cr>


""""""""""
" Functions
"

" Tab completion (except at beginning of line)
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

" Find alternate files
function! AltCommand(path, vim_command)
  let l:alternate = system("alt " . a:path)
  if empty(l:alternate)
    echo "No alternate file for " . a:path . " exists!"
  else
    exec a:vim_command . " " . l:alternate
  endif
endfunction


""""""""""
" Auto commands
"

" Resize splits automatically when the window is resized
autocmd VimResized * wincmd =

" Delete trailing spaces on save
autocmd BufWritePre *.rb,*.html,*.erb,*.css,*.scss,*.sass,*.js,*.coffee,*.hbs :%s/\s\+$//e

" Jump to last line when opening a file
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Always show the file browser
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Close vim if the last buffer is the file browser
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


""""""""""
" Plug.vim plugins
"

call plug#begin('~/.vim/plugged')

" File browser
Plug 'scrooloose/nerdtree'

" Syntax highlighting and linting
Plug 'vim-syntastic/syntastic'

" Surrounding verb
Plug 'tpope/vim-surround'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'

" Ruby syntax highlighting and formatting
Plug 'vim-ruby/vim-ruby'

" Integration with running rspec from the editor
Plug 'thoughtbot/vim-rspec'

" Ctrl+P fuzzy finder
Plug 'kien/ctrlp.vim', { 'tag': '1.80' }

" Ack in vim
Plug 'mileszs/ack.vim', { 'tag': '1.0.9' }

" Pretty colors
Plug 'carakan/new-railscasts-theme'
 
" Commenting out of code
Plug 'scrooloose/nerdcommenter'

" Bar at the bottom of VIM showing status
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Handlebars!
Plug 'nono/vim-handlebars'

" Diffs in gutter!
Plug 'airblade/vim-gitgutter'

call plug#end()

