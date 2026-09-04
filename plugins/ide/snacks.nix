{ pkgs, ... }:
{
  extraPackages = [ pkgs.imagemagick ];

  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      gitbrowse.enabled = true;
      lazygit = {
        enabled = true;
        config.os = {
          edit = ''[ -z "$NVIM" ] && (nvim -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote-send "<C-\><C-N>:NeonixLazygitEdit {{filename}}<CR>")'';
          editAtLine = ''[ -z "$NVIM" ] && (nvim +{{line}} -- {{filename}}) || (nvim --server "$NVIM" --remote-send "q" && nvim --server "$NVIM" --remote-send "<C-\><C-N>:{{line}}NeonixLazygitEdit {{filename}}<CR>")'';
        };
      };
      notifier.enabled = true;
      notify.enabled = true;
      image.enabled = true;
      input.enabled = true;
      picker = {
        enabled = true;
        ui_select = true;
        sources = {
          files = {
            follow = true;
            hidden = true;
          };
          grep.follow = true;
        };
      };
      quickfile.enabled = true;
      terminal.enabled = true;
      scroll.enabled = true;
      words.enabled = true;
    };
  };

  extraConfigLua = ''
    vim.api.nvim_create_user_command("NeonixLazygitEdit", function(opts)
      local origin = vim.g.neonix_lazygit_origin
      if not origin or not vim.api.nvim_win_is_valid(origin) then
        origin = vim.api.nvim_get_current_win()
      end

      vim.api.nvim_set_current_win(origin)
      local current_buf = vim.api.nvim_win_get_buf(origin)
      if vim.bo[current_buf].filetype == "oil" then
        vim.cmd("enew")
      end
      vim.cmd({ cmd = "edit", args = { opts.args } })
      if opts.range > 0 then
        vim.api.nvim_win_set_cursor(0, { opts.line1, 0 })
      end
    end, { nargs = 1, range = true })
  '';

  keymaps = [
    {
      action = "<cmd>lua Snacks.picker.files()<cr>";
      key = "<leader>ff";
      options.desc = "Find files";
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua Snacks.picker.lines()<cr>";
      key = "<leader>fz";
      options.desc = "Find in current buffer";
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua Snacks.picker.resume()<cr>";
      key = "<leader>fr";
      options.desc = "Resume picker";
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua Snacks.picker.recent()<cr>";
      key = "<leader>f?";
      options.desc = "Recent files";
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua Snacks.picker.grep()<cr>";
      key = "<leader>fg";
      options.desc = "Grep";
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua Snacks.picker.grep_word()<cr>";
      key = "<leader>fw";
      options.desc = "Search word under cursor";
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua Snacks.picker.buffers()<cr>";
      key = "<leader><space>";
      options.desc = "Find buffer";
      mode = [ "n" ];
    }
    {
      action = "<cmd>lua Snacks.picker.command_history()<cr>";
      key = "<leader>fc";
      options.desc = "Search in command history";
      mode = [ "n" ];
    }
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
      __unkeyed-1 = "<leader>f";
      group = "Search";
      icon = {
        icon = "󰍉";
        color = "blue";
      };
    }
    {
      __unkeyed-1 = "<leader>g";
      group = "Git";
      icon = {
        icon = "";
        color = "orange";
      };
    }
  ];
}
