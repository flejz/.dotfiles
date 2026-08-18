-- general
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- basic settings
vim.opt.autoindent = true
vim.opt.autoread = true
vim.opt.backspace:append({ 'indent', 'eol', 'start' })
vim.opt.clipboard = 'unnamedplus'
vim.opt.cmdheight = 2
vim.opt.complete:append('kspell')
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
vim.opt.virtualedit = 'block'
vim.opt.wildmenu = true
vim.opt.wildmode = 'full'

-- overrides
vim.o.termguicolors = true
vim.o.number = true
vim.o.relativenumber = false
vim.o.signcolumn = "yes"
vim.o.background = "dark"
vim.o.updatetime = 250 -- time before the popup
vim.o.completeopt = "menu,menuone,noselect"

-- NOTE (linux): clipboard='unnamedplus' requires xclip or wl-clipboard installed

-- basic mappings
-- config handling
vim.keymap.set("n", "<C-o>", function()
  vim.cmd("edit " .. vim.fn.stdpath("config") .. "/init.lua")
end, { desc = "Open init.lua" })

vim.keymap.set("n", "<C-o>r", function()
  dofile(vim.fn.stdpath("config") .. "/init.lua")
  vim.notify("Neovim config reloaded!", vim.log.levels.INFO)
end, { desc = "Reload init.lua" })

-- key mapping for tab navigation
vim.keymap.set('n', '<Tab>', 'gt', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', 'gT', { noremap = true, silent = true })

-- prevent x from overriding what's in the clipboard.
vim.keymap.set('n', 'x', '"_x', { noremap = true })
vim.keymap.set('n', 'X', '"_x', { noremap = true })

-- toggle spell check.
vim.keymap.set('n', '<F5>', ':setlocal spell!<CR>', { noremap = true })

-- toggle visually showing all whitespace characters.
vim.keymap.set('n', '<F7>', ':set list!<CR>', { noremap = true })

-- comment
-- vim.keymap.set("n", "<leader>c", "<S-v>gc", { remap = true })
-- vim.keymap.set("v", "<leader>c", "gc", { remap = true })

-- terminal exit
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- lazy.nvim bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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
  { "saadparwaiz1/cmp_luasnip" },
  -- { "rafamadriz/friendly-snippets" },

  -- syntax & ui niceties
  { "nvim-telescope/telescope.nvim" },
  { "nvim-lua/plenary.nvim" },
  -- NOTE: BurntSushi/ripgrep is a system binary, not a plugin. Install via OS pkg manager
  --   windows: winget install BurntSushi.ripgrep.MSVC   linux: apt/pacman install ripgrep
  { "hoob3rt/lualine.nvim" },
  -- NOTE: branch matters. master is archived and refuses neovim 0.12; main
  -- needs 0.12 for vim.list. so the branch is pinned to the neovim we run,
  -- not left to the repo default.
  { "nvim-treesitter/nvim-treesitter",  branch = "main",   build = ":TSUpdate" },
  { "j-hui/fidget.nvim" },
  { "numToStr/Comment.nvim" },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-mini/mini.icons',
    },
    ft = { "markdown", "md", "AgenticChat", "codecompanion" },
  },
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>lg", "<cmd>LazyGit<cr>", desc = "LazyGit" }
    }
  },

  -- dap (debugging)
  { "mfussenegger/nvim-dap" },

  -- theme
  { "Mofiqul/vscode.nvim" },

  -- rendering

  -- ai
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "franco-ruggeri/codecompanion-spinner.nvim",
    },
    opts = {
      -- NOTE: The log_level is in `opts.opts`
      opts = {
        log_level = "DEBUG", -- or "TRACE"
      },
      extensions = {
        spinner = {},
      },
    },
  },
  -- {
  --   "carlos-algms/agentic.nvim",
  --   dependencies = {
  --     "hakonharnes/img-clip.nvim",
  --   },
  --
  --   opts = {
  --     -- Available by default: "claude-acp" | "gemini-acp" | "codex-acp" | "opencode-acp" | "cursor-acp"
  --     provider = "claude-acp", -- setting the name here is all you need to get started
  --   },
  --
  --   -- these are just suggested keymaps; customize as desired
  --   keys = {
  --     {
  --       "<C-\\>",
  --       function() require("agentic").toggle() end,
  --       mode = { "n", "v", "i" },
  --       desc = "Toggle Agentic Chat"
  --     },
  --     {
  --       "<C-'>",
  --       function() require("agentic").add_selection_or_file_to_context() end,
  --       mode = { "n", "v" },
  --       desc = "Add file or selection to Agentic to Context"
  --     },
  --     {
  --       "<C-,>",
  --       function() require("agentic").new_session() end,
  --       mode = { "n", "v", "i" },
  --       desc = "New Agentic Session"
  --     },
  --   },
  -- },


})

