{
  plugins.spectre = {
    enable = true;
  };
  keymaps = [
    {
      action = ''<cmd>lua require("spectre").toggle()<CR>'';
      key = "<leader>S";
      options = {
        desc = "Toggle Spectre (Search & Replace)";
      };
      mode = [ "n" ];
    }
  ];
}
