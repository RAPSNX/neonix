{
  config,
  pkgs,
  lib,
  ...
}:
{
  extraPackages = with pkgs; [
    nixfmt
    statix
  ];

  plugins = {
    nix.enable = true;

    # TODO: remove this -> but lets test it one time
    # highlight inline code in nix files
    # hmts.enable = true;

    conform-nvim = {
      settings = {
        formatters_by_ft = {
          nix = [ "nixfmt" ];
        };
        formatters = {
          nixfmt = {
            command = lib.getExe pkgs.nixfmt;
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
      grammarPackages = with config.plugins.treesitter.package.builtGrammars; [ nix ];
    };
  };

  extraConfigVim = ''
    au BufRead,BufNewFile flake.lock setf json
  '';
}
