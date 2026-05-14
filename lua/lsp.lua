local servers = {
  nixd = {
    cmd = { "nixd" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
  },
  marksman = {
    cmd = { "marksman", "server" },
    filetypes = { "markdown", "markdown.mdx" },
    root_markers = { ".marksman.toml", ".git" },
  },
  bashls = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash" },
    root_markers = { ".git" },
  },
  pyright = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", "pyrightconfig.json", ".git" },
  },
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
  },
  gopls = {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.mod", "go.work", ".git" },
  },
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = { checkThirdParty = false },
        telemetry = { enable = false },
      },
    },
  },
  ts_ls = {
    cmd = { "typescript-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
  },
  clangd = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp" },
    root_markers = { ".clangd", "compile_commands.json", "compile_flags.txt", ".git" },
  },
  omnisharp = {
    cmd = { "OmniSharp" },
    filetypes = { "cs" },
    root_markers = { "*.sln", "*.csproj", ".git" },
  },
  cssls = {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    root_markers = { "package.json", ".git" },
  },
  html = {
    cmd = { "vscode-html-language-server", "--stdio" },
    filetypes = { "html", "templ" },
    root_markers = { "package.json", ".git" },
  },
  jsonls = {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git" },
  },
  sqls = {
    cmd = { "sqls" },
    filetypes = { "sql", "mysql" },
    root_markers = { "config.yml", ".git" },
  },
  jdtls = {
    cmd = { "jdtls" },
    filetypes = { "java" },
    root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", ".git" },
  },
  zls = {
    cmd = { "zls" },
    filetypes = { "zig", "zir" },
    root_markers = { "build.zig", ".git" },
  },
  tinymist = {
    cmd = { "tinymist" },
    filetypes = { "typst" },
    root_markers = { ".git" },
  },
  kotlin_lsp = {
    cmd = { vim.env.KOTLIN_LSP_BIN or "kotlin-lsp", "--stdio" },
    filetypes = { "kotlin" },
    root_markers = { ".git" },
  },
}

local caps = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, "blink.cmp")
if ok and blink.get_lsp_capabilities then
  caps = blink.get_lsp_capabilities(caps)
end

for name, cfg in pairs(servers) do
  cfg.capabilities = vim.tbl_deep_extend("force", caps, cfg.capabilities or {})
  vim.lsp.config(name, cfg)
  vim.lsp.enable(name)
end

vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  float = { border = "rounded", source = true },
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }
    local set = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end
    set("n", "gd", vim.lsp.buf.definition,      "Go to definition")
    set("n", "gr", vim.lsp.buf.references,      "Find references")
    set("n", "gi", vim.lsp.buf.implementation,  "Go to implementation")
    set("n", "gy", vim.lsp.buf.type_definition, "Type definition")
    set("n", "K",  vim.lsp.buf.hover,           "Hover documentation")
    set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    set("n", "<leader>cn", vim.lsp.buf.rename,  "Rename symbol")
  end,
})
