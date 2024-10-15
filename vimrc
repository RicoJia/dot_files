set compatible

syntax on
let g:markdown_fenced_languages = ['html', 'python', 'ruby', 'vim', 'cpp', 'css']
filetype indent plugin on
set nobackup
set ma	" so you can use buffer to modify disk
if has("autocmd")
    autocmd FileType python set complete+=k/home/ricojia/.vim/pydiction-0.5/pydiction 
endif 
set exrc
set secure
inoremap <C-S-P> <C-X><C-F>

"--------------------------------------Vim-Plug---------
" install neovim thingys
" https://www.linode.com/docs/guides/how-to-install-neovim-and-plugins-with-vim-plug/
call plug#begin()

" format vim buffer, independent of coc-ccls
" Plug 'rhysd/vim-clang-format'

" Preview window
Plug 'skywind3000/vim-preview'

" autosave
Plug '907th/vim-auto-save'

" T-Comment
Plug 'tomtom/tcomment_vim'

" vim float
Plug 'voldikss/vim-floaterm'

" undo tree
Plug 'mbbill/undotree'

"vim-instant-markdown
Plug 'instant-markdown/vim-instant-markdown', {'for': 'markdown'}

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" vim-visual-star-search
Plug 'bronson/vim-visual-star-search'

"airline, for status bar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" coc
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
" bash language server
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'

" A bunch of useful language related snippets (ultisnips is the engine).
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" shellmake
Plug 'neomake/neomake'

" Transparent background
Plug 'tribela/vim-transparent'

Plug 'NLKNguyen/papercolor-theme'

" Add your plugins here
Plug 'preservim/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'mbbill/undotree'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'


call plug#end()
"

"-----------------------------------------General
set nocompatible              " be iMproved, required

set signcolumn=no
hi clear SpellBad

filetype plugin indent on    " required
if executable("ag")
    set grepprg=ag\ --nogroup\ --nocolor\ --column
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
	let g:ctrlp_use_caching=0
endif
" Editing
set backspace=indent,eol,start	
set autoread
" set hidden	"changed files will be put into buffer, and can be accessed later. These changes are not written to disk, so you can :e to other files
set expandtab
set number
set relativenumber
set softtabstop=4
set shiftwidth=4
set tabstop=4

" Use the below settings for editing flexbe state machine. which disables spaces and only allows tabs
" set noexpandtab
"
set autoindent
" set smartindent		" for c, cpp source files
filetype indent on
set foldmethod=indent
set foldlevelstart=20
" Command comlpetion
set wildmenu
set showcmd
" search
set hlsearch incsearch
set ignorecase
set smartcase

" Enabling mouse click
set mouse=a
" connecting register to the system clipboard, you still cannot use C-S-c, but
" you can use yank :)
" set mouse&

" Toggle clipboard
set clipboard=unnamedplus
" if |$mouse == 'a' 
" if !empty($SSH_CLIENT) 
" 	set mouse=
" 	echom 'mouse click disabled for SSH Session'
" endif

" yank file name
nnoremap <C-y> :let @+=expand('%:')<CR>
execute "set <M-y>=\ey"
nnoremap <M-y> :let @+=expand("%:p:h")<CR>

" colorscheme morning
set t_Co=256   " This is may or may not needed.
set background=dark
colorscheme PaperColor

set cursorline 
" highlight line color, see here https://jonasjacek.github.io/colors/
hi CursorLine   cterm=NONE ctermbg=52 ctermfg=NONE

" change directory automatically
set autochdir

" dictionary
set dictionary+=/usr/share/dict/words
inoremap <F12> <C-X><C-K>

set iskeyword=@,48-57,192-255,34,95
" set iskeyword-=@,48-57,_,32

"-----------------------------------------General Key Remappings
" remap leader to space, we need the first line for not having space to jump
nnoremap <SPACE> <Nop>
let mapleader=" "
let maplocalleader=" "

" Disable F1
nmap <F1> :echo<CR>

" Use F1 for folding & unfolding
nnoremap <F1> za

" right mouse to get into/out of insert mode
imap <RightMouse> <Esc>
nmap <RightMouse> i<LeftMouse>

" increase number now is A-a
execute "set <M-c>=\ec"
nnoremap <M-c> <C-a>
execute "set <M-x>=\ex"
nnoremap <M-x> <C-x>

" Close the current buffer and move to the previous one
nnoremap <leader>bd :<c-u>bp <bar> bd #<cr>

" end, start of line
nnoremap ` 0
vnoremap ` 0
nnoremap = $
vnoremap = $

