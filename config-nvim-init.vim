" 1. Use vim-plug to manage the neovim plugins
" 2. :CheckHealth command to check the status of neovim

" https://www.reddit.com/r/neovim/comments/3r3nn8/how_to_get_vimplug_to_autoload/
" Automatic installation
" Put plug.vim itself under $XDG_DATA_HOME/nvim/site/autoload
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  " Note that --sync flag is used to block the execution until the installer finishes.
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Conditional activation
" function! Cond(cond, ...)
"   let opts = get(a:000, 0, {})
"   return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
" endfunction

" Plugins directory: $XDG_DATA_HOME/nvim/site/plugged
call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'tpope/vim-fugitive'
Plug 'taglist.vim'

" On-demand loading of plugins
" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'Xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeToggle'}

" YCM and color_coded have compiled component, which needs to be recompiled
" once they are updated.
Plug 'Valloric/YouCompleteMe', {'for': ['c', 'cpp', 'python']}

" neovim version of color_coded
" P.S. [20170604] This plugin doesn't work.
" Plug 'arakashic/chromatica.nvim'

Plug 'scrooloose/syntastic'

" toggling the display of the quickfix and the locationlist window
" '<leader>l' and '<leader>q'
Plug 'Valloric/ListToggle'

Plug 'tomtom/tcomment_vim'
Plug 'mhinz/vim-startify'
Plug 'wincent/command-t'

" Colorscheme
" Plug 'altercation/vim-colors-solarized'
" Plug 'jnurmine/Zenburn'

" Plug '256-grayvim'
" Plug 'chriskempson/base16-vim'
" Plug 'Colour-Sampler-Pack'
" Plug 'freya'
" Plug 'mimicpak'
" Plug 'noahfrederick/vim-hemisu'
" Plug 'tomasr/molokai'
Plug 'itchyny/landscape.vim'

" Syntax highlight
" Plug 'brgmnn/vim-opencl'
" Plug 'neovimhaskell/haskell-vim'

" PL Plugins
" Plug 'derekwyatt/vim-scala'
" let g:scala_scaladoc_indent = 1

" Plug 'jez/vim-better-sml'
" vim-better-sml
" au FileType sml setlocal conceallevel=2

call plug#end()

" Option for every plugin

" taglist
" <F3> Taglist
let Tlist_Auto_Open = 0
let Tlist_Auto_Update = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
map <silent> <F3> :TlistToggle<CR>

" NERDTree
" :helptags <dir> => generate the help tags files (*.txt and *.??x)
" Bookmark commands is helpful
" <F5> The NERD Tree
let NERDTreeWinPos='left'
let NERDTreeWinSize=41
let NERDTreeChDirMode=1
map <F5> :NERDTreeToggle<CR>
autocmd bufenter * call s:CloseVimIfOnlyNERDTreeLeft()
function! s:CloseVimIfOnlyNERDTreeLeft()
	if winnr("$") == 1
            \ && exists("b:NERDTreeType")
            \ && b:NERDTreeType == "primary"
		quit
	endif
endfunction


" YCM
" YCM related configuration [See youcompleteme-options]
" Some interesting options:
"
"   1. g:ycm_min_num_of_chars_for_completion (Default: '2') controls the
"   number of characters the user needs to type before identifier-based
"   completion suggestions are triggered. This option is NOT used for semantic
"   completion.
"
"   2. g:ycm_auto_trigger (Default: '1'): When the value is '0', it turns off
"   YCM's identifier completer (the as-you-type popup) and the semantic
"   triggers (the popup you'd get after typing '.' or '->' in say C++). You
"   can still force semantic completion with the '<C-Space>' shortcut.
"
"   3. g:ycm_key_invoke_completion (Default: <C-Space>)
"
"   4. g:ycm_show_diagnostics_ui (Default: '1') turns on YCM's diagnostic
"   display features
"
"   5. g:ycm_always_populate_location_list
"
"   6. g:ycm_collect_identifiers_from_tags_files (Default: '0'): When this
"   option is set to '1', YCM's identifier completer will also collect
"   identifiers from tags files.This option is off by default because it makes
"   Vim slower if your tags are on a network directory.
"
"   7. g:ycm_key_detailed_diagnostics (Default: '<leader>d')
"
"   8. g:ycm_extra_conf_globlist: Note that this option is not used when
"   confirmation is disabled using g:ycm_confirm_extra_conf and that items
"   earlier in the list will take precedence over the later ones.
"
"   ?. g:syntastic_enable_signs
"
"   Commands (youcomplete-commands)
"     :YcmDiags will fill Vim's 'locationlist' with errors or warnings if any
"     were detected in your file and then open it.
"
"     :YcmCompleter
let g:ycm_show_diagnostics_ui = 0
let g:ycm_always_populate_location_list = 1
let g:ycm_complete_in_comments = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_confirm_extra_conf = 1
let g:ycm_extra_conf_globlist = ['~/']
let g:ycm_global_ycm_extra_conf = '~/my_ycm_extra_conf.py'
nnoremap <leader>jd :YcmCompleter GoTo<CR>

