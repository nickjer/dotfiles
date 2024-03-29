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
  set cmdheight=2             " Better display for messages
  set signcolumn=yes          " Always show signcolumns

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
  highlight link yardGenericTag rubyKeyword " better highlight yardoc keywords
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
  autocmd BufNewFile,BufRead *.rbs set filetype=rbs
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

" Download vim-plug if missing
if empty(glob("~/.vim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fsSLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

" Plugins {
  call plug#begin('~/.vim/plugged')  " specify dir for plugins
  Plug 'morhetz/gruvbox'
  Plug 'dense-analysis/ale'
  Plug 'jlcrochet/vim-rbs'
  Plug 'wellle/context.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-bundler'
  Plug 'ruanyl/vim-gh-line'
  Plug 'nathanaelkane/vim-indent-guides'
  Plug 'scrooloose/nerdcommenter'
  Plug 'junegunn/fzf', { 'do': './install --bin' }
  Plug 'junegunn/fzf.vim'
  Plug 'junegunn/vim-easy-align'
  Plug 'justinmk/vim-sneak'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'sheerun/vim-polyglot'
  if has('nvim')
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
    Plug 'honza/vim-snippets'
  endif
  call plug#end()

  " rust.vim {
    let g:rust_recommended_style = 0
  " }

  " Gruvbox {
    let g:gruvbox_contrast_dark = 'medium'
    colorscheme gruvbox
  " }

  " Ale {
    let g:ale_sign_error = '✘'
    let g:ale_sign_warning = '⚠'
    let g:ale_ruby_rubocop_executable = 'bundle'
    let g:ale_ruby_reek_executable = 'bundle'
    let g:ale_rust_cargo_use_clippy = 1
    let g:ale_disable_lsp = 1
    let g:ale_fixers = {
    \   '*': ['remove_trailing_lines', 'trim_whitespace'],
    \   'ruby': ['rubocop'],
    \   'rust': ['rustfmt'],
    \}

    " Bind F8 to fixing problems with ALE
    nmap <F8> <Plug>(ale_fix)

    " Map movement through errors with wrapping
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
  " }

  " Fugitive {
  " }

  " IndentGuides {
    let g:indent_guides_enable_on_vim_startup = 1
  " }

  " NERDCommenter {
    let g:NERDSpaceDelims = 1
    let g:NERDDefaultAlign = 'left'
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

  " EasyAlign {
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
  " }

  " html5.vim {
  " }

  " Sneak {
    " Replace f and t with one-character Sneak
    map f <Plug>Sneak_f
    map F <Plug>Sneak_F
    map t <Plug>Sneak_t
    map T <Plug>Sneak_T

    " Label mode
    let g:sneak#label = 1
  " }

  if has('nvim')
    " Remap keys for gotos
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)

    " Use K to show documentation in preview window
    nnoremap <silent> K :call ShowDocumentation()<CR>

    function! ShowDocumentation()
      if CocAction('hasProvider', 'hover')
        call CocActionAsync('doHover')
      else
        call feedkeys('K', 'in')
      endif
    endfunction

    " Highlight the symbol and its references when holding the cursor
    autocmd CursorHold * silent call CocActionAsync('highlight')

    " Remap for rename current word
    nmap <leader>rn <Plug>(coc-rename)

    " Create mappings for function text object, requires document symbols feature of languageserver.
    xmap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap if <Plug>(coc-funcobj-i)
    omap af <Plug>(coc-funcobj-a)

    " Toggle coc-explorer
    nmap <leader>e :CocCommand explorer<CR>
  " }
  endif
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
