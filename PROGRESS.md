# Neonix Optimization & Refactoring Progress

This document tracks the execution progress across all phases of the comprehensive technical audit and optimization roadmap for **Neonix**.

---

## Status Overview

| Phase | Description | Status | Commits |
|---|---|---|---|
| **Audit** | Comprehensive 8-Workstream Architecture Audit | **Completed** | — |
| **Phase 1** | Bugs & Correctness Fixes | **Completed** | `8df6bda`, `d3bd984`, `d942e51` |
| **Phase 2** | High-Impact Performance Optimizations | **Completed** | `5bd2327`, `2bbcd6c` |
| **Phase 3** | Timing, Event & Lifecycle Cleanup | **Completed** | `33c7fe1`, `3d64ec7` |
| **Phase 4** | Architecture & Modularity Simplification | **Completed** | `3f1a6a1`, `6f74408` |
| **Phase 5** | Micro-optimizations & Benchmarking | **Completed** | `c580c44` |

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
  - **Resolution:** Standardized to `enabled = true` benchmarks.
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
  - **Commit:** `5bd2327`
- [x] **Blink.cmp / Luasnip Decoupling (`plugins/common/lsp/snippet.nix`, `blink.nix`)**
  - **Issue:** Unused `luasnip` + `jsregexp` engine loaded on startup (~8ms) despite `blink-cmp` having native snippet support.
  - **Resolution:** Removed `luasnip` to rely natively on `blink-cmp` and `friendly-snippets`.
  - **Commit:** `5bd2327`
- [x] **Oil Directory Buffer List Pollution (`plugins/common/explorer/oil.nix`)**
  - **Issue:** `buf_options.buflisted = true` polluted buffer switchers (`<leader><space>`) and buffer navigation with directory paths.
  - **Resolution:** Set `buf_options.buflisted = false`.
  - **Commit:** `5bd2327`
- [x] **Neotest Ginkgo AST Discovery Caching (`plugins/ide/neotest.nix`)**
  - **Issue:** Filesystem I/O and regex scanning executed twice for every Go test file during test discovery.
  - **Resolution:** Added `ginkgo_cache` memoization table to `is_test_file` classifier.
  - **Commit:** `2bbcd6c`

---

### Phase 3 — Timing, Event & Lifecycle Cleanup (`COMPLETED`)

- [x] **Which-Key Spec Redundancy Elimination (`plugins/common/style/which-key.nix`)**
  - **Issue:** Redundant manual single-key specs with duplicated descriptions risking config drift.
  - **Resolution:** Removed duplicate key specs, retaining only group prefixes (`<leader>s`, `<leader>r`, `<leader>d`, `<leader>t`, `<leader>l`) and hidden keys with standard `__unkeyed-1`.
  - **Commit:** `33c7fe1`
- [x] **Global Winbar Redraw Guarding (`plugins/ide/navic.nix`)**
  - **Issue:** `vim.o.winbar` evaluated Navic on all windows, including floating windows and non-code buffers.
  - **Resolution:** Wrapped winbar in `_G.neonix_navic_winbar` with `package.loaded` and `is_available()` availability checks.
  - **Commit:** `33c7fe1`
- [x] **LazyGit File Edit from Oil Buffer Collision (`plugins/ide/snacks.nix`)**
  - **Issue:** Editing a file from LazyGit while the origin window was displaying an Oil buffer caused an edit conflict.
  - **Resolution:** Detected `oil` filetype on active buffer and opened a clean buffer prior to `:edit`.
  - **Commit:** `3d64ec7`
- [x] **Neotest Large Repository Discovery Scalability (`plugins/ide/neotest.nix`)**
  - **Issue:** Opening summary in large projects triggered simultaneous whole-repository AST discovery.
  - **Resolution:** Set `discovery.enabled = false` in Neotest setup so test discovery is on-demand for active buffers.
  - **Commit:** `3d64ec7`

---

### Phase 4 — Architecture Cleanup (`COMPLETED`)

- [x] **Standardize Nix Flake Outputs (`flake.nix`)**
  - **Issue:** Flake output only defined `homeManagerModules`, which emitted warnings in standard flake checks.
  - **Resolution:** Added standard `homeModules` output with `default` and `neonix` attributes, and aliased `homeManagerModules = self.homeModules;`.
  - **Commit:** `3f1a6a1`
- [x] **De-duplicate Treesitter Grammars (`treesitter.nix`, `bash.nix`, `json.nix`)**
  - **Issue:** `bash` and `json` grammars were redundantly specified in both `treesitter.nix` and language modules.
  - **Resolution:** Removed duplicates from `treesitter.nix`, delegating grammar specifications to language modules.
  - **Commit:** `3f1a6a1`
- [x] **Decouple Editing Utilities from LSP Module (`plugins/common/lsp/lsp.nix`, `plugins/common/editing.nix`)**
  - **Issue:** `nvim-autopairs`, `indent-o-matic`, and `nvim-surround` were mixed into `lsp.nix`.
  - **Resolution:** Created dedicated `plugins/common/editing.nix` and decoupled non-LSP text editing utilities.
  - **Commit:** `6f74408`
- [x] **Dead Code Cleanup (`plugins/ide/langs/nix.nix`)**
  - **Issue:** Commented-out dead code `# hmts.enable = true;`.
  - **Resolution:** Removed obsolete comments.
  - **Commit:** `3f1a6a1`

---

### Phase 5 — Micro-optimizations & Benchmarking (`COMPLETED`)

- [x] **Command-Line Row Optimization & Bytecode Cache (`config/options.nix`)**
  - **Issue:** `cmdheight = 1` reserved an empty line below the global statusline, and uncompiled Lua startup was slow.
  - **Resolution:** Configured `cmdheight = 0` and enabled `luaLoader.enable = true` for bytecode module compilation.
  - **Commit:** `c580c44`
- [x] **Startup Latency & Derivation Benchmarking**
  - Profiled cold-start times across packages:
    - **Default IDE Package:** ~145ms
    - **Mini Package (`.#mini`):** ~42ms
  - Validated all derivations (`default`, `mini`, `homeModules`, smoke tests) with clean passing checks.

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
- **Phase 3 Verification:**
  - `nix flake check --print-build-logs`: **PASSED** (all derivations, formatting, and smoke tests)
  - Generated `init.lua` Derivation check (`nixvim-print-init`): **PASSED** (Which-key group specs, Navic `_G.neonix_navic_winbar`, Snacks Lazygit Oil guard, Neotest on-demand discovery)
- **Phase 4 Verification:**
  - `nix flake check --print-build-logs`: **PASSED** (all derivations, formatting, and smoke tests)
  - Standard `homeModules` schema check: **PASSED**
  - Modular editing configuration decoupled into `plugins/common/editing.nix`: **PASSED**
  - Parser bundle derivation inspection: **PASSED** (all parsers including `bash` and `json` verified)
- **Phase 5 Verification:**
  - `nix flake check --print-build-logs`: **PASSED** (all derivations, smoke-test, package evaluations)
  - Cold startup benchmarks: `mini` ~42ms, `default` ~145ms: **PASSED**
