{
  pkgs,
  lib,
  ...
}
: {
  vim = {
    startPlugins = with pkgs.vimPlugins; [gitsigns-nvim];

    luaConfigRC = {
      a-basics = ''
        vim.o.laststatus = 3
        vim.o.showmode = false
        vim.o.clipboard = "unnamedplus"
        vim.o.cursorline = true
        vim.o.cursorlineopt = "number"
        vim.o.ignorecase = true
        vim.o.smartcase = true
        vim.o.mouse = "a"
        vim.o.signcolumn = "yes"
        vim.o.splitbelow = true
        vim.o.splitright = true
        vim.o.timeoutlen = 400
        vim.o.undofile = true

        vim.api.nvim_create_autocmd({"WinEnter", "BufWinEnter"}, {
          callback = function()
            if vim.api.nvim_win_get_config(0).relative == "" then
              vim.opt_local.scroll = 10
            end
          end
        })

        vim.opt.shortmess:append "sI"
        vim.opt.fillchars = { eob = " " }
        vim.opt.wildmode = "full"
      '';

      b-numbers = ''
        vim.o.number = true
        vim.o.numberwidth = 2
        vim.o.ruler = false
      '';

      c-indent = ''
        vim.o.expandtab = true
        vim.o.shiftwidth = 2
        vim.o.smartindent = true
        vim.o.tabstop = 2
        vim.o.softtabstop = 2
      '';

      d-visuals = ''
        vim.opt.cursorline = true
        vim.opt.termguicolors = true
        vim.opt.scrolloff = 5
        vim.opt.sidescrolloff = 5
        vim.opt.showmode = false
      '';

      e-mappings = ''
        vim.keymap.set("n", "<leader>e", "<CMD>Neotree toggle<CR>", { desc = "Toggle file explorer" })
        vim.keymap.set("n", "<leader>tt", "<CMD>ToggleTerm<CR>", { desc = "Toggle terminal" })

        vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

        -- Ctrl-d/u always move cursor 10 lines
        vim.keymap.set("n", "<C-d>", "10j")
        vim.keymap.set("n", "<C-u>", "10k")

        -- Buffer management
        vim.keymap.set("n", "<leader>bd", "<CMD>bdelete<CR>", { desc = "Delete buffer" })
        vim.keymap.set("n", "<leader>bn", "<CMD>bnext<CR>", { desc = "Next buffer" })
        vim.keymap.set("n", "<leader>bp", "<CMD>bprevious<CR>", { desc = "Previous buffer" })
        vim.keymap.set("n", "<leader>bw", "<CMD>w<CR>", { desc = "Save buffer" })

        -- Find/Search
        vim.keymap.set("n", "<leader>ff", "<CMD>FzfLua files<CR>", { desc = "Find files" })
        vim.keymap.set("n", "<leader>fg", "<CMD>FzfLua live_grep<CR>", { desc = "Grep in files" })
        vim.keymap.set("n", "<leader>fb", "<CMD>FzfLua buffers<CR>", { desc = "Find buffers" })

        -- Git
        vim.keymap.set("n", "<leader>gb", "<CMD>Gitsigns blame_line<CR>", { desc = "Git blame line" })
        vim.keymap.set("n", "<leader>gt", "<CMD>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle git blame" })
        vim.keymap.set("n", "<leader>gh", "<CMD>DiffviewFileHistory %<CR>", { desc = "Git file history" })
        vim.keymap.set("v", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "Git selection history" })

        -- LSP
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
        vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "Go to definition" })
        vim.keymap.set("n", "<leader>cR", vim.lsp.buf.references, { desc = "Find references" })
        vim.keymap.set("n", "<leader>ci", vim.lsp.buf.implementation, { desc = "Go to implementation" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })

        -- Oil file explorer
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent dir in Oil" })

        -- Swedish keyboard homerow navigation
        vim.keymap.set({"n", "v", "o"}, "j", "h")
        vim.keymap.set({"n", "v", "o"}, "k", "j")
        vim.keymap.set({"n", "v", "o"}, "l", "k")
        vim.keymap.set({"n", "v", "o"}, "ö", "l")

        -- Window navigation
        vim.keymap.set("n", "<C-w>j", "<C-w>h")
        vim.keymap.set("n", "<C-w>k", "<C-w>j")
        vim.keymap.set("n", "<C-w>l", "<C-w>k")
        vim.keymap.set("n", "<C-w>ö", "<C-w>l")

        vim.keymap.set("n", "<leader>k", function()
          local keymaps = vim.api.nvim_get_keymap('n')
          local filtered = vim.tbl_filter(function(map)
            local desc = map.desc or ""
            return not desc:match("autopairs")
              and not desc:match("Nvim builtin")
              and not desc:match("Increment")
              and not desc:match("Decrement")
              and not desc:match("^%s*$")
              and not desc:match("which_key_ignore")
          end, keymaps)
          require("fzf-lua").keymaps()
        end, { desc = "Search keymaps" })
      '';

      f-whichkey-groups = ''
        require("which-key").add({
          { "<leader>b", group = "Buffer" },
          { "<leader>c", group = "Code" },
          { "<leader>d", group = "Debug" },
          { "<leader>f", group = "Find" },
          { "<leader>g", group = "Git" },
          { "<leader>l", group = "LSP" },
          { "<leader>s", group = "Search" },
          { "<leader>t", group = "Terminal" },
          { "<leader>u", group = "UI" },
          { "<leader>w", group = "Window" },
          { "<leader>x", group = "Diagnostics" },
        })
      '';

      z-gitsigns-nokeys = ''
        require('gitsigns').setup({
          current_line_blame = false,
          on_attach = function(bufnr)
          end
        })
      '';
    };

    viAlias = true;
    vimAlias = true;

    lsp = {
      enable = true;
      formatOnSave = true;
      lightbulb.enable = true;
      trouble.enable = true;
      nvim-docs-view.enable = true;
    };

    languages = {
      enableTreesitter = true;
      enableFormat = true;
      enableExtraDiagnostics = true;
      nix.enable = true;
      markdown.enable = true;
      bash.enable = true;
      python.enable = true;
      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };
      go.enable = true;
      lua.enable = true;
      ts.enable = true;
      clang.enable = true;
      csharp = {
        enable = true;
        lsp.servers = ["omnisharp"];
      };
      css.enable = true;
      html.enable = true;
      sql.enable = true;
      java.enable = true;
      kotlin.enable = true;
      zig.enable = true;
      typst.enable = true;
    };

    debugger = {
      nvim-dap = {
        enable = true;
        ui.enable = true;
      };
    };

    formatter.conform-nvim = {
      enable = true;
      setupOpts = {
        formatters_by_ft = {
          nix = ["nixfmt"];
        };
      };
    };

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
    };

    autocomplete = {
      blink-cmp = {
        enable = true;
        setupOpts = {
          cmdline = {
            keymap = {
              "<C-y>" = ["select_and_accept"];
            };
          };
        };
      };
    };

    filetree = {
      neo-tree = {
        enable = true;
        setupOpts = {
          window = {
            mappings = {
              "<space>" = "none";
              "<Esc>" = "close_window";
              "<C-c>" = "close_window";
            };
          };
        };
      };
    };

    telescope.enable = true;

    fzf-lua.enable = true;

    git = {
      enable = false;
    };

    statusline = {
      lualine = {
        enable = true;
        theme = "catppuccin";
      };
    };

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    utility = {
      diffview-nvim = {
        enable = true;
        setupOpts = {
          keymaps = {
            view = {
              q = "<Cmd>DiffviewClose<CR>";
              "<Esc>" = "<Cmd>DiffviewClose<CR>";
              "<C-c>" = "<Cmd>DiffviewClose<CR>";
            };
            file_panel = {
              q = "<Cmd>DiffviewClose<CR>";
              "<Esc>" = "<Cmd>DiffviewClose<CR>";
              "<C-c>" = "<Cmd>DiffviewClose<CR>";
            };
            file_history_panel = {
              q = "<Cmd>DiffviewClose<CR>";
              "<Esc>" = "<Cmd>DiffviewClose<CR>";
              "<C-c>" = "<Cmd>DiffviewClose<CR>";
            };
          };
        };
      };
      surround.enable = true;
      undotree.enable = true;
      icon-picker.enable = true;
      smart-splits.enable = true;
      oil-nvim = {
        enable = true;
        setupOpts = {
          default_file_explorer = true;
          view_options = {
            show_hidden = true;
          };
        };
      };
      motion = {
        hop.enable = true;
        leap.enable = true;
        precognition.enable = true;
      };
      images = {
        img-clip.enable = true;
      };
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = false;
        setupOpts = {
          size = 20;
        };
      };
    };

    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      fidget-nvim.enable = true;
      highlight-undo.enable = true;
      indent-blankline.enable = true;
    };

    autopairs.nvim-autopairs.enable = true;
    snippets.luasnip.enable = true;

    tabline = {
      nvimBufferline.enable = true;
    };

    mini.bufremove.enable = true;

    dashboard = {
      alpha.enable = true;
    };

    notify = {
      nvim-notify.enable = true;
    };

    ui = {
      borders.enable = true;
      noice.enable = true;
      colorizer.enable = true;
      fastaction.enable = true;
    };

    projects = {
      project-nvim.enable = true;
    };

    comments = {
      comment-nvim.enable = true;
    };
  };
}
