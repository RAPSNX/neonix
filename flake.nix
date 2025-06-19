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
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixvim,
    pre-commit-hooks,
    ...
  }: let
    inherit (nixpkgs) lib;

    systems = ["x86_64-linux" "aarch64-darwin" "aarch64-linux"];
    pkgsFor = lib.genAttrs systems (system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      });
    forAllSystems = f: lib.genAttrs systems (system: f pkgsFor.${system});
  in {
    formatter = forAllSystems (pkgs: pkgs.alejandra);
    devShells = forAllSystems (pkgs: import ./shell.nix {inherit pkgs pre-commit-hooks;});

    homeManagerModules = {
      default = self.homeManagerModules.neonix;
      neonix = import ./hm-module.nix self;
    };

    packages = forAllSystems (pkgs: {
      default = nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
        inherit pkgs;
        module = {
          imports = [
            ./config
            ./plugins/common
            ./plugins/ide
          ];
        };
        # You can use `extraSpecialArgs` to pass additional arguments to your module files
        extraSpecialArgs = {
          inherit inputs;
        };
      };
      mini = nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
        inherit pkgs;
        module = {
          imports = [
            ./config
            ./plugins/common
          ];
        };
        # You can use `extraSpecialArgs` to pass additional arguments to your module files
        extraSpecialArgs = {
          inherit inputs;
        };
      };
    });
  };
}
