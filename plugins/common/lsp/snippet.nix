{ pkgs, ... }:
{
  # Blink's default snippet source consumes VS Code-style snippets through
  # Neovim's native vim.snippet API, so LuaSnip is not needed.
  extraPlugins = [ pkgs.vimPlugins.friendly-snippets ];
}
