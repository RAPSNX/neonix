{
  keymaps = [
    # Copy to system clipboard
    {
      action = "\"+";
      key = "<leader>c";
      options = {
        desc = "System clipboard";
      };

      mode = [
        "n"
        "v"
      ];
    }

    # Better search
    {
      action = '':%s/\v'';
      key = "<leader>fs";
      options = {
        desc = "Search + replace magic";
      };

      mode = [
        "n"
        "v"
      ];
    }

    # Quick search
    {
      action = ":cclose<CR>";
      key = "<leader>q";
      options = {
        desc = "Close quickfix";
      };

      mode = [
        "n"
        "v"
      ];
    }
  ];
}
