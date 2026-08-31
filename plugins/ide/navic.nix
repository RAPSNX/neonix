{
  plugins.navic = {
    enable = true;
    settings = {
      lsp.auto_attach = true;
      separator = "  ";
      depth_limit_indicator = "..";
    };

    luaConfig.post = ''
      _G.neonix_navic_winbar = function()
        local navic = package.loaded["nvim-navic"]
        if navic and navic.is_available() then
          return navic.get_location()
        end
        return ""
      end
      vim.o.winbar = "%{%v:lua._G.neonix_navic_winbar()%}"
    '';
  };
}
