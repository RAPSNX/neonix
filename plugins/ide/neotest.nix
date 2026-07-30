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
    settings.output.open_on_run = true;
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
      local neotest_go = require("neotest-go")
      local neotest_ginkgo = require("neotest-ginkgo")

      -- neotest-go and neotest-ginkgo both match any "*_test.go" file on their own
      -- (neither is aware of the other), so neotest's single-owner-per-file
      -- resolution effectively picks between them by undefined table iteration
      -- order. Make it deterministic: a spec file belongs to neotest-ginkgo only
      -- when its package has a Ginkgo suite bootstrap file; neotest-go keeps
      -- everything else, including that bootstrap file itself (it has a real
      -- `func Test...(t *testing.T)`).
      local ginkgo_is_test_file = neotest_ginkgo.is_test_file
      neotest_ginkgo.is_test_file = function(file_path)
        if not ginkgo_is_test_file(file_path) then
          return false
        end
        -- Use vim.fs (backed by libuv) rather than vim.fn.fnamemodify/readdir:
        -- this runs inside neotest's async discovery coroutines, where
        -- VimL-calling vim.fn.* functions silently break the coroutine.
        local dir = vim.fs.dirname(file_path)
        for name, type_ in vim.fs.dir(dir) do
          if type_ == "file" and (name == "suite_test.go" or vim.endswith(name, "_suite_test.go")) then
            return true
          end
        end
        return false
      end

      local go_is_test_file = neotest_go.is_test_file
      neotest_go.is_test_file = function(file_path)
        return go_is_test_file(file_path) and not neotest_ginkgo.is_test_file(file_path)
      end

      require("neotest").setup({
        adapters = {
          neotest_go,
          neotest_ginkgo,
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
