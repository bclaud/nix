{pkgs, ...}: {
  home.packages = with pkgs; [ fzf unzip clang ripgrep fd cargo clang luajit nil nodejs xclip gnumake ];

  home.sessionVariables = {
    EDITOR="nvim";
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      # TODO LSPs aren connecting with the server

      #lsp and treesitter
      nvim-lspconfig
      nvim-cmp
      nvim-treesitter.withAllGrammars
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
      elixir-tools-nvim

      nvim-autopairs

      # not sure about mason
      #mason-lspconfig-nvim

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

      #File explorer and navigation
      oil-nvim
      grapple-nvim

      nvim-web-devicons
    ];

    extraPackages = with pkgs; [ nil elixir-ls lua-language-server basedpyright zls];
  };

  xdg.configFile."nvim/init.lua".text = ''
  -- [[ Setting options ]]
  -- See `:help vim.o`
  -- personal configs
  vim.o.relativenumber = true
  vim.o.scrolloff = 10

  -- make paste persistant
  vim.keymap.set("x", "<leader>p", "\"_dP")

  -- yank to registry
  vim.keymap.set("n", "<leader>y", "\"+y")
  vim.keymap.set("v", "<leader>y", "\"+y")
  vim.keymap.set("n", "<leader>y", "\"+Y")

  vim.keymap.set("n", "Q", "<nop>")

  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  -- Set highlight on search
  vim.o.hlsearch = false

  vim.opt.clipboard = 'unnamedplus'

  -- Make line numbers default
  vim.wo.number = true

  -- Enable mouse mode
  vim.o.mouse = 'a'

  -- Enable break indent
  vim.o.breakindent = true

  -- Save undo history
  vim.o.undofile = true

  -- Case insensitive searching UNLESS /C or capital in search
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Decrease update time
  vim.o.updatetime = 250
  vim.wo.signcolumn = 'yes'

  -- Set colorscheme
  vim.o.termguicolors = true
  vim.cmd [[colorscheme onedark]]

  -- Set completeopt to have a better completion experience
  vim.o.completeopt = 'menuone,noselect'

  -- [[ Basic Keymaps ]]
  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  -- Keymaps for better default experience
  -- See `:help vim.keymap.set()`
  vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

  -- Remap for dealing with word wrap
  vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
  vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

  -- [[ Highlight on yank ]]
  -- See `:help vim.highlight.on_yank()`
  local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
    vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
  })

  -- Set lualine as statusline
  -- See `:help lualine.txt`
  require('lualine').setup {
    options = {
      icons_enabled = false,
      component_separators = '|',
      section_separators = "",
    },
  }

  -- Enable Comment.nvim NOT WORKING
  -- require('Comment').setup()

  -- Enable `lukas-reineke/indent-blankline.nvim`
  -- For version 3, see :help ibl.setup()
  -- See `:help indent_blankline.txt`
  require("ibl").setup()
  
  -- Gitsigns
  -- See `:help gitsigns.txt`
  require('gitsigns').setup {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  }
  
  -- [[ Configure Autopairs ]]
  require('nvim-autopairs').setup()

  -- [[ Configure Telescope ]]
  -- See `:help telescope` and `:help telescope.setup()`
  require('telescope').setup {
    defaults = {
      mappings = {
        i = {
          ['<C-u>'] = false,
          ['<C-d>'] = false,
        },
      },
    },
  }

  -- OIL NVIM
  require("oil").setup()
  vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

  -- Grapple
  vim.keymap.set("n", "<leader>m", require("grapple").toggle)
  vim.keymap.set("n", "<leader>M", "<cmd>Telescope grapple tags<cr>")

  -- User command
  vim.keymap.set("n", "<leader>1", "<cmd>Grapple select index=1<cr>")
  require("telescope").load_extension("grapple")

  -- Enable telescope fzf native, if installed
  pcall(require('telescope').load_extension, 'fzf')

  -- See `:help telescope.builtin`
  vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
  end, { desc = '[/] Fuzzily search in current buffer]' })

  vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

  -- [[ Configure Treesitter ]]
  -- See `:help nvim-treesitter`
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<c-backspace>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }

  -- Diagnostic keymaps
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)


  --  This function gets run when an LSP connects to a particular buffer.
  local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
  if desc then
  desc = 'LSP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  if vim.lsp.buf.format then
  vim.lsp.buf.format()
  elseif vim.lsp.buf.formatting then
  vim.lsp.buf.formatting()
  end
  end, { desc = 'Format current buffer with LSP' })
  end


  -- Turn on lsp status information
  require('fidget').setup()

  -- Example custom configuration for lua
  --
  -- Make runtime files discoverable to the server
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, 'lua/?.lua')
  table.insert(runtime_path, 'lua/?/init.lua')

  -- nvim-cmp setup
  local cmp = require 'cmp'
  local luasnip = require 'luasnip'

  cmp.setup {
    snippet = {
      expand = function(args)
      luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ['<C-y>'] = cmp.mapping.confirm { select = true },
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
      cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
      luasnip.expand_or_jump()
      else
      fallback()
      end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
      cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
      else
      fallback()
      end
      end, { 'i', 's' }),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
    },
  }

  local cmp_autopairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
    )

  local capabilities = require('cmp_nvim_lsp').default_capabilities()


  local lspc = require'lspconfig'

  lspc.nil_ls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
  }

  elixirls = require("elixir.elixirls")

  require("elixir").setup({
    nextls = {enable = false},
    credo = {enable = false},
    elixirls = {
      enable = true,
      cmd = { "${pkgs.elixir-ls}/bin/elixir-ls" },
      settings = elixirls.settings {
        dialyzerEnabled = true,
        fetchDeps = false,
        enableTestLenses = true,
        suggestSpecs = true,
      },
      on_attach = on_attach,
      capabilities = capabilities,
    },
  })
  
  lspc.gleam.setup{}

  lspc.ocamllsp.setup{
    on_attach = on_attach,
    capabilities = capabilities,
  }

  lspc.lua_ls.setup{
    cmd = { "${pkgs.lua-language-server}/bin/lua_language_server" },
    on_attach = on_attach,
    capabilities = capabilities,
  }

  lspc.basedpyright.setup{
    cmd = { "${pkgs.basedpyright}/bin/basedpyright-langserver", "--stdio" },
    on_attach = on_attach,
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = "standard"
        }
      }
    }
  }

  lspc.zls.setup{
    on_attach = on_attach,
  }
  '';
}
