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
      }
      {
        __unkeyed-numb = "<leader>sn";
        desc = "Toggle relativenumber";
      }
      {
        __unkeyed-numb = "<leader>s";
        desc = "Style";
        icon = "💄";
      }
      {
        __unkeyed-numb = "<leader>r";
        desc = "Refactor";
      }
      {
        __unkeyed-numb = "<leader>d";
        desc = "Debug";
      }
      # Hide some keymaps
      {
        __unkeyed-numb = "<leader>h";
        hidden = true;
      }
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
        icon = "🔍";
      }
    ];
  };
}
