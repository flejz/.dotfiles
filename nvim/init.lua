-- Load Telescope
local telescope = require('telescope')

telescope.setup {
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = require("telescope.actions").move_selection_next,
				["<C-k>"] = require("telescope.actions").move_selection_previous,
			},
		},
	},
}

vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>lua require("telescope.builtin").find_files()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>lua require("telescope.builtin").live_grep()<CR>', { noremap = true, silent = true })

-- Lualine
local lualine = require('lualine')
lualine.setup {
	options = {
		icons_enabled = false,
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch'},
		lualine_c = {'filename'},
		lualine_x = {'encoding', 'fileformat', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	extensions = {}
}

-- Language servers.
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()



-- Configure autocompletion on type
lspconfig.util.default_config = vim.tbl_extend('force', lspconfig.util.default_config, {
		capabilities = capabilities
	})

lspconfig.pyright.setup {}
lspconfig.tsserver.setup {}
lspconfig.gopls.setup {}
lspconfig.rust_analyzer.setup {
	-- Server-specific settings. See `:help lspconfig-setup`
	settings = {
		['rust-analyzer'] = {},
	},
}


-- Global mappings.
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('UserLspConfig', {}),
		callback = function(ev)
			-- Enable completion triggered by <c-x><c-o>
			vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

			-- Buffer local mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local opts = { buffer = ev.buf }
			vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
			vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
			vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
			vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
			vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
			vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
			vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
			vim.keymap.set('n', '<space>wl', function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)
			vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
			vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
			vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
			vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
			vim.keymap.set('n', '<space>f', function()
				vim.lsp.buf.format { async = true }
			end, opts)
	end,
})
-- Enable syntax highlighting.
vim.cmd('filetype plugin indent on')
vim.cmd('syntax on')

-- Spelling mistakes will be colored red.
vim.cmd('highlight SpellBad cterm=underline ctermfg=203 guifg=#ff5f5f')
vim.cmd('highlight SpellLocal cterm=underline ctermfg=203 guifg=#ff5f5f')
vim.cmd('highlight SpellRare cterm=underline ctermfg=203 guifg=#ff5f5f')
vim.cmd('highlight SpellCap cterm=underline ctermfg=203 guifg=#ff5f5f')

-- Basic settings
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace:append({ 'indent', 'eol', 'start' })
vim.opt.clipboard = 'unnamedplus'
vim.opt.cmdheight = 2
vim.opt.complete:append('kspell')
vim.opt.completeopt = { 'menuone', 'longest' }
vim.opt.encoding = 'utf-8'
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.foldmethod = 'indent'
vim.opt.foldnestmax = 10
vim.opt.foldlevel = 1
vim.opt.formatoptions:append({ 'tcqrn1' })
vim.opt.guitablabel = '%M%t'
vim.opt.hidden = true
vim.opt.history = 1000
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.laststatus = 2
vim.opt.linespace = 4
vim.opt.mmp = 5000
vim.opt.modelines = 2
vim.opt.backup = false
vim.opt.compatible = false
vim.opt.errorbells = false
vim.opt.visualbell = false
vim.opt.shiftround = false
vim.opt.spell = false
vim.opt.startofline = false
vim.opt.number = true
vim.opt.wrap = false
vim.opt.writebackup = false
vim.opt.smartcase = true
vim.opt.shiftwidth = 2
vim.opt.showcmd = true
vim.opt.showmatch = true
vim.opt.shortmess:append('c')
vim.opt.showmode = true
vim.opt.signcolumn = 'yes'
vim.opt.softtabstop = 2
vim.opt.spelllang = 'en_us'
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.termencoding = 'utf-8'
vim.opt.textwidth = 0
vim.opt.termencoding = 'utf-8'
vim.opt.ttimeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.updatetime = 300
vim.opt.virtualedit = 'block'
vim.opt.wildmenu = true
vim.opt.wildmode = 'full'

