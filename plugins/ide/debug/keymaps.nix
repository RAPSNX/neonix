{
  keymaps = [
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').continue()
          end
        '';
      key = "<leader>dc";
      options = {
        desc = "Continue";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').step_over()
          end
        '';
      key = "<leader>o";
      options = {
        desc = "[Debug] Step Over";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').step_into()
          end
        '';
      key = "<leader>i";
      options = {
        desc = "[Debug] Step Into";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').step_out()
          end
        '';
      key = "<leader>O";
      options = {
        desc = "[Debug] Step Out";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').pause()
          end
        '';
      key = "<leader>dp";
      options = {
        desc = "Pause";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').toggle_breakpoint()
          end
        '';
      key = "<C-b>";
      options = {
        desc = "Toggle Breakpoint";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
          	require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
          end
        '';
      key = "<leader>dB";
      options = {
        desc = "Breakpoint (conditional)";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').repl.toggle()
          end
        '';
      key = "<leader>dR";
      options = {
        desc = "Toggle REPL";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').restart()
          end
        '';
      key = "<leader>dr";
      options = {
        desc = "Restart Debugger";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').run_last()
          end
        '';
      key = "<leader>dl";
      options = {
        desc = "Run Last";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').session()
          end
        '';
      key = "<leader>ds";
      options = {
        desc = "Session";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').terminate()
          end
        '';
      key = "<leader>dt";
      options = {
        desc = "Terminate";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap.ui.widgets').hover()
          end
        '';
      key = "<leader>dw";
      options = {
        desc = "Hover Widget";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dap').run_to_cursor()
          end
        '';
      key = "<leader>dC";
      options = {
        desc = "Run all lines up to cursor";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dapui').eval(nil, { enter = true })
          end
        '';
      key = "<leader>?";
      options = {
        desc = "Evaluate value under cursor";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dapui').toggle()
          end
        '';
      key = "<leader>du";
      options = {
        desc = "Toggle UI";
      };
      mode = [ "n" ];
    }
    {
      action.__raw =
        # lua
        ''
          function()
            require('dapui').eval()
          end
        '';
      key = "<leader>de";
      options = {
        desc = "Eval";
      };
      mode = [ "n" ];
    }
  ];
}
