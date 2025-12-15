{
  plugins.spectre = {
    enable = true;
  };
  keymaps = [
    {
      action = ''<cmd>lua require("spectre").toggle()<CR>'';
      key = "<leader>S";
      options = {
        desc = "Open LazyGit";
      };
      mode = [ "n" ];
    }
  ];
}
