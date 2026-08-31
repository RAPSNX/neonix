{ pkgs, ... }: {
  extraPackages = with pkgs; [
    ripgrep
    fd
  ];

  plugins = {
    telescope = {
      enable = true;

      settings.pickers = {
        buffers = {
          initial_mode = "normal";
          theme = "ivy";
        };
        find_files = {
          follow = true;
          hidden = true;
        };
        live_grep = {
          additional_args = [ "--follow" ];
        };
      };

      extensions.fzf-native.enable = true;
      extensions.media-files.enable = true;

      keymaps = {
        "<leader>ff" = {
          action = "find_files";
          options = {
            desc = "Find files";
          };
        };
        "<leader>fz" = {
          action = "current_buffer_fuzzy_find";
          options = {
            desc = "Find in current buffer";
          };
        };
        "<leader>fr" = {
          action = "resume";
          options = {
            desc = "Resume Telescope";
          };
        };
        "<leader>f?" = {
          action = "oldfiles";
          options = {
            desc = "Recent files";
          };
        };
        "<leader>fg" = {
          action = "live_grep";
          options = {
            desc = "Grep";
          };
        };
        "<leader>fw" = {
          action = "grep_string";
          options = {
            desc = "Search word under cursor";
          };
        };
        "<leader><space>" = {
          action = "buffers";
          options = {
            desc = "Find buffer";
          };
        };
        "<leader>fc" = {
          action = "command_history";

          options = {
            desc = "Search in command history";
          };
        };
      };

      settings.defaults = {
        mappings = {
          i = {
            "<esc>" = {
              __raw = "require('telescope.actions').close";
            };
          };
        };
      };
    };
    which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>f";
        group = "Search";
        icon = {
          icon = "󰍉";
          color = "blue";
        };
      }
    ];
  };
}
