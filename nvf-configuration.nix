{ pkgs, lib, ... }: {
  vim = {
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
        vim.opt.cursorline = true
        vim.opt.termguicolors = true
        vim.opt.scrolloff = 5
        vim.opt.sidescrolloff = 5
        vim.opt.showmode = false

        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent dir in Oil" })
      '';

      e-mappings = ''
        -- Replace q / wq / x with MiniBufremove.delete
        vim.keymap.set("c", "<CR>", function()
          local cmd = vim.fn.getcmdline()

          if cmd == "q"
            or cmd == "q!"
            or cmd == "wq"
            or cmd == "wq!"
            or cmd == "x"
            or cmd == "x!" then

            if cmd:sub(1,1) == "w" or cmd:sub(1,1) == "x" then
              return '<C-u>write | lua require("mini.bufremove").delete(0)<CR>'
            end

            return '<C-u>lua require("mini.bufremove").delete(0)<CR>'
          end

          return "<CR>"
        end, { expr = true })

        -- FzfLua keymaps search
        vim.keymap.set("n", "<leader>k", function()
          require("fzf-lua").keymaps()
        end, { desc = "Search keymaps" })
      '';
    };

    viAlias = true;
    vimAlias = true;
    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };

    spellcheck = {
      enable = true;
      programmingWordlist.enable = true;
    };

    lsp = {
      enable = true;

      formatOnSave = true;
      lspkind.enable = false;
      lightbulb.enable = true;
      lspsaga.enable = false;
      trouble.enable = true;
      otter-nvim.enable = true;
      nvim-docs-view.enable = true;
    };
    formatter.conform-nvim = {
      enable = true;
      setupOpts = { formatters_by_ft = { nix = [ "nixfmt" ]; }; };
    };
    debugger = {
      nvim-dap = {
        enable = true;
        ui.enable = true;
      };
    };

    # This section does not include a comprehensive list of available language modules.
    # To list all available language module options, please visit the nvf manual.
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;

      # Languages that will be supported in default and maximal configurations.
      nix.enable = true;
      markdown.enable = true;

      # Languages that are enabled in the maximal configuration.
      bash.enable = true;
      clang.enable = true;
      css.enable = true;
      html.enable = true;
      sql.enable = true;
      java.enable = true;
      kotlin.enable = true;
      ts.enable = true;
      go.enable = true;
      lua.enable = true;
      zig.enable = true;
      python.enable = true;
      typst.enable = true;
      rust = {
        enable = true;
        crates.enable = true;
      };

      # Language modules that are not as common.
      assembly.enable = false;
      astro.enable = false;
      nu.enable = false;
      csharp.enable = false;
      julia.enable = false;
      vala.enable = false;
      scala.enable = false;
      r.enable = false;
      gleam.enable = false;
      dart.enable = false;
      ocaml.enable = false;
      elixir.enable = false;
      haskell.enable = false;
      ruby.enable = false;
      fsharp.enable = false;

      tailwind.enable = false;
      svelte.enable = false;

      # Nim LSP is broken on Darwin and therefore
      # should be disabled by default. Users may still enable
      # `vim.languages.vim` to enable it, this does not restrict
      # that.
      # See: <https://github.com/PMunch/nimlsp/issues/178#issue-2128106096>
      nim.enable = false;
    };

    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;
      highlight-undo.enable = true;
      indent-blankline.enable = true;
      cellular-automaton.enable = false;
    };

    statusline = {
      lualine = {
        enable = true;
        theme = "catppuccin";
      };
    };

    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = false;
    };

    autopairs.nvim-autopairs.enable = true;

    # nvf provides various autocomplete options. The tried and tested nvim-cmp
    # is enabled in default package, because it does not trigger a build. We
    # enable blink-cmp in maximal because it needs to build its rust fuzzy
    # matcher library.
    autocomplete = { blink-cmp.enable = true; };

    snippets.luasnip.enable = true;

    filetree = { neo-tree = { enable = true; }; };
    utility.oil-nvim = {
      enable = true;
      setupOpts = {
        default_file_explorer = false;
        view_options = { show_hidden = true; };
        filter = ''
          function(name, _)
            if name == "../" or name == ".." then
              return false
            end
            return true
          end,
        '';
      };
    };
    tabline = { nvimBufferline.enable = true; };

    treesitter.context.enable = true;

    binds = {
      whichKey.enable = true;
      cheatsheet.enable = true;
    };

    telescope.enable = true;

    git = {
      enable = true;
      gitsigns.enable = true;
      gitsigns.codeActions.enable = false; # throws an annoying debug message
      neogit.enable = true;
    };

    mini.bufremove.enable = true;

    minimap = {
      minimap-vim.enable = false;
      codewindow.enable =
        true; # lighter, faster, and uses lua for configuration
    };

    dashboard = {
      dashboard-nvim.enable = false;
      alpha.enable = true;
    };

    notify = { nvim-notify.enable = true; };

    projects = { project-nvim.enable = true; };

    utility = {
      ccc.enable = false;
      vim-wakatime.enable = false;
      diffview-nvim.enable = true;
      yanky-nvim.enable = false;
      icon-picker.enable = true;
      surround.enable = true;
      leetcode-nvim.enable = true;
      multicursors.enable = true;
      smart-splits.enable = true;
      undotree.enable = true;
      nvim-biscuits.enable = true;

      motion = {
        hop.enable = true;
        leap.enable = true;
        precognition.enable = true;
      };
      images = {
        image-nvim.enable = false;
        img-clip.enable = true;
      };
    };

    notes = {
      obsidian.enable =
        false; # FIXME: neovim fails to build if obsidian is enabled
      neorg.enable = false;
      orgmode.enable = false;
      mind-nvim.enable = true;
      todo-comments.enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;
        lazygit.enable = true;
      };
    };

    ui = {
      borders.enable = true;
      noice.enable = true;
      colorizer.enable = true;
      modes-nvim.enable = false; # the theme looks terrible with catppuccin
      illuminate.enable = true;
      breadcrumbs = {
        enable = true;
        navbuddy.enable = true;
      };
      smartcolumn = {
        enable = true;
        setupOpts.custom_colorcolumn = {
          # this is a freeform module, it's `buftype = int;` for configuring column position
          nix = "110";
          ruby = "120";
          java = "130";
          go = [ "90" "130" ];
        };
      };
      fastaction.enable = true;
    };

    assistant = {
      chatgpt.enable = false;
      copilot = {
        enable = false;
        cmp.enable = true;
      };
      codecompanion-nvim.enable = false;
      avante-nvim.enable = true;
    };

    session = { nvim-session-manager.enable = false; };

    gestures = { gesture-nvim.enable = false; };

    comments = { comment-nvim.enable = true; };

    presence = { neocord.enable = false; };
  };
}
