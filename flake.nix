{
  description = "neovim 0.12 config, plain lua, wrapped by nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      lib = pkgs.lib;

      kotlin-lsp = pkgs.callPackage ./kotlin-lsp.nix { };
      kotlin-debug-adapter = pkgs.callPackage ./kotlin-debug-adapter.nix { };

      configDir = pkgs.stdenv.mkDerivation {
        name = "nvim-config";
        src = ./.;
        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp init.lua $out/
          cp -r lua $out/
        '';
      };

      plugins = with pkgs.vimPlugins; [
        # treesitter (with all grammars baked in)
        (nvim-treesitter.withAllGrammars)

        # theme + icons
        catppuccin-nvim
        nvim-web-devicons

        # statusline / tabline / dashboard
        lualine-nvim
        bufferline-nvim
        alpha-nvim

        # ui polish
        noice-nvim
        nui-nvim
        nvim-notify
        nvim-scrollbar
        nvim-cursorline
        fidget-nvim
        indent-blankline-nvim
        nvim-colorizer-lua
        highlight-undo-nvim
        fastaction-nvim

        # which-key + cheatsheet
        which-key-nvim
        cheatsheet-nvim

        # fuzzy / pickers
        telescope-nvim
        telescope-frecency-nvim
        fzf-lua
        plenary-nvim

        # file explorers
        neo-tree-nvim
        oil-nvim

        # git
        gitsigns-nvim
        diffview-nvim

        # lsp / docs / actions
        nvim-lightbulb
        trouble-nvim
        nvim-docs-view

        # completion + snippets
        blink-cmp
        luasnip
        friendly-snippets

        # formatter
        conform-nvim

        # debugger
        nvim-dap
        nvim-dap-ui
        nvim-dap-virtual-text
        nvim-nio

        # motion
        leap-nvim
        hop-nvim
        precognition-nvim

        # editing utilities
        nvim-surround
        nvim-autopairs
        comment-nvim
        undotree
        smart-splits-nvim
        img-clip-nvim
        mini-nvim

        # terminal
        toggleterm-nvim

        # project + crates
        project-nvim
        crates-nvim

        # session
        persistence-nvim
      ];

      runtimeBins = with pkgs; [
        # nix
        nixd
        nixfmt
        # generic formatters
        shfmt
        prettier
        # sqlite for telescope-frecency
        sqlite
        # docs / shell
        marksman
        bash-language-server
        shellcheck
        # python
        pyright
        black
        # rust
        rust-analyzer
        # go
        gopls
        delve
        # lua
        lua-language-server
        stylua
        # ts/js
        typescript-language-server
        # c/c++
        clang-tools
        # c#
        omnisharp-roslyn
        # web (css/html/json)
        vscode-langservers-extracted
        # sql
        sqls
        # java
        jdt-language-server
        jdk21
        # zig
        zls
        # typst
        tinymist
        # jar:// inspection
        unzip
      ];

      neovim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
        viAlias = true;
        vimAlias = true;
        configure = {
          customRC = ''
            set runtimepath^=${configDir}
            luafile ${configDir}/init.lua
          '';
          packages.my = {
            start = plugins;
            opt = [ ];
          };
        };
      };

      wrapped = pkgs.symlinkJoin {
        name = "nvim";
        paths = [ neovim ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/nvim \
            --prefix PATH : ${lib.makeBinPath runtimeBins} \
            --set KOTLIN_LSP_BIN ${kotlin-lsp}/bin/kotlin-lsp \
            --set KOTLIN_DAP_BIN ${kotlin-debug-adapter}/bin/kotlin-debug-adapter \
            --set UNZIP_BIN ${pkgs.unzip}/bin/unzip
        '';
      };
    in {
      packages.${system} = {
        nvim = wrapped;
        default = wrapped;
      };
    };
}
