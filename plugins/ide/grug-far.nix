{
  plugins.grug-far = {
    enable = true;
    lazyLoad.settings = {
      cmd = "GrugFar";
      keys = [
        {
          __unkeyed-1 = "<leader>S";
          __unkeyed-2 = "<cmd>GrugFar<cr>";
          desc = "Search & Replace";
        }
      ];
    };
  };
}