-- mason setup
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
  },
  automatic_installation = true,
  -- rustaceanvim owns the rust client; letting mason-lspconfig enable
  -- rust_analyzer too would start a second one on every rust buffer.
  automatic_enable = { exclude = { "rust_analyzer" } },
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
  map("n", "<leader>r", vim.lsp.buf.rename, "Rename")
  map({ "n", "v" }, "<leader>a", vim.lsp.buf.code_action, "Code Action")
  map("n", "<leader>e", vim.diagnostic.open_float, "Line Diagnostics")
  map("n", "[d", function()
    vim.diagnostic.jump({ count = -1 })
    vim.diagnostic.open_float(nil, { scope = "cursor" })
  end, "Prev Diagnostic")
  map("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
    vim.diagnostic.open_float(nil, { scope = "cursor" })
  end, "Next Diagnostic")
  map("n", "<leader>F", function() vim.lsp.buf.format({ async = true }) end, "Format")
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

vim.lsp.config["gopls"] = {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}
vim.lsp.enable("gopls")

vim.lsp.config["clangd"] = {
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
  },
}
vim.lsp.enable("clangd")

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
          -- share target/debug with make and bacon instead of keeping a private
          -- target/rust-analyzer. the toolchain and rustflags are part of the unit
          -- fingerprint, so they must match the non-release branch of the project
          -- Makefile or r-a recompiles everything make just built. check.extraEnv
          -- inherits this, so flycheck fingerprints the same way.
          extraEnv = {
            RUSTUP_TOOLCHAIN = "nightly",
            CARGO_BUILD_RUSTFLAGS = "-Z threads=6",
          },
        },
        check = {
          command = "check",
          -- skip tests/benches/examples + dev-deps on save (tests still build via `make test`)
          allTargets = false,
        },
        checkOnSave = true,
        procMacro = { enable = true },
        -- nightly rustfmt for project's import grouping
        rustfmt = {
          overrideCommand = { "rustup", "run", "nightly", "rustfmt", "--edition", "2024" },
        },
        -- skip indexing heavy dirs in this workspace
        files = {
          excludeDirs = {
            ".cache",
            "target",
            "embedded-web-app/node_modules",
            "embedded-web-app/dist",
            ".git",
          },
        },
        -- speed: smaller lru, no unneeded scans
        lru = { capacity = 256 },
        diagnostics = {
          experimental = { enable = false },
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

-- color scheme
vim.cmd("colorscheme vscode")
vim.api.nvim_set_hl(0, "Normal", { bg = "#030303" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#030303" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5A5A5A", bg = "#030303" })
vim.api.nvim_set_hl(0, "TabLineSel", { bg = "#030303" })
vim.api.nvim_set_hl(0, "LspInlayHint", { fg = "#A3A3A3" })

-- NOTE: "filetype plugin indent on" is default in neovim 0.8+
-- NOTE: "syntax on" removed - treesitter handles highlighting,
--       having both causes the old regex engine to also load (slow)

-- auto-resize splits when vim gets resized.
vim.cmd("autocmd VimResized * wincmd =")

-- detect external file changes (claude edits, git pulls, formatters)
-- triggers checktime on focus, buffer enter, cursor idle, terminal exit
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI", "TermLeave" }, {
  pattern = "*",
  callback = function()
    if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
      vim.cmd("checktime")
    end
  end,
})
-- notify when a buffer was reloaded from disk
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})

-- unset paste on insertleave.
vim.cmd("autocmd InsertLeave * silent! set nopaste")

