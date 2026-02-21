{
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";
      integrations = {
        alpha = true;
        cmp = false;
        dashboard = true;
        illuminate.enabled = true;
        mini.enabled = true;
        telescope.enabled = true;
        navic.enabled = true;
      };
    };
  };

  # Theme or related plugins
  plugins = {
    web-devicons.enable = true; # dependency for core-plugins
    colorizer.enable = true; # highlight hex colors & more
    illuminate.enable = true; # highlight word under cursor
    todo-comments.enable = true; # highlight todo comments
    dressing.enable = true; # better ui-elements
    headlines.enable = true; # highlights for markdown
  };

  # Colorscheme overwrites / fixes
  highlightOverride = {
    "@variable" = {
      fg = "#ea999c";
      bg = null;
    };
    "LspSignatureActiveParameter" = {
      fg = null;
      bg = "#313244";
    };
  };
}
