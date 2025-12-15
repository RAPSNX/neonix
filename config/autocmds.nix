{
  autoGroups = {
    highlight_yank.clear = true;
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
  ];
}
