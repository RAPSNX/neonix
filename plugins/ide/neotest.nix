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

          -- Upstream hands Ginkgo's CLI-only --ginkgo.output-dir to the test
          -- binary Delve launches, which rejects it ("flag provided but not
          -- defined") and kills every debug session. Rewrite the pair into one
          -- absolute --ginkgo.json-report. neotest-ginkgo looks `build` up on
          -- the module at call time, so overriding it here takes effect.
          local ginkgo_dap = require("neotest-ginkgo.dap")
          local upstream_build = ginkgo_dap.build
          ginkgo_dap.build = function(context)
            local strategy = upstream_build(context)
            local rewritten, i = {}, 1
            while i <= #strategy.args do
              local arg = strategy.args[i]
              if arg == "--ginkgo.output-dir" then
                i = i + 2
              elseif arg == "--ginkgo.json-report" then
                table.insert(rewritten, arg)
                table.insert(rewritten, context.report_output_path)
                i = i + 2
              else
                table.insert(rewritten, arg)
                i = i + 1
              end
            end
            strategy.args = rewritten
            return strategy
          end

          local go = require("neotest-go")
          -- `dap = {}` drops upstream's --ginkgo.v default via its public API.
          local ginkgo = require("neotest-ginkgo").setup({ dap = {} })

          -- Ginkgo vs plain Go is a property of the module, not of the file:
          -- both adapters claim every *_test.go and Neotest takes the first
          -- match. Decide once per go.mod and let Neotest route by project root.
          local configured = {}
          local function configure_project(path)
            if path == "" then
              return
            end
            local root = vim.fs.root(path, "go.mod")
            if not root or configured[root] then
              return
            end
            configured[root] = true
            local uses_ginkgo = false
            local fh = io.open(vim.fs.joinpath(root, "go.mod"), "r")
            if fh then
              uses_ginkgo = fh:read("*a"):find("github.com/onsi/ginkgo", 1, true) ~= nil
              fh:close()
            end
            neotest.setup_project(root, { adapters = { uses_ginkgo and ginkgo or go } })
          end

          neotest.setup({
            output = {
              open_on_run = true,
            },
            adapters = { go },
          })

          vim.api.nvim_create_autocmd("FileType", {
            pattern = "go",
            callback = function(event)
              configure_project(vim.api.nvim_buf_get_name(event.buf))
            end,
          })
          configure_project(vim.api.nvim_buf_get_name(0))

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
              if event.match == "neotest-summary" then
                vim.wo.wrap = false
              end
            end,
          })
        end
      '';
    };
  };
}
