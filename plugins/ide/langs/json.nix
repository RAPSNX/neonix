{
  pkgs,
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
}
