{
  imports = [
    # LSP
    ./lsp/lsp.nix
    ./lsp/cmp.nix
    ./lsp/snippet.nix
    ./lsp/better-escape.nix
    ./lsp/treesitter.nix
    ./lsp/telescope.nix

    # Explorer
    ./explorer/oil.nix
    ./explorer/mini.nix

    # Style
    ./style/colorscheme.nix
    ./style/lualine.nix
    ./style/which-key.nix
  ];

  plugins = {
    lz-n.enable = true; # LazyLoad libary
    nvim-autopairs.enable = true;
    web-devicons.enable = true; # dependency for core-plugins
    headlines.enable = true; # highlights for markdown
    indent-o-matic.enable = true;
  };
}
