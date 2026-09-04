{
  viAlias = true;
  vimAlias = true;
  luaLoader.enable = true;

  globals = {
    mapleader = " ";
    maplocalleader = ",";
  };

  # custom command config
  userCommands = {
    # macos workaround for strange behavior
    W = {
      command = "w";
    };
    Q = {
      command = "q";
    };
  };

  opts = {
    sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal";
    completeopt = "menuone,noinsert,noselect";

    spelllang = "en";

    switchbuf = "useopen,uselast";
    termguicolors = true;
    scrolloff = 8;
    swapfile = false;

    # search
    ignorecase = true; # ignores case in search
    smartcase = true;
    tabstop = 4;
    softtabstop = 4;
    shiftwidth = 4;
    expandtab = true;

    list = true;
    listchars = "tab:  ,trail:λ";

    cursorline = true;
    number = true;
    relativenumber = false;
    numberwidth = 3;
    ruler = false;
    showmode = false;

    splitbelow = true;
    splitright = true;
    undofile = true;
    undolevels = 10000;

    signcolumn = "yes";
    cmdheight = 0;
    colorcolumn = "120";

    foldenable = true;
    foldmethod = "expr";
    foldexpr = "v:lua.vim.treesitter.foldexpr()";
    foldlevel = 99;
    foldlevelstart = 99;
    foldtext = "";

    winwidth = 10;
    winminwidth = 10;
    equalalways = false;
  };
}
