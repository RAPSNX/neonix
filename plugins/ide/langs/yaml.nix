{
  pkgs,
  config,
  lib,
  ...
}:
{
  extraPackages = with pkgs; [
    helm-ls
    yaml-language-server
  ];

  plugins = {
    lsp.servers = {
      yamlls = {
        enable = true;
        extraOptions.settings = {
          yaml = {
            schemas = {
              kubernetes = "*.k8s.yaml";
              "http://json.schemastore.org/kustomization" = "kustomization.yaml";
              "http://json.schemastore.org/chart" = "Chart.yaml";
            };
            validate = true;
          };
        };
      };

      helm_ls = {
        enable = true;
        extraOptions.settings = {
          "helm-ls" = {
            yamlls = {
              enabled = false;
            };
          };
        };
      };
    };

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
  };

  plugins.treesitter = {
    grammarPackages = lib.attrValues {
      inherit (config.plugins.treesitter.package.builtGrammars) yaml helm gotmpl;
    };
  };

  extraConfigLua = ''
    vim.filetype.add({
      extension = {
        gotmpl = "gotmpl",
        helm = "helm",
      },
      pattern = {
        [".*/templates/.*%.ya?ml"] = "helm",
        [".*/templates/.*%.tpl"] = "helm",
        [".*%.ya?ml%.gotmpl"] = "helm",
        ["helmfile.*%.ya?ml"] = "helm",
        [".*%.ya?ml"] = function(path, bufnr)
          -- Fast in-memory check (only runs once upon opening a file)
          if bufnr and bufnr > 0 then
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 100, false)
            for _, line in ipairs(lines) do
              if
                line:match("{{%-?%s*%.Values")
                or line:match("{{%-?%s*%.Release")
                or line:match("{{%-?%s*%.Chart")
                or line:match("{{%-?%s*%.Files")
                or line:match("{{%-?%s*%.Capabilities")
                or line:match("{{%-?%s*template%s")
                or line:match("{{%-?%s*include%s")
                or line:match("{{%-?%s*define%s")
              then
                return "helm"
              end
            end
          end
          return "yaml"
        end,
      },
    })
  '';
}
