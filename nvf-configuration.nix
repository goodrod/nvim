{
  pkgs,
  lib,
  ...
}: let
  kotlin-lsp = pkgs.callPackage ./kotlin-lsp.nix { };
in {
  vim = {
    startPlugins = with pkgs.vimPlugins; [gitsigns-nvim];

    luaConfigRC = {
      a-basics = ''
        -- Polyfill: shadow deprecated vim.tbl_flatten so plugins (lualine etc.)
        -- that still call it don't emit warnings on nvim 0.11+.
        vim.tbl_flatten = function(t) return vim.iter(t):flatten(math.huge):totable() end

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

        vim.api.nvim_create_autocmd({"WinEnter", "BufWinEnter"}, {
          callback = function()
            if vim.api.nvim_win_get_config(0).relative == "" then
              vim.opt_local.scroll = 10
            end
          end
        })

        vim.opt.shortmess:append "sI"
        vim.opt.fillchars = { eob = " " }
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
        vim.opt.scrolloff = 5
        vim.opt.sidescrolloff = 5
      '';

      e-mappings = ''
        vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

        -- Ctrl-d/u always move cursor 10 lines
        vim.keymap.set("n", "<C-d>", "10j")
        vim.keymap.set("n", "<C-u>", "10k")

        -- Terminal
        vim.keymap.set("n", "<leader>t", "<CMD>ToggleTerm<CR>", { desc = "Toggle terminal" })

        -- Find/Search
        vim.keymap.set("n", "<leader>ff", "<CMD>FzfLua files<CR>", { desc = "Find files" })
        vim.keymap.set("n", "<leader>fg", "<CMD>FzfLua live_grep<CR>", { desc = "Grep in files" })
        vim.keymap.set("n", "<leader>fb", "<CMD>FzfLua buffers<CR>", { desc = "Find buffers" })
        vim.keymap.set("n", "<leader>fk", "<CMD>FzfLua keymaps<CR>", { desc = "Find keymaps" })

        -- Explorer
        vim.keymap.set("n", "<leader>e", "<CMD>Neotree toggle<CR>", { desc = "Toggle file explorer" })

        -- Undotree
        vim.keymap.set("n", "<leader>u", "<CMD>UndotreeToggle<CR>", { desc = "Undotree" })

        -- Git
        vim.keymap.set("n", "<leader>gb", "<CMD>Gitsigns blame_line<CR>", { desc = "Blame line" })
        vim.keymap.set("n", "<leader>gt", "<CMD>Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle blame" })
        vim.keymap.set("n", "<leader>gh", "<CMD>DiffviewFileHistory %<CR>", { desc = "File history" })
        vim.keymap.set("v", "<leader>gh", ":DiffviewFileHistory<CR>", { desc = "Selection history" })
        vim.keymap.set("n", "<leader>gd", "<CMD>DiffviewOpen<CR>", { desc = "Diff view" })
        vim.keymap.set("n", "<leader>gs", "<CMD>Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
        vim.keymap.set("n", "<leader>gu", "<CMD>Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })

        -- Hunk navigation
        vim.keymap.set("n", "]c", "<CMD>Gitsigns next_hunk<CR>", { desc = "Next hunk" })
        vim.keymap.set("n", "[c", "<CMD>Gitsigns prev_hunk<CR>", { desc = "Prev hunk" })

        -- Code/LSP (actions only)
        vim.keymap.set({"n", "v"}, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
        vim.keymap.set("n", "<leader>cn", vim.lsp.buf.rename, { desc = "Rename symbol" })

        -- LSP navigation (direct)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
        vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Type definition" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })

        -- Diagnostics
        vim.keymap.set("n", "<leader>xx", "<CMD>Trouble toggle<CR>", { desc = "Trouble toggle" })
        vim.keymap.set("n", "<leader>xd", "<CMD>FzfLua diagnostics_document<CR>", { desc = "Document diagnostics" })
        vim.keymap.set("n", "<leader>xw", "<CMD>FzfLua diagnostics_workspace<CR>", { desc = "Workspace diagnostics" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev diagnostic" })

        -- Debug
        vim.keymap.set("n", "<leader>db", "<CMD>DapToggleBreakpoint<CR>", { desc = "Toggle breakpoint" })
        vim.keymap.set("n", "<leader>dc", "<CMD>DapContinue<CR>", { desc = "Continue" })
        vim.keymap.set("n", "<leader>ds", "<CMD>DapStepOver<CR>", { desc = "Step over" })
        vim.keymap.set("n", "<leader>di", "<CMD>DapStepInto<CR>", { desc = "Step into" })
        vim.keymap.set("n", "<leader>du", function() require("dapui").toggle() end, { desc = "Toggle DAP UI" })

        -- Oil file explorer
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent dir in Oil" })

        -- Leap motion
        vim.keymap.set({"n", "x", "o"}, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
        vim.keymap.set({"n", "x", "o"}, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })

        -- Swedish keyboard homerow navigation
        vim.keymap.set({"n", "v", "o"}, "j", "h")
        vim.keymap.set({"n", "v", "o"}, "k", "j")
        vim.keymap.set({"n", "v", "o"}, "l", "k")
        vim.keymap.set({"n", "v", "o"}, "ö", "l")

        -- Window navigation (homerow + arrows)
        vim.keymap.set("n", "<C-j>", "<C-w>h")
        vim.keymap.set("n", "<C-k>", "<C-w>j")
        vim.keymap.set("n", "<C-l>", "<C-w>k")
        vim.keymap.set("n", "<C-ö>", "<C-w>l")
        vim.keymap.set("n", "<C-Left>", "<C-w>h")
        vim.keymap.set("n", "<C-Down>", "<C-w>j")
        vim.keymap.set("n", "<C-Up>", "<C-w>k")
        vim.keymap.set("n", "<C-Right>", "<C-w>l")

        -- Window splits & close
        vim.keymap.set("n", "<C-w>v", "<CMD>vsplit<CR>", { desc = "Vertical split" })
        vim.keymap.set("n", "<C-w>s", "<CMD>split<CR>", { desc = "Horizontal split" })
        vim.keymap.set("n", "<C-w>q", "<CMD>close<CR>", { desc = "Close window" })

        -- Window resize
        vim.keymap.set("n", "<C-S-j>", "<C-w><")
        vim.keymap.set("n", "<C-S-ö>", "<C-w>>")
        vim.keymap.set("n", "<C-S-k>", "<C-w>-")
        vim.keymap.set("n", "<C-S-l>", "<C-w>+")
      '';

      f-whichkey-groups = ''
        require("which-key").add({
          { "<leader>c", group = "Code" },
          { "<leader>d", group = "Debug" },
          { "<leader>f", group = "Find" },
          { "<leader>g", group = "Git" },
          { "<leader>x", group = "Diagnostics" },
        })
      '';

      y-kotlin-lsp = ''
        vim.lsp.config('kotlin_lsp', {
          cmd = { '${kotlin-lsp}/bin/kotlin-lsp', '--stdio' },
          filetypes = { 'kotlin' },
          root_markers = { 'settings.gradle.kts', 'build.gradle.kts', 'pom.xml', '.git' },
        })
        vim.lsp.enable('kotlin_lsp')

        vim.api.nvim_create_autocmd('BufReadCmd', {
          pattern = 'jar://*',
          callback = function(args)
            local jar, inner = vim.api.nvim_buf_get_name(args.buf):match("^jar:/*(/.-)!/(.+)$")
            if not jar then return end
            local out = vim.system({ "${pkgs.unzip}/bin/unzip", "-p", jar, inner }, { text = true }):wait().stdout or ""
            local lines = vim.split(out, "\n", { plain = true })
            if lines[#lines] == "" then lines[#lines] = nil end
            vim.bo[args.buf].modifiable = true
            vim.api.nvim_buf_set_lines(args.buf, 0, -1, false, lines)
            vim.bo[args.buf].modifiable = false
            vim.bo[args.buf].modified = false
            local ft = vim.filetype.match({ filename = inner, buf = args.buf })
            if ft then vim.bo[args.buf].filetype = ft end
            if ft == 'kotlin' then
              vim.schedule(function()
                local c = vim.lsp.get_clients({ name = 'kotlin_lsp' })[1]
                if c then vim.lsp.buf_attach_client(args.buf, c.id) end
              end)
            end
          end,
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
      typescript.enable = true;
      clang.enable = true;
      csharp = {
        enable = true;
        lsp.servers = ["omnisharp"];
      };
      css.enable = true;
      html.enable = true;
      sql.enable = true;
      java.enable = true;
      kotlin = {
        enable = true;
        lsp.enable = false;
      };
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
              "<LeftRelease>" = "open";
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
        theme = "auto";
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
