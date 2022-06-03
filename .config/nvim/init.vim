set nocompatible
filetype off

call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'skywind3000/asyncrun.vim'
Plug 'Pocco81/AutoSave.nvim'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'jvirtanen/vim-hcl'
Plug 'baverman/vial'
Plug 'baverman/vial-http'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'ggandor/lightspeed.nvim'

" Telescope Setup
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-file-browser.nvim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" DAP Setup
Plug 'mfussenegger/nvim-dap'
Plug 'leoluz/nvim-dap-go'
Plug 'nvim-telescope/telescope-dap.nvim'

" LSP Setup
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'

call plug#end()

filetype plugin indent on

set number
set relativenumber
set title
set clipboard=unnamedplus
syntax on
set tabstop=4
set softtabstop=4
set shiftwidth=0
set expandtab                     " use spaces, not tab characters
autocmd FileType dart setlocal shiftwidth=2 softtabstop=2 expandtab
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set incsearch                     " show search results as I type
set smartcase                     " pay attention to case when caps are used
set ruler                         " show row and column in footer
set autochdir
set nowrap
set autoread
set undofile
set updatetime=100
set mouse=a
set scrolloff=100000

" gitgutter setup
let g:gitgutter_signs = 0
let g:gitgutter_highlight_linenrs = 1
highlight link GitGutterAddLineNr DiffAdd
highlight link GitGutterChangeLineNr DiffChange
highlight link GitGutterDeleteLineNr DiffDelete
highlight link GitGutterChangeDeleteLineNr DiffChange
highlight DiffAdd ctermfg=lightgreen ctermbg=none
highlight DiffChange ctermfg=blue ctermbg=none
highlight DiffDelete ctermfg=red ctermbg=none
highlight LightspeedCursor ctermbg=white

set colorcolumn=81,101,121
highlight ColorColumn ctermbg=16
hi MatchParen cterm=bold ctermbg=none ctermfg=red

set noswapfile

nnoremap !d :AsyncRun alacritty&<CR>

augroup vimrc

    " Remove all vimrc autocommands
    autocmd!

    " Track insert mode with a variable

    autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 1000)
    autocmd BufWritePre *.py.in lua vim.lsp.buf.formatting_sync(nil, 1000)

    autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
    autocmd BufWritePre *.go.in lua vim.lsp.buf.formatting_sync(nil, 1000)

augroup END

highlight IndentBlanklineChar ctermfg=gray cterm=nocombine
highlight IndentBlanklineContextChar ctermfg=blue cterm=nocombine

" Setup lspconfig

lua << EOF

local opts = { noremap=true, silent=true }

local telescope = require('telescope')
telescope.setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    file_browser = {
        theme = 'ivy',
    }
  }
}
telescope.load_extension('fzf')
telescope.load_extension('dap')
telescope.load_extension('file_browser')

vim.api.nvim_set_keymap('n', '<space>s', '<cmd>lua require(\'telescope.builtin\').find_files()<cr>', opts)
vim.api.nvim_set_keymap('n', '<space>/', '<cmd>lua require(\'telescope.builtin\').live_grep()<cr>', opts)
vim.api.nvim_set_keymap('n', '<space>b', '<cmd>lua require(\'telescope.builtin\').buffers()<cr>', opts)
vim.api.nvim_set_keymap('n', '<space>h', '<cmd>lua require(\'telescope.builtin\').help_tags()<cr>', opts)
vim.api.nvim_set_keymap('n', '<space>e', ':Telescope file_browser', opts)

-- nvim-dap-go setup
local dap_go = require('dap-go')
dap_go.setup()
vim.api.nvim_set_keymap('n', '<space>t', '<cmd>lua require(\'dap-go\').debug_test()<CR>', opts)

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
})

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  client.config.flags.debounce_text_changes = 150
end
local lspconfig = require('lspconfig')

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = {  'gopls', 'tsserver', 'pylsp', 'clangd', 'rls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Setup indent-blankline
vim.opt.list = true
vim.opt.listchars:append("trail:⋅")

require("indent_blankline").setup {
    show_end_of_line = false,
    space_char_blankline = " ",
    show_current_context = true,
    show_trailing_blankline_indent = false,

    context_patterns = {
        "class",
        "^func",
        "^fn",
        "method",
        "^if",
        "while",
        "for",
        "with",
        "try",
        "type",
        "typedef",
        "import",
        "except",
        "arguments",
        "argument_list",
        "object",
        "dictionary",
        "element",
        "table",
        "tuple",
    },
}

local autosave = require("autosave")

autosave.setup(
    {
        enabled = true,
        execution_message = "AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"),
        events = {"InsertLeave", "TextChanged"},
        conditions = {
            exists = true,
            filename_is_not = {},
            filetype_is_not = {},
            modifiable = true
        },
        write_all_buffers = false,
        on_off_commands = true,
        clean_command_line_interval = 0,
        debounce_delay = 135
    }
)

EOF
