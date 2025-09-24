-- general
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = false
vim.o.updatetime = 250
vim.o.signcolumn = "yes"
vim.o.background = "dark"

-- basic settings
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
vim.opt.foldenable = false
vim.opt.formatoptions:append({ 'tcqrn1' })
-- vim.opt.guitablabel = '%M%t'
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
vim.opt.rnu = false
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
vim.opt.textwidth = 0
vim.opt.ttimeout = true
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.updatetime = 300
vim.opt.virtualedit = 'block'
vim.opt.wildmenu = true
vim.opt.wildmode = 'full'

-- basic mappings

-- key mapping for tab navigation
vim.api.nvim_set_keymap('n', '<Tab>', 'gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<S-Tab>', 'gT', { noremap = true, silent = true })

-- prevent x from overriding what's in the clipboard.
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true })
vim.api.nvim_set_keymap('n', 'X', '"_x', { noremap = true })

-- toggle spell check.
vim.api.nvim_set_keymap('n', '<F5>', ':setlocal spell!<CR>', { noremap = true })

-- toggle visually showing all whitespace characters.
vim.api.nvim_set_keymap('n', '<F7>', ':set list!<CR>', { noremap = true })

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- plugins
require("lazy").setup({
  -- package manager helpers
  { "williamboman/mason.nvim",          config = true },
  { "williamboman/mason-lspconfig.nvim" },
  { "jay-babu/mason-nvim-dap.nvim" },

  -- lsp
  { "neovim/nvim-lspconfig" },

  -- snippets
  { "L3MON4D3/LuaSnip" },

  -- best-in-class rust tooling (hover, inlay hints, code actions, runnables)
  { "mrcjkb/rustaceanvim",              version = '^6',     lazy = false },

  -- completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },
  { "saadparwaiz1/cmp_luasnip" },
  { "rafamadriz/friendly-snippets" },

  -- syntax & ui niceties
  { "nvim-telescope/telescope.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "BurntSushi/ripgrep" },
  { "hoob3rt/lualine.nvim" },
  { "sheerun/vim-polyglot" },
  { "nvim-treesitter/nvim-treesitter",  build = ":TSUpdate" },
  { "nvim-lua/plenary.nvim" },
  { "j-hui/fidget.nvim" },

  -- dap (debugging)
  { "mfussenegger/nvim-dap" },

  -- theme
  { "Mofiqul/vscode.nvim" },
})

-- mason setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
  },
  automatic_installation = false,
})

-- capabilities for nvim-cmp
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- global lsp keymaps (buffer-local in on_attach)
local on_attach = function(_, bufnr)
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
  end
  map("n", "K", vim.lsp.buf.hover, "LSP Hover")
  map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>e", vim.diagnostic.open_float, "Line Diagnostics")
  map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
  map("n", "<leader>f", function() vim.lsp.buf.format({ async = true }) end, "Format")
end


vim.lsp.config["lua_ls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      workspace = { checkThirdParty = false },
    },
  },
}
vim.lsp.enable("lua_ls")

-- enable inlay hints automatically on rust buffers
vim.api.nvim_create_autocmd({ "LspAttach", "TextChanged", "TextChangedI", "BufEnter" }, {
  callback = function(args)
    local bufnr = args.buf
    if not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
})

-- on hold, show diagnostics in a float; close when moving
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      border = "rounded",
      source = "if_many",
      scope = "cursor",
    })
  end,
})