" chromatica
"   1. Use :ChromaticaToggle to manually toggle Chromatica
"   2. Compilation flags: A .clang file that has the compilation flags.
"   3. :ChromaticaShowInfo
"
" let g:chromatica#libclang_path = '/usr/local/lib'
" let g:chromatica#enable_at_startup = 1
"   4. Chromatica can search a customized path for the `.clang` file or the
"   compilation database.
" let g:chromatica#dotclangfile_search_path = ''
" let g:chromatica#responsive_mode = 1

" syntastic
" :SyntasticInfo for giving some useful information
" Recommended option on the website
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

"   Start the customization
let g:syntastic_warning_symbol = "\u26A0"
let g:syntastic_error_symbol = "\u2717"
let g:syntastic_aggregate_errors = 1

let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++11'

" Enable multiple checkers
let g:syntastic_cpp_checkers = ['gcc', 'cpplint']
let g:syntastic_cpp_cpplint_exec = '~/script/cpplint.py'
let g:syntastic_cpp_cpplint_args = "--verbose=3 --filter=-legal/copyright"

let g:syntastic_c_compiler = 'clang'
let g:syntastic_c_clang_check_args = '-std=c11'

let g:syntastic_python_python_exe = 'python3'
let g:syntastic_python_checkers = ['python3-flake8']


" ListToggle

" command-t
if !has('ruby')
    let Msg="The Ruby interface ruby doesn't support. The command-t is disable."
    echohl WarningMsg | echo Msg | echohl None
else
    " check if ruby works
    silent execute 'ruby puts "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"'
    if !filereadable(expand('~/.local/share/nvim/site/plugged/command-t/ruby/command-t/ext.so'))
        let Msg="See *command-t-compile* to compile command-t"
        echohl WarningMsg | echo Msg | echohl None
        echo ""
        echo "Press any key to continue..."
        let c = getchar()
    endif
endif

" General options
set laststatus=2
set showtabline=2
set guioptions-=e

" See Also: FAQ - Colors aren't displayed correctly
" neovim ignores t_Co and other terminal codes
set termguicolors

set textwidth=79
set colorcolumn=+1 " base the value of 'colorcolumn' on 'textwidth'
" ColorColumn is one of the built-in *highlight-groups*
hi ColorColumn ctermbg=red ctermfg=white

set bg=dark
silent! colorscheme landscape

" See Also: http://vim.wikia.com/wiki/Working_with_Unicode
" **VIM set encoding and fileencoding utf-8** @ Stackoverflow
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8
    set fileencodings=ucs-bom,utf-8,big5,gbk,latin1
endif

" http://vim.wikia.com/wiki/Remove_unwanted_spaces
" <F2>: Remove unwanted spaces
:nnoremap <silent> <F2> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>

" expandtab: insert space characters whenever the tab key is pressed
set expandtab

" the # of space characters that will be inserted when the tab key is pressed
set tabstop=2

" A tab produces a 4-space indentation
"
" Number of spaces that a <Tab> counts for while performing editing
" operations, like inserting a <Tab> or using <BS>.
set softtabstop=2

" shiftwidth: change the number of space characters inserted for indentation
set shiftwidth=2

