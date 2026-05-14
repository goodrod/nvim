local function safe(name, fn)
  local ok, mod = pcall(require, name)
  if ok then fn(mod) end
end

-- Theme
safe("catppuccin", function(c)
  c.setup({ flavour = "mocha" })
  vim.cmd.colorscheme("catppuccin")
end)

safe("nvim-web-devicons", function(m) m.setup() end)

-- Treesitter
safe("nvim-treesitter.configs", function(m)
  m.setup({
    highlight = { enable = true },
    indent = { enable = true },
  })
end)

-- Statusline / tabline / dashboard
safe("lualine", function(m)
  m.setup({
    options = {
      theme = "auto",
      globalstatus = true,
      icons_enabled = true,
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = {
        { "filetype", icon_only = true, padding = { left = 1, right = 0 } },
        "filename",
      },
      lualine_c = { "diff" },
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients({ bufnr = 0 })
            if vim.tbl_isempty(clients) then return "No Active LSP" end
            local names = {}
            for _, c in ipairs(clients) do table.insert(names, c.name) end
            return table.concat(names, ", ")
          end,
          icon = " ",
        },
        "diagnostics",
      },
      lualine_y = { "searchcount", { "branch", icon = "" } },
      lualine_z = {
        "progress",
        "location",
        { function() return os.date("%H:%M") end },
      },
    },
    inactive_sections = {
      lualine_a = {}, lualine_b = {}, lualine_c = { "filename" },
      lualine_x = { "location" }, lualine_y = {}, lualine_z = {},
    },
  })
end)
safe("bufferline", function(m)
  m.setup({
    options = {
      mode = "buffers",
      separator_style = "thin",
      show_buffer_icons = true,
      diagnostics = "nvim_lsp",
      offsets = {
        { filetype = "neo-tree", text = "Explorer", separator = true },
      },
      hover = { enabled = true, delay = 200, reveal = { "close" } },
      numbers = function(opts)
        return string.format("%s·%s", opts.raise(opts.id), opts.lower(opts.ordinal))
      end,
    },
  })
end)
safe("alpha", function(m)
  local dashboard = require("alpha.themes.dashboard")
  dashboard.section.buttons.val = {
    dashboard.button("e", "  New file", "<Cmd>ene<CR>"),
    dashboard.button("SPC f f", "  Find file", "<Cmd>FzfLua files<CR>"),
    dashboard.button("SPC f h", "  Recently opened files", "<Cmd>FzfLua oldfiles<CR>"),
    dashboard.button("SPC f r", "  Frecency/MRU", "<Cmd>Telescope frecency<CR>"),
    dashboard.button("SPC f g", "  Find word", "<Cmd>FzfLua live_grep<CR>"),
    dashboard.button("SPC f m", "  Jump to bookmarks", "<Cmd>FzfLua marks<CR>"),
    dashboard.button("SPC s l", "  Open last session", "<Cmd>lua require('persistence').load({ last = true })<CR>"),
  }
  m.setup(dashboard.config)
end)

-- Notify + noice
safe("notify", function(m)
  m.setup({ background_colour = "#000000" })
  vim.notify = m
end)
safe("noice", function(m)
  m.setup({
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
      lsp_doc_border = true,
    },
  })
end)

-- UI polish
safe("scrollbar", function(m) m.setup() end)
safe("nvim-cursorline", function(m) m.setup() end)
safe("fidget", function(m) m.setup() end)
safe("ibl", function(m) m.setup() end)
safe("colorizer", function(m) m.setup() end)
safe("highlight-undo", function(m) m.setup() end)
safe("fastaction", function(m) m.setup({}) end)

-- Which-key
safe("which-key", function(wk)
  wk.setup({ preset = "modern", win = { border = "rounded" } })
  wk.add({
    { "<leader>b", group = "Buffer" },
    { "<leader>bs", group = "Sort" },
    { "<leader>bm", group = "Move" },
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Debug" },
    { "<leader>dg", group = "Goto" },
    { "<leader>dv", group = "View" },
    { "<leader>f", group = "Find" },
    { "<leader>g", group = "Git" },
    { "<leader>x", group = "Diagnostics" },
  })
end)
safe("cheatsheet", function(m) m.setup() end)

-- Fuzzy
safe("telescope", function(t)
  t.setup()
  pcall(t.load_extension, "frecency")
end)
safe("fzf-lua", function(m) m.setup() end)

-- Session
safe("persistence", function(m) m.setup() end)

-- Explorers
safe("neo-tree", function(m)
  m.setup({
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
      hijack_netrw_behavior = "disabled",
    },
    window = {
      mappings = {
        ["<space>"] = "none",
        ["<Esc>"] = "close_window",
        ["<C-c>"] = "close_window",
        ["<LeftRelease>"] = "open",
      },
    },
  })
