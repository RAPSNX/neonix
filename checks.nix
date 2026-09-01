{
  pkgs ? import <nixpkgs> { },
  self,
  ...
}:
let
  system = pkgs.stdenv.hostPlatform.system;
  nvim = self.packages.${system}.default;
  fixture = name: text: pkgs.writeText name text;
  plainTest = fixture "plain_test.go" ''
    package neotestfixture

    import "testing"

    func TestPlain(t *testing.T) {}
  '';
  ginkgoTest = fixture "ginkgo_test.go" ''
    package neotestfixture

    import . "github.com/onsi/ginkgo/v2"

    var _ = Describe("fixture", func() {})
  '';
  mentionTest = fixture "mention_test.go" ''
    package neotestfixture

    import "testing"

    // github.com/onsi/ginkgo/v2 is mentioned here, not imported.
    func TestMention(t *testing.T) {}
  '';
  trailingCommentTest = fixture "trailing_comment_test.go" ''
    package neotestfixture

    import ( // stdlib and ginkgo
      "github.com/onsi/ginkgo/v2"
    )

    var _ = ginkgo.Describe("fixture", func() {})
  '';
  subpackageTest = fixture "subpackage_test.go" ''
    package neotestfixture

    import (
      "testing"

      "github.com/onsi/ginkgo/v2/types"
    )

    func TestSubpackage(t *testing.T) {
      _ = types.SpecStatePassed
    }
  '';
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
        cp ${ginkgoTest} .cache/nvim/ginkgo_cache_test.go
        chmod u+w .cache/nvim/ginkgo_cache_test.go

        output=$(
          HOME=$(realpath .) nvim -mn --headless \
            ${self}/flake.nix \
            ${self}/tests/flake.nix \
            ${self}/tests/gotk-components.yaml \
            ${self}/tests/reconciler.go \
            '+doautocmd BufWritePost' \
            '+lua assert(not package.loaded["diffview"]); assert(not package.loaded["trouble"]); assert(not package.loaded["spectre"]); assert(not package.loaded["neotest"]); require("lz.n").trigger_load("neotest"); local go = require("neotest-go"); local ginkgo = require("neotest-ginkgo"); assert(go.is_test_file("${plainTest}")); assert(not ginkgo.is_test_file("${plainTest}")); assert(ginkgo.is_test_file("${ginkgoTest}")); assert(not go.is_test_file("${ginkgoTest}")); assert(go.is_test_file("${mentionTest}")); assert(not ginkgo.is_test_file("${mentionTest}")); assert(ginkgo.is_test_file("${trailingCommentTest}")); assert(not go.is_test_file("${trailingCommentTest}")); assert(go.is_test_file("${subpackageTest}")); assert(not ginkgo.is_test_file("${subpackageTest}")); local cache_test = vim.fn.stdpath("cache") .. "/ginkgo_cache_test.go"; assert(ginkgo.is_test_file(cache_test)); vim.fn.writefile({ "package neotestfixture", "", "import \"testing\"" }, cache_test); vim.cmd("doautocmd BufWritePost " .. vim.fn.fnameescape(cache_test)); assert(not ginkgo.is_test_file(cache_test))' \
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
