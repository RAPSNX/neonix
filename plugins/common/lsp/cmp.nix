{
  plugins = {
    cmp-nvim-lsp.enable = true;
    cmp-path.enable = true;
    cmp_luasnip.enable = true;
    cmp-buffer.enable = true;
    cmp-emoji.enable = true;

    cmp = {
      enable = true;
      autoEnableSources = false;
      settings = {
        sources = {
          __raw = ''
            cmp.config.sources({
              { name = 'nvim_lsp'},
              { name = 'path'},
              { name = 'luasnip'},
              { name = 'emoji'},
            }, {
              { name = 'buffer'},
            })
          '';
        };

        preselect = "cmp.PreselectMode.None";
        snippet.expand = "luasnip";

        mapping = {
          "<C-e>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = false })";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        };

        window = {
          completion = {
            winhighlight = "FloatBorder:CmpBorder";
            scrollbar = false;
          };

          documentation = {
            winhighlight = "FloatBorder:CmpBorder";
          };
        };

        formatting = {
          fields = [
            "abbr"
            "kind"
            "menu"
          ];
          format =
            # lua
            ''
              function(_, item)
                local icons = {
                  Namespace = "󰌗",
                  Text = "󰉿",
                  Method = "󰆧",
                  Function = "󰆧",
                  Constructor = "",
                  Field = "󰜢",
                  Variable = "󰀫",
                  Class = "󰠱",
                  Interface = "",
                  Module = "",
                  Property = "󰜢",
                  Unit = "󰑭",
                  Value = "󰎠",
                  Enum = "",
                  Keyword = "󰌋",
                  Snippet = "",
                  Color = "󰏘",
                  File = "󰈚",
                  Reference = "󰈇",
                  Folder = "󰉋",
                  EnumMember = "",
                  Constant = "󰏿",
                  Struct = "󰙅",
                  Event = "",
                  Operator = "󰆕",
                  TypeParameter = "󰊄",
                  Table = "",
                  Object = "󰅩",
                  Tag = "",
                  Array = "[]",
                  Boolean = "",
                  Number = "",
                  Null = "󰟢",
                  String = "󰉿",
                  Calendar = "",
                  Watch = "󰥔",
                  Package = "",
                  Copilot = "",
                  Codeium = "",
                  TabNine = "",
                }

                local icon = icons[item.kind] or ""
                item.kind = string.format("%s %s", icon, item.kind or "")
                return item
              end
            '';
        };
      };
    };
    lsp-signature = {
      enable = true;
      settings = {
        doc_lines = 0;
      };
    };
  };
}
