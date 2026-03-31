-- =============================================================================
-- treesitter.lua — Syntax highlighting, indentation & text objects
-- =============================================================================

return {
  {
    "nvim-treesitter/nvim-treesitter",
    version      = false,
    build        = ":TSUpdate",
    event        = { "BufReadPost", "BufNewFile" },
    dependencies = {
      -- Text objects: af/if (function), ac/ic (class), aa/ia (argument)
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        -- Your stack
        "php", "phpdoc",
        "python",
        "go", "gomod", "gowork", "gosum",
        "rust",
        "lua",
        "javascript", "typescript", "tsx", "jsdoc",
        "sql",
        "bash",
        "html", "css", "scss",
        -- Config & infra
        "json", "json5",
        "yaml",
        "toml",
        "dockerfile",
        -- Docs & markup
        "markdown", "markdown_inline",
        -- Neovim internals
        "vim", "vimdoc", "query", "luadoc",
        -- Git
        "git_config", "gitcommit", "gitignore", "diff",
        -- Extras
        "regex", "comment", "graphql",
      },
      auto_install  = true,
      sync_install  = false,

      highlight = {
        enable  = true,
        -- Disable built-in vim regex highlighting for TS-supported langs
        additional_vim_regex_highlighting = false,
        -- Disable for very large files
        disable = function(_, buf)
          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then return true end
        end,
      },

      indent = {
        enable  = true,
        disable = { "python" }, -- pyright handles python indent better
      },

      -- ── nvim-treesitter-textobjects ───────────────────────────────────────
      textobjects = {
        select = {
          enable    = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Select outer function" },
            ["if"] = { query = "@function.inner", desc = "Select inner function" },
            ["ac"] = { query = "@class.outer",    desc = "Select outer class" },
            ["ic"] = { query = "@class.inner",    desc = "Select inner class" },
            ["aa"] = { query = "@parameter.outer", desc = "Select outer parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner parameter" },
            ["ab"] = { query = "@block.outer",    desc = "Select outer block" },
            ["ib"] = { query = "@block.inner",    desc = "Select inner block" },
            ["al"] = { query = "@loop.outer",     desc = "Select outer loop" },
            ["il"] = { query = "@loop.inner",     desc = "Select inner loop" },
          },
        },
        move = {
          enable     = true,
          set_jumps  = true,
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer",    desc = "Next class start" },
            ["]a"] = { query = "@parameter.inner", desc = "Next parameter" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "Prev function start" },
            ["[c"] = { query = "@class.outer",    desc = "Prev class start" },
            ["[a"] = { query = "@parameter.inner", desc = "Prev parameter" },
          },
          goto_next_end = {
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
            ["]C"] = { query = "@class.outer",    desc = "Next class end" },
          },
          goto_previous_end = {
            ["[F"] = { query = "@function.outer", desc = "Prev function end" },
            ["[C"] = { query = "@class.outer",    desc = "Prev class end" },
          },
        },
        -- swap disabled: <leader>c is reserved for close buffer
      swap = { enable = false },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
