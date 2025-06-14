" Vim configuration for 42 School
" ================================

" Basic settings
syntax on
set number
set ruler
set showmatch
set smartindent
set autoindent
set mouse=a

" 42 Norminette compliant settings
set tabstop=4
set shiftwidth=4
set noexpandtab

" Visual settings
colorscheme desert
set cursorline
set showcmd
set wildmenu

" Search settings
set hlsearch
set incsearch
set ignorecase
set smartcase

" File handling
set autoread
set nobackup
set noswapfile

" 42 Header shortcuts
" F1 to insert 42 header
nnoremap <F1> :Stdheader<CR>
inoremap <F1> <Esc>:Stdheader<CR>o

" Useful shortcuts for 42 development
nnoremap <F2> :!norminette %<CR>
nnoremap <F3> :!gcc -Wall -Wextra -Werror %<CR>
nnoremap <F4> :!make<CR>
nnoremap <F5> :!make clean<CR>

" Split navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Quick save and quit
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>

" Toggle line numbers
nnoremap <leader>n :set number!<CR>

" Clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>

" Auto-commands
" Remove trailing whitespace on save for C files
autocmd BufWritePre *.c,*.h :%s/\s\+$//e

" Auto-insert newline at end of file if missing
autocmd BufWritePre *.c,*.h :if getline('$') !~ '^\s*$' | call append(line('$'), '') | endif

" Set filetype for header files
autocmd BufNewFile,BufRead *.h set filetype=c

" Folding settings
set foldmethod=syntax
set foldlevelstart=99

" Status line
set laststatus=2
set statusline=%f\ %m%r%h%w\ [%{&ff}]\ [%Y]\ [%04l,%04v]\ [%p%%]\ [%L\ lines]

" Highlight trailing whitespace and tabs
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" Show tabs as characters (fixed encoding issue)
set list
set listchars=tab:>-,trail:.

" Disable arrow keys to force hjkl usage
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
inoremap <Up> <NOP>
inoremap <Down> <NOP>
inoremap <Left> <NOP>
inoremap <Right> <NOP>

" Comment/uncomment blocks
vnoremap <leader>c :s/^/\/\/ /<CR>:nohlsearch<CR>
vnoremap <leader>u :s/^\/\/ //<CR>:nohlsearch<CR>

" Quick compilation shortcuts
nnoremap <leader>g :!gcc -Wall -Wextra -Werror -g %<CR>
nnoremap <leader>v :!valgrind ./a.out<CR>
nnoremap <leader>r :!./a.out<CR>

" 42 specific templates
" Template for new C files
autocmd BufNewFile *.c 0r ~/.vim/templates/template.c
autocmd BufNewFile *.h 0r ~/.vim/templates/template.h

" Ensure proper 42 formatting
set encoding=utf-8
set fileformat=unix
