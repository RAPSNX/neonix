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

  extraConfigLua = ''
    vim.filetype.add({
      filename = {
        ["flake.lock"] = "json",
      },
    })
  '';
}
