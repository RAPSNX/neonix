{
  plugins.snacks = {
    enable = true;
    settings = {
      bigfile.enabled = true;
      gitbrowse.enabled = true;
      lazygit.enabled = true;
      notifier.enabled = true;
      notify.enabled = true;
      quickfile.enabled = true;
      terminal.enabled = true;
      scroll.enabled = true;
    };
  };

  keymaps = [
    {
      action = "<cmd>lua Snacks.lazygit.open()<cr>";
      key = "<leader>gg";
      options = {
        desc = "Open LazyGit";
      };
      mode = ["n"];
    }
    {
      action = "<cmd>lua Snacks.terminal.toggle()<cr>";
      key = "<leader>T";
      options = {
        desc = "Toggle Terminal";
      };
      mode = ["n"];
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>g";
      group = "Git";
      icon = "🐈";
    }
  ];
}
