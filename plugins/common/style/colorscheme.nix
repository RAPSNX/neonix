{
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";
      integrations = {
        blink_cmp = true;
        diffview = true;
        gitsigns = true;
        illuminate.enabled = true;
        mini.enabled = true;
        native_lsp = {
          enabled = true;
          virtual_text = {
            errors = [ "italic" ];
            hints = [ "italic" ];
            warnings = [ "italic" ];
            information = [ "italic" ];
          };
          underlines = {
            errors = [ "underline" ];
            hints = [ "underline" ];
            warnings = [ "underline" ];
            information = [ "underline" ];
          };
        };
        navic.enabled = true;
        neotest = true;
        snacks = true;
        telescope.enabled = true;
        treesitter = true;
        which_key = true;
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