" Replace
nnoremap <Leader>ws :/\<\><Left><Left>	" search for one whole word
" enable case sensitive/insensitive searches 
nnoremap <Leader>r :%s///g<Left><Left><Left>
nnoremap <Leader>cr :%s/\C//g<Left><Left><Left><Left><Left>
" block replace actually operates with vim-visual-star-search
xnoremap <Leader>r :<C-u>call VisualStarSearchSet('/', 'raw')<CR> :%s///g<Left><Left>
" Search in Block 
xnoremap <Leader>br :s///g<Left><Left>
" Search exact matched case
nnoremap <Leader>/ /\C<Left><Left>

" save
nmap <C-s> :w <Enter>
" we do this since we have auto save
set noswapfile	
" shift + arrow
nmap <S-Up> V
nmap <S-Down> V
" these are mapped in visual mode
vmap <S-Up> k
vmap <S-Down> j

" Editing
" paste to previous line / next line

nnoremap <leader>p o<Esc>p
nnoremap <leader><S-p> O<Esc>p

" remap  for line cut (the traditional dd), dd now is regular delete 
nnoremap x "_x
nnoremap X "_X
vnoremap x "_x
nnoremap c "_c
vnoremap c "_c
nnoremap ff "_dd
vnoremap ff "_dd
nnoremap <F10> :set relativenumber! <Enter>
" delete till the beginning of the sentence
nnoremap <leader>d hv0wd


" clear line
nnoremap <S-c>  0<S-D>i

" reload vimrc
nmap <F5> :source ~/.vimrc<CR>

" Common patterns
" insert ``` ``` 
" xnoremap <expr> <F3> mode() ==# "v"? "c```<CR>```<Esc>mzko<Esc>p'[kA" : "c```<CR>```<Esc>mzkp'[kA" 
xnoremap <expr> <F3> mode() ==# "v"? "di```<Esc>pa```<Esc>a" : "c```<CR>```<Esc>mzkp'[kA" 
nnoremap <F3> i``````<Esc>hhi
inoremap <F3> ``````<Esc>hhi
" xnoremap <expr> <F4> mode() ==# "v"? "c****<Esc>hhplla" : "di**<CR>**<Esc>kpkgJ\*<CR>kgJ" 
xnoremap <expr> <F4> mode() ==# "v"? "di****<Esc>hP/*<CR>na" : "di**<CR>**<Esc>kpkgJ/*<CR>kgJla<CR><Esc>kA" 
" xnoremap <expr> <F4> mode() ==# "v"? "c**<CR>**<Esc>ko<Esc>p'[kA" : "c**<CR>**<Esc>kp'[kA" 
" vnoremap <F4> c**<Esc>pa**
nnoremap <f4> i****<esc>hi
inoremap <F4> ****<Esc>hi
" insert at end of everyline in visual mode
vnoremap A :s/$//<Left>

" visually select the last pasted item 
nnoremap gp `[v`]

"-----------------------------------------Clang Format
" noremap <F6> :<C-u>ClangFormat<CR>
" let g:clang_format#auto_format=1 " enable autoformatting on buffer write
" let g:clang_format#detect_style_file=1 " detect and load .clang-format file automatically
" let g:clang_format#auto_format_on_insert_leave=1
"-----------------------------------------Auto Save
let g:auto_save = 1  " enable AutoSave on Vim startup
"-----------------------------------------Status bar
" Status bar
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline#extensions#tabline#show_tabs = 1
set showtabline=2
let g:airline_theme = 'onedark'
set shortmess-=S    "will show match counts for a search

"-----------------------------------------T-comment
" <C-_> <C-_> is the default comment

" -----------------------------------------floatterm
 " c-\ c-n will let you scroll like normal
" nnoremap <F12> :FloatermNew! --cwd=<root> --autoclose=2 <CR> 
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_keymap_new    = '<F9>'
let g:floaterm_autoclose=2
tnoremap <C-n>    <C-\><C-n>
autocmd QuitPre * exec 'FloatermKill!' 
 
 "-----------------------------------------vim instant markdown
" " remove strange chars
let &t_TI = ""
let &t_TE = ""
let g:instant_markdown_slow = 0 
let g:instant_markdown_autostart =1
" let g:instant_markdown_open_to_the_world = 1
let g:instant_markdown_allow_unsafe_content = 0
"let g:instant_markdown_allow_external_content = 0
let g:instant_markdown_mathjax = 1
"let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
let g:instant_markdown_autoscroll = 1 
" let g:instant_markdown_port = 8888
" let g:instant_markdown_python = 1
" let g:instant_markdown_browser = "google-chrome-stable --new-window"
 
"-----------------------------------------undotree
nnoremap <leader>u :UndotreeShow<cr>
"-----------------------------------------SirVer/ultisnips
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"-----------------------------------------Neomake (shellmake)
" When writing a buffer (no delay).
call neomake#configure#automake('w')
" When writing a buffer (no delay), and on normal mode changes (after 750ms).
call neomake#configure#automake('nw', 750)
" When reading a buffer (after 1s), and when writing (no delay).
call neomake#configure#automake('rw', 1000)
" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 500ms; no delay when writing).
call neomake#configure#automake('nrwi', 500)
" open the list automatically
" let g:neomake_open_list = 2
" Else, do 

"-----------------------------------------fzf search
" searches everything in the same directory
execute "set <M-f>=\ef"
nnoremap <M-f> :Rg<space>
nnoremap <leader>f :BLines<Enter>
nnoremap <C-f> :FZF<Enter>
if executable('rg')
	let g:rg_derive_root='true'
endif

nnoremap <leader>s :Snippets<Enter>

" remap file
nnoremap <leader><f4> :Files<space>
" 'ctrl-t' is how to write ctrl here
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit',
			\ 'ctrl-t': 'tab split',
  \ }
