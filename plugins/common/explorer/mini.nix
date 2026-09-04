{
  lib,
  self ? { },
  ...
}:
let
  ref = self.ref or self.sourceInfo.ref or "fancy";
  rev = self.shortRev or self.dirtyShortRev or "dev";
  version = "${ref}:${rev}";
in
{
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
            action = "lua if _G.Snacks then Snacks.picker.files() else require('mini.files').open() end";
            section = "";
          }
          {
            name = "Recent File";
            action = "lua if _G.Snacks then Snacks.picker.recent() else vim.cmd('browse oldfiles') end";
            section = "";
          }
          {
            name = "Quit";
            action = "qa";
            section = "";
          }
        ];
        footer = "I use nix btw. (${version}) -- RAPSN";
      };

      files = { }; # mini file explorer
      icons = { }; # icon provider
      comment = { }; # toggle comments
    };
    mockDevIcons = true;
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
