{
  plugins = {
    lsp = {
      enable = true;

      keymaps = {
        diagnostic = {
          "]d" = "goto_next";
          "[d" = "goto_prev";
        };

        lspBuf = {
          K = "hover";
          gD = "declaration";
          gr = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
          "<leader>ra" = {
            action = "code_action";
            desc = "Code Action";
            mode = [
              "n"
              "v"
            ];
          };
          "<leader>rn" = {
            action = "rename";
            desc = "Rename";
          };
        };
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lsp_format = "fallback";
          timeout_ms = 1500;
        };
      };
    };
    fidget.enable = true; # LSP progress
  };
}