if not vim.fn.has('nvim') then
  vim.opt.term = 'xterm-256color'
end

-- Set the color scheme.
vim.cmd('colorscheme flejz')
vim.opt.background = 'dark'

-- Basic mappings

-- Key mapping for tab navigation
vim.api.nvim_set_keymap('n', '<Tab>', 'gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', 'gT', { noremap = true, silent = true })

-- Prevent x from overriding what's in the clipboard.
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true })
vim.api.nvim_set_keymap('n', 'X', '"_x', { noremap = true })

-- Edit and source vim config file in a new tab.
vim.api.nvim_set_keymap('n', '<Leader>ev', ':tabnew $HOME/.vim/vimrc<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>sv', ':source $MYVIMRC<CR>', { noremap = true })

-- Toggle spell check.
vim.api.nvim_set_keymap('n', '<F5>', ':setlocal spell!<CR>', { noremap = true })

-- Toggle visually showing all whitespace characters.
vim.api.nvim_set_keymap('n', '<F7>', ':set list!<CR>', { noremap = true })

-- Basic autocommands

-- Auto-resize splits when vim gets resized.
vim.cmd('autocmd VimResized * wincmd =')

-- Update a buffer's contents on focus if it changed outside of vim.
vim.cmd('autocmd FocusGained,BufEnter * :checktime')

-- Unset paste on insertleave.
vim.cmd('autocmd InsertLeave * silent! set nopaste')

-- Make sure all types of requirements.txt files get syntax highlighting.
vim.cmd('autocmd BufNewFile,BufRead requirements*.txt set syntax=python')

-- Ensure tabs don't get converted to spaces in makefiles.
vim.cmd('autocmd FileType make setlocal noexpandtab')

-- ALE settings
vim.g.ale_sign_style_error = '>>'
vim.g.ale_sign_style_warning = '--'
vim.g.ale_sign_error = '>>'
vim.g.ale_sign_warning = '--'

vim.g.ale_set_highlights = 1
vim.g.ale_lint_on_insert_leave = 1
vim.g.ale_lint_on_save = 1
vim.g.ale_lint_on_enter = 1
vim.g.ale_completion_autoimport = 1
vim.g.ale_completion_enabled = 1
vim.g.ale_completion_trigger_on_edit = 1
vim.g.ale_typescript_standard_use_global = 1
vim.g.ale_typescript_tsserver_use_global = 1
vim.g.ale_fixers = {
	['*'] = { 'remove_trailing_lines', 'trim_whitespace' },
	['javascript'] = { 'eslint' },
	['typescript'] = { 'eslint' },
	['typescriptreact'] = { 'eslint' },
	['go'] = { 'gopls' },
	['rust'] = { 'rust-analyzer' }
}
vim.g.ale_linters = {
	['javascript'] = { 'eslint' },
	['typescript'] = { 'tsserver', 'prettier' },
	['typescriptreact'] = { 'tsserver' },
	['go'] = { 'gopls' },
	['rust'] = { 'rust-analyzer' }
}

vim.g.ale_cpp_ccls_init_options = {
	['cache'] = {
		['directory'] = '/tmp/ccls/cache'
	}
}

-- Key mappings
vim.api.nvim_set_keymap('n', '<silent> <C-j>', '<Plug>(ale_next_wrap)', {})
vim.api.nvim_set_keymap('n', '<silent> <C-k>', '<Plug>(ale_previous_wrap)', {})
vim.api.nvim_set_keymap('n', '<C-f>', ':ALEFix<CR>', { noremap = true })
vim.api.nvim_set_keymap('i', '<C-f>', '<Esc>:ALEFix<CR>', { noremap = true })

local cmp = require('cmp')

cmp.setup({
		mapping = {
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.close(),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
		},
		sources = {
			{ name = 'nvim_lsp' },
			{ name = 'buffer' },
			{ name = 'path' },
		},
	})
