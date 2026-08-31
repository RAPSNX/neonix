{
  keymaps = [
    {
      action = "<cmd> Oil <CR>";
      key = "-";
      options = {
        desc = "Open parent directory";
      };
      mode = [ "n" ];
    }
  ];
  plugins = {
    oil = {
      enable = true;

      settings = {
        delete_to_trash = true;
        use_default_keymaps = true;
        lsp_file_method.autosave_changes = true;
        buf_options = {
          buflisted = false;
          bufhidden = "hide";
        };
        view_options = {
          show_hidden = true;
        };
        experimental_watch_for_changes = true;
      };
    };
  };
}