-- format on save
-- vim.cmd("autocmd BufWritePre <buffer> :lua vim.lsp.buf.format()")

-- enable inlay hints only when an LSP client that supports them attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      if not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end
  end,
})


-- format on save (rust uses nightly rustfmt via the r-a override above).
-- guarded: real files only, and only when a client actually advertises
-- formatting. without this it fires on scratch buffers and logs
-- "Format request failed, no matching language servers".
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    local clients = vim.lsp.get_clients({ bufnr = args.buf, method = "textDocument/formatting" })
    if #clients == 0 then
      return
    end
    vim.lsp.buf.format({ bufnr = args.buf, async = false, timeout_ms = 2000 })
  end,
})

-- completionmain
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
    ["<C-x>"] = cmp.mapping.complete(),
    ["<CR>"]  = cmp.mapping.confirm({ select = true }),
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-p>"] = cmp.mapping(function(fallback)
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

-- treesitter. the main branch dropped `.configs.setup`: install() only fetches
-- parsers, and highlight/indent became opt-in per buffer instead of global.
-- it also compiles parsers with the tree-sitter cli rather than a bare c
-- compiler. on a fresh machine run `:MasonInstall tree-sitter-cli` once --
-- mason's bin dir is already on nvim's PATH, so no global install is needed.
-- without it every startup re-downloads parsers and fails at the build step.
local ts_langs = { "lua", "rust", "toml", "json", "markdown" }
require("nvim-treesitter").install(ts_langs)
vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_langs,
  callback = function(args)
    -- pcall: the parser may not be downloaded yet on a cold start
    pcall(vim.treesitter.start, args.buf)
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})

