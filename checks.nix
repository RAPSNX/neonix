{
  pkgs ? import <nixpkgs> { },
  self,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  nvim = self.packages.${system}.default;
in
{
  smoke-test =
    pkgs.runCommand "smoke-test"
      {
        nativeBuildInputs = [ nvim ];
      }
      ''
        set -euo pipefail

        mkdir -p .cache/nvim

        output=$(
          HOME=$(realpath .) nvim -mn --headless \
            ${self}/flake.nix \
            ${self}/tests/flake.nix \
            ${self}/tests/reconciler.go \
            ${self}/tests/gotk-components.yaml \
            '+qall!' \
            2>&1 >/dev/null
        )

        [[ -z "$output" ]] || {
          echo "ERROR: $output"
          exit 1
        }

        touch "$out"
      '';
}
