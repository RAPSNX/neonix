{
  plugins.lualine = {
    enable = true;
    settings = {
      options = {
        globalstatus = true;
        icons_enabled = true;
        theme = "catppuccin-mocha";
        section_separators = {
          right = "";
          left = "";
        };
        component_separators = {
          left = "";
          right = "";
        };
      };

      sections = {
        lualine_a = [
          {
            __unkeyed-1 = "mode";
            icon = " ";
            color = {
              gui = "bold";
            };
          }
        ];
        lualine_b = [
          {
            __unkeyed-1 = "filetype";
            icon_only = true;
            colored = true;
            padding = {
              left = 1;
              right = 0;
            };
          }
          {
            __unkeyed-1 = "filename";
            color = {
              fg = "#FFF";
            };
            path = 1;
          }
        ];
        lualine_c = [
          {
            __unkeyed-1 = "branch";
            padding = {
              left = 2;
              right = 0;
            };
            icon = "";
            colored = true;
            color = {
              gui = "bold";
              fg = "#fab387";
            };
          }
          {
            __unkeyed-1 = "diff";
            colored = true;
            diff_color = {
              added = {
                fg = "#a6e3a1";
              };
              modified = {
                fg = "#fab387";
              };
              removed = {
                fg = "#f38ba8";
              };
            };
            symbols = {
              added = " ";
              modified = "󰝤 ";
              removed = " ";
            };
          }
        ];
        lualine_x = [
          {
            __unkeyed-1 = "diagnostics";
            colored = true;
            diagnostics_color = {
              color_error = {
                fg = "#f38ba8";
              };
              color_warn = {
                fg = "#f9e2af";
              };
              color_info = {
                fg = "#89b4fa";
              };
              color_hint = {
                fg = "#94e2d5";
              };
            };
            symbols = {
              error = " ";
              warn = " ";
              info = " ";
              hint = "󰌶 ";
            };
          }
          {
            __unkeyed-1.__raw =
              # lua
              ''
                function()
                   return (vim.t.maximized and " ") or ""
                end
              '';
            color = {
              fg = "#2d2c3c";
              bg = "#CBA6F7";
              gui = "bold";
            };
            separator = {
              left = "";
            };
          }
        ];
        lualine_y = [
          {
            __unkeyed-1.__raw =
              # lua
              ''
                function()
                  local clients = vim.lsp.get_clients({ bufnr = 0 })
                  if #clients == 0 then
                    return "None"
                  end

                  local names = {}
                  for _, client in ipairs(clients) do
                    table.insert(names, client.name)
                  end

                  return table.concat(names, " ")
                end
              '';
            icon = {
              __unkeyed-1 = " ";
              color = {
                fg = "#2d2c3c";
                bg = "#8bc2f0";
              };
            };
            padding = {
              left = 0;
              right = 1;
            };
            separator = {
              left = "";
            };
            color = {
              bg = "#2d2c3c";
              fg = "#FFF";
            };
          }
          {
            __unkeyed-1 = "location";
            icon = {
              __unkeyed-1 = " ";
              color = {
                fg = "#2d2c3c";
                bg = "#F38BA8";
              };
            };
            padding = {
              left = 1;
              right = 1;
            };
            separator = {
              left = "";
            };
            color = {
              bg = "#2d2c3c";
              fg = "#FFF";
            };
          }
        ];
        lualine_z = [
          {
            __unkeyed-1 = "progress";
            icon = {
              __unkeyed-1 = " ";
              # TODO: use variable colours
              color = {
                fg = "#2d2c3c";
                bg = "#ABE9B3";
              };
            };
            padding = {
              left = 1;
              right = 1;
            };
            separator = {
              left = "";
            };
            color = {
              bg = "#2d2c3c";
              fg = "#ABE9B3";
            };
          }
        ];
      };
    };
  };
}
