-- =============================================================================
-- markdown.lua — Markdown tooling
-- markdown-preview.nvim (browser preview) + render-markdown.nvim (inline rendering)
-- =============================================================================

return {

  -- --------------------------------------------------------------------------
  -- markdown-preview.nvim — live browser preview
  -- --------------------------------------------------------------------------
  {
    "iamcco/markdown-preview.nvim",
    cmd   = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft    = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" },
      { "<leader>ms", "<cmd>MarkdownPreviewStop<cr>",   desc = "Stop MD preview" },
    },
    init = function()
      vim.g.mkdp_auto_start   = 0
      vim.g.mkdp_auto_close   = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_browser      = ""       -- use system default browser
      vim.g.mkdp_echo_preview_url = 1    -- print URL in messages
      vim.g.mkdp_page_title   = "${name}"
      vim.g.mkdp_theme        = "dark"
      vim.g.mkdp_preview_options = {
        mkit            = {},
        katex           = {},
        uml             = {},
        mermaid         = {},
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
        toc              = {},
      }
    end,
  },

  -- --------------------------------------------------------------------------
  -- render-markdown.nvim — beautiful inline rendering inside Neovim
  -- Renders headings, code blocks, bullets, checkboxes — no browser needed
  -- --------------------------------------------------------------------------
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft           = { "markdown", "norg", "rmd", "org" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.icons",
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", ft = "markdown", desc = "Toggle rendered markdown" },
    },
    opts = {
      enabled      = true,
      render_modes = { "n", "c" },
      anti_conceal = { enabled = true },
      heading = {
        enabled  = true,
        sign     = true,
        position = "overlay",
        icons    = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
      },
      code = {
        enabled  = true,
        sign     = false,
        style    = "full",
        position = "left",
        width    = "full",
        border   = "thin",
      },
      bullet = {
        enabled = true,
        icons   = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        enabled = true,
        unchecked = { icon = "󰄱 " },
        checked   = { icon = "󰱒 " },
      },
      table = {
        enabled = true,
        style   = "full",
        cell    = "padded",
      },
      link = {
        enabled    = true,
        image      = "󰥶 ",
        hyperlink  = "󰌹 ",
        custom     = {
          web  = { pattern = "^http", icon = "󰖟 " },
        },
      },
    },
  },
}
