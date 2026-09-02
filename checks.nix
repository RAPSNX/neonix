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

        output=$(
          HOME=$(realpath .) nvim -mn --headless \
            ${self}/flake.nix \
            ${self}/tests/flake.nix \
            ${self}/tests/gotk-components.yaml \
            ${self}/tests/reconciler.go \
            '+lua assert(not package.loaded["neotest"]); local buf = vim.api.nvim_create_buf(true, false); vim.api.nvim_set_current_buf(buf); vim.bo[buf].filetype = "dap-float"; assert(not vim.bo[buf].buflisted); local map = vim.fn.maparg("q", "n", false, true); assert(map.buffer == 1 and map.desc == "Close window"); vim.api.nvim_buf_delete(buf, { force = true })' \
            '+lua assert(not package.loaded["diffview"]); assert(not package.loaded["trouble"]); assert(not package.loaded["spectre"]); assert(not package.loaded["neotest"]); require("lz.n").trigger_load("neotest"); assert(_G.neonix_neotest_active_adapter() == "ginkgo"); _G.neonix_neotest_toggle_adapter(); assert(_G.neonix_neotest_active_adapter() == "go"); _G.neonix_neotest_toggle_adapter(); assert(_G.neonix_neotest_active_adapter() == "ginkgo")' \
            '+lua vim.cmd("DiffviewClose"); vim.cmd("Trouble diagnostics toggle"); vim.cmd("Spectre"); assert(package.loaded["diffview"]); assert(package.loaded["trouble"]); assert(package.loaded["spectre"]); assert(package.loaded["neotest"]); assert(pcall(require, "gitsigns"))' \
            '+lua local config = vim.lsp.config.gopls; assert(type(config.on_attach) == "function"); config.on_attach({}, 0); for _, lhs in ipairs({ " rf", " rs", " rj", " ri", " rq" }) do local map = vim.fn.maparg(lhs, "n", false, true); assert(map.buffer == 1, "missing gopls keymap: " .. lhs) end' \
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
