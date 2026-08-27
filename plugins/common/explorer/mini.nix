{ lib, ... }: {
  plugins.mini = {
    enable = true;
    modules = {
      starter = {
        header = lib.concatLines [
          "███╗   ██╗███████╗ ██████╗ ███╗   ██╗██╗██╗  ██╗"
          "████╗  ██║██╔════╝██╔═══██╗████╗  ██║██║╚██╗██╔╝"
          "██╔██╗ ██║█████╗  ██║   ██║██╔██╗ ██║██║ ╚███╔╝ "
          "██║╚██╗██║██╔══╝  ██║   ██║██║╚██╗██║██║ ██╔██╗ "
          "██║ ╚████║███████╗╚██████╔╝██║ ╚████║██║██╔╝ ██╗"
          "╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝"
        ];
        items = [
          {
            name = "Find File";
            action = "lua if pcall(require, 'telescope.builtin') then require('telescope.builtin').find_files({follow=true, hidden=true}) else require('mini.files').open() end";
            section = "";
          }
          {
            name = "Recent File";
            action = "lua if pcall(require, 'telescope.builtin') then require('telescope.builtin').oldfiles() else vim.cmd('browse oldfiles') end";
            section = "";
          }
          {
            name = "Quit";
            action = "qa";
            section = "";
          }
        ];
        footer = "I use NIX btw. -- RAPSN";
      };

      files = { }; # mini file explorer
      comment = { }; # toggle comments
    };
  };

  keymaps = [
    # explorer
    {
      action = "<cmd>lua MiniFiles.open()<cr>";
      key = "<leader>e";
      options = {
        desc = "Open File Tree";
      };
      mode = [ "n" ];
    }
  ];
}
