{
  plugins.dropbar = {
    enable = true;
  };

  keymaps = [
    {
      action = "<cmd>lua require('dropbar.api').pick()<cr>";
      key = "<leader>;";
      options.desc = "Pick breadcrumb";
      mode = [ "n" ];
    }
  ];
}
