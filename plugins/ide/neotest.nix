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
        -- neotest-ginkgo's filter_dir already restricts scanning to
        -- directories that contain a Ginkgo suite file, so a plain
        -- substring check is enough here without parsing imports.
        return content:find("onsi/ginkgo", 1, true) ~= nil
      end

      local go_is_test_file = neotest_go.is_test_file
      neotest_go.is_test_file = function(file_path)
        return go_is_test_file(file_path) and not neotest_ginkgo.is_test_file(file_path)
      end

      -- neotest.setup() rebuilds its config from scratch on every call
      -- (vim.tbl_deep_extend("force", default_config, config) -- it does not
      -- merge with whatever a prior setup() call already applied), so every
      -- option this config cares about must be set together in this one,
      -- final call rather than split across plugins.neotest.settings and here.
      require("neotest").setup({
        output = {
          open_on_run = true,
        },
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
