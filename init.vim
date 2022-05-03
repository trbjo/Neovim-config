if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/plugged')
    Plug 'ajh17/VimCompletesMe'
    Plug 'justinmk/vim-sneak'
    Plug 'projekt0n/github-nvim-theme'
    Plug 'tpope/vim-fugitive'
    " Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Plug 'dense-analysis/ale'
    Plug 'sheerun/vim-polyglot'
    " Plug 'terryma/vim-expand-region'
    "  Plug 'OmniSharp/omnisharp-vim', { 'for': 'cs' }
call plug#end()

colorscheme github_light
"set background=light
set statusline=%=%#UserRulerStatus#%t%m%r%w%0(%4(%p%)\ %)
set rulerformat=%33(%=%#UserRuler#%t%m%r%w%0(%4(%p%)%)%)
set laststatus=0
set ruler
set magic
set lazyredraw
set mouse=a
set hidden
set breakindent " preserve indentation when wrapping long lines
set nowrap
set noshowcmd noshowmode " hides --insert-- in echo area and j j k k
set wildignorecase
set shortmess+=c
set clipboard+=unnamedplus
"set signcolumn=no " for ale etc.
set expandtab tabstop=4 shiftwidth=4
set updatetime=200
set virtualedit=onemore " makes $ go after EOL
set autoread
set number
set cursorline
set switchbuf=useopen
set grepprg=rg\ --smart-case\ --vimgrep\ --glob\ '!*{.git,node_modules,build,bin,obj,README.md,tags}'\ 
set wildmenu
set path=.,**
" set list
" set listchars=tab:·\ ,trail:·,extends:»,precedes:«

" Don't offer to open certain files/directories
set wildignore+=*.bmp,*.gif,*.ico,*.jpg,*.png,*.ico
set wildignore+=*.pdf,*.psd,*.md
set wildignore+=**/node_modules/**,**/build/**,**/bin/**,**/obj/**

set complete-=t " We don't want tag completion
set pumheight=12 "max number of autocompletions
set completeopt=menuone
" ,noselect

" Search and replace
set hlsearch
set ignorecase smartcase "ignore, except if capital
set inccommand=nosplit " Split window on replace
set gdefault " trailing g in regexps automatically

" no backup but unlimited undo
set nobackup
set noswapfile
set undofile    

set title
set titlestring=%t%(\ %M%)

augroup init
    autocmd!
    autocmd BufReadCmd */ call NewsplitTermDir(expand('%:p'))
    autocmd BufReadPost quickfix call matchadd('Type', '\(|\d\{1,5} col \d\{1,5}| .*\)\@<=' . substitute(@q, '\\b\|\\\([(){]\)\@=', '', 'g') . '\c') | let @q = ''
    autocmd CmdLineLeave set inccommand=nosplit
    autocmd FocusLost * highlight UserRulerStatus ctermfg=18 | highlight UserRuler ctermfg=18 | set nocursorline
    autocmd FocusGained * highlight UserRulerStatus ctermfg=6 | highlight UserRuler ctermfg=6 | checktime | set cursorline
    autocmd FileType python,cs,typescript,typescriptreact autocmd BufWritePre <buffer> :call StripTrailingWhitespaces()
    autocmd InsertEnter * match none
    autocmd QuickFixCmdPost cgetexpr set errorformat&
    autocmd VimEnter * call ChangeDir()
    autocmd WinLeave,BufWinLeave * if &buftype == 'quickfix' | set rulerformat=%33(%=%#UserRuler#%t%m%r%w%0(%4(%p%)%)%) | endif
    autocmd WinEnter * if &buftype == 'quickfix' | setlocal rulerformat=%30(%=%#UserRuler#\(%l/%{quickfix#length()}%\)) | endif
    autocmd VimLeave * set guicursor=a:ver20
augroup END


"let g:coc_global_extensions = ['coc-tslint-plugin', 'coc-tsserver', 'coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-rust-analyzer' ]
"inoremap <silent><expr> <TAB>
"      \ pumvisible() ? "\<C-n>" :
"      \ <SID>check_back_space() ? "\<TAB>" :
"      \ coc#refresh()
"inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
"function! s:check_back_space() abort
"  let col = col('.') - 1
"  return !col || getline('.')[col - 1]  =~# '\s'
"endfunction

"let g:ale_linters = {
            "\   'typescript': ['tsserver', 'tslint'],
            "\   'javascript': ['eslint'],
            "\   'cs': ['OmniSharp'],
"\}
"
"let g:ale_fixers = {
            "\    'javascript': ['eslint'],
            "\    'typescript': ['prettier'],
            "\    'scss': ['prettier'],
            "\    'html': ['prettier']
"\}


let g:sneak#label = 1


fun! StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

function! g:ChangeDir()
    lcd %:p:h
    if (getcwd() =~ '/ClientApp/')
        lcd /home/tb/Pilatus.Bank/Pilatus.Bank.WS/ClientApp/
        return
    endif
    let l:git_dir = fnameescape(system('git rev-parse --show-toplevel 2> /dev/null')[:-2])
    if l:git_dir != ''
        execute ':lcd ' l:git_dir
        return
    endif
endfunction



noremap <space> <nop>
let mapleader="\<Space>"

nnoremap <silent><S-Right> :vertical resize +10<CR>
nnoremap <silent><S-Up> :resize +10<CR>
nnoremap <silent><S-Left> :vertical resize -10<CR>
nnoremap <silent><S-Down> :resize -10<CR>

" Indent
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv
nnoremap <TAB> >>
nnoremap <S-TAB> <<

" Wrap words
xnoremap " <ESC>`>a"<ESC>`<i"<ESC>
xnoremap ' <ESC>`>a'<ESC>`<i'<ESC>
xnoremap ( <ESC>`>a)<ESC>`<i(<ESC>
xnoremap [ <ESC>`>a]<ESC>`<i[<ESC>
xnoremap { <ESC>`>a}<ESC>`<i{<ESC>
xnoremap < <ESC>`>a><ESC>`<i<<ESC>

nnoremap <F8> :%s/\s\+$//e<CR>
nnoremap <F7> mzgg=G`zzz
nnoremap <F12> :echo expand('%:p')<CR>

function! BreakHere()
    s/^\(\s*\)\(.\{-}\)\(\s*\)\(\%#\)\(\s*\)\(.*\)/\1\2\r\1\4\6
    call histdel("/", -1)
endfunction

nnoremap <leader>e :<C-u>call BreakHere()<CR>
