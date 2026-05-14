vim.api.nvim_create_autocmd({ "WinEnter", "BufWinEnter" }, {
  callback = function()
    if vim.api.nvim_win_get_config(0).relative ~= "" then return end
    local h = vim.api.nvim_win_get_height(0)
    if h >= 4 then vim.opt_local.scroll = math.min(10, math.max(1, math.floor(h / 2))) end
  end,
})

-- chdir to first cli arg so git-root scans (fzf, neo-tree) anchor there
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local arg = vim.fn.argv(0)
    if arg == "" then return end
    arg = (arg:gsub("^%w+://", ""))
    arg = vim.fn.fnamemodify(arg, ":p")
    local dir = vim.fn.isdirectory(arg) == 1 and arg or vim.fn.fnamemodify(arg, ":h")
    if vim.fn.isdirectory(dir) == 1 then vim.cmd.lcd(dir) end
  end,
})

-- jar:// reader for kotlin-lsp jumps into archived sources
vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "jar://*",
  callback = function(args)
    local jar, inner = vim.api.nvim_buf_get_name(args.buf):match("^jar:/*(/.-)!/(.+)$")
    if not jar then return end
    local unzip = vim.env.UNZIP_BIN or "unzip"
    local out = vim.system({ unzip, "-p", jar, inner }, { text = true }):wait().stdout or ""
    local lines = vim.split(out, "\n", { plain = true })
    if lines[#lines] == "" then lines[#lines] = nil end
    vim.bo[args.buf].modifiable = true
    vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
    vim.bo[args.buf].modifiable = false
    vim.bo[args.buf].modified = false
    local ft = vim.filetype.match({ filename = inner, buf = args.buf })
    if ft then vim.bo[args.buf].filetype = ft end
    if ft == "kotlin" then
      vim.schedule(function()
        local c = vim.lsp.get_clients({ name = "kotlin_lsp" })[1]
        if c then vim.lsp.buf_attach_client(args.buf, c.id) end
      end)
    end
  end,
})

