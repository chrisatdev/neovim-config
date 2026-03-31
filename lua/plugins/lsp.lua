-- =============================================================================
-- lsp.lua — Language Server Protocol + Completion
-- Neovim 0.11+ API: vim.lsp.config + vim.lsp.enable (no require('lspconfig'))
-- nvim-lspconfig still used — it provides default server configs via runtime files
-- mason handles installation, no mason-lspconfig bridge needed
-- =============================================================================

return {

  -- --------------------------------------------------------------------------
  -- mason.nvim — install LSP servers, formatters, linters
  -- --------------------------------------------------------------------------
  {
    "williamboman/mason.nvim",
    cmd   = { "Mason", "MasonUpdate" },
    build = ":MasonUpdate",
    keys  = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason installer" } },
    opts  = {
      ui = {
        border = "rounded",
        width  = 0.8,
        height = 0.8,
        icons  = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
      ensure_installed = {
        -- LSP servers
        "intelephense",                     -- PHP
        "pyright",                          -- Python
        "gopls",                            -- Go
        "rust-analyzer",                    -- Rust
        "lua-language-server",              -- Lua
        "typescript-language-server",       -- JS / TS
        "sqls",                             -- SQL
        "bash-language-server",             -- Bash / Shell
        "html-lsp",                         -- HTML
        "css-lsp",                          -- CSS
        "json-lsp",                         -- JSON
        "yaml-language-server",             -- YAML
        "taplo",                            -- TOML
        "dockerfile-language-server",       -- Dockerfile
        "docker-compose-language-service",  -- docker-compose.yml
        -- Formatters (used by conform.nvim)
        "stylua",        -- Lua
        "prettier",      -- JS/TS/HTML/CSS/JSON/YAML/MD
        "black",         -- Python
        "isort",         -- Python imports
        "gofumpt",       -- Go
        "goimports",     -- Go imports
        "php-cs-fixer",  -- PHP
        "shfmt",         -- Shell / Bash
        "sql-formatter", -- SQL
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then p:install() end
        end
      end
      if mr.refresh then mr.refresh(ensure_installed) else ensure_installed() end
    end,
  },

  -- --------------------------------------------------------------------------
  -- schemastore — JSON & YAML schemas
  -- --------------------------------------------------------------------------
  { "b0o/schemastore.nvim", lazy = true },

  -- --------------------------------------------------------------------------
  -- nvim-lspconfig — provides default server configs via runtime files
  -- We do NOT call require('lspconfig') — that API is deprecated in Nvim 0.11+
  -- We use vim.lsp.config / vim.lsp.enable instead
  -- --------------------------------------------------------------------------
  {
    "neovim/nvim-lspconfig",
    event        = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "b0o/schemastore.nvim",
    },
    config = function()

      -- ── Diagnostics UI ──────────────────────────────────────────────────────
      local signs = {
        [vim.diagnostic.severity.ERROR] = { name = "DiagnosticSignError", text = " " },
        [vim.diagnostic.severity.WARN]  = { name = "DiagnosticSignWarn",  text = " " },
        [vim.diagnostic.severity.HINT]  = { name = "DiagnosticSignHint",  text = "󰠠 " },
        [vim.diagnostic.severity.INFO]  = { name = "DiagnosticSignInfo",  text = " " },
      }
      for _, s in pairs(signs) do
        vim.fn.sign_define(s.name, { text = s.text, texthl = s.name, numhl = "" })
      end

      vim.diagnostic.config({
        severity_sort    = true,
        underline        = true,
        update_in_insert = false,
        virtual_text     = { spacing = 4, source = "if_many", prefix = "●" },
        float = {
          focusable = false,
          style     = "minimal",
          border    = "rounded",
          source    = "always",
          header    = "",
          prefix    = "",
        },
      })

      -- ── Capabilities (augmented by blink.cmp) ─────────────────────────────
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_blink, blink = pcall(require, "blink.cmp")
      if ok_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end

      -- ── on_attach — keymaps active in every LSP buffer ────────────────────
      local function on_attach(_, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end

        -- Navigation
        map("n", "gd",  vim.lsp.buf.definition,      "Go to definition")
        map("n", "gD",  vim.lsp.buf.declaration,     "Go to declaration")
        map("n", "gr",  vim.lsp.buf.references,       "References")
        map("n", "gi",  vim.lsp.buf.implementation,  "Go to implementation")
        map("n", "gt",  vim.lsp.buf.type_definition, "Type definition")
        map("n", "K",   vim.lsp.buf.hover,           "Hover docs")
        -- Signature help in INSERT mode to avoid conflicting with split navigation
        map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")

        -- Actions
        map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, "Code action")
        map("n", "<leader>ln", vim.lsp.buf.rename, "Rename symbol")
        map("n", "<leader>ld", vim.diagnostic.open_float, "Line diagnostics")
        map("n", "<leader>lf", function()
          require("conform").format({ async = true, lsp_fallback = true })
        end, "Format buffer")

        -- Diagnostics
        map("n", "[d", vim.diagnostic.goto_prev, "Prev diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
        map("n", "<leader>lq", vim.diagnostic.setloclist, "Diagnostics loclist")

        -- Workspace
        map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder,    "Add workspace folder")
        map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
        map("n", "<leader>lwl", function()
          vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, "List workspace folders")
      end

      -- ── Global defaults for ALL servers ───────────────────────────────────
      -- on_attach and capabilities applied to every server automatically
      vim.lsp.config("*", {
        on_attach    = on_attach,
        capabilities = capabilities,
      })

      -- ── Per-server customization ───────────────────────────────────────────

      vim.lsp.config("intelephense", {
        settings = {
          intelephense = {
            environment = { phpVersion = "8.2" },
            stubs = {
              "apache", "bcmath", "bz2", "Core", "curl", "date", "dom",
              "fileinfo", "filter", "gd", "hash", "iconv", "json", "mbstring",
              "mysql", "mysqli", "openssl", "pcntl", "pcre", "PDO",
              "pdo_mysql", "pgsql", "Phar", "posix", "readline", "Reflection",
              "session", "SimpleXML", "sockets", "sodium", "SPL", "sqlite3",
              "standard", "tokenizer", "xml", "xmlreader", "xmlwriter", "xsl",
              "zip", "zlib", "wordpress", "laravel",
            },
          },
        },
      })

      vim.lsp.config("pyright", {
        settings = {
          python = {
            analysis = {
              autoSearchPaths        = true,
              useLibraryCodeForTypes = true,
              diagnosticMode         = "workspace",
              typeCheckingMode       = "basic",
            },
          },
        },
      })

      vim.lsp.config("gopls", {
        settings = {
          gopls = {
            analyses        = { unusedparams = true, shadow = true },
            staticcheck     = true,
            gofumpt         = true,
            usePlaceholders = true,
            hints = {
              assignVariableTypes    = true,
              compositeLiteralFields = true,
              compositeLiteralTypes  = true,
              constantValues         = true,
              functionTypeParameters = true,
              parameterNames         = true,
              rangeVariableTypes     = true,
            },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
            cargo       = { buildScripts = { enable = true } },
            procMacro   = { enable = true },
            imports     = { granularity = { group = "module" }, prefix = "self" },
          },
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime     = { version = "LuaJIT" },
            workspace   = {
              checkThirdParty = false,
              library = {
                vim.fn.expand("$VIMRUNTIME/lua"),
                vim.fn.stdpath("config") .. "/lua",
              },
            },
            completion  = { callSnippet = "Replace" },
            telemetry   = { enable = false },
            diagnostics = { globals = { "vim" } },
            hint        = { enable = true },
          },
        },
      })

      vim.lsp.config("ts_ls", {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints                          = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName   = false,
              includeInlayFunctionParameterTypeHints                  = true,
              includeInlayVariableTypeHints                           = true,
              includeInlayPropertyDeclarationTypeHints                = true,
              includeInlayFunctionLikeReturnTypeHints                 = true,
              includeInlayEnumMemberValueHints                        = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints                          = "all",
              includeInlayParameterNameHintsWhenArgumentMatchesName   = false,
              includeInlayFunctionParameterTypeHints                  = true,
              includeInlayVariableTypeHints                           = true,
              includeInlayPropertyDeclarationTypeHints                = true,
              includeInlayFunctionLikeReturnTypeHints                 = true,
              includeInlayEnumMemberValueHints                        = true,
            },
          },
        },
      })

      vim.lsp.config("bashls", {
        filetypes = { "sh", "bash", "zsh" },
      })

      vim.lsp.config("html", {
        filetypes = { "html", "twig", "hbs", "blade", "htmldjango" },
      })

      -- JSON + schemastore (loaded as dependency, available here)
      vim.lsp.config("jsonls", {
        settings = {
          json = {
            schemas  = require("schemastore").json.schemas(),
            validate = { enable = true },
            format   = { enable = true },
          },
        },
      })

      -- YAML + schemastore
      vim.lsp.config("yamlls", {
        settings = {
          yaml = {
            schemaStore  = { enable = false, url = "" },
            schemas      = require("schemastore").yaml.schemas(),
            keyOrdering  = false,
            format       = { enable = true },
            validate     = true,
          },
        },
      })

      -- ── Enable all servers ─────────────────────────────────────────────────
      -- sqls, cssls, taplo, dockerls, docker_compose_language_service use
      -- nvim-lspconfig defaults with no custom settings
      vim.lsp.enable({
        "intelephense",
        "pyright",
        "gopls",
        "rust_analyzer",
        "lua_ls",
        "ts_ls",
        "sqls",
        "bashls",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "taplo",
        "dockerls",
        "docker_compose_language_service",
      })
    end,
  },

  -- --------------------------------------------------------------------------
  -- blink.cmp — completion engine (replaces nvim-cmp)
  -- --------------------------------------------------------------------------
  {
    "saghen/blink.cmp",
    event        = "InsertEnter",
    version      = "*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      keymap = {
        preset        = "default",
        ["<C-j>"]     = { "select_next",               "fallback" },
        ["<C-k>"]     = { "select_prev",               "fallback" },
        ["<C-d>"]     = { "scroll_documentation_down", "fallback" },
        ["<C-u>"]     = { "scroll_documentation_up",   "fallback" },
        ["<CR>"]      = { "accept",                    "fallback" },
        ["<Tab>"]     = { "snippet_forward",           "fallback" },
        ["<S-Tab>"]   = { "snippet_backward",          "fallback" },
        ["<C-e>"]     = { "hide" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant       = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      cmdline = {
        sources = {},
      },
      completion = {
        accept        = { auto_brackets = { enabled = true } },
        documentation = {
          auto_show          = true,
          auto_show_delay_ms = 200,
          window             = { border = "rounded" },
        },
        ghost_text = { enabled = true },
        menu = {
          border = "none",
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1 },
            },
          },
        },
      },
      signature = {
        enabled = true,
        window  = { border = "rounded" },
      },
    },
  },
}
