{
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      gitbrowse.enabled = true;
      lazygit = {
        enable = true;
        config.os = {
          edit = ''f="$(git rev-parse --show-toplevel)/{{filename}}"; [ -z "$NVIM" ] && (nvim -- "$f") || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote-send "<C-\><C-N>:NeonixLazygitEdit $f<CR>")'';
          editAtLine = ''f="$(git rev-parse --show-toplevel)/{{filename}}"; [ -z "$NVIM" ] && (nvim +{{line}} -- "$f") || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote-send "<C-\><C-N>:{{line}}NeonixLazygitEdit $f<CR>")'';
        };
      };
      notifier.enabled = true;
      notify.enabled = true;
      quickfile.enabled = true;
      terminal.enabled = true;
      scroll.enabled = true;
    };
  };

  extraConfigLua = ''
    vim.api.nvim_create_user_command("NeonixLazygitEdit", function(opts)
      local origin = vim.g.neonix_lazygit_origin
      if not origin or not vim.api.nvim_win_is_valid(origin) then
        origin = vim.api.nvim_get_current_win()
      end

      vim.api.nvim_set_current_win(origin)
      vim.cmd({ cmd = "edit", args = { opts.args } })
      if opts.range > 0 then
        vim.api.nvim_win_set_cursor(0, { opts.line1, 0 })
      end
    end, { nargs = 1, range = true })
  '';

  keymaps = [
    {
      action.__raw = ''
        function()
          vim.g.neonix_lazygit_origin = vim.api.nvim_get_current_win()
          Snacks.lazygit.open()
        end
      '';
      key = "<leader>gg";
      options = {
        desc = "Open LazyGit";
      };
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua Snacks.terminal.toggle()<cr>";
      key = "<leader>T";
      options = {
        desc = "Toggle Terminal";
      };
      mode = [ "n" ];
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>g";
      group = "Git";
      icon = "🐈";
    }
  ];
}
