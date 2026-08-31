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

      -- Give every Go test file exactly one adapter with memoized discovery.
      local ginkgo_cache = {}
      local ginkgo_is_test_file = neotest_ginkgo.is_test_file
      neotest_ginkgo.is_test_file = function(file_path)
        if ginkgo_cache[file_path] ~= nil then
          return ginkgo_cache[file_path]
        end
        if not ginkgo_is_test_file(file_path) then
          ginkgo_cache[file_path] = false
          return false
        end
        -- Discovery runs asynchronously, so use libuv instead of vim.fn.
        local fd = vim.uv.fs_open(file_path, "r", 438)
        if not fd then
          ginkgo_cache[file_path] = false
          return false
        end
        local stat = vim.uv.fs_fstat(fd)
        local content = stat and vim.uv.fs_read(fd, stat.size, 0) or ""
        vim.uv.fs_close(fd)
        local in_import_block = false
        for line in content:gmatch("[^\n]+") do
          local import_path
          if in_import_block then
            if line:match("^%s*%)%s*$") then
              in_import_block = false
            else
              import_path = line:match("^%s*[%w_.]*%s*\"([^\"]+)\"")
            end
          elseif line:match("^%s*import%s*%(%s*$") or line:match("^%s*import%s*%(%s*//") then
            in_import_block = true
          else
            import_path = line:match("^%s*import%s+[%w_.]*%s*\"([^\"]+)\"")
          end

          if
            import_path
            and (import_path == "github.com/onsi/ginkgo" or import_path == "github.com/onsi/ginkgo/v2")
          then
            ginkgo_cache[file_path] = true
            return true
          end
        end

        ginkgo_cache[file_path] = false
        return false
      end

      local go_is_test_file = neotest_go.is_test_file
      neotest_go.is_test_file = function(file_path)
        return go_is_test_file(file_path) and not neotest_ginkgo.is_test_file(file_path)
      end

      require("neotest").setup({
        output = {
          open_on_run = true,
        },
        adapters = {
          neotest_go,
          neotest_ginkgo,
        },
      })

      -- Close floating/tool windows with q.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "neotest-output",
          "neotest-output-panel",
          "neotest-summary",
          "help",
          "qf",
          "dap-float",
        },
        callback = function(event)
          vim.bo[event.buf].buflisted = false
          vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close window" })
        end,
      })
    '';
}
