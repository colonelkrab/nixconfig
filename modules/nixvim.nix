{pkgs, ...}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    colorschemes.catppuccin.enable = true;

    # keybindings
    keymaps = [
      {
        action = "<cmd>Telescope find_files<cr>";
        key = "ff";
      }
      {
        key = "<Up>";
        action = "";
      }
      {
        key = "<Down>";
        action = "";
      }

      {
        key = "<Left>";
        action = "";
      }

      {
        key = "<Right>";
        action = "";
      }
      {
        key = "<C-n>";
        action = "<cmd>Neotree filesystem toggle<cr>";
      }
    ];
    opts = {
      number = true;
      relativenumber = true;
      swapfile = false;
    };
    plugins = {
      web-devicons.enable = true;
      nvim-autopairs.enable = true;
      telescope.enable = true;
      neo-tree.enable = true;
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save.lsp_format = "fallback";
          formatters_by_ft = {
            nix = ["alejandra"];
            rust = ["rustfmt"];
            c = ["astyle"];
            fish = ["fish_indent"];
          };
        };
      };
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          auto_install = true;
        };
      };
      lspkind.enable = true;
      lsp-lines.enable = true;
      lsp-signature.enable = true;

      lualine = {
        enable = true;
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings.sources = [{name = "nvim_lsp";} {name = "path";} {name = "buffer";}];
      };
      lsp = {
        enable = true;
        inlayHints = true;
        servers = {
          nixd = {
            enable = true;
          };
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          clangd = {
            enable = true;
            package = null; # use clang-unrwapped and include needed files in compile-commands.json
          };
        };
      };
    };
  };
}