nmap <silent> <leader>m :History<CR>
"-----------------------------------------nerdtree
"Change splitting options, similar to :vs and :sp in defaults
let NERDTreeMapOpenSplit='s'
let NERDTreeMapOpenVSplit='v'

" nerd_tree auto start with the right dir
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * silent NERDTreeMirror

" automatically close a tab if the only remaining window is NerdTree 
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") 
			\ && b:NERDTree.isTabTree()) | q | endif

" Create a new tab
let NERDTreeMapOpenInTabSilent='<c-t>'

" refresh the nerdtree directory
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    if (expand("%:t") != '')
      exe ":NERDTreeFind"
    else
      exe ":NERDTreeToggle"
    endif
  endif
endfunction
nnoremap <F2> :call NERDTreeToggleInCurDir()<cr>

" -------------------------------------- Split Window Navigation
map <C-h> <C-w>h	
map <C-j> <C-w>j	
map <C-k> <C-w>k	
map <C-l> <C-w>l	
map <C-Left> <C-w>h	
map <C-Down> <C-w>j	
map <C-Up> <C-w>k	
map <C-Right> <C-w>l	

nnoremap <PageUp><PageUp> :bp<CR>
nnoremap <PageDown><PageDown> :bn<CR>
  
" resize window
nnoremap - <C-W><lt>
nnoremap + <C-W>>

" -------------------------------------- Tab Settings
" next tabs
nmap <C-PageUp> gT 
nmap <C-PageDown> gt
" New tab
nmap <C-t> :tabnew<Enter>

" Go to last active tab
au TabLeave * let g:lasttab = tabpagenr()
nnoremap <silent> <c-n> :exe "tabn ".g:lasttab<cr>
vnoremap <silent> <c-n> :exe "tabn ".g:lasttab<cr>

" -------------------------------------- Common Mispellings
iabbrev teh the
iabbrev adn and
iabbrev waht what
iabbrev wehn when 

" -------------------------------------- Pop-ups
highlight PmenuSel ctermbg=yellow guibg=yellow
set complete=kspell,.,b,u,]
set completeopt=menuone,longest,popup
set shortmess+=c
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
  
" Navigate the complete menu items like CTRL+n / CTRL+p would.
" inoremap <expr> <Down> pumvisible() ? "<C-n>" :"<Down>"
" inoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"
inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Esc> pumvisible() ? "\<C-e>" : "\<Esc>"
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<Up>"

" " Select the complete menu item like CTRL+y would.
" inoremap <expr> <Right> pumvisible() ? "<C-y>" : "<Right>"
inoremap <expr> <CR> pumvisible() ? "<C-y>" :"<CR>"
" " Cancel the complete menu item like CTRL+e would.
" inoremap <expr> <Left> pumvisible() ? "<C-e>" : "<Left>"

