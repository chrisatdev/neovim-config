-- =============================================================================
-- mini.lua — mini.nvim module suite
-- Icons, pairs, surround, comment, indentscope, bufremove, move
-- =============================================================================

return {
  -- --------------------------------------------------------------------------
  -- mini.icons — icon provider (replaces nvim-web-devicons)
  -- Must be loaded early (lazy = false) as other plugins depend on it
  -- --------------------------------------------------------------------------
  {
    "echasnovski/mini.icons",
    lazy = false,
    priority = 900,
    opts = {
      style = "glyph",
    },
    init = function()
      -- Shim nvim-web-devicons API so plugins that require it still work
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- --------------------------------------------------------------------------
  -- mini.pairs — auto-close brackets, quotes, etc.
  -- --------------------------------------------------------------------------
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {
      modes = { insert = true, command = false, terminal = false },
      -- Skip auto-closing when next char is a word char
      mappings = {
        ["("] = { action = "open",  pair = "()", neigh_pattern = "[^\\]." },
        ["["] = { action = "open",  pair = "[]", neigh_pattern = "[^\\]." },
        ["{"] = { action = "open",  pair = "{}", neigh_pattern = "[^\\]." },
        [")"] = { action = "close", pair = "()", neigh_pattern = "[^\\]." },
        ["]"] = { action = "close", pair = "[]", neigh_pattern = "[^\\]." },
        ["}"] = { action = "close", pair = "{}", neigh_pattern = "[^\\]." },
        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = "[^\\].", register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = "[^%a\\].", register = { cr = false } },
        ["`"] = { action = "closeopen", pair = "``", neigh_pattern = "[^\\].", register = { cr = false } },
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- mini.surround — add, delete, replace surroundings
  -- Keymaps: gsa (add), gsd (delete), gsr (replace), gsf (find), gsh (highlight)
  -- --------------------------------------------------------------------------
  {
    "echasnovski/mini.surround",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      mappings = {
        add            = "gsa",
        delete         = "gsd",
        find           = "gsf",
        find_left      = "gsF",
        highlight      = "gsh",
        replace        = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- mini.comment — toggle comments with gc / gcc
  -- --------------------------------------------------------------------------
  {
    "echasnovski/mini.comment",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      options = {
        custom_commentstring = function()
          -- Use treesitter context for embedded languages (e.g. JS in HTML)
          local ok, ts_cs_internal = pcall(require, "ts_context_commentstring.internal")
          if ok then
            local cs = ts_cs_internal.calculate_commentstring()
            if cs then return cs end
          end
          return vim.bo.commentstring
        end,
      },
    },
    dependencies = {
      {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = { enable_autocmd = false },
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- mini.indentscope — animated scope indicator (│ line on current block)
  -- Disabled for certain filetypes via autocmd in autocmds.lua
  -- --------------------------------------------------------------------------
  {
    "echasnovski/mini.indentscope",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      symbol  = "│",
      options = { try_as_border = true },
      draw = {
        delay     = 100,
        animation = function() return 0 end, -- instant, no lag
      },
    },
  },

  -- --------------------------------------------------------------------------
  -- mini.bufremove — delete buffers without closing windows
  -- Used by keymaps.lua <leader>c and bufferline close button
  -- --------------------------------------------------------------------------
  {
    "echasnovski/mini.bufremove",
    lazy = true,
    opts = {},
  },

  -- --------------------------------------------------------------------------
  -- mini.move — move lines and selections with Alt+hjkl
  -- --------------------------------------------------------------------------
  {
    "echasnovski/mini.move",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      mappings = {
        -- Visual mode: move selection
        left       = "<M-h>",
        right      = "<M-l>",
        down       = "<M-j>",
        up         = "<M-k>",
        -- Normal mode: move current line
        line_left  = "<M-h>",
        line_right = "<M-l>",
        line_down  = "<M-j>",
        line_up    = "<M-k>",
      },
      options = {
        reindent_linewise = true,
      },
    },
  },
}
