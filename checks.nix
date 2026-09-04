{
  pkgs ? import <nixpkgs> { },
  self,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  nvim = self.packages.${system}.default;
  miniNvim = self.packages.${system}.mini;
in
{
  smoke-test = pkgs.runCommand "smoke-test" { } ''
    set -euo pipefail

    output=$(
      HOME=$(realpath .) ${nvim}/bin/nvim -mn --headless \
        ${self}/flake.nix \
        ${self}/tests/flake.nix \
        ${self}/tests/gotk-components.yaml \
        ${self}/tests/reconciler.go \
        '+luafile ${self}/tests/smoke.lua' \
        '+qall!' \
        2>&1 >/dev/null
    )

    [[ -z "$output" ]] || {
      echo "ERROR: $output"
      exit 1
    }

    mini_output=$(
      HOME=$(realpath .) ${miniNvim}/bin/nvim -mn --headless \
        '+lua assert(_G.MiniFiles); assert(_G.MiniIcons); assert(_G.MiniStarter); assert(not pcall(require, "snacks")); local devicons = require("nvim-web-devicons"); assert(type(devicons.get_icon("init.lua", "lua")) == "string")' \
        '+qall!' \
        2>&1 >/dev/null
    )

    [[ -z "$mini_output" ]] || {
      echo "ERROR (mini): $mini_output"
      exit 1
    }

    touch "$out"
  '';
}
