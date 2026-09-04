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
        local function code_action(pattern)
          return function()
            vim.lsp.buf.code_action({
              context = { only = { "refactor.rewrite" } },
              filter = function(action)
                local title = (action.title or ""):lower()
                if type(pattern) == "table" then
                  for _, p in ipairs(pattern) do
                    if title:find(p, 1, true) then
                      return true
                    end
                  end
                  return false
                end
                return title:find(pattern, 1, true) ~= nil
              end,
              apply = true,
            })
          end
        end

        local function map(key, pattern, desc)
          vim.keymap.set("n", key, code_action(pattern), { buffer = bufnr, desc = desc })
        end

        map("<leader>rf", "fill", "Fill struct or switch")
        map("<leader>rs", "split", "Split lines")
        map("<leader>rj", "join", "Join lines")
        map("<leader>ri", "invert", "Invert if condition")
        map("<leader>rq", { "quote", "raw string", "string literal" }, "Toggle quote style")
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
