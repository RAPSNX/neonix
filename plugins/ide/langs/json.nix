{
  pkgs,
  config,
  lib,
  ...
}:
{
  plugins = {
    conform-nvim = {
      settings = {
        formatters_by_ft = {
          json = [ "jsonfmt" ];
          jsonc = [ "jsonfmt" ];
        };
        formatters = {
          jsonfmt = {
            command = lib.getExe pkgs.jsonfmt;
          };
        };
      };
    };
    lsp.servers.jsonls = {
      enable = true;
    };
  };

  plugins.treesitter = {
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [ json ];
  };
}
