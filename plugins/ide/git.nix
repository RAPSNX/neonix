{
  plugins.diffview.enable = true;
  plugins.gitsigns.enable = true;

  keymaps = [
    # diffview.nvim - large side-by-side review
    {
      action = "<cmd>DiffviewOpen<CR>";
      key = "<leader>gd";
      options = {
        desc = "Open diff view";
      };
      mode = [ "n" ];
    }
    {
      action = "<cmd>DiffviewClose<CR>";
      key = "<leader>gD";
      options = {
        desc = "Close diff view";
      };
      mode = [ "n" ];
    }

    # gitsigns.nvim - hunk-level fixes inside files
    {
      action = "<cmd>lua require('gitsigns').nav_hunk('next')<CR>";
      key = "]h";
      options = {
        desc = "Next git hunk";
      };
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua require('gitsigns').nav_hunk('prev')<CR>";
      key = "[h";
      options = {
        desc = "Previous git hunk";
      };
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua require('gitsigns').stage_hunk()<CR>";
      key = "<leader>hs";
      options = {
        desc = "Stage hunk";
      };
      mode = [ "n" ];
    }
    {
      # <cmd> keeps the mapping in Visual mode, so line('.')/line('v') still
      # reflect the current selection instead of leaving it and reading it
      # back from the '< / '> marks.
      action = "<cmd>lua require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })<CR>";
      key = "<leader>hs";
      options = {
        desc = "Stage selected lines";
      };
      mode = [ "v" ];
    }
    {
      action = "<cmd>lua require('gitsigns').reset_hunk()<CR>";
      key = "<leader>hr";
      options = {
        desc = "Reset hunk";
      };
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua require('gitsigns').reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })<CR>";
      key = "<leader>hr";
      options = {
        desc = "Reset selected lines";
      };
      mode = [ "v" ];
    }
    {
      action = "<cmd>lua require('gitsigns').preview_hunk()<CR>";
      key = "<leader>hp";
      options = {
        desc = "Preview hunk";
      };
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>";
      key = "<leader>hb";
      options = {
        desc = "Toggle line blame";
      };
      mode = [ "n" ];
    }
  ];
}
