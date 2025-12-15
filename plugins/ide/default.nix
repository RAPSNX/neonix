{
  imports = [
    # Languages
    ./langs/nix.nix
    ./langs/go.nix
    ./langs/rust.nix
    ./langs/bash.nix

    ./langs/helm.nix
    ./langs/yaml.nix
    ./langs/json.nix

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
    ./spectre.nix
  ];

  plugins = {
    dressing.enable = true; # better ui-elements
    fidget.enable = true; # LSP progress
  };
}
