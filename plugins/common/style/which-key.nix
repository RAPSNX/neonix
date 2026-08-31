{
  plugins.which-key = {
    enable = true;

    settings = {
      layout = {
        height = {
          min = 10;
          max = 25;
        };
        width = {
          min = 20;
          max = 50;
        };
      };
    };

    # Additional which-key descriptions
    settings.spec = [
      {
        __unkeyed-diag = "<leader>sd";
        desc = "Toggle virtual text";
        icon = {
          icon = "󰅚";
          color = "cyan";
        };
      }
      {
        __unkeyed-numb = "<leader>sn";
        desc = "Toggle relativenumber";
        icon = {
          icon = "󰋽";
          color = "yellow";
        };
      }
      {
        __unkeyed-numb = "<leader>s";
        group = "Style";
        icon = {
          icon = "";
          color = "purple";
        };
      }
      {
        __unkeyed-numb = "<leader>r";
        group = "Refactor";
        icon = {
          icon = "󰑕";
          color = "yellow";
        };
      }
      {
        __unkeyed-ra = "<leader>ra";
        desc = "Code Action";
        icon = {
          icon = "󰌵";
          color = "yellow";
        };
      }
      {
        __unkeyed-rn = "<leader>rn";
        desc = "Rename";
        icon = {
          icon = "󰤌";
          color = "yellow";
        };
      }
      {
        __unkeyed-numb = "<leader>d";
        group = "Debug";
        icon = {
          icon = "";
          color = "red";
        };
      }
      {
        __unkeyed-numb = "<leader>t";
        group = "Test";
        icon = {
          icon = "󰙨";
          color = "green";
        };
      }
      {
        __unkeyed-numb = "<leader>e";
        desc = "Open File Tree";
        icon = {
          icon = "󰉓";
          color = "azure";
        };
      }
      {
        __unkeyed-numb = "<leader>T";
        desc = "Toggle Terminal";
        icon = {
          icon = "";
          color = "green";
        };
      }
      {
        __unkeyed-numb = "<leader>S";
        desc = "Toggle Spectre";
        icon = {
          icon = "󰛔";
          color = "yellow";
        };
      }
      {
        __unkeyed-numb = "<leader>c";
        desc = "System clipboard";
        icon = {
          icon = "󰅌";
          color = "blue";
        };
      }
      {
        __unkeyed-numb = "<leader>q";
        desc = "Close quickfix";
        icon = {
          icon = "󰅖";
          color = "red";
        };
      }
      {
        __unkeyed-numb = "<leader><space>";
        desc = "Find buffer";
        icon = {
          icon = "󱔗";
          color = "purple";
        };
      }
      # Hide some keymaps
      {
        __unkeyed-numb = "<leader>j";
        hidden = true;
      }
      {
        __unkeyed-numb = "<leader>k";
        hidden = true;
      }
      {
        __unkeyed-1 = "<leader>l";
        group = "Lint";
        icon = {
          icon = "󰁨";
          color = "cyan";
        };
      }
    ];
  };
}
