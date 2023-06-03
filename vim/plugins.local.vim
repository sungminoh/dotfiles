Plug 'tmhedberg/SimpylFold'
Plug 'konfekt/fastfold'
"Plug 'scrooloose/syntastic'
Plug 'jiangmiao/auto-pairs'
Plug 'aperezdc/vim-template'

" js
Plug 'pangloss/vim-javascript'
Plug 'isruslan/vim-es6'
Plug 'mxw/vim-jsx'
" js autocompletion
Plug 'marijnh/tern_for_vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }
Plug 'othree/jspc.vim', { 'for': ['javascript', 'javascript.jsx'] }
Plug 'honza/vim-snippets'

" Add maktaba and codefmt to the runtimepath.
" (The latter must be installed before it can be used.)
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
" Also add Glaive, which is used to configure codefmt's maktaba flags. See
" `:help :Glaive` for usage.
Plug 'google/vim-glaive'

" https://plugins.jetbrains.com/plugin/12153-comrade-neovim
" Plug 'beeender/Comrade'

" Docker
Plug 'ekalinin/dockerfile.vim'

" Tagbar like
Plug 'liuchengxu/vista.vim'


" Vim
Plug 'liuchengxu/vim-which-key'

" Auto import
Plug 'wookayin/vim-autoimport'

Plug 'hotwatermorning/auto-git-diff'
Plug 'rhysd/committia.vim'


" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'


Plug 'sk1418/howmuch'
