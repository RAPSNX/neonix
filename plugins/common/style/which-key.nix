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
        __unkeyed-1 = "<leader>s";
        group = "Style";
        icon = {
          icon = "";
          color = "purple";
        };
      }
      {
        __unkeyed-1 = "<leader>r";
        group = "Refactor";
        icon = {
          icon = "󰑕";
          color = "yellow";
        };
      }
      {
        __unkeyed-1 = "<leader>d";
        group = "Debug";
        icon = {
          icon = "";
          color = "red";
        };
      }
      {
        __unkeyed-1 = "<leader>t";
        group = "Test";
        icon = {
          icon = "󰙨";
          color = "green";
        };
      }
      {
        __unkeyed-1 = "<leader>l";
        group = "Lint";
        icon = {
          icon = "󰁨";
          color = "cyan";
        };
      }
      # Hide some keymaps
      {
        __unkeyed-1 = "<leader>j";
        hidden = true;
      }
      {
        __unkeyed-1 = "<leader>k";
        hidden = true;
      }
    ];
  };
}
