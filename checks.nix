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
            ${self}/tests/gotk-components.yaml \
            ${self}/tests/reconciler.go \
            '+doautocmd BufWritePost' \
            '+lua local go = require("neotest-go"); local ginkgo = require("neotest-ginkgo"); assert(go.is_test_file("${plainTest}")); assert(not ginkgo.is_test_file("${plainTest}")); assert(ginkgo.is_test_file("${ginkgoTest}")); assert(not go.is_test_file("${ginkgoTest}")); assert(go.is_test_file("${mentionTest}")); assert(not ginkgo.is_test_file("${mentionTest}"))' \
            '+lua assert(pcall(require, "diffview")); assert(pcall(require, "gitsigns"))' \
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