-- color scheme
vim.cmd("colorscheme vscode")
vim.api.nvim_set_hl(0, "Normal", { bg = "#030303" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#030303" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5A5A5A", bg = "#030303" })
vim.api.nvim_set_hl(0, "TabLineSel", { bg = "#030303" })
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#A3A3A3" })

-- enable syntax highlighting.
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-- auto-resize splits when vim gets resized.
vim.cmd("autocmd VimResized * wincmd =")

-- update a buffer's contents on focus if it changed outside of vim.
vim.cmd("autocmd FocusGained,BufEnter * :checktime")

-- unset paste on insertleave.
vim.cmd("autocmd InsertLeave * silent! set nopaste")

-- format on save
vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")

-- rustaceanvim (rust + rust-analyzer)
-- this plugin auto-wires rust_analyzer via lspconfig for rust buffers.
-- it also provides extra tools like inlay hints, hover actions, runnables, etc.
vim.g.rustaceanvim = {
  -- server: rust-analyzer settings
  server = {
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      -- extra rust-specific keymaps
      local map = function(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      -- provided by rustaceanvim
      vim.keymap.set(
        "n",
        "<leader>a",
        function() vim.cmd.RustLsp('codeAction') end,
        { silent = true, buffer = bufnr, desc = "Rust Grouping" }
      )

      vim.keymap.set(
        "n",
        "ga",
        function() vim.cmd.RustLsp({ 'hover', 'actions' }) end,
        { silent = true, buffer = bufnr, desc = "Rust Grouping" }
      )

      map("n", "<leader>ha", function()
        vim.cmd.RustLsp({ 'hover', 'actions' })
      end, "Rust Hover Actions")

      map("n", "<leader>rr", function()
        vim.cmd.RustLsp("runnables")
      end, "Rust Runnables")

      map("n", "<leader>rd", function()
        vim.cmd.RustLsp("debuggables")
      end, "Rust Debuggables")

      map("n", "<leader>re", function()
        vim.cmd.RustLsp("explainError")
      end, "Explain Error")

      map("n", "<leader>ri", function()
        vim.cmd.RustLsp("inlayHints")
      end, "Toggle Inlay Hints")

      map("n", "<leader>rc", function()
        vim.cmd.RustLsp("openCargo")
      end, "Open Cargo.toml")

      map("n", "<leader>rt", function()
        vim.cmd.RustLsp("testables")
      end, "Rust Tests (list)")
    end,
    capabilities = capabilities,
    default_settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = true,
        -- inlayHints = {
        --   typeHints = { enable = true },
        --   parameterHints = { enable = true },
        --   chainingHints = { enable = true },
        --   closureReturnTypeHints = { enable = true },
        --   lifetimeElisionHints = { enable = true, useParameterNames = true },
        --   reborrowHints = { enable = true },
        -- },
        diagnostics = {
          disabled = { "inactive-code" },
        },
      },
    },
  },

  -- tools ui tweaks (optional)
  tools = {
    hover_actions = {
      replace_builtin_hover = true,
      border = "rounded",
    },
  },

  -- dap (codelldb) is auto-detected below via mason-nvim-dap
}

-- time before the popup
vim.o.updatetime = 250


-- ---------- completion ----------
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-j>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-k>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

-- treesitter
require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "rust", "toml", "json", "markdown" },
  highlight = { enable = true },
  indent = { enable = true },
})

-- dap (debugging)
local mason_dap = require("mason-nvim-dap")
mason_dap.setup({
  ensure_installed = { "codelldb" },
  -- add custom per-adapter handlers here if needed
  -- handlers = {
  --   function(config) mason_dap.default_setup(config) end,
  -- }
})

