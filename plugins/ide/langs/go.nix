{
  pkgs,
  config,
  lib,
  ...
}:
{
  extraPackages = with pkgs; [
    go
    gopls
    delve
    golangci-lint
  ];

  plugins = {
    lint = {
      enable = true;
      lintersByFt.go = [ "golangcilint" ];
    };

    lsp.servers.gopls = {
      enable = true;

      onAttach.function = ''
        local function code_action(kind)
          return function()
            vim.lsp.buf.code_action({
              context = { only = { kind } },
              apply = true,
            })
          end
        end

        local function map(key, kind, desc)
          vim.keymap.set("n", key, code_action(kind), { buffer = bufnr, desc = desc })
        end

        map("<leader>rf", "refactor.rewrite.fill", "Fill struct or switch")
        map("<leader>rs", "refactor.rewrite.splitLines", "Split lines")
        map("<leader>rj", "refactor.rewrite.joinLines", "Join lines")
        map("<leader>ri", "refactor.rewrite.invertIf", "Invert if condition")
        map("<leader>rq", "refactor.rewrite.changeQuote", "Toggle quote style")
      '';

      extraOptions.settings.gopls.staticcheck = true;
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
          go = [ "goimports" ];
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
    grammarPackages = with config.plugins.treesitter.package.builtGrammars; [ go ];
  };

  keymaps = [
    {
      action = ''<cmd>lua require("lint").try_lint()<CR>'';
      key = "<leader>ll";
      options = {
        desc = "Lint buffer";
      };
      mode = [ "n" ];
    }
  ];
}
