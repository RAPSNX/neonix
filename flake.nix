{
  description = "RAPSN NeoNix IDE";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    neotest-ginkgo = {
      url = "github:nvim-contrib/neotest-ginkgo";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixvim,
      pre-commit-hooks,
      ...
    }:
    let
      inherit (nixpkgs) lib;

      systems = [
        "x86_64-linux"
        "aarch64-darwin"
        "aarch64-linux"
      ];

      pkgsFor = lib.genAttrs systems (
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );

      forAllSystems = f: lib.genAttrs systems (system: f pkgsFor.${system});
    in
    {
      formatter = forAllSystems (pkgs: pkgs.nixfmt);

      checks = forAllSystems (pkgs: import ./checks.nix { inherit pkgs self; });

      devShells = forAllSystems (pkgs: import ./devshell.nix { inherit pkgs pre-commit-hooks; });

      homeModules = {
        default = self.homeModules.neonix;
        neonix = import ./hm-module.nix self;
      };

      homeManagerModules = self.homeModules;

      packages = forAllSystems (pkgs: {
        default = nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
          inherit pkgs;
          module = {
            imports = [
              (inputs.import-tree ./config)
              (inputs.import-tree ./plugins)
            ];
          };
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            inherit inputs;
          };
        };
        mini = nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
          inherit pkgs;
          module = {
            imports = [
              (inputs.import-tree ./config)
              ./plugins/common/editing.nix
              ./plugins/common/explorer/mini.nix
              ./plugins/common/explorer/oil.nix
              ./plugins/common/lsp/better-escape.nix
              ./plugins/common/lsp/treesitter.nix
              ./plugins/common/style/lualine.nix
              ./plugins/common/style/which-key.nix
            ];
            colorschemes.catppuccin = {
              enable = true;
              settings = {
                flavour = "mocha";
                integrations = {
                  mini.enabled = true;
                  treesitter = true;
                  which_key = true;
                };
              };
            };
            plugins = {
              web-devicons.enable = true;
            };
          };
          # You can use `extraSpecialArgs` to pass additional arguments to your module files
          extraSpecialArgs = {
            inherit inputs;
          };
        };
      });
    };
}
