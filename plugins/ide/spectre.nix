{
  plugins.spectre = {
    enable = true;
    lazyLoad.settings = {
      cmd = "Spectre";
      keys = [
        {
          __unkeyed-1 = "<leader>S";
          __unkeyed-2 = ''<cmd>lua require("spectre").toggle()<CR>'';
          desc = "Toggle Spectre (Search & Replace)";
        }
      ];
    };
  };
}