-- handy dap mappings
local dap = require("dap")
vim.keymap.set("n", "<F5>", dap.continue, { desc = "DAP Continue" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP Step Into" })
vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP Step Out" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "DAP Conditional BP" })

-- ui niceties
-- basic diagnostic symbols (optional) - deprecated
local signs = { Error = "E ", Warn = "W ", Hint = "H ", Info = "I " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- fidget
local fidget = require("fidget")
fidget.setup({
  -- Options related to LSP progress subsystem
  progress = {
    poll_rate = 0,                -- How and when to poll for progress messages
    suppress_on_insert = false,   -- Suppress new messages while in insert mode
    ignore_done_already = false,  -- Ignore new tasks that are already complete
    ignore_empty_message = false, -- Ignore new tasks that don't contain a message
    clear_on_detach =             -- Clear notification group when LSP server detaches
        function(client_id)
          local client = vim.lsp.get_client_by_id(client_id)
          return client and client.name or nil
        end,
    notification_group = -- How to get a progress message's notification group key
        function(msg) return msg.lsp_client.name end,
    ignore = {},         -- List of LSP servers to ignore

    -- Options related to how LSP progress messages are displayed as notifications
    display = {
      render_limit = 16, -- How many LSP messages to show at once
      done_ttl = 3, -- How long a message should persist after completion
      done_icon = "✔", -- Icon shown when all LSP progress tasks are complete
      done_style = "Constant", -- Highlight group for completed LSP tasks
      progress_ttl = math.huge, -- How long a message should persist when in progress
      progress_icon = -- Icon shown when LSP progress tasks are in progress
      { "dots" },
      progress_style = -- Highlight group for in-progress LSP tasks
      "WarningMsg",
      group_style = "Title", -- Highlight group for group name (LSP server name)
      icon_style = "Question", -- Highlight group for group icons
      priority = 30, -- Ordering priority for LSP notification group
      skip_history = true, -- Whether progress notifications should be omitted from history
      format_message = -- How to format a progress message
          require("fidget.progress.display").default_format_message,
      format_annote = -- How to format a progress annotation
          function(msg) return msg.title end,
      format_group_name = -- How to format a progress notification group's name
          function(group) return tostring(group) end,
      overrides = { -- Override options from the default notification config
        rust_analyzer = { name = "rust-analyzer" },
      },
    },

    -- Options related to Neovim's built-in LSP client
    lsp = {
      progress_ringbuf_size = 0, -- Configure the nvim's LSP progress ring buffer size
      log_handler = false,       -- Log `$/progress` handler invocations (for debugging)
    },
  },

  -- Options related to notification subsystem
  notification = {
    poll_rate = 10,               -- How frequently to update and render notifications
    filter = vim.log.levels.INFO, -- Minimum notifications level
    history_size = 128,           -- Number of removed messages to retain in history
    override_vim_notify = false,  -- Automatically override vim.notify() with Fidget
    configs =                     -- How to configure notification groups when instantiated
    { default = require("fidget.notification").default_config },
    redirect =                    -- Conditionally redirect notifications to another backend
        function(msg, level, opts)
          if opts and opts.on_open then
            return require("fidget.integration.nvim-notify").delegate(msg, level, opts)
          end
        end,

    -- Options related to how notifications are rendered as text
    view = {
      stack_upwards = true,    -- Display notification items from bottom to top
      align = "message",       -- Indent messages longer than a single line
      reflow = false,          -- Reflow (wrap) messages wider than notification window
      icon_separator = " ",    -- Separator between group name and icon
      group_separator = "---", -- Separator between notification groups
      group_separator_hl =     -- Highlight group used for group separator
      "Comment",
      line_margin = 1,         -- Spaces to pad both sides of each non-empty line
      render_message =         -- How to render notification messages
          function(msg, cnt)
            return cnt == 1 and msg or string.format("(%dx) %s", cnt, msg)
          end,
    },

    -- Options related to the notification window and buffer
    window = {
      normal_hl = "Comment", -- Base highlight group in the notification window
      winblend = 100,        -- Background color opacity in the notification window
      border = "none",       -- Border around the notification window
      zindex = 45,           -- Stacking priority of the notification window
      max_width = 0,         -- Maximum width of the notification window
      max_height = 0,        -- Maximum height of the notification window
      x_padding = 1,         -- Padding from right edge of window boundary
      y_padding = 0,         -- Padding from bottom edge of window boundary
      align = "bottom",      -- How to align the notification window
      relative = "editor",   -- What the notification window position is relative to
      tabstop = 8,           -- Width of each tab character in the notification window
      avoid = {}             -- Filetypes the notification window should avoid
      -- e.g., { "aerial", "NvimTree", "neotest-summary" }
    },
  },

  -- Options related to integrating with other plugins
  integration = {
    ["nvim-tree"] = {
      enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
      -- DEPRECATED; use notification.window.avoid = { "NvimTree" }
    },
    ["xcodebuild-nvim"] = {
      enable = true, -- Integrate with wojciech-kulik/xcodebuild.nvim (if installed)
      -- DEPRECATED; use notification.window.avoid = { "TestExplorer" }
    },
  },

  -- Options related to logging
  logger = {
    level = vim.log.levels.WARN, -- Minimum logging level
    max_size = 10000,            -- Maximum log file size, in KB
    float_precision = 0.01,      -- Limit the number of decimals displayed for floats
    path =                       -- Where Fidget writes its logs to
        string.format("%s/fidget.nvim.log", vim.fn.stdpath("cache")),
  },
})


-- telescope
local telescope = require('telescope')
local actions = require('telescope.actions')
local action_layout = require("telescope.actions.layout")

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<C-s>"] = actions.cycle_previewers_next,
        ["<C-a>"] = actions.cycle_previewers_prev,
        ["<Esc>"] = actions.close,
        ["<A-j>"] = actions.preview_scrolling_down,
        ["<A-k>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-u>"] = false,
        ["<M-p>"] = action_layout.toggle_preview
      },
    },
  },
}
-- telescope.load_extension("fidget")

vim.api.nvim_set_keymap('n', '<C-p>', '<cmd>lua require("telescope.builtin").find_files()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>f', '<cmd>lua require("telescope.builtin").live_grep()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>b', '<cmd>lua require("telescope.builtin").buffers()<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>h', '<cmd>lua require("telescope.builtin").help_tags()<CR>',
  { noremap = true, silent = true })

-- lualine

local lualine = require('lualine')
lualine.setup {
  options = {
    icons_enabled = false,
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    theme = "vscode",
  },
  sections = {
    lualine_a = { 'mode' },
    lualine_b = { 'branch' },
    lualine_c = { { 'filename', path = 1 } },
    lualine_x = { { 'diagnostics' } },
    lualine_y = { 'progress', 'location' },
    lualine_z = { 'encoding', 'filetype' },
  },
}