" This line is deprecated for C and C++?
" set fdm=syntax
set nu
" set sessionoptions-=curdir
" set sessionoptions+=sesdir
set showcmd
set showmatch

" completeopt: A comma separated list of options for Insert mode completion
" ins-completion.
set completeopt+=longest

" complete (cpt): specifies how keyword completion ins-completion works when
" CTRL-P or CTRL-N are used.

au BufNewFile,BufFilePre,BufRead *.tex setlocal spell spelllang=en_us

autocmd Filetype gitcommit setlocal spell textwidth=72

" formatoptions (default: tcqj)
" set fo? to see the current formatoptions => ex: jcroql.
" When the 'paste' option is on, no formatting is done

" Some ftplugin would change the formatoptions after the above set command
" http://stackoverflow.com/questions/16030639/vim-formatoptions-or#16032415
" You can use commands like 5verbose set fo? :5verbose setl fo? to see
" where the option is set.

" An alternative method is a "soft" wrap which does not change the text but
" simply displays it on multiple lines.
" set wrap linebreak nolist

" tabline & statusline
" See also: http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
" https://github.com/mkitt/tabline.vim
function! Tabline()
    let s = ''
    for i in range(tabpagenr('$'))
        let tab = i + 1
        let winnr = tabpagewinnr(tab)
        let buflist = tabpagebuflist(tab)
        let bufnr = buflist[winnr - 1]
        let bufname = bufname(bufnr)
        let bufmodified = getbufvar(bufnr, "&mod")

        let s .= '%' . tab . 'T'
        let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
        let s .= ' ' . tab .':'
        let s .= (bufname != '' ? ' '. fnamemodify(bufname, ':t') . ' ' : '[No Name] ')

        if bufmodified
            let s .= '[+] '
        endif
    endfor

    let s .= '%#TabLineFill#'
    return s
endfunction
set tabline=%!Tabline()
set statusline=[%n]\ %<%F\ \ \ [%M%R%H%W%Y][%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%

augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Make Vim show ALL white spaces as a character
" brettanomyces's answer on StackOverflow
" set list! to toggle the list mode
"
" set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

" This setting is based on another random neovim-init
set listchars=trail:·,precedes:«,extends:»,eol:↲,space:␣,tab:▸\

" The following are taken from llvm/utils/vim/vimrc
"
" LLVM coding guidelines conformance for VIM
" $Revision: 293693 $
"
" Highlight trailing whitespace and lines longer than 80 columns.
highlight LongLine ctermbg=DarkYellow guibg=DarkYellow
highlight WhitespaceEOL ctermbg=DarkYellow guibg=DarkYellow
if v:version >= 702
  " Lines longer than 80 columns.
  au BufWinEnter * let w:m0=matchadd('LongLine', '\%>80v.\+', -1)

  " Whitespace at the end of a line. This little dance suppresses
  " whitespace that has just been typed.
  au BufWinEnter * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
  au InsertEnter * call matchdelete(w:m1)
  au InsertEnter * let w:m2=matchadd('WhitespaceEOL', '\s\+\%#\@<!$', -1)
  au InsertLeave * call matchdelete(w:m2)
  au InsertLeave * let w:m1=matchadd('WhitespaceEOL', '\s\+$', -1)
else
  au BufRead,BufNewFile * syntax match LongLine /\%>80v.\+/
  au InsertEnter * syntax match WhitespaceEOL /\s\+\%#\@<!$/
  au InsertLeave * syntax match WhitespaceEOL /\s\+$/
endif

" LLVM Makefiles can have names such as Makefile.rules or TEST.nightly.Makefile,
" so it's important to categorize them as such.
augroup filetype
  au! BufRead,BufNewFile *Makefile* set filetype=make
augroup END

augroup markdown
  au!
  au BufWinEnter,BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
augroup END


" In Makefiles, don't expand tabs to spaces, since we need the actual tabs
autocmd FileType make set noexpandtab

"===== End LLVM coding guidelines conformance for VIM =====

function! SetMarkdownOptions()
  call clearmatches()
  setlocal textwidth=0
endfunction

autocmd FileType markdown call SetMarkdownOptions()
