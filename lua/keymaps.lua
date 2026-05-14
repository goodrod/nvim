local map = vim.keymap.set

local function cmd(c) return "<CMD>" .. c .. "<CR>" end

local dap;  local function D()  dap  = dap  or require("dap")             return dap end
local dapw; local function DW() dapw = dapw or require("dap.ui.widgets") return dapw end
local ss;   local function S()  ss   = ss   or require("smart-splits")    return ss end

map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Ctrl-d/u always move cursor 10 lines
map("n", "<C-d>", "10j")
map("n", "<C-u>", "10k")

-- Terminal
map("n", "<leader>t", cmd("ToggleTerm"), { desc = "Toggle terminal" })

-- Find/Search
local function git_root()
  local start = vim.api.nvim_buf_get_name(0):gsub("^%w+://", "")
  if start == "" or vim.fn.filereadable(start) == 0 and vim.fn.isdirectory(start) == 0 then
    start = vim.uv.cwd()
  end
  local hit = vim.fs.find(".git", { upward = true, path = start })[1]
  return hit and vim.fs.dirname(hit) or vim.uv.cwd()
end
map("n", "<leader>ff", function() require("fzf-lua").files({ cwd = git_root() }) end,     { desc = "Find files" })
map("n", "<leader>fg", function() require("fzf-lua").live_grep({ cwd = git_root() }) end, { desc = "Grep in files" })
map("n", "<leader>fb", cmd("FzfLua buffers"),   { desc = "Find buffers" })
map("n", "<leader>fk", cmd("FzfLua keymaps"),   { desc = "Find keymaps" })

-- Explorer
map("n", "<leader>e", function()
  local root = vim.fs.root(0, { ".git" }) or vim.uv.cwd()
  vim.cmd("Neotree toggle dir=" .. vim.fn.fnameescape(root))
end, { desc = "Toggle file explorer" })

-- Undotree
map("n", "<leader>u", cmd("UndotreeToggle"), { desc = "Undotree" })

-- Git
map("n", "<leader>gb", cmd("Gitsigns blame_line"),                { desc = "Blame line" })
map("n", "<leader>gt", cmd("Gitsigns toggle_current_line_blame"), { desc = "Toggle blame" })
map("n", "<leader>gh", cmd("DiffviewFileHistory %"),              { desc = "File history" })
map("v", "<leader>gh", ":DiffviewFileHistory<CR>",                { desc = "Selection history" })
map("n", "<leader>gd", cmd("DiffviewOpen"),                       { desc = "Diff view" })
map("n", "<leader>gs", cmd("Gitsigns stage_hunk"),                { desc = "Stage hunk" })
map("n", "<leader>gu", cmd("Gitsigns undo_stage_hunk"),           { desc = "Undo stage hunk" })
map("n", "<leader>gn", cmd("Gitsigns next_hunk"),                 { desc = "Next hunk" })
map("n", "<leader>gp", cmd("Gitsigns prev_hunk"),                 { desc = "Prev hunk" })

-- Diagnostics (LSP code-action/rename binds attached on LspAttach in lsp.lua)
map("n", "<leader>xx", cmd("Trouble diagnostics toggle"),      { desc = "Trouble diagnostics" })
map("n", "<leader>xd", cmd("FzfLua diagnostics_document"),     { desc = "Document diagnostics" })
map("n", "<leader>xw", cmd("FzfLua diagnostics_workspace"),    { desc = "Workspace diagnostics" })
map("n", "<leader>xn", function() vim.diagnostic.jump({ count =  1, float = true }) end, { desc = "Next diagnostic" })
map("n", "<leader>xp", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Prev diagnostic" })

-- Debug (leader binds)
map("n", "<leader>dc",  function() D().continue() end,         { desc = "Continue" })
map("n", "<leader>dR",  function() D().restart() end,          { desc = "Restart" })
map("n", "<leader>dq",  function() D().terminate() end,        { desc = "Terminate" })
map("n", "<leader>d.",  function() D().run_last() end,         { desc = "Run last" })
map("n", "<leader>dr",  function() D().repl.toggle() end,      { desc = "REPL" })
map("n", "<leader>dh",  function() DW().hover() end,           { desc = "Hover" })
map("n", "<leader>db",  function() D().toggle_breakpoint() end,{ desc = "Toggle breakpoint" })
map("n", "<leader>dgc", function() D().run_to_cursor() end,    { desc = "Run to cursor" })
map("n", "<leader>dgi", function() D().step_into() end,        { desc = "Step into" })
map("n", "<leader>dgo", function() D().step_out() end,         { desc = "Step out" })
map("n", "<leader>dgj", function() D().step_over() end,        { desc = "Step over" })
map("n", "<leader>dgk", function() D().step_back() end,        { desc = "Step back" })
map("n", "<leader>dvo", function() D().up() end,               { desc = "Up frame" })
map("n", "<leader>dvi", function() D().down() end,             { desc = "Down frame" })
map("n", "<leader>du",  function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })

-- Debug (IDE-style F-keys)
map("n", "<F5>",    function() D().continue() end,          { desc = "DAP continue" })
map("n", "<F6>",    function() D().repl.toggle() end,       { desc = "DAP REPL" })
map("n", "<F9>",    function() D().toggle_breakpoint() end, { desc = "DAP toggle breakpoint" })
map("n", "<F10>",   function() D().step_over() end,         { desc = "DAP step over" })
map("n", "<F11>",   function() D().step_into() end,         { desc = "DAP step into" })
map("n", "<S-F11>", function() D().step_out() end,          { desc = "DAP step out" })

-- Buffer (nvf bufferline binds)
map("n", "<leader>bn",  cmd("BufferLineCycleNext"),        { desc = "Next buffer" })
map("n", "<leader>bp",  cmd("BufferLineCyclePrev"),        { desc = "Prev buffer" })
map("n", "<leader>bc",  cmd("BufferLinePick"),             { desc = "Pick buffer" })
map("n", "<leader>bse", cmd("BufferLineSortByExtension"),  { desc = "Sort by extension" })
map("n", "<leader>bsd", cmd("BufferLineSortByDirectory"),  { desc = "Sort by directory" })
map("n", "<leader>bmn", cmd("BufferLineMoveNext"),         { desc = "Move buffer next" })
map("n", "<leader>bmp", cmd("BufferLineMovePrev"),         { desc = "Move buffer prev" })

-- Dashboard-referenced helpers
map("n", "<leader>fr", cmd("Telescope frecency"), { desc = "Frecency/MRU" })
map("n", "<leader>fh", cmd("FzfLua oldfiles"),    { desc = "Recently opened" })
map("n", "<leader>fm", cmd("FzfLua marks"),       { desc = "Bookmarks" })
map("n", "<leader>sl", function() require("persistence").load({ last = true }) end, { desc = "Last session" })

-- Hop
map("n", "<leader>h", cmd("HopPattern"), { desc = "Hop pattern" })

-- Oil file explorer
map("n", "-", cmd("Oil"), { desc = "Open parent dir in Oil" })

-- Leap motion
map({ "n", "x", "o" }, "s", "<Plug>(leap-forward)",  { desc = "Leap forward" })
map({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })

-- Homerow navigation: jklö (right hand) -> hjkl
map({ "n", "v", "o" }, "j", "h")
map({ "n", "v", "o" }, "k", "j")
map({ "n", "v", "o" }, "l", "k")
map({ "n", "v", "o" }, "ö", "l")

-- Window navigation (Ctrl + homerow jklö, matches the j/k/l/ö motion remap)
map("n", "<C-j>", function() S().move_cursor_left() end)
map("n", "<C-k>", function() S().move_cursor_down() end)
map("n", "<C-l>", function() S().move_cursor_up() end)
map("n", "<C-ö>", function() S().move_cursor_right() end)
map("n", "<A-j>", function() S().resize_left() end)
map("n", "<A-k>", function() S().resize_down() end)
map("n", "<A-l>", function() S().resize_up() end)
map("n", "<A-ö>", function() S().resize_right() end)
map("n", "<C-Left>",  function() S().move_cursor_left() end)
map("n", "<C-Down>",  function() S().move_cursor_down() end)
map("n", "<C-Up>",    function() S().move_cursor_up() end)
map("n", "<C-Right>", function() S().move_cursor_right() end)

-- Window splits & close
map("n", "<C-w>v", cmd("vsplit"), { desc = "Vertical split" })
map("n", "<C-w>s", cmd("split"),  { desc = "Horizontal split" })
map("n", "<C-w>q", cmd("close"),  { desc = "Close window" })
