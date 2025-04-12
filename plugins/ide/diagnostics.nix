{
  plugins.trouble = {
    enable = true;
  };

  diagnostics = {
    update_in_insert = true;
    virtual_text = true;
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
    -- diagnostic signs
    local signs = { Error = "", Warn = "🚧", Hint = "💡", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl= hl, numhl = hl })
    end

    -- toggle virtual_text & relativenumber
    vim.keymap.set("n", "<leader>sd", function()
        isLspDiagnosticsVisible = not isLspDiagnosticsVisible
        vim.diagnostic.config({
            virtual_text = isLspDiagnosticsVisible,
            underline = isLspDiagnosticsVisible
          })
    end)

    vim.keymap.set("n", "<leader>sn", function()
    	if vim.wo.relativenumber then
    		vim.wo.relativenumber = false
    	vim.wo.number = true
    	else
    		vim.wo.relativenumber = true
    		vim.wo.number = false
    	end
    end)
  '';
}
