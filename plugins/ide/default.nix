{
  imports = [
    # Languages
    ./langs/go.nix
    ./langs/nix.nix
    ./langs/helm.nix
    ./langs/rust.nix
    ./langs/yaml.nix
    ./langs/bash.nix

    # Debugging
    ./debug/dap.nix
    ./debug/dap-ui.nix
    ./debug/keymaps.nix

    # Testing
    ./neotest.nix

    # Diag
    ./diagnostics.nix

    # Navigation / UX
    ./snacks.nix
    ./navic.nix
  ];

  plugins = {
    dressing.enable = true; # better ui-elements
    fidget.enable = true; # LSP progress
  };
}