end)
safe("oil", function(m)
  m.setup({
    default_file_explorer = true,
    view_options = { show_hidden = true },
  })
end)

-- Git
safe("gitsigns", function(m)
  m.setup({ current_line_blame = false })
end)
safe("diffview", function(m)
  m.setup({
    keymaps = {
      view = {
        q = "<Cmd>DiffviewClose<CR>",
        ["<Esc>"] = "<Cmd>DiffviewClose<CR>",
        ["<C-c>"] = "<Cmd>DiffviewClose<CR>",
      },
      file_panel = {
        q = "<Cmd>DiffviewClose<CR>",
        ["<Esc>"] = "<Cmd>DiffviewClose<CR>",
        ["<C-c>"] = "<Cmd>DiffviewClose<CR>",
      },
      file_history_panel = {
        q = "<Cmd>DiffviewClose<CR>",
        ["<Esc>"] = "<Cmd>DiffviewClose<CR>",
        ["<C-c>"] = "<Cmd>DiffviewClose<CR>",
      },
    },
  })
end)

-- LSP-adjacent UI
safe("trouble", function(m) m.setup() end)
safe("nvim-lightbulb", function(m)
  m.setup({ autocmd = { enabled = true } })
end)
safe("docs-view", function(m) m.setup({}) end)

-- Completion + snippets
safe("luasnip.loaders.from_vscode", function(m) m.lazy_load() end)
safe("blink.cmp", function(m)
  m.setup({
    keymap = { preset = "default" },
    cmdline = {
      keymap = {
        preset = "cmdline",
        ["<C-y>"] = { "select_and_accept" },
      },
    },
    snippets = { preset = "luasnip" },
  })
end)

-- Formatter
safe("conform", function(m)
  m.setup({
    formatters_by_ft = {
      nix = { "nixfmt" },
      lua = { "stylua" },
      python = { "black" },
      sh = { "shfmt" }, bash = { "shfmt" },
      rust = { "rustfmt" },
      go = { "gofmt" },
      javascript = { "prettier" }, typescript = { "prettier" },
      javascriptreact = { "prettier" }, typescriptreact = { "prettier" },
      json = { "prettier" }, jsonc = { "prettier" },
      css = { "prettier" }, scss = { "prettier" },
      html = { "prettier" }, markdown = { "prettier" },
      c = { "clang-format" }, cpp = { "clang-format" },
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function(bufnr)
      if not vim.g.formatsave or vim.b[bufnr].disableFormatSave then return end
      return { lsp_format = "fallback", timeout_ms = 500 }
    end,
  })
end)

-- Debugger
safe("dapui", function(m) m.setup() end)
safe("nvim-dap-virtual-text", function(m) m.setup() end)
safe("dap", function(dap)
  vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DiagnosticWarn",  linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected",  { text = "○", texthl = "DiagnosticError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapLogPoint",            { text = "◆", texthl = "DiagnosticInfo",  linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticWarn",  linehl = "Visual", numhl = "" })

  local ok, dapui = pcall(require, "dapui")
  if ok then
    dap.listeners.before.attach.dapui_config = function() dapui.open() end
    dap.listeners.before.launch.dapui_config = function() dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
  end

  local kotlin_dap = vim.env.KOTLIN_DAP_BIN or "kotlin-debug-adapter"
  dap.adapters.kotlin = { type = "executable", command = kotlin_dap }
  dap.configurations.kotlin = {
    {
      type = "kotlin",
      request = "launch",
      name = "Launch Kotlin",
      projectRoot = function()
        local root = vim.fs.root(0, { "settings.gradle.kts", "build.gradle.kts", "pom.xml", ".git" })
        return root or vim.uv.cwd()
      end,
      mainClass = function()
        local default = "MainKt"
        return vim.fn.input("Main class (FQN): ", default)
      end,
    },
  }
end)

-- Motion
safe("leap", function(_) end)
safe("hop", function(m) m.setup() end)
safe("precognition", function(m)
  m.setup({
    startVisible = true,
    showBlankVirtLine = true,
    highlightColor = { link = "Comment" },
    disabled_fts = { "startify", "alpha" },
  })
end)

-- Editing utilities
safe("nvim-surround", function(m) m.setup() end)
safe("nvim-autopairs", function(m) m.setup() end)
safe("Comment", function(m) m.setup() end)
safe("mini.bufremove", function(m) m.setup() end)
safe("smart-splits", function(m) m.setup() end)
safe("img-clip", function(m) m.setup() end)

-- Terminal
safe("toggleterm", function(m) m.setup({ size = 20 }) end)

-- Project + crates
safe("project_nvim", function(m) m.setup() end)
safe("crates", function(m) m.setup() end)
