{pkgs, ...}: {
  home.packages = with pkgs; [ fzf unzip clang ripgrep fd cargo clang luajit nil nodejs xclip ];
  
  programs.neovim= {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      # TODO LSPs aren connecting with the server

      #lsp and treesitter
      nvim-lspconfig
      nvim-cmp
      nvim-treesitter
      nvim-treesitter-context
      nvim-treesitter-endwise
      nvim-treesitter-refactor
      nvim-treesitter-textobjects
      indent-blankline-nvim
      nvim-comment
      vim-sleuth
      cmp-nvim-lsp
      fidget-nvim
      luasnip
      vim-nix

      # not sure about mason
      mason-lspconfig-nvim

      #git
      vim-fugitive
      vim-rhubarb
      gitsigns-nvim

      #themes and fancystuff
      onedark-nvim
      lualine-nvim
      gruvbox-material

      # telescope
      telescope-nvim
      telescope-file-browser-nvim
      plenary-nvim

      ];
      extraPackages = with pkgs; [ nil elixir-ls lua-language-server ];
    };
  
  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
