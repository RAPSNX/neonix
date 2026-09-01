{
  plugins.trouble = {
    enable = true;
    lazyLoad.settings.cmd = "Trouble";
  };

  diagnostic.settings = {
    update_in_insert = true;
    virtual_text = true;
    signs.text.__raw = ''
      {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = "󰌶 ",
        [vim.diagnostic.severity.INFO] = " ",
      }
    '';
  };

  keymaps = [
    {
      action = "<cmd>lua vim.diagnostic.open_float()<cr>";
      key = "L";
      options = {
        desc = "[Diag] Toggle float";
      };
      mode = [
        "n"
      ];
    }
    {
      action = "<cmd>Trouble diagnostics toggle win.position=right win.size=0.4<cr>";
      key = "<leader>dx";
      options = {
        desc = "Trouble diagnostics whole project";
      };
      mode = [
        "n"
      ];
    }
    {
      action = "<cmd>Trouble diagnostics toggle win.position=right win.size=0.4 filter.buf=0<cr>";
      key = "<leader>dd";
      options = {
        desc = "Trouble diagnostics current buffer";
      };
      mode = [
        "n"
      ];
    }
  ];

  extraConfigLua = ''
    -- toggle virtual_text & relativenumber
    local isLspDiagnosticsVisible = true
    vim.keymap.set("n", "<leader>sd", function()
        isLspDiagnosticsVisible = not isLspDiagnosticsVisible
        vim.diagnostic.config({
            virtual_text = isLspDiagnosticsVisible,
            underline = isLspDiagnosticsVisible
          })
    end, { desc = "Toggle diagnostics" })

    vim.keymap.set("n", "<leader>sn", function()
      vim.wo.relativenumber = not vim.wo.relativenumber
      vim.wo.number = true
    end, { desc = "Toggle relative line numbers" })
  '';
}
