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
        desc = "Search magic";
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

    # TODO: remove below, use default mapping instead
    # --

    # Tiling
    # {
    #   action = "<C-w>v";
    #   key = "<leader>,";
    #   options = {
    #     desc = "Split right";
    #   };
    #
    #   mode = ["n"];
    # }
    #
    # {
    #   action = "<C-w>s";
    #   key = "<leader>.";
    #   options = {
    #     desc = "Split below";
    #   };
    #   mode = ["n"];
    # }
    # # Window navigation
    # {
    #   action = "<C-w>h";
    #   key = "<leader>h";
    #   options = {
    #     desc = "move left";
    #   };
    #   mode = ["n"];
    # }
    # {
    #   action = "<C-w>j";
    #   key = "<leader>j";
    #   options = {
    #     desc = "move up";
    #   };
    #   mode = ["n"];
    # }
    # {
    #   action = "<C-w>k";
    #   key = "<leader>k";
    #   options = {
    #     desc = "move down";
    #   };
    #   mode = ["n"];
    # }
    # {
    #   action = "<C-w>l";
    #   key = "<leader>l";
    #   options = {
    #     desc = "move right";
    #   };
    #   mode = ["n"];
    # }
  ];
}
