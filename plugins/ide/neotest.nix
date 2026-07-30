{ pkgs, inputs, ... }:
{
  extraPlugins = [
    pkgs.vimPlugins.neotest-go
    pkgs.vimPlugins.plenary-nvim
    pkgs.vimPlugins.nvim-nio
    (pkgs.vimUtils.buildVimPlugin {
      pname = "neotest-ginkgo";
      version = inputs.neotest-ginkgo.shortRev or "unstable";
      src = inputs.neotest-ginkgo;
      dependencies = with pkgs.vimPlugins; [
        neotest
        plenary-nvim
        nvim-nio
      ];
    })
  ];

  extraPackages = [ pkgs.ginkgo ];

  plugins.neotest = {
    enable = true;
  };

  keymaps = [
    {
      action = ''<cmd>lua require("neotest").run.run()<CR>'';
      key = "<leader>tt";
      options = {
        desc = "Run nearest test";
      };
      mode = [ "n" ];
    }
    {
      action = ''<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>'';
      key = "<leader>tf";
      options = {
        desc = "Run current file's tests";
      };
      mode = [ "n" ];
    }
    {
      action = ''<cmd>lua require("neotest").run.run(vim.fn.getcwd())<CR>'';
      key = "<leader>td";
      options = {
        desc = "Run whole test suite";
      };
      mode = [ "n" ];
    }
    {
      action = ''<cmd>lua require("neotest").run.run({ strategy = "dap" })<CR>'';
      key = "<leader>tD";
      options = {
        desc = "Debug nearest test";
      };
      mode = [ "n" ];
    }
    {
      action = "<cmd>Neotest summary<CR>";
      key = "<leader>ts";
      options = {
        desc = "Toggle test summary";
      };
      mode = [ "n" ];
    }
    {
      action = ''<cmd>lua require("neotest").output_panel.toggle()<CR>'';
      key = "<leader>to";
      options = {
        desc = "Toggle test output panel";
      };
      mode = [ "n" ];
    }
  ];

  extraConfigLua =
    # lua
    ''
       require("neotest").setup({
         adapters = {
           require("neotest-go"),
           require("neotest-ginkgo"),
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
