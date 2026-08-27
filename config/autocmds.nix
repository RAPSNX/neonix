{
  autoGroups = {
    highlight_yank.clear = true;
    fast_fold.clear = true;
  };
  autoCmd = [
    {
      event = [ "TextYankPost" ];
      group = "highlight_yank";
      desc = "Highlight yanked content";
      callback = {
        __raw = "function() vim.hl.on_yank() end";
      };
    }
    # Treesitter fold performance optimization during typing in Insert mode
    {
      event = [ "InsertEnter" ];
      group = "fast_fold";
      desc = "Disable treesitter foldexpr during Insert mode for smooth typing";
      callback = {
        __raw = ''
          function()
            if vim.w.foldmethod_before_insert == nil and vim.wo.foldmethod == "expr" then
              vim.w.foldmethod_before_insert = "expr"
              vim.wo.foldmethod = "manual"
            end
          end
        '';
      };
    }
    {
      event = [ "InsertLeave" ];
      group = "fast_fold";
      desc = "Restore treesitter foldexpr after exiting Insert mode";
      callback = {
        __raw = ''
          function()
            if vim.w.foldmethod_before_insert == "expr" then
              vim.wo.foldmethod = "expr"
              vim.w.foldmethod_before_insert = nil
            end
          end
        '';
      };
    }
  ];
}
