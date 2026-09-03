local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h")

local function edit(path)
  vim.cmd.edit(vim.fs.joinpath(root, path))
end

local function assert_module_missing(name)
  local ok = pcall(require, name)
  assert(not ok, name .. " should not be installed")
end

local function assert_map(lhs, needle)
  local map = vim.fn.maparg(lhs, "n", false, true)
  assert(map and map.rhs and map.rhs:find(needle, 1, true), "unexpected mapping for " .. lhs)
end

-- Removed plugins must not remain in the runtime path or Lua module graph.
for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
  for _, removed in ipairs({
    "LuaSnip",
    "headlines.nvim",
    "indent-o-matic",
    "nvim-colorizer",
    "nvim-navic",
    "nvim-spectre",
    "nvim-web-devicons",
    "telescope-fzf-native",
    "telescope-media-files",
    "telescope.nvim",
    "vim-helm",
    "vim-illuminate",
    "vim-nix",
    "dressing.nvim",
  }) do
    assert(not path:find(removed, 1, true), removed .. " remains in runtime path: " .. path)
  end
end
for _, module in ipairs({
  "colorizer",
  "dressing",
  "headlines",
  "illuminate",
  "luasnip",
  "nvim-navic",
  "spectre",
  "telescope",
}) do
  assert_module_missing(module)
end

-- Blink uses Neovim's native snippet engine while retaining friendly-snippets.
local blink_config = require("blink.cmp.config")
assert(blink_config.snippets.preset == "default")
local friendly_snippets = false
for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
  friendly_snippets = friendly_snippets or path:find("friendly-snippets", 1, true) ~= nil
end
assert(friendly_snippets, "friendly-snippets is not available to Blink")
local snippet_buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_set_current_buf(snippet_buf)
vim.snippet.expand("${1:hello} ${2:world}")
assert(vim.snippet.active({ direction = 1 }))
vim.snippet.jump(1)
assert(vim.snippet.active({ direction = -1 }))
vim.api.nvim_buf_delete(snippet_buf, { force = true })

-- Snacks replaces Telescope, Dressing, Illuminate, and media previews.
assert(type(Snacks.picker.files) == "function")
assert(Snacks.config.get("picker").enabled)
assert(Snacks.config.get("picker").ui_select)
assert(Snacks.config.get("picker").sources.files.hidden)
assert(Snacks.config.get("picker").sources.files.follow)
assert(Snacks.config.get("picker").sources.grep.follow)
assert(Snacks.config.get("input").enabled)
assert(Snacks.config.get("words").enabled)
assert(Snacks.config.get("image").enabled)
assert(vim.fn.executable("magick") == 1)
for lhs, picker in pairs({
  ["<leader>ff"] = "Snacks.picker.files",
  ["<leader>fz"] = "Snacks.picker.lines",
  ["<leader>fr"] = "Snacks.picker.resume",
  ["<leader>f?"] = "Snacks.picker.recent",
  ["<leader>fg"] = "Snacks.picker.grep",
  ["<leader>fw"] = "Snacks.picker.grep_word",
  ["<leader><space>"] = "Snacks.picker.buffers",
  ["<leader>fc"] = "Snacks.picker.command_history",
}) do
  assert_map(lhs, picker)
end

-- mini.icons provides the compatibility API expected by remaining plugins.
assert(_G.MiniIcons and type(MiniIcons.get) == "function")
local devicons = require("nvim-web-devicons")
local icon = devicons.get_icon("init.lua", "lua")
assert(type(icon) == "string" and icon ~= "")

-- Color highlighting creates an extmark for a CSS color literal.
local colors = require("nvim-highlight-colors")
local color_buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_set_current_buf(color_buf)
vim.api.nvim_buf_set_lines(color_buf, 0, -1, false, { ".smoke { color: #89b4fa; }" })
colors.turnOn()
local color_ns = vim.api.nvim_get_namespaces()["nvim-highlight-colors"]
assert(color_ns and #vim.api.nvim_buf_get_extmarks(color_buf, color_ns, 0, -1, {}) > 0)
vim.api.nvim_buf_delete(color_buf, { force = true })

-- Markdown rendering and Dropbar breadcrumbs are configured and active.
edit("tests/markdown.md")
assert(vim.bo.filetype == "markdown")
assert(pcall(require, "render-markdown"))
assert(vim.fn.exists(":RenderMarkdown") == 2)
assert(pcall(require, "dropbar.api"))
assert(vim.o.winbar:find("dropbar", 1, true))
assert_map("<leader>;", "dropbar.api")

-- Guess Indent is the fallback, while native EditorConfig has precedence.
edit("tests/indent.lua")
assert(vim.bo.expandtab and vim.bo.shiftwidth == 2, "Guess Indent did not detect two spaces")
edit("tests/editorconfig/sample.lua")
assert(vim.bo.expandtab and vim.bo.shiftwidth == 3, "EditorConfig did not override Guess Indent")

-- Treesitter and LSP retain Nix and Helm support without legacy Vim plugins.
edit("flake.nix")
assert(vim.bo.filetype == "nix")
assert(pcall(vim.treesitter.language.add, "nix"))
assert(vim.lsp.config.nixd)
edit("tests/chart/templates/deployment.yaml")
assert(vim.bo.filetype == "helm")
assert(pcall(vim.treesitter.language.add, "helm"))
assert(vim.lsp.config.helm_ls)

-- Grug-far preserves the lazy-loaded search/replace entrypoint.
assert(not package.loaded["grug-far"])
assert(vim.fn.exists(":GrugFar") == 2)
local grug_map = vim.fn.maparg("<leader>S", "n", false, true)
assert(grug_map.desc == "Search & Replace")
vim.cmd.GrugFar()
assert(package.loaded["grug-far"])
vim.wait(100)

-- Existing lazy-loading and behavior checks remain covered.
assert(not package.loaded["neotest"])
local dap_buf = vim.api.nvim_create_buf(true, false)
vim.api.nvim_set_current_buf(dap_buf)
vim.bo[dap_buf].filetype = "dap-float"
assert(not vim.bo[dap_buf].buflisted)
local close_map = vim.fn.maparg("q", "n", false, true)
assert(close_map.buffer == 1 and close_map.desc == "Close window")
vim.api.nvim_buf_delete(dap_buf, { force = true })

assert(not package.loaded["diffview"])
assert(not package.loaded["trouble"])
require("lz.n").trigger_load("neotest")
assert(_G.neonix_neotest_active_adapter() == "ginkgo")
_G.neonix_neotest_toggle_adapter()
assert(_G.neonix_neotest_active_adapter() == "go")
_G.neonix_neotest_toggle_adapter()
assert(_G.neonix_neotest_active_adapter() == "ginkgo")
vim.cmd("DiffviewClose")
vim.cmd("Trouble diagnostics toggle")
assert(package.loaded["diffview"])
assert(package.loaded["trouble"])
assert(package.loaded["neotest"])
assert(pcall(require, "gitsigns"))

local gopls = vim.lsp.config.gopls
assert(type(gopls.on_attach) == "function")
gopls.on_attach({}, 0)
for _, lhs in ipairs({ " rf", " rs", " rj", " ri", " rq" }) do
  local map = vim.fn.maparg(lhs, "n", false, true)
  assert(map.buffer == 1, "missing gopls keymap: " .. lhs)
end
