{ config, ... }:
{
  plugins = {
    treesitter = {
      enable = true;
      nixvimInjections = true;
      settings = {
        highlight = {
          enable = true;
        };
        indent = {
          enable = true;
        };
        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<C-space>";
            node_incremental = "<C-space>";
            node_decremental = "<bs>";
          };
        };
      };

      grammarPackages = with config.plugins.treesitter.package.builtGrammars; [
        c
        css
        bash
        fish
        diff

        vim
        vimdoc
        vhs

        json
        toml
      ];
    };
    treesitter-textobjects = {
      enable = true;
      settings = {
        select = {
          enable = true;
          keymaps = {
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "ai" = "@conditional.outer";
            "ii" = "@conditional.inner";
            "al" = "@loop.outer";
            "il" = "@loop.inner";
            "ak" = "@block.outer";
            "ik" = "@block.inner";
            "is" = "@statement.inner";
            "as" = "@statement.outer";
            "ad" = "@comment.outer";
            "am" = "@call.outer";
            "im" = "@call.inner";
          };
        };
        move = {
          enable = true;
          set_jumps = true;
          goto_next_start = {
            "]m" = "@function.outer";
            "]]" = "@class.outer";
          };
          goto_next_end = {
            "]M" = "@function.outer";
            "][" = "@class.outer";
          };
          goto_previous_start = {
            "[m" = "@function.outer";
            "[[" = "@class.outer";
          };
          goto_previous_end = {
            "[M" = "@function.outer";
            "[]" = "@class.outer";
          };
        };

        swap = {
          enable = true;
          swap_next = {
            ")a" = "@parameter.inner";
          };
          swap_previous = {
            ")A" = "@parameter.inner";
          };
        };
      };
    };
  };
}
