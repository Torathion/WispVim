return function()
	-- Frequently referenced plugins
	local treeSitter = 'nvim-treesitter/nvim-treesitter'
	local luaCore = 'nvim-lua/plenary.nvim'
	local icons = 'nvim-tree/nvim-web-devicons'
	local miniIcons = 'echasnovski/mini.icons'
	local uiCore = 'MunifTanjim/nui.nvim'
	local telescope = 'nvim-telescope/telescope.nvim'
	require('lazy').setup({
		luaCore, -- Core library for lua plugins
		uiCore, -- Component library for visual plugins
		miniIcons, -- Additional icons
		icons, -- Icons for everything
		'echasnovski/mini.nvim', -- Library for mini plugins
		'nvzone/volt', -- Library for nvzone ui plugins
		'airblade/vim-gitgutter', -- Git integration
		'tpope/vim-fugitive', -- Additional git tools
		'williamboman/mason.nvim', -- LSP server manager
		'karb94/neoscroll.nvim', -- Smooth scrolling
		'mfussenegger/nvim-dap', -- Debug Adapter Protocol client
		'akinsho/toggleterm.nvim', -- Integrated terminal window
		'lewis6991/gitsigns.nvim', -- Git diff decorations
		'sindrets/diffview.nvim', -- Git diff viewer
		'dense-analysis/ale', -- Asynchonous Linter Engine
		'farmergreg/vim-lastplace', -- Reopens files at that position you left them
		'stevearc/dressing.nvim', -- General UI beautification
		'stevearc/stickybuf.nvim', -- Fix floating window issques
		'rcarriga/nvim-notify', -- Notification toasts
		'folke/neoconf.nvim', -- Project settings manager
		'folke/twilight.nvim', -- Dims inactive parts of code
		'folke/zen-mode.nvim', -- Distraction free coding
		'rafamadriz/friendly-snippets', -- Snippets collection for neovim
		'onsails/lspkind.nvim', -- Intellisense icons
		'nvimtools/none-ls-extras.nvim', -- Extra diagnostics and tools for none-ls
		'HiPhish/rainbow-delimiters.nvim', -- Rainbow brackets
		'mg979/vim-visual-multi', -- Multi cursor plugin
		'sphamba/smear-cursor.nvim', -- Cursor animation,
		'RRethy/vim-illuminate', -- Highlight occurrences
		'ap/vim-css-color', -- CSS color colorizer
		'mattn/emmet-vim', -- EMMET abbreviations for HTML
		'nvzone/menu', -- Context menu
		'echasnovski/mini.surround', -- Selection char surrounding
		{
			'oxfist/night-owl.nvim', -- VSCode NightOwl theme
			lazy = false,
			priority = 999,
		},
		{
			'rachartier/tiny-inline-diagnostic.nvim',
			event = 'LspAttach',
			priority = 1000,
			config = true,
		},
		{
			'folke/noice.nvim',
			event = 'VeryLazy',
			dependencies = {
				uiCore,
				'rcarriga/nvim-notify',
			},
			keys = {
				{ '<leader>sn', '', desc = '+noice' },
				{
					'<S-Enter>',
					function() require('noice').redirect(vim.fn.getcmdline()) end,
					mode = 'c',
					desc = 'Redirect Cmdline',
				},
				{
					'<leader>snl',
					function() require('noice').cmd('last') end,
					desc = 'Noice Last Message',
				},
				{
					'<leader>snh',
					function() require('noice').cmd('history') end,
					desc = 'Noice History',
				},
				{
					'<leader>sna',
					function() require('noice').cmd('all') end,
					desc = 'Noice All',
				},
				{
					'<leader>snd',
					function() require('noice').cmd('dismiss') end,
					desc = 'Dismiss All',
				},
				{
					'<leader>snt',
					function() require('noice').cmd('pick') end,
					desc = 'Noice Picker (Telescope/FzfLua)',
				},
				{
					'<c-f>',
					function()
						if not require('noice.lsp').scroll(4) then return '<c-f>' end
					end,
					silent = true,
					expr = true,
					desc = 'Scroll Forward',
					mode = { 'i', 'n', 's' },
				},
				{
					'<c-b>',
					function()
						if not require('noice.lsp').scroll(-4) then return '<c-b>' end
					end,
					silent = true,
					expr = true,
					desc = 'Scroll Backward',
					mode = { 'i', 'n', 's' },
				},
			},
			config = function(_, opts)
				-- noice shows messages from before it was enabled, but this is not ideal when Lazy is installing plugins, so clear all noice messages.
				if vim.o.filetype == 'lazy' then vim.cmd([[messages clear]]) end
				require('noice').setup(opts)
			end,
		},

		{
			'f-person/git-blame.nvim', -- Git blame to show who wrote the code
			event = 'VeryLazy',
			opts = {
				enabled = true,
				message_template = ' <summary> • <date> • <author> • <<sha>>',
				date_format = '%m-%d-%Y %H:%M:%S',
				virtual_text_column = 1,
			},
		},
		{
			'folke/trouble.nvim', -- Error and warning list view
			event = 'InsertEnter',
			cmd = 'Trouble',
			keys = {
				{
					'<leader>xx',
					'<cmd>Trouble diagnostics toggle<cr>',
					desc = 'Diagnostics (Trouble)',
				},
				{
					'<leader>xX',
					'<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
					desc = 'Buffer Diagnostics (Trouble)',
				},
				{
					'<leader>cs',
					'<cmd>Trouble symbols toggle focus=false<cr>',
					desc = 'Symbols (Trouble)',
				},
				{
					'<leader>cl',
					'<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
					desc = 'LSP Definitions / references / ... (Trouble)',
				},
				{
					'<leader>xL',
					'<cmd>Trouble loclist toggle<cr>',
					desc = 'Location List (Trouble)',
				},
				{
					'<leader>xQ',
					'<cmd>Trouble qflist toggle<cr>',
					desc = 'Quickfix List (Trouble)',
				},
			},
		},
		{
			'folke/flash.nvim', -- String finder in code
			event = 'VeryLazy',
		},
		{
			'folke/edgy.nvim', -- Window layout manager
			event = 'VeryLazy',
		},
		{
			'folke/persistence.nvim', -- Session Manager
			event = 'BufReadPre',
		},
		{
			'folke/ts-comments.nvim',
			event = 'VeryLazy',
		},
		{
			'kosayoda/nvim-lightbulb',
			event = 'VeryLazy',
		},
		{
			'windwp/nvim-autopairs', -- Automatically closes pairs and more
			event = 'InsertEnter',
			config = true,
		},
		{
			'windwp/nvim-ts-autotag',
			event = 'InsertEnter',
			config = true,
			dependencies = treeSitter,
		},
		{
			'tpope/vim-commentary', -- Adds ability to comment out stuff
			event = 'InsertEnter',
		},
		{
			'Isrothy/neominimap.nvim',
			enabled = true,
			lazy = false,
		},
		{
			'nvim-lualine/lualine.nvim', -- Bottom status bar
			dependencies = icons,
			init = function()
				vim.g.lualine_laststatus = vim.o.laststatus
				if vim.fn.argc(-1) > 0 then
					-- set an empty statusline till lualine loads
					vim.o.statusline = ' '
				else
					-- hide the statusline on the starter page
					vim.o.laststatus = 0
				end
			end,
		},
		{
			'ibhagwan/fzf-lua', -- FZF in nvim
			dependencies = icons,
		},
		{
			'lukas-reineke/indent-blankline.nvim', -- Indentation marker
			main = 'ibl',
		},
		{
			'echasnovski/mini.pick', -- Picker dialog window
			dependencies = miniIcons,
		},
		{
			treeSitter, -- Syntax highlighting
			build = ':TSUpdate',
		},
		{
			'nvim-treesitter/nvim-treesitter-textobjects', -- Syntax aware text object highlighting
			dependencies = treeSitter,
		},
		{
			'RRethy/nvim-treesitter-textsubjects', -- Semantic text object highlighting
			dependencies = treeSitter,
		},
		{
			'RRethy/nvim-treesitter-endwise',
			dependencies = treeSitter,
		},
		{
			's1n7ax/nvim-window-picker', -- Window pick prompt
			name = 'window-picker',
			event = 'VeryLazy',
		},
		{
			'MeanderingProgrammer/render-markdown.nvim',
			dependencies = {
				treeSitter,
				'echasnovski/mini.nvim',
			},
		},
		{
			'nvim-tree/nvim-tree.lua',
			lazy = false,
			depndencies = icons,
		},
		{
			'nvimdev/lspsaga.nvim', -- LSP improvements
			dependencies = {
				treeSitter,
				icons,
			},
		},
		{
			'neovim/nvim-lspconfig', -- Repo providing lsp clients
			dependencies = 'saghen/blink.cmp',
		},
		{
			'williamboman/mason-lspconfig.nvim', -- Extra config for Mason
			dependencies = {
				'williamboman/mason.nvim',
				'neovim/nvim-lspconfig',
			},
		},
		{
			telescope, -- Fuzzy File Finder
			dependencies = luaCore,
		},
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			dependencies = {
				luaCore,
				telescope,
			},
			build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release',
		},
		{
			'nvim-telescope/telescope-dap.nvim',
			dependencies = {
				luaCore,
				telescope,
				treeSitter,
			},
		},
		{
			'nvim-telescope/telescope-frecency.nvim',
			dependencies = { luaCore, telescope },
		},
		{
			'nvim-telescope/telescope-ui-select.nvim',
			dependencies = { luaCore, telescope },
		},
		{
			'romgrk/barbar.nvim', -- File tab par
			dependencies = {
				'lewis6991/gitsigns.nvim',
				icons,
			},
		},
		{
			'NeogitOrg/neogit', -- Git UI
			dependencies = {
				luaCore,
				'sindrets/diffview.nvim',
				'nvim-telescope/telescope.nvim',
				'ibhagwan/fzf-lua',
				'echasnovski/mini.pick',
			},
		},
		{
			'iamcco/markdown-preview.nvim', -- Markdown preview window
			cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
			build = 'cd app && pnpm install',
			ft = { 'markdown' },
		},
		{
			'nvim-neorg/neorg', -- Organization scripting engine
			event = 'VeryLazy',
			ft = 'norg',
		},
		{
			'dstein64/vim-startuptime', -- Measure startup time
			cmd = 'StartupTime',
		},
		{
			'L3MON4D3/LuaSnip', -- Snippet engine
			build = 'make install_jsregexp',
			dependencies = 'rafamadriz/friendly-snippets',
		},
		{
			'saghen/blink.cmp',
			dependencies = {
				'rafamadriz/friendly-snippets',
				miniIcons,
			},
			build = 'cargo +nightly build --release',
		},
		{
			'ray-x/lsp_signature.nvim',
			event = 'VeryLazy',
		},
		{
			'nvimtools/none-ls.nvim',
			dependencies = 'nvimtools/none-ls-extras.nvim',
		},
		{
			'stevearc/conform.nvim',
			event = 'BufWritePre',
			log_level = vim.log.levels.DEBUG,
			keys = {
				{
					-- Customize or remove this keymap to your liking
					'<C-S-f>',
					function() require('conform').format({ async = true }) end,
					mode = '',
					desc = 'Format buffer',
				},
			},
		},
		{
			'Wansmer/treesj',
			keys = { '<space>m', '<space>j', '<space>s' },
			dependencies = treeSitter,
		},
		{
			'monaqa/dial.nvim', -- Easy semver incrementing and decrementing
			keys = { '<C-a>', { '<C-x>', mode = 'n' } },
		},
		{
			'nvimdev/dashboard-nvim',
			event = 'VimEnter',
			dependencies = icons,
		},
		{
			'SmiteshP/nvim-navic', -- LSP aware winbar component
			dependencies = 'neovim/nvim-lspconfig',
		},
		{
			'utilyre/barbecue.nvim', -- VSCode like winbar
			dependencies = {
				'SmiteshP/nvim-navic',
				icons,
			},
		},
		{
			'nvzone/menu',
			dependencies = 'nvzone/volt',
		},
		{
			'vidocqh/auto-indent.nvim',
			config = true,
		},
		install = {
			colorscheme = 'habamax',
		},
		defaults = {
			lazy = true,
		},
		checker = {
			enabled = true,
		},
		ui = {
			border = 'rounded',
		},
	})
end
