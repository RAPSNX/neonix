{
  pkgs,
  config,
  lib,
  ...
}: {
  extraPackages = with pkgs; [
    go
    gopls
    delve
  ];

  plugins = {
    lsp.servers.gopls = {
      enable = true;

      extraOptions.settings = {
        gopls = {
          staticcheck = true;
          directoryFilters = [
            "-.git"
            "-.vscode"
          ];
        };
      };
    };

    dap-go = {
      enable = true;

      settings = {
        delve = {
          port = "38697";
          path = "dlv";
        };

        dapConfigurations = [
          {
            type = "go";
            name = "Attach remote";
            mode = "remote";
            request = "attach";
          }
        ];
      };
    };

    conform-nvim = {
      settings = {
        formatters_by_ft = {
          go = ["goimports"];
        };

        formatters = {
          goimports = {
            command = lib.getExe' pkgs.gotools "goimports";
          };
        };
      };
    };
  };
  plugins.treesitter = {
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [go];
  };
}
