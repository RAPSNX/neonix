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
          yaml = [ "yamlfmt" ];
        };
        formatters = {
          yamlfmt = {
            command = lib.getExe pkgs.yamlfmt;
          };
        };
      };
    };
    # TODO: remove if not needed
    # lsp.servers.yamlls = {
    #   enable = true;
    # };
  };

  plugins.treesitter = {
    grammarPackages = lib.attrValues {
      inherit (config.plugins.treesitter.package.builtGrammars) yaml helm;
    };
  };
}
