set nocompatible
filetype off

call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter'

Plug 'skywind3000/asyncrun.vim'
Plug 'Pocco81/auto-save.nvim'
Plug 'tpope/vim-surround'
Plug 'hashivim/vim-hashicorp-tools'
Plug 'jvirtanen/vim-hcl'
Plug 'lukas-reineke/indent-blankline.nvim'

" Shared dependencies
Plug 'nvim-lua/plenary.nvim'

" Telescope Setup
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

Plug 'tamton-aquib/duck.nvim'

" Status line
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'justinhj/battery.nvim'

" LLM Support
Plug 'MunifTanjim/nui.nvim'
Plug 'Bryley/neoai.nvim'

call plug#end()

filetype plugin indent on

set number
set relativenumber
set title
set clipboard=unnamedplus
syntax on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set shiftround
set expandtab                     " use spaces, not tab characters
set smartindent
set autoindent
autocmd FileType dart setlocal shiftwidth=2 softtabstop=2 expandtab
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set incsearch                     " show search results as I type
set smartcase                     " pay attention to case when caps are used
set ruler                         " show row and column in footer
set nowrap
set autoread
set undofile
set updatetime=100
set mouse=a
set scrolloff=100000
set tw=80

set termguicolors

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
highlight Visual ctermfg=None ctermbg=DarkRed guibg=white

set colorcolumn=81,101,121
highlight ColorColumn ctermbg=16
hi MatchParen cterm=bold ctermbg=none ctermfg=red

set noswapfile
set backupdir=~/.local/share/nvim/backup//
set backupskip=/tmp/*,/private/tmp/* 
set backup

nnoremap !d :AsyncRun alacritty&<CR>

augroup vimrc

    " Remove all vimrc autocommands
    autocmd!

    " Track insert mode with a variable

    autocmd BufWritePre *.py lua vim.lsp.buf.formatting_sync(nil, 1000)
    autocmd BufWritePre *.py.in lua vim.lsp.buf.formatting_sync(nil, 1000)

    autocmd BufWritePre *.go lua vim.lsp.buf.formatting_sync(nil, 1000)
    autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)

augroup END

highlight IndentBlanklineChar ctermfg=gray cterm=nocombine
highlight IndentBlanklineContextChar ctermfg=blue cterm=nocombine

highlight Comment ctermfg=DarkGray cterm=nocombine

lua << EOF

local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>dh', '<cmd>lua require(\'duck\').hatch()<cr>', opts)
vim.api.nvim_set_keymap('n', '<space>dc', '<cmd>lua require(\'duck\').cook()<cr>', opts)

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

vim.api.nvim_set_keymap('n', '<space>f', '<cmd>lua require(\'telescope.builtin\').find_files()<cr>', opts)
vim.api.nvim_set_keymap('n', '<space>/', '<cmd>lua require(\'telescope.builtin\').live_grep()<cr>', opts)
vim.api.nvim_set_keymap('n', '<space>b', '<cmd>lua require(\'telescope.builtin\').buffers()<cr>', opts)
vim.api.nvim_set_keymap('n', '<space>h', '<cmd>lua require(\'telescope.builtin\').help_tags()<cr>', opts)
vim.api.nvim_set_keymap('n', '<space>s', '<cmd>lua require(\'telescope.builtin\').lsp_document_symbols()<cr>', opts)
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
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

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
lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
lspconfig.pylsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
lspconfig.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}
lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ["rust_analyzer"] = {
            diagnostics = {
                enable = true,
                procMacro = { enable = true },
                enableExperimental = true,
            },
        },
    },
}

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

local autosave = require("auto-save")

autosave.setup({
    enabled = true, -- start auto-save when the plugin is loaded (i.e. when your package manager loads it)
    execution_message = {
		message = function() -- message to print on save
			return ("AutoSave: saved at " .. vim.fn.strftime("%H:%M:%S"))
		end,
		dim = 0.18, -- dim the color of `message`
		cleaning_interval = 1250, -- (milliseconds) automatically clean MsgArea after displaying `message`. See :h MsgArea
	},
    trigger_events = {"InsertLeave", "TextChanged"}, -- vim events that trigger auto-save. See :h events
	-- function that determines whether to save the current buffer or not
	-- return true: if buffer is ok to be saved
	-- return false: if it's not ok to be saved
	condition = function(buf)
		local fn = vim.fn
		local utils = require("auto-save.utils.data")

		if
			fn.getbufvar(buf, "&modifiable") == 1 and
			utils.not_in(fn.getbufvar(buf, "&filetype"), {}) then
			return true -- met condition(s), can save
		end
		return false -- can't save
	end,
    write_all_buffers = false, -- write all buffers when the current one meets `condition`
    debounce_delay = 135, -- saves the file at most every `debounce_delay` milliseconds
	callbacks = { -- functions to be executed at different intervals
		enabling = nil, -- ran when enabling auto-save
		disabling = nil, -- ran when disabling auto-save
		before_asserting_save = nil, -- ran before checking `condition`
		before_saving = nil, -- ran before doing the actual save
		after_saving = nil -- ran after doing the actual save
	}
})

require('neoai').setup{
    -- Below are the default options, feel free to override what you would like changed
    ui = {
        output_popup_text = "NeoAI",
        input_popup_text = "Prompt",
        width = 30,      -- As percentage eg. 30%
        output_popup_height = 80, -- As percentage eg. 80%
    },
    models = {
        {
            name = "openai",
            model = "gpt-3.5-turbo"
        },
    },
    register_output = {
        ["g"] = function(output)
            return output
        end,
        ["c"] = require("neoai.utils").extract_code_snippets,
    },
    inject = {
        cutoff_width = 80,
    },
    prompts = {
        context_prompt = function(context)
            return "Here is some code/text for context:\n\n"
                .. context
        end,
    },
    open_api_key_env = "OPENAI_API_KEY",
    shortcuts = {
        {
            key = "<space>as",
            use_context = true,
            prompt = [[
                Rewrite the text to make it more readable, clear, and concise,
                and to fix any grammatical, punctuation, or spelling errors
            ]],
            modes = { "v" },
            strip_function = nil,
        },
        {
            key = "<space>ac",
            use_context = true,
            prompt = [[
                Write a comment to summarize the behavior of this code
            ]],
            modes = { "v" },
            strip_function = nil,
        },
        {
            key = "<space>ag",
            use_context = false,
            prompt = function ()
                return [[
                    Using the following git diff generate a consise and
                    clear git commit message, with a short title summary
                    that is 75 characters or less:
                ]] .. vim.fn.system("git diff --cached")
            end,
            modes = { "n" },
            strip_function = nil,
        },
    },
}

require"battery".setup({})
local nvimbattery = {
  function()
    return require("battery").get_status_line()
  end,
}
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {nvimbattery},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {{'filename', path = 4}},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

EOF
