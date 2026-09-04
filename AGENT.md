# Neonix

Neonix is a Neovim distribution built with Nix and the Nixvim module system. It is
designed to be performant, efficient, and versatile.

- `config/` contains global Neovim options, keymaps, and autocmds.
- `plugins/` contains modular plugin configuration; keep plugin changes scoped to the relevant module.
- `tests/` contains fixtures used by the smoke test.

The default package imports the full global config and plugin tree. Use the `mini`
package (`nix run .#mini`) for a fast, lightweight setup on servers or ad-hoc systems.

## Development

```sh
nix develop
nix run .
nix run .#mini
nix flake check --print-build-logs
```

Keep changes focused and idiomatic Nix. Consider adding or extending smoke-test
coverage for changed behavior.
