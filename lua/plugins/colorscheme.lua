-- =============================================================================
-- colorscheme.lua — kanagawa-dragon theme
-- Telescope: borderless style (background blending)
-- =============================================================================

return {
  {
    "rebelot/kanagawa.nvim",
    lazy    = false,
    priority = 1000,
    opts = {
      compile        = true,
      undercurl      = true,
      commentStyle   = { italic = true },
      functionStyle  = {},
      keywordStyle   = { italic = true },
      statementStyle = { bold = true },
      typeStyle      = {},
      transparent    = false,
      dimInactive    = false,
      terminalColors = true,
      theme          = "dragon",
      background     = { dark = "dragon", light = "lotus" },

      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none", -- remove sign-column background tint
            },
          },
        },
      },

      overrides = function(colors)
        local t = colors.theme
        return {
          -- ----------------------------------------------------------------
          -- Borderless Telescope (backgrounds merge into editor background)
          -- ----------------------------------------------------------------
          TelescopeTitle          = { fg = t.ui.special, bold = true },
          TelescopePromptNormal   = { bg = t.ui.bg_p1 },
          TelescopePromptBorder   = { fg = t.ui.bg_p1, bg = t.ui.bg_p1 },
          TelescopeResultsNormal  = { fg = t.ui.fg_dim, bg = t.ui.bg_m1 },
          TelescopeResultsBorder  = { fg = t.ui.bg_m1, bg = t.ui.bg_m1 },
          TelescopePreviewNormal  = { bg = t.ui.bg_dim },
          TelescopePreviewBorder  = { fg = t.ui.bg_dim, bg = t.ui.bg_dim },

          -- ----------------------------------------------------------------
          -- Completion menu — clean, no hard border
          -- ----------------------------------------------------------------
          Pmenu      = { fg = t.ui.shade0, bg = t.ui.bg_p1, blend = 10 },
          PmenuSel   = { fg = "NONE", bg = t.ui.bg_p2 },
          PmenuSbar  = { bg = t.ui.bg_m1 },
          PmenuThumb = { bg = t.ui.bg_p2 },

          -- ----------------------------------------------------------------
          -- Floating windows — consistent with theme
          -- ----------------------------------------------------------------
          NormalFloat   = { bg = t.ui.bg_dim },
          FloatBorder   = { fg = t.ui.bg_dim, bg = t.ui.bg_dim },
          FloatTitle    = { fg = t.ui.special, bold = true },
        }
      end,
    },
    config = function(_, opts)
      require("kanagawa").setup(opts)
      vim.cmd("colorscheme kanagawa-dragon")
    end,
  },
}
