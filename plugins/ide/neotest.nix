{ pkgs, ... }:
{
  extraPlugins = [
    pkgs.vimPlugins.neotest-go
  ];

  plugins.neotest = {
    enable = true;
  };

  keymaps = [
    {
      action = ''<cmd>lua require("neotest").setup({adapters = {require("neotest-go")}})<CR>'';
      key = "<leader>to";
      options = {
        desc = "enable neotest-go adapter";
      };
      mode = [ "n" ];
    }
    {
      action = ''<cmd>lua require("neotest").setup({adapters = {require("nvim-ginkgo")}})<CR>'';
      key = "<leader>tg";
      options = {
        desc = "enable ginkgo adapter";
      };
      mode = [ "n" ];
    }
    {
      action = "<cmd>Neotest summary<CR>";
      key = "<leader>ts";
      options = {
        desc = "enable ginkgo adapter";
      };
      mode = [ "n" ];
    }
  ];

  extraConfigLua =
    # lua
    ''
       require("neotest").setup({
         adapters = {
           require("neotest-go")
         },
       })

      -- Make q to quit floating windows
      vim.keymap.set('n', 'q', function()
        local winid = vim.api.nvim_get_current_win()
        local config = vim.api.nvim_win_get_config(winid)

        if config.relative ~= "" then
          vim.api.nvim_win_close(winid, true)
        else
          vim.api.nvim_feedkeys('q', 'n', false)
        end
      end, { noremap = true, silent = true })
    '';
}
