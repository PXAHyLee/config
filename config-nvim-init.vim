" 1. Use vim-plug to manage the neovim plugins
" 2. :CheckHealth command to check the status of neovim

" Automatic installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" Conditional activation
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

call plug#begin('~/.vim/bundle')
" On-demand loading of plugins

" NERD tree will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}
Plug 'Xuyuanp/nerdtree-git-plugin', {'on': 'NERDTreeToggle'}

Plug 'taglist.vim'

" YCM and color_coded have compiled component, which needs to be recompiled
" once they are updated.
Plug 'Valloric/YouCompleteMe', {'for': ['c', 'cpp']}
" :YcmGenerateConfig or :CCGenerateConfig
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}

" neovim version of color_coded
Plug 'arakashic/chromatica.nvim'

Plug 'tomtom/tcomment_vim'
Plug 'mhinz/vim-startify'
Plug 'scrooloose/syntastic'
Plug 'wincent/command-t'

" Colorscheme
Plug 'altercation/vim-colors-solarized'
Plug 'jnurmine/Zenburn'

Plug '256-grayvim'
Plug 'chriskempson/base16-vim'
Plug 'Colour-Sampler-Pack'
Plug 'freya'
Plug 'mimicpak'
Plug 'noahfrederick/vim-hemisu'
Plug 'tomasr/molokai'

" Syntax highlight
Plug 'brgmnn/vim-opencl'
Plug 'neovimhaskell/haskell-vim'

" PL Plugins
Plug 'derekwyatt/vim-scala'
Plug 'jez/vim-better-sml'

" Other plugins
" eagletmt/ghcmod-vim requires vimproc.vim
" Plug 'Shougo/vimproc.vim'
" Plug 'eagletmt/ghcmod-vim'
" let g:ghcmod_ghc_options = ['-XDataKinds']
"
" Plug 'godlygeek/tabular'
" Plug 'plasticboy/vim-markdown'
call plug#end()

" Option for every plugin
" NERDTree
" <F5> The NERD Tree
let NERDTreeWinPos='left'
let NERDTreeWinSize=40
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

" Taglist
" <F3> Taglist
let Tlist_Auto_Open = 0
let Tlist_Auto_Update = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Compact_Format = 1
let Tlist_GainFocus_On_ToggleOpen = 1
map <silent> <F3> :TlistToggle<CR>

" chromatica
let g:chromatica#libclang_path='/usr/lib'

" syntastic
" :SyntasticInfo for giving some useful information
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = '-std=c++11'

let g:syntastic_c_compiler = 'clang'
let g:syntastic_c_clang_check_args = '-std=c11'

let g:syntastic_python_python_exe = 'python3'
let g:syntastic_python_checkers = ['python3-flake8']
let g:syntastic_check_on_wq = 1

" command-t
if !has('ruby')
    let Msg="The Ruby interface ruby doesn't support. The command-t is disable."
    echohl WarningMsg | echo Msg | echohl None
else
    " check if ruby works
    silent execute 'ruby puts "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}"'
    if !filereadable(expand('~/.vim/bundle/command-t/ruby/command-t/ext.so'))
        let Msg="See *command-t-compile* to compile command-t"
        echohl WarningMsg | echo Msg | echohl None
        echo ""
        echo "Press any key to continue..."
        let c = getchar()
    endif
endif

" vim-scala
let g:scala_scaladoc_indent = 1


" General options
set shell=bash
set t_Co=256
set colorcolumn=80
set bg=dark
silent! colorscheme desert

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
set tabstop=8

" A tab produces a 4-space indentation
"
" Number of spaces that a <Tab> counts for while performing editing
" operations, like inserting a <Tab> or using <BS>.
set softtabstop=8

" shiftwidth: change the number of space characters inserted for indentation
set shiftwidth=8

set fdm=syntax
set nu
set sessionoptions-=curdir
set sessionoptions+=sesdir
set showcmd
set ruler
set wildmenu
set showmatch
set completeopt=menu,longest

au BufNewFile,BufFilePre,BufRead *.tex setlocal spell spelllang=en_us

au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
autocmd Filetype gitcommit setlocal spell textwidth=72

" tabline & statusline
" See also: http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
" https://github.com/mkitt/tabline.vim
set tabline=%!MyTabLine()

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
set laststatus=2
set statusline=[%n]\ %<%F\ \ \ [%M%R%H%W%Y][%{&ff}]\ \ %=\ line:%l/%L\ col:%c\ \ \ %p%%

" auto reload .config/nvim/init.vim
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" YCM related configuration
" See syntastic-ycm
let g:ycm_show_diagnostics_ui = 0
let g:ycm_confirm_extra_conf = 0
let g:ycm_extra_conf_globlist = ['~/']

" vim-better-sml
au FileType sml setlocal conceallevel=2

" The following are taken from llvm/utils/vim
"
"===== LLVM coding guidelines conformance for VIM =====
" $Revision: 176235 $

" LLVM Makefiles can have names such as Makefile.rules or TEST.nightly.Makefile,
" so it's important to categorize them as such.
augroup filetype
  au! BufRead,BufNewFile *Makefile* set filetype=make
augroup END

" In Makefiles, don't expand tabs to spaces, since we need the actual tabs
autocmd FileType make set noexpandtab

" Enable syntax highlighting for LLVM files. To use, copy
" utils/vim/llvm.vim to ~/.vim/syntax .
augroup filetype
  au! BufRead,BufNewFile *.ll     set filetype=llvm
augroup END

" Enable syntax highlighting for tablegen files. To use, copy
" utils/vim/tablegen.vim to ~/.vim/syntax .
augroup filetype
  au! BufRead,BufNewFile *.td     set filetype=tablegen
augroup END

" Enable syntax highlighting for reStructuredText files. To use, copy
" rest.vim (http://www.vim.org/scripts/script.php?script_id=973)
" to ~/.vim/syntax .
augroup filetype
 au! BufRead,BufNewFile *.rst     set filetype=rest
augroup END

"===== End LLVM coding guidelines conformance for VIM =====
