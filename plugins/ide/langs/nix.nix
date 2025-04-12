{
  config,
  pkgs,
  lib,
  ...
}: {
  extraPackages = with pkgs; [
    alejandra
    statix
  ];

  plugins = {
    nix.enable = true;
    # highlight inline code in nix files
    hmts.enable = true;

    conform-nvim = {
      settings = {
        formatters_by_ft = {
          nix = ["alejandra"];
        };
        formatters = {
          alejandra = {
            command = lib.getExe pkgs.alejandra;
          };
        };
      };
    };

    lsp.servers.nixd = {
      enable = true;
      extraOptions.settings = {
        nixd = {
          nixpkgs = {
            expr = "import <nixpkgs> { }";
          };
        };
      };
    };

    treesitter = {
      grammarPackages = with config.plugins.treesitter.package.builtGrammars; [nix];
    };
  };

  extraConfigVim = ''
    au BufRead,BufNewFile flake.lock setf json
  '';
}
