{
  plugins.noice = {
    enable = true;
    settings = {
      lsp = {
        override = {
          "vim.lsp.util.convert_input_to_markdown_lines" = true;
          "vim.lsp.util.set_lines_to_buf" = true;
        };
      };
      presets = {
        bottom_search = true;
        command_palette = true;
        long_message_to_split = true;
        lsp_doc_border = true;
      };
    };
  };

  keymaps = [
    {
      action = "<cmd>Noice dismiss<CR>";
      key = "<leader>nd";
      options = {
        desc = "Dismiss notifications";
      };
      mode = [ "n" ];
    }
    {
      action = "<cmd>Noice history<CR>";
      key = "<leader>nh";
      options = {
        desc = "Notification history";
      };
      mode = [ "n" ];
    }
    {
      action = "<cmd>Noice last<CR>";
      key = "<leader>nl";
      options = {
        desc = "Last notification";
      };
      mode = [ "n" ];
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>n";
      group = "Noice";
      icon = {
        icon = "󰂚";
        color = "yellow";
      };
    }
  ];
}