" " -------------------------------------- Coc-Search 
" "" TextEdit might fail if hidden is not set.
" set hidden
"
" " Some servers have issues with backup files, see #649.
" set nobackup
" set nowritebackup
"
" " Give more space for displaying messages.
" set cmdheight=2
"
" " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" " delays and poor user experience.
" set updatetime=300
" " for slow <Esc>
" set ttimeoutlen=5
"
" " Don't pass messages to |ins-completion-menu|.
" set shortmess+=c
"
" " Always show the signcolumn, otherwise it would shift the text each time
" " diagnostics appear/become resolved.
" if has("patch-8.1.1564")
"   " Recently vim can merge signcolumn and number column into one
"   set signcolumn=number
" else
"   set signcolumn=yes
" endif
"
" " Use tab for trigger completion with characters ahead and navigate.
" " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" " other plugin before putting this into your config.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
"
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
"
" " Use <c-space> to trigger completion.
" if has('nvim')
"   inoremap <silent><expr> <c-space> coc#refresh()
" else
"   inoremap <silent><expr> <c-@> coc#refresh()
" endif
"
" " Make <CR> auto-select the first completion item and notify coc.nvim to
" " format on enter, <cr> could be remapped by other vim plugin
" " Rico: for remapping <CR>?
" " Make <CR> to accept selected completion item or notify coc.nvim to format
" " <C-g>u breaks current undo, please make your own choice.
" inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
"                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" " inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
" "                               \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
"
" " Use `[g` and `]g` to navigate diagnostics
" " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
" nmap <silent> [g <Plug>(coc-diagnostic-prev)
" nmap <silent> ]g <Plug>(coc-diagnostic-next)
"
" " GoTo code navigation.
" " for referring to class def of an object
" nmap <silent> gd <Plug>(coc-definition)
" " for checking the class definition of a type
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
"
" " Use K to show documentation in preview window.
" nnoremap <silent> K :call <SID>show_documentation()<CR>
"
" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   elseif (coc#rpc#ready())
"     call CocActionAsync('doHover')
"   else
"     execute '!' . &keywordprg . " " . expand('<cword>')
"   endif
" endfunction
"
" " Highlight the symbol and its references when holding the cursor.
" " to enable or disable highlight, go to CocConfig, color support
" autocmd CursorHold * silent call CocActionAsync('highlight')
"
" " Symbol renaming.
" " nmap <leader>rn <Plug>(coc-rename)
" "
" " " Formatting selected code.
" " xmap <F6> <Plug>(coc-format-selected)
" " nmap <F6>  <Plug>(coc-format-selected)
"
" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder.
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end
"
" " Applying codeAction to the selected region.
" " Example: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)
"
" " Remap keys for applying codeAction to the current buffer.
" nmap <leader>ac  <Plug>(coc-codeaction)
" " Apply AutoFix to problem on the current line.
" nmap <leader>qf  <Plug>(coc-fix-current)
"
" " Map function and class text objects
" " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
" " xmap if <Plug>(coc-funcobj-i)
" " omap if <Plug>(coc-funcobj-i)
" " xmap af <Plug>(coc-funcobj-a)
" " omap af <Plug>(coc-funcobj-a)
" " xmap ic <Plug>(coc-classobj-i)
" " omap ic <Plug>(coc-classobj-i)
" " xmap ac <Plug>(coc-classobj-a)
" " omap ac <Plug>(coc-classobj-a)
"
" " Remap <C-f> and <C-b> for scroll float windows/popups.
" " if has('nvim-0.4.0') || has('patch-8.2.0750')
" "   nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
" "   nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" "   inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
" "   inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
" "   vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
" "   vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
" " endif
"
" " Use CTRL-S for selections ranges.
" " Requires 'textDocument/selectionRange' support of language server.
" " nmap <silent> <C-s> <Plug>(coc-range-select)
" " xmap <silent> <C-s> <Plug>(coc-range-select)
"
" " Add `:Format` command to format current buffer.
" command! -nargs=0 Format :call CocAction('format')
"
" " Add `:Fold` command to fold current buffer.
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)
"
" " Add `:OR` command for organize imports of the current buffer.
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
"
" " Add (Neo)Vim's native statusline support.
" " NOTE: Please see `:h coc-status` for integrations with external plugins that
" " provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
"
" " Mappings for CoCList
" " Show all diagnostics.
" " nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " " Manage extensions.
" " nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " " Show commands.
" " nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " " Find symbol of current document.
" " nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " " Search workspace symbols.
" " nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " " Do default action for next item.
" " nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " " Do default action for previous item.
" " nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " " Resume latest coc list.
" " nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
"---------------------------------------
" bash-language-server ---------
" Note: a known issue is coc-bash has issues when launched in root folder. 
if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'allowlist': ['sh'],
        \ })
endif

" file types
augroup filetypedetect
    au BufRead,BufNewFile *.launch setfiletype xml
    " associate *.foo with php filetype
augroup END

"--------------------------------------- ctags
" go from the current directory up to the nearest tags file
set tags=tags;/
nnoremap <leader>. :Tags <C-R><C-W> !build <cr>
nnoremap <C-a> <C-t>

" --------------------------------------- macros
" the image one 
let @i='`f(ldi(ffO<img	€ýab`f"lci"€ýaciw€ýaa"€ýapa€ýaa"€ýawwwlci"400€ýa' 
let @p ='pww€krãyy'
set nomodeline    " Maybe an error pops up saying error processing mode line
