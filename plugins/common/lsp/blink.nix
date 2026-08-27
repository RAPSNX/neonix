{
  plugins = {
    blink-cmp = {
      enable = true;
      settings = {
        appearance = {
          nerd_font_variant = "normal";
          use_nvim_cmp_as_default = true;
        };
        completion = {
          accept = {
            auto_brackets = {
              enabled = true;
              semantic_token_resolution = {
                enabled = false;
              };
            };
          };
          documentation = {
            auto_show = true;
          };
          list.selection = {
            preselect = false;
            auto_insert = true;
          };
        };
        keymap = {
          preset = "enter";
          "<Tab>" = [
            "select_next"
            "fallback"
          ];
          "<S-Tab>" = [
            "select_prev"
            "fallback"
          ];
          "<C-n>" = [
            "snippet_forward"
            "fallback"
          ];
          "<C-p>" = [
            "snippet_backward"
            "fallback"
          ];
        };
        signature = {
          enabled = true;
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
            "emoji"
          ];

          cmdline = [ ];
          providers = {
            buffer = {
              score_offset = -7;
            };
            lsp = {
              fallbacks = [ ];
            };
            emoji = {
              module = "blink-emoji";
              name = "Emoji";
              score_offset = -5;
              # Optional configurations
              opts = {
                insert = true;
              };
            };
          };
        };
      };
    };
    blink-emoji.enable = true;
  };
}