-- dap (debugging)
local mason_dap = require("mason-nvim-dap")
mason_dap.setup({
  -- debug adapters only. gopls/clangd are language servers and were silently
  -- ignored here; go would want "delve".
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
-- diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    source = "if_many",
  },
  float = {
    focusable = false,
    border = "rounded",
    source = "if_many",
    header = "",
    prefix = "",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E ",
      [vim.diagnostic.severity.WARN] = "W ",
      [vim.diagnostic.severity.HINT] = "H ",
      [vim.diagnostic.severity.INFO] = "I ",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- fidget
require("fidget").setup({
  progress = {
    poll_rate = 0,
    display = {
      skip_history = true,
      done_ttl = 3,
      progress_ttl = math.huge,
    },
    lsp = {
      progress_ringbuf_size = 0,
      log_handler = false,
    },
  },
  notification = {
    poll_rate = 10,
    filter = vim.log.levels.INFO,
    override_vim_notify = false,
    window = {
      winblend = 100,
    },
  },
})


-- telescope
local telescope = require('telescope')
local actions = require('telescope.actions')
-- local action_layout = require("telescope.actions.layout")

telescope.setup {
  defaults = {
    mappings = {
      i = {
        ["<C-s>"] = actions.cycle_previewers_next,
        ["<C-a>"] = actions.cycle_previewers_prev,
        ["<Esc>"] = actions.close,
        ["<A-n>"] = actions.preview_scrolling_down,
        ["<A-p>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
        -- ["<C-j>"] = actions.move_selection_next,
        -- ["<C-k>"] = actions.move_selection_previous,
        ["<C-u>"] = false,
        -- ["<C-t>"] = action_layout.toggle_preview
      },
    },
  },
}

local key_map_opts = { noremap = true, silent = true }

-- File & Buffer pickers
vim.keymap.set('n', '<leader>f', '<cmd>lua require("telescope.builtin").find_files()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>/', '<cmd>lua require("telescope.builtin").live_grep()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>b', '<cmd>lua require("telescope.builtin").buffers()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>h', '<cmd>lua require("telescope.builtin").help_tags()<CR>', key_map_opts)

-- LSP pickers
vim.keymap.set('n', '<leader>ls', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>lS', '<cmd>lua require("telescope.builtin").lsp_workspace_symbols()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>lw', '<cmd>lua require("telescope.builtin").lsp_dynamic_workspace_symbols()<CR>',
  key_map_opts)
vim.keymap.set('n', '<leader>lr', '<cmd>lua require("telescope.builtin").lsp_references()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>ld', '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>li', '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>lt', '<cmd>lua require("telescope.builtin").lsp_type_definitions()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>lD', '<cmd>lua require("telescope.builtin").diagnostics()<CR>', key_map_opts)

-- Additional useful pickers
vim.keymap.set('n', '<leader>th', '<cmd>lua require("telescope.builtin").oldfiles()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>tw', '<cmd>lua require("telescope.builtin").grep_string()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>tb', '<cmd>lua require("telescope.builtin").current_buffer_fuzzy_find()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>tc', '<cmd>lua require("telescope.builtin").commands()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>tk', '<cmd>lua require("telescope.builtin").keymaps()<CR>', key_map_opts)

-- Git pickers
vim.keymap.set('n', '<leader>gc', '<cmd>lua require("telescope.builtin").git_commits()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>gb', '<cmd>lua require("telescope.builtin").git_branches()<CR>', key_map_opts)
vim.keymap.set('n', '<leader>gs', '<cmd>lua require("telescope.builtin").git_status()<CR>', key_map_opts)

-- Treesitter picker (alternative to LSP symbols)
vim.keymap.set('n', '<leader>ts', '<cmd>lua require("telescope.builtin").treesitter()<CR>', key_map_opts)

-- lualine
require('lualine').setup({
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
    lualine_z = { 'encoding', 'filetype', { "os.date('%H:%M')" } },
  },
})

-- ui and niceties
require('Comment').setup()

require('render-markdown').setup({
  render_modes = true,
  anti_conceal = {
    enabled = false,
  },
})

-- refresh render-markdown when codecompanion finishes streaming
vim.api.nvim_create_autocmd("User", {
  pattern = "CodeCompanionChat*",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].filetype == "codecompanion" then
      vim.schedule(function()
        local rm = require("render-markdown")
        rm.buf_disable()
        rm.buf_enable()
      end)
    end
  end,
})

-- ai
-- load claude oauth token from credentials file
local function load_claude_oauth_token()
  local creds_path = vim.fn.expand("~/.claude/.credentials.json")
  local file = io.open(creds_path, "r")
  if file then
    local content = file:read("*a")
    file:close()
    local ok, creds = pcall(vim.json.decode, content)
    if ok and creds.claudeAiOauth and creds.claudeAiOauth.accessToken then
      vim.env.CLAUDE_CODE_OAUTH_TOKEN = creds.claudeAiOauth.accessToken
    end
  end
end
load_claude_oauth_token()

require("codecompanion").setup({
  adapters = {
    acp = {
      claude_code = function()
        return require("codecompanion.adapters").extend("claude_code")
      end,
    },
  },
  display = {
    action_palette = {
      provider = "telescope", -- use telescope for action palette
    },
  },
  interactions = {
    chat = {
      opts = {
        completion_provider = "nvim-cmp", -- blink|cmp|coc|default
      }
    },
    cli = {
      agent = "claude_code",
      agents = {
        claude_code = {
          cmd = "claude",
          args = {},
          description = "Claude Code CLI",
          provider = "terminal",
        },
      },
    },
  },
  strategies = {
    chat = {
      adapter = "claude_code",
    },
    inline = {
      adapter = "githubmodels",
    },
    cmd = {
      adapter = "githubmodels",
    },
  },
})


-- CodeCompanion keybindings
vim.keymap.set({ "n", "v" }, "<C-\\>", "<cmd>CodeCompanionChat Toggle<CR>", { desc = "Toggle CodeCompanion Chat" })
vim.keymap.set({ "n", "v" }, "<leader>cf", "<cmd>CodeCompanionActions<CR>", { desc = "CodeCompanion Actions" })
vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionChat Add<CR>", { desc = "Add to CodeCompanion Chat" })
vim.keymap.set("n", "<leader>cc", "<cmd>CodeCompanionChat<CR>", { desc = "Open CodeCompanion Chat" })
vim.keymap.set("n", "<leader>ci", "<cmd>CodeCompanion<CR>", { desc = "CodeCompanion Inline" })
vim.keymap.set("n", "<leader>ct", "<cmd>Telescope codecompanion<CR>", { desc = "CodeCompanion Telescope" })
