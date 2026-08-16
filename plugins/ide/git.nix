{
  plugins.diffview.enable = true;
  plugins.gitsigns = {
    enable = true;
    settings.signs = {
      add.text = "➕";
      change.text = "🔄";
      delete.text = "➖";
      topdelete.text = "🔼";
      changedelete.text = "🔀";
      untracked.text = "❔";
    };
  };

  keymaps = [
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

    {
      action = "<cmd>lua require('gitsigns').toggle_current_line_blame()<CR>";
      key = "<leader>gb";
      options = {
        desc = "Toggle line blame";
      };
      mode = [ "n" ];
    }
    {
      action.__raw = ''
        function()
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].filetype == "gitsigns-blame" then
              vim.api.nvim_win_close(win, true)
              return
            end
          end
          require("gitsigns").blame()
        end
      '';
      key = "<leader>gB";
      options = {
        desc = "Toggle file blame";
      };
      mode = [ "n" ];
    }
  ];
}
