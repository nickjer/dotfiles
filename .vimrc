"
" My personal settings
"

" Basics
set nocompatible        " Must be first line
set shell=/bin/bash

" General {
  set background=dark         " Assume a dark background
  filetype plugin indent on   " Automatically detect file types
  syntax on                   " Syntax highlighting
  set mouse=a                 " Automatically enable mouse usage
  set mousehide               " Hide the mouse cursor while typing
  scriptencoding utf-8

  set history=1000            " Store a ton of history (default is 20)
  set spell                   " Spell checking on
  set hidden                  " Allow buffer switching without saving
  set lazyredraw              " Buffer the screen updates

  " Instead of reverting the cursor to the last position in the buffer, we set
  " it to the first line when editing a git commit message
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

  " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
  " Restore cursor to file position in previous editing session {
    function! ResCur()
      if line("'\"") <= line("$")
        silent! normal! g`"
        return 1
      endif
    endfunction

    augroup resCur
      autocmd!
      autocmd BufWinEnter * call ResCur()
    augroup END
  " }

  " Setting up the directories {
    set backup                    " backups are nice ...
    if has('persistent_undo')
      set undofile                " So is persistent undo ...
      set undolevels=1000         " Maximum number of changes that can be undone
      set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
    endif
  " }
" }

" Vim UI {
  set tabpagemax=50               " Only show 50 tabs
  set cursorline                  " Highlight current line
  highlight clear SignColumn      " SignColumn should match background
  highlight clear LineNr          " Current line number row will have same background color in relative mode
  set backspace=indent,eol,start  " Backspace for dummies
  set linespace=0                 " No extra spaces between rows
  set number                      " Line numbers on
  set showmatch                   " Show matching brackets/parenthesis
  set incsearch                   " Find as you type search
  set hlsearch                    " Highlight search terms
  set winminheight=0              " Windows can be 0 line high
  set ignorecase                  " Case insensitive search
  set smartcase                   " Case sensitive when uc present
  set wildmenu                    " Show list instead of just completing
  set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
  set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
  set scrolljump=5                " Lines to scroll when cursor leaves screen
  set scrolloff=3                 " Minimum lines to keep above and below cursor
  set sidescrolloff=5             " Minimum lines to keep left and right cursor
  set foldenable                  " Auto fold code
  set list
  set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
  set colorcolumn=80              " Set column where formatting breaks lines

  if has('cmdline_info')
    set ruler                   " Show the ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
    set showcmd                 " Show partial commands in status line and
                                " Selected characters/lines in visual mode
  endif

  if has('statusline')
    set laststatus=2

    " Broken down into easily includeable segments
    set statusline=%<%f\                     " Filename
    set statusline+=%w%h%m%r                 " Options
    set statusline+=%{fugitive#statusline()} " Git Hotness
    set statusline+=\ [%{&ff}/%Y]            " Filetype
    set statusline+=\ [%{getcwd()}]          " Current dir
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
  endif
" }

" Formatting {
  set nowrap                      " Do not wrap long lines
  set autoindent                  " Indent at the same level of the previous line
  set shiftwidth=2                " Use indents of 2 spaces
  set expandtab                   " Tabs are spaces, not tabs
  set tabstop=2                   " An indentation every 2 columns
  set softtabstop=2               " Let backspace delete indent
  set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
  set splitright                  " Puts new vsplit windows to the right of the current
  set splitbelow                  " Puts new split windows to the bottom of the current
  set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)

  autocmd BufNewFile,BufRead *.md set filetype=markdown
" }

" Key (re)Mappings {
  let mapleader = ','             " default leader is '\', but I prefer ','
  let maplocalleader = '_'        " set local leader to '_'

  " Yank from the cursor to the end of the line, to be consistent with C and D
  nnoremap Y y$

  " Visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv

  " For when you forget to sudo.. Really Write the file.
  cmap w!! w !sudo tee % >/dev/null

  " Toggle search highlighting
  nmap <silent> <leader>/ :set invhlsearch<CR>

  " Wrapped lines goes down/up to next row, rather than next line in file.
  noremap j gj
  noremap k gk
" }

" Plugins {
  call plug#begin('~/.vim/plugged')  " specify dir for plugins
  Plug 'morhetz/gruvbox'
  Plug 'airblade/vim-gitgutter'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-syntastic/syntastic'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'myusuf3/numbers.vim'
  Plug 'scrooloose/nerdcommenter'
  Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
  Plug 'junegunn/fzf', { 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
  Plug 'othree/html5.vim', { 'for': 'html' }
  Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
  Plug 'slim-template/vim-slim', { 'for': 'slim' }
  Plug 'rhysd/vim-crystal', { 'for': 'crystal' }
  Plug 'rust-lang/rust.vim', { 'for': 'rust' }
  call plug#end()

  " Gruvbox {
    let g:gruvbox_contrast_dark = 'hard'
    colorscheme gruvbox
  " }

  " GitGutter {
    let g:gitgutter_realtime = 0
    let g:gitgutter_eager = 0
  " }

  " Airline {
  " }

  " Syntastic {
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
  " }

  " Fugitive {
  " }

  " IndentGuides {
    let g:indent_guides_enable_on_vim_startup = 1
  " }

  " numbers.vim {
    nnoremap <F3> :NumbersToggle<CR>
  " }

  " NERDCommenter {
    let g:NERDDefaultAlign = 'left'
  " }

  " NERDTree {
    nmap <C-e>      :NERDTreeToggle<CR>
    nmap <leader>e  :NERDTreeFind<CR>

    let NERDTreeQuitOnOpen = 1
    let NERDTreeMouseMode = 2
    let NERDTreeShowHidden = 1
  " }

  " FZF {
    " Mapping selecting mappings
    nmap <leader><tab> <plug>(fzf-maps-n)
    xmap <leader><tab> <plug>(fzf-maps-x)
    omap <leader><tab> <plug>(fzf-maps-o)

    nmap <leader>ff :Files<CR>
    nmap <leader>fg :GFiles<CR>
    nmap <leader>fb :Buffers<CR>
  " }

  " Tabularize {
    nmap <leader>a= :Tabularize /=<CR>
    vmap <leader>a= :Tabularize /=<CR>
    nmap <leader>a: :Tabularize /:\zs<CR>
    vmap <leader>a: :Tabularize /:\zs<CR>
  " }

  " html5.vim {
  " }
" }

" Functions {
  " Strip whitespace {
    function! StripTrailingWhitespace()
      " Preparation: save last search, and cursor position.
      let _s=@/
      let l = line(".")
      let c = col(".")
      " do the business:
      %s/\s\+$//e
      " clean up: restore previous search history, and cursor position
      let @/=_s
      call cursor(l, c)
    endfunction
  " }

  " Initialize directories {
    function! InitializeDirectories()
      let parent = $HOME . '/.vim/cache'
      let dir_list = {
            \ 'backup': 'backupdir',
            \ 'views': 'viewdir',
            \ 'swap': 'directory' }

      if has('persistent_undo')
        let dir_list['undo'] = 'undodir'
      endif

      for [dirname, settingname] in items(dir_list)
        let directory = parent . '/' . dirname
        if exists("*mkdir")
          if !isdirectory(directory)
            call mkdir(directory, 'p')
          endif
        endif
        if !isdirectory(directory)
          echo "Warning: Unable to create backup directory: " . directory
          echo "Try: mkdir -p " . directory
        else
          let directory = substitute(directory, " ", "\\\\ ", "g")
          exec "set " . settingname . "=" . directory
        endif
      endfor
    endfunction
    call InitializeDirectories()
  " }
" }
