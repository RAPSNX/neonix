{
  config,
  lib,
  pkgs,
  ...
}:
{
  plugins = {
    lsp.servers.bashls = {
      enable = true;
    };
    conform-nvim = {
      settings = {
        formatters_by_ft = {
          sh = [ "shfmt" ];
          bash = [ "shfmt" ];
        };

        formatters = {
          shfmt = {
            command = lib.getExe pkgs.shfmt;
          };
        };
      };
    };
  };
  plugins.treesitter = {
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [ bash ];
  };
}
