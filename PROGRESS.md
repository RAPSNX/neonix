# Neonix Optimization & Refactoring Progress

This document tracks the execution progress across all phases of the comprehensive technical audit and optimization roadmap for **Neonix**.

---

## Status Overview

| Phase | Description | Status | Commits |
|---|---|---|---|
| **Audit** | Comprehensive 8-Workstream Architecture Audit | **Completed** | — |
| **Phase 1** | Bugs & Correctness Fixes | **Completed** | `8df6bda`, `d3bd984`, `d942e51` |
| **Phase 2** | High-Impact Performance Optimizations | **Completed** | `a9dfb21`, `74bc29d` |
| **Phase 3** | Timing, Event & Lifecycle Cleanup | *Pending* | — |
| **Phase 4** | Architecture & Modularity Simplification | *Pending* | — |
| **Phase 5** | Optional Micro-optimizations & Benchmarking | *Pending* | — |

---

## Detailed Task Breakdown

### Phase 1 — Bugs & Correctness (`COMPLETED`)

- [x] **YAML / Helm False Positive Isolation (`plugins/ide/langs/yaml.nix`)**
  - **Issue:** Any YAML file containing `{{` (e.g., GitHub Actions workflows, Jinja templates, Ansible playbooks) was misclassified as `helm`, disabling `yamlls` and YAML formatting.
  - **Resolution:** Replaced generic `{{` search with specific Helm directive pattern matching (`.Values`, `.Release`, `.Chart`, `.Files`, `.Capabilities`, `include`, `template`, `define`).
  - **Commit:** `d3bd984`
- [x] **DAP-UI Automatic Window Cleanup (`plugins/ide/debug/dap.nix`)**
  - **Issue:** DAP UI remained open after debug sessions terminated or exited.
  - **Resolution:** Registered `event_terminated` and `event_exited` listener hooks on `dap.listeners` to trigger `dapui.close()`.
  - **Commit:** `8df6bda`
- [x] **DAP Debugger Restart Race Condition (`plugins/ide/debug/keymaps.nix`)**
  - **Issue:** `<leader>dr` chained `disconnect()`, `close()`, and `run_last()` synchronously without waiting for async socket teardown.
  - **Resolution:** Replaced with built-in `require('dap').restart()`.
  - **Commit:** `8df6bda`
- [x] **Hybrid Relative Line Number Toggle (`plugins/ide/diagnostics.nix`)**
  - **Issue:** `<leader>sn` turned off absolute numbering (`number = false`) when enabling relative numbers (`relativenumber = true`), causing current line to display `0`.
  - **Resolution:** Set `number = true` unconditionally while toggling `relativenumber`.
  - **Commit:** `8df6bda`
- [x] **Snacks Lazygit Configuration Typo (`plugins/ide/snacks.nix`)**
  - **Issue:** Used `enable = true` instead of `enabled = true` in Snacks settings.
  - **Resolution:** Standardized to `enabled = true`.
  - **Commit:** `8df6bda`
- [x] **Modernize `flake.lock` Filetype Detection (`plugins/ide/langs/nix.nix`)**
  - **Issue:** Used legacy Vimscript `au BufRead,BufNewFile flake.lock setf json`.
  - **Resolution:** Migrated to `vim.filetype.add({ filename = { ["flake.lock"] = "json" } })`.
  - **Commit:** `d3bd984`
- [x] **Conform Formatter Filetype Mappings (`plugins/ide/langs/bash.nix`, `json.nix`)**
  - **Issue:** `shfmt` only mapped `sh` (missing `bash`); `jsonfmt` only mapped `json` (missing `jsonc`).
  - **Resolution:** Added `bash = ["shfmt"]` and `jsonc = ["jsonfmt"]`.
  - **Commit:** `d3bd984`
