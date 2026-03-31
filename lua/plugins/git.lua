-- =============================================================================
-- git.lua — Git integration
-- gitsigns (gutter, hunks) + lazygit (full TUI in a float)
-- =============================================================================

return {

  -- --------------------------------------------------------------------------
  -- gitsigns.nvim — git decorations in the sign column + hunk operations
  -- --------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts  = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      signs_staged = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text         = true,
        virt_text_pos     = "eol",
        delay             = 500,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> · <summary>",
      on_attach = function(bufnr)
        local gs  = package.loaded.gitsigns
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end

        -- ── Hunk navigation ──────────────────────────────────────────────
        map("n", "]h", function()
          if vim.wo.diff then return "]h" end
          vim.schedule(gs.next_hunk)
          return "<Ignore>"
        end, "Next git hunk")

        map("n", "[h", function()
          if vim.wo.diff then return "[h" end
          vim.schedule(gs.prev_hunk)
          return "<Ignore>"
        end, "Prev git hunk")

        -- ── Stage / reset ─────────────────────────────────────────────────
        map("n", "<leader>ghs", gs.stage_hunk,  "Stage hunk")
        map("n", "<leader>ghr", gs.reset_hunk,  "Reset hunk")
        map("v", "<leader>ghs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage hunk (visual)")
        map("v", "<leader>ghr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset hunk (visual)")

        map("n", "<leader>ghS", gs.stage_buffer, "Stage buffer")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo stage hunk")

        -- ── Preview & blame ───────────────────────────────────────────────
        map("n", "<leader>ghp", gs.preview_hunk,  "Preview hunk")
        map("n", "<leader>ghb", function()
          gs.blame_line({ full = true })
        end, "Blame line (full)")
        map("n", "<leader>ghB", gs.toggle_current_line_blame, "Toggle line blame")

        -- ── Diff ──────────────────────────────────────────────────────────
        map("n", "<leader>ghd", gs.diffthis, "Diff this")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff this ~")
        map("n", "<leader>ghT", gs.toggle_deleted, "Toggle deleted lines")

        -- ── Text objects for hunks ────────────────────────────────────────
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Select hunk")
      end,
    },
  },

  -- --------------------------------------------------------------------------
  -- lazygit.nvim — full LazyGit TUI in a floating window
  -- Requires: lazygit installed on the system (e.g. brew/apt/scoop)
  -- --------------------------------------------------------------------------
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>",            desc = "LazyGit" },
      { "<leader>gf", "<cmd>LazyGitCurrentFile<cr>", desc = "LazyGit (current file)" },
      { "<leader>gl", "<cmd>LazyGitFilter<cr>",      desc = "LazyGit log" },
    },
    opts = {
      floating_window_winblend       = 0,
      floating_window_scaling_factor = 0.9,
      floating_window_border_chars   = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      use_neovim_remote              = true,
    },
  },
}
