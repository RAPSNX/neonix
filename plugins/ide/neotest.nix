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
      -- order. Make it deterministic based on the file's own content: a file
      -- belongs to neotest-ginkgo only if it actually imports ginkgo, so plain
      -- `func Test...(t *testing.T)` files living alongside Ginkgo specs stay
      -- with neotest-go instead of silently disappearing from both adapters
      -- (the suite bootstrap file is already excluded by neotest-ginkgo's own
      -- is_test_file, since it's named "*_suite_test.go").
      local ginkgo_is_test_file = neotest_ginkgo.is_test_file
      neotest_ginkgo.is_test_file = function(file_path)
        if not ginkgo_is_test_file(file_path) then
          return false
        end
        -- Use vim.uv (backed by libuv) rather than vim.fn.readfile: this runs
        -- inside neotest's async discovery coroutines, where VimL-calling
        -- vim.fn.* functions silently break the coroutine.
        local fd = vim.uv.fs_open(file_path, "r", 438)
        if not fd then
          return false
        end
        local stat = vim.uv.fs_fstat(fd)
        local content = stat and vim.uv.fs_read(fd, stat.size, 0) or ""
        vim.uv.fs_close(fd)
        -- Match only actual import specs (optional alias, then a bare quoted
        -- path filling the whole line), not any occurrence of the substring
        -- "onsi/ginkgo" -- e.g. in a comment, doc string, or fixture literal.
        for line in content:gmatch("[^\n]+") do
          local import_path = line:match('^%s*[%w_.]*%s*"([^"]+)"%s*$')
          if import_path and import_path:find("onsi/ginkgo", 1, true) then
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
