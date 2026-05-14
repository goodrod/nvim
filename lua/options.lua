-- Polyfill for plugins still calling vim.tbl_flatten on 0.11+.
vim.tbl_flatten = function(t) return vim.iter(t):flatten(math.huge):totable() end

vim.opt.termguicolors = true

vim.o.laststatus = 3
vim.o.showmode = false
vim.o.clipboard = "unnamedplus"
vim.o.cursorline = true
vim.o.cursorlineopt = "number"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = "a"
vim.o.timeoutlen = 400
vim.o.undofile = true
vim.o.winborder = "rounded"

vim.g.formatsave = true

vim.opt.shortmess:append("sI")
vim.opt.fillchars = { eob = " " }

vim.o.number = true
vim.o.numberwidth = 2
vim.o.ruler = false

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2

vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
