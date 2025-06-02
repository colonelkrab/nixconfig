{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.nixvim = {
    enable = true;
    colorschemes.catppuccin.enable = true;
    keymaps = [
      {
        action = "<cmd>Telescope find_files<CR>";
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
    ];
    plugins = {
      web-devicons.enable = true;
      nvim-autopairs.enable = true;
      telescope.enable = true;
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save.lsp_format = "fallback";
          formatters_by_ft = {
            nix = ["alejandra"];
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
        };
      };
    };
  };
}