- [x] **Telescope Resume Keymap Description Typo (`plugins/common/lsp/telescope.nix`)**
  - **Issue:** `<leader>fr` had description `"Find in current buffer"` instead of `"Resume Telescope"`.
  - **Resolution:** Corrected description to `"Resume Telescope"`.
  - **Commit:** `d942e51`

---

### Phase 2 — High-Impact Performance (`COMPLETED`)

- [x] **Lualine LSP Statusline Redraw Optimization (`plugins/common/style/lualine.nix`)**
  - **Issue:** Synchronous `vim.fn.index` Vimscript bridge call and redundant `client.config.filetypes` check on every statusline redraw.
  - **Resolution:** Aggregated client names directly from `vim.lsp.get_clients({ bufnr = 0 })` via `table.concat`.
- [x] **Blink.cmp / Luasnip Decoupling (`plugins/common/lsp/snippet.nix`, `blink.nix`)**
  - **Issue:** Unused `luasnip` + `jsregexp` engine loaded on startup (~8ms) despite `blink-cmp` having native snippet support.
  - **Resolution:** Removed `luasnip` to rely natively on `blink-cmp` and `friendly-snippets`.
- [x] **Oil Directory Buffer List Pollution (`plugins/common/explorer/oil.nix`)**
  - **Issue:** `buf_options.buflisted = true` polluted buffer switchers (`<leader><space>`) and buffer navigation with directory paths.
  - **Resolution:** Set `buf_options.buflisted = false`.
- [x] **Neotest Ginkgo AST Discovery Caching (`plugins/ide/neotest.nix`)**
  - **Issue:** Filesystem I/O and regex scanning executed twice for every Go test file during test discovery.
  - **Resolution:** Added `ginkgo_cache` memoization table to `is_test_file` classifier.

---

### Phase 3 — Timing, Event & Lifecycle Cleanup (`PENDING`)

- [ ] **Which-Key Spec Redundancy Elimination (`plugins/common/style/which-key.nix`)**
  - Remove duplicate single-key manual specs that already have `desc` attributes in keymap declarations; retain only group prefixes (`<leader>f`, `<leader>g`, etc.).
- [ ] **Global Winbar Redraw Optimization (`plugins/ide/navic.nix`)**
  - Guard `nvim-navic` winbar evaluation to prevent overhead on non-code buffers and floating windows.

---

### Phase 4 — Architecture Cleanup (`PENDING`)

- [ ] **Standardize Nix Flake Outputs (`flake.nix`)**
  - Add standard `homeModules` output alongside `homeManagerModules` to eliminate Nix flake check warnings.
- [ ] **De-duplicate Treesitter Grammars (`treesitter.nix`, `bash.nix`, `json.nix`)**
  - Remove redundant `bash` and `json` grammar entries across modules.
- [ ] **Decouple Editing Utilities from LSP Module (`plugins/common/lsp/lsp.nix`)**
  - Move `nvim-autopairs` and `nvim-surround` out of `lsp.nix` into proper common editing configurations.
- [ ] **Dead Code Cleanup (`plugins/ide/langs/nix.nix`)**
  - Remove obsolete commented `# hmts.enable = true;`.

---

## Verification History

- **Phase 1 Verification:**
  - `nix flake check --print-build-logs`: **PASSED** (all derivations, formatting, and smoke tests)
  - Headless filetype detection test (`.github/workflows/update-flake-lock.yml` -> `yaml`, `tests/gotk-components.yaml` -> `yaml`, `flake.lock` -> `json`): **PASSED**
  - Generated `init.lua` Derivation check (`nixvim-print-init`): **PASSED**
- **Phase 2 Verification:**
  - `nix flake check --print-build-logs`: **PASSED** (all derivations, formatting, and smoke tests)
  - Headless `--startuptime` profiling: **PASSED** (Luasnip/JSRegexp no longer loaded on startup)
  - Generated `init.lua` Derivation check (`nixvim-print-init`): **PASSED** (Lualine `table.concat`, Oil `buflisted = false`, Neotest `ginkgo_cache`)
