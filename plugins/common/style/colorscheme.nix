{ pkgs, ... }:
{
  colorschemes.catppuccin = {
    enable = true;
    settings = {
      flavour = "mocha";
      integrations = {
        blink_cmp = true;
        diffview = true;
        gitsigns = true;
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
        neotest = true;
        render_markdown = true;
        snacks = true;
        treesitter = true;
        which_key = true;
      };
    };
  };

  # Theme or related plugins
  plugins = {
    todo-comments.enable = true; # highlight todo comments
    render-markdown.enable = true;
  };

  extraPlugins = [ pkgs.vimPlugins.nvim-highlight-colors ];
  extraConfigLua = ''
    require("nvim-highlight-colors").setup({})
  '';

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
