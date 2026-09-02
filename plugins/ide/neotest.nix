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
    callSetup = false;
    lazyLoad.settings = {
      before.__raw = ''
        function()
          for _, plugin in ipairs({ "plenary.nvim", "nvim-nio", "neotest-go", "neotest-ginkgo" }) do
            require("lz.n").trigger_load(plugin)
          end
        end
      '';
      keys = [
        {
          __unkeyed-1 = "<leader>tt";
          __unkeyed-2 = ''<cmd>lua require("neotest").run.run()<CR>'';
          desc = "Run nearest test";
        }
        {
          __unkeyed-1 = "<leader>tf";
          __unkeyed-2 = ''<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>'';
          desc = "Run current file's tests";
        }
        {
          __unkeyed-1 = "<leader>td";
          __unkeyed-2 = ''<cmd>lua require("neotest").run.run(vim.fn.getcwd())<CR>'';
          desc = "Run whole test suite";
        }
        {
          __unkeyed-1 = "<leader>tD";
          __unkeyed-2 = ''<cmd>lua require("neotest").run.run({ strategy = "dap" })<CR>'';
          desc = "Debug nearest test";
        }
        {
          __unkeyed-1 = "<leader>ta";
          __unkeyed-2 = "<cmd>lua _G.neonix_neotest_toggle_adapter()<CR>";
          desc = "Toggle test adapter (Ginkgo/Go)";
        }
        {
          __unkeyed-1 = "<leader>ts";
          __unkeyed-2 = ''<cmd>lua require("neotest").summary.toggle()<CR>'';
          desc = "Toggle test summary";
        }
        {
          __unkeyed-1 = "<leader>to";
          __unkeyed-2 = ''<cmd>lua require("neotest").output_panel.toggle()<CR>'';
          desc = "Toggle test output panel";
        }
      ];

      after.__raw = ''
        function()
          local neotest = require("neotest")
          local adapters = {
            go = require("neotest-go"),
            ginkgo = require("neotest-ginkgo"),
          }

          -- Ginkgo is the default for each Neovim session. <leader>ta changes
          -- this value so subsequent test discovery and runs use plain Go.
          local active_adapter = "ginkgo"

          -- Both upstream adapters accept every *_test.go filename, so Neotest
          -- cannot infer whether a file belongs to Ginkgo or standard Go tests.
          -- Wrap copies of the adapters and let only the selected one claim files.
          -- Copying keeps the modules returned by require() unchanged.
          local function selectable_adapter(name, adapter)
            local wrapped = vim.tbl_extend("force", {}, adapter)
            wrapped.is_test_file = function(file_path)
              return active_adapter == name and adapter.is_test_file(file_path)
            end
            return wrapped
          end

          local function adapter_label()
            return active_adapter == "ginkgo" and "Ginkgo" or "Go"
          end

          _G.neonix_neotest_toggle_adapter = function()
            active_adapter = active_adapter == "ginkgo" and "go" or "ginkgo"
            vim.notify("Neotest adapter: " .. adapter_label())
          end

          -- Expose the session mode for smoke tests without exposing adapters.
          _G.neonix_neotest_active_adapter = function()
            return active_adapter
          end

          neotest.setup({
            discovery = {
              enabled = false,
            },
            output = {
              open_on_run = true,
            },
            adapters = {
              selectable_adapter("ginkgo", adapters.ginkgo),
              selectable_adapter("go", adapters.go),
            },
          })

          -- These filetypes do not exist until Neotest is loaded, so their
          -- buffer-local mappings can stay inside this lazy-load callback.
          vim.api.nvim_create_autocmd("FileType", {
            pattern = {
              "neotest-output",
              "neotest-output-panel",
              "neotest-summary",
            },
            callback = function(event)
              vim.bo[event.buf].buflisted = false
              vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close window" })
            end,
          })
        end
      '';
    };
  };
}
