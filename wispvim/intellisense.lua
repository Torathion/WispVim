local utils = require('utils')

local cmp = require('blink.cmp')
local luasnip = require('luasnip')
local lspkind = require('lspkind')
local lspconfig = require('lspconfig')
local nullLS = require('null-ls')
local navic = require('nvim-navic')
local telescope = require('telescope')

-- Overarching lspconfig config
local configLSP = {
	servers = {
		cssls = {
			css = { validate = true },
			less = { validate = true },
			scss = { validate = true },
		},
		cssmodules_ls = {},
		ts_ls = {
			settings = {
				javascript = {
					format = {
						enable = false,
					},
				},
				typescript = {
					format = {
						enable = false,
					},
				},
			},
		},
		basedpyright = {
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						diagnosticsMode = 'workspace',
						useLibraryCodeForTypes = true,
					},
				},
			},
		},
		html = {},
		lua_ls = {
			settings = {
				Lua = {
					diagnostics = {
						globals = { 'vim' },
					},
					runtime = {
						version = 'LuaJIT',
						path = vim.split('package.path', ';'),
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file('', true),
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
		},
	},
}

-- Performance optimization flags for lsp servers
local serverConfig = {
	debounce_text_changes = 150,
	allow_incremental_sync = true,
}

-- List of files to only enable cmp there
local allowedFiles = {
	'html',
	'css',
	'scss',
	'less',
	'javascript',
	'typescript',
	'jsx',
	'tsx',
	'vue',
	'json',
	'yaml',
	'xml',
	'python',
}

-- All active providers by default
local defaultCmpProviders = { 'lsp', 'path', 'luasnip', 'snippets', 'buffer' }

local function onAttach(client, bufnr)
	local bufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, bufopts)

	local caps = client.server_capabilities
	caps.documentFormattingProvider = false
	caps.documentRangeFormattingProvider = false
	if caps.documentSymbolProvider then navic.attach(client, bufnr) end
end

local function configureLspConfig()
	for server, config in pairs(configLSP.servers) do
		-- Get base capabilities
		config.capabilities = cmp.get_lsp_capabilities(config.capabilities or vim.lsp.protocol.make_client_capabilities())
		-- Enable snipport support manually
		config.capabilities.textDocument.completion.completionItem.snippetSupport = true
		config.on_attach = onAttach
		config.flags = serverConfig
		if server == 'ts_ls' then
			config.filetypes = {
				'javascript',
				'javascriptreact',
				'typescript',
				'typescriptreact',
				'jsx',
				'tsx',
				'vue',
			}
			config.root_dir = lspconfig.util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git')
		elseif server == 'lua_ls' then
			config.filetypes = { 'lua' }
		elseif server == 'cssls' then
			config.filetypes = { 'css', 'scss', 'less' }
		elseif server == 'cssmodules_ls' then
			config.filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' }
		end
		lspconfig[server].setup(config)
	end
end

local function shouldCmpBeEnabled() return not vim.tbl_contains(allowedFiles, vim.bo.filetype) and utils.isBufRealFile() and vim.b.completion ~= false end

local extensions = { 'fzf', 'dap', 'ui-select', 'frecency' }

local function loadTelescopeExtensions()
	for _, ext in ipairs(extensions) do
		telescope.load_extension(ext)
	end
end

return function()
	require('luasnip.loaders.from_vscode').lazy_load()
	cmp.setup({
		enabled = shouldCmpBeEnabled,
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = 'mono',
		},
		completion = {
			accept = { auto_brackets = { enabled = true } },
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 500,
				treesitter_highlighting = true,
				window = {
					border = 'rounded',
					scrollbar = true,
				},
			},
			ghost_text = { enabled = true },
			keyword = {
				range = 'full',
			},
			list = {
				selection = function(ctx) return ctx.mode == 'cmdline' and 'auto_insert' or 'preselect' end,
			},
			menu = {
				auto_show = function(ctx) return ctx.mode ~= 'cmdline' end,
				border = 'rounded',
				cmdline_position = function()
					if vim.g.ui_cmdline_pos ~= nil then
						local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
						return { pos[1] - 1, pos[2] }
					end
					local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
					return { vim.o.lines - height, 0 }
				end,
				draw = {
					columns = {
						{ 'item_idx' },
						{ 'kind_icon', 'label', gap = 1 },
						{ 'kind' },
					},
					components = {
						item_idx = {
							text = function(ctx) return ctx.idx == 10 and '0' or ctx.idx >= 10 and ' ' or tostring(ctx.idx) end,
							highlight = 'BlinkCmpItemIdx', -- optional, only if you want to change its color
						},
						kind_icon = {
							text = function(item) return (lspkind.symbolic(item.kind, { mode = 'symbol' }) or '') .. ' ' end,
							highlight = 'CmpItemKind',
						},
						label = {
							text = function(item) return item.label end,
							highlight = 'CmpItemAbbr',
						},
						kind = {
							text = function(item) return item.kind end,
							highlight = 'CmpItemKind',
						},
					},
					treesitter = { 'lsp' },
				},
			},
		},
		keymap = {
			preset = 'default',
			['<A-1>'] = { function(cmp) cmp.accept({ index = 1 }) end },
			['<A-2>'] = { function(cmp) cmp.accept({ index = 2 }) end },
			['<A-3>'] = { function(cmp) cmp.accept({ index = 3 }) end },
			['<A-4>'] = { function(cmp) cmp.accept({ index = 4 }) end },
			['<A-5>'] = { function(cmp) cmp.accept({ index = 5 }) end },
			['<A-6>'] = { function(cmp) cmp.accept({ index = 6 }) end },
			['<A-7>'] = { function(cmp) cmp.accept({ index = 7 }) end },
			['<A-8>'] = { function(cmp) cmp.accept({ index = 8 }) end },
			['<A-9>'] = { function(cmp) cmp.accept({ index = 9 }) end },
			['<A-0>'] = { function(cmp) cmp.accept({ index = 10 }) end },
			['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
			['<C-e>'] = { 'hide', 'fallback' },
			['<Up>'] = { 'select_prev', 'fallback' },
			['<Down>'] = { 'select_next', 'fallback' },
			['<CR>'] = { 'accept', 'fallback' },
			['<Tab>'] = {
				function(ctx) return ctx.select_next() end,
				'snippet_forward',
				'fallback',
			},
			['<S-Tab>'] = {
				function(ctx) return ctx.select_prev() end,
				'snippet_backward',
				'fallback',
			},
			['<C-p>'] = { 'select_prev', 'fallback' },
			['<C-n>'] = { 'select_next', 'fallback' },
			['<C-up>'] = { 'scroll_documentation_up', 'fallback' },
			['<C-down>'] = { 'scroll_documentation_down', 'fallback' },
		},
		signature = {
			enabled = true,
			window = {
				border = 'rounded',
			},
		},
		snippets = {
			expand = function(snippet) luasnip.lsp_expand(snippet) end,
			active = function(filter)
				if filter and filter.direction then return luasnip.jumpable(filter.direction) end
				return luasnip.in_snippet()
			end,
			jump = function(direction) luasnip.jump(direction) end,
		},
		sources = {
			default = function()
				local success, node = pcall(vim.treesitter.get_node)
				if not success or not node then return defaultCmpProviders end
				local tab = { 'buffer' }
				if vim.tbl_contains({ 'comment', 'line_comment', 'block_comment' }, node:type()) then return tab end
				if vim.tbl_contains({ 'markdown' }, node:type()) then return utils.mergeTable(tab, { 'markdown' }) end
				return defaultCmpProviders
			end,
			cmdline = {}, -- Disable sources for command-line mode
			providers = {
				lsp = {
					min_keyword_length = 2, -- Number of characters to trigger porvider
					score_offset = 0, -- Boost/penalize the score of the items
					module = 'blink.cmp.sources.lsp',
				},
				path = {
					min_keyword_length = 0,
				},
				snippets = {
					should_show_items = function(ctx) return ctx.trigger.initial_kind ~= 'trigger_character' end,
					min_keyword_length = 2,
				},
				buffer = {
					min_keyword_length = 5,
					max_items = 5,
				},
				markdown = {
					name = 'RenderMarkdown',
					module = 'render-markdown.integ.blink',
				},
			},
		},
	})

	configureLspConfig()

	vim.diagnostic.config({ virtual_text = false })
	require('tiny-inline-diagnostic').setup({
		preset = 'modern',
		options = {
			throttle = 100,
			enable_on_insert = true,
			multiple_diag_under_cursor = true,
			show_all_diags_on_cursorline = true,
			multilines = {
				enabled = true,
				always_show = true,
			},
		},
	})

	-- Additional UI stuff
	require('mason').setup({
		ui = {
			border = 'rounded',
			icons = {
				package_installed = '✓',
				package_pending = '➜',
				package_uninstalled = '✗',
			},
		},
	})

	require('mason-lspconfig').setup({
		ensure_installed = { 'ast_grep', 'eslint', 'basedpyright', 'lua_ls', 'jsonls' },
		automatic_installation = true,
	})

	require('lspsaga').setup({
		ui = {
			border = 'rounded',
			winblend = 10,
		},
	})

	require('lsp_signature').setup({
		bind = true,
		handler_opts = {
			border = 'rounded',
		},
	})

	nullLS.setup({
		sources = {
			nullLS.builtins.formatting.prettier,
			nullLS.builtins.formatting.black,
			nullLS.builtins.formatting.stylua.with({
				extra_args = { '--config-path', '~/.stylua.toml' },
			}),
			require('none-ls.diagnostics.eslint'),
		},
	})

	-- Quick actions
	require('nvim-lightbulb').setup({
		action_kinds = { 'quickfix', 'refactor.rewrite' },
		code_lenses = true,
		float = {
			enabled = true,
			win_opts = {
				focusable = true,
			},
		},
		status_text = {
			enabled = true,
			text_unavailable = 'Unable to retrieve code actions',
		},
		line = { enabled = true },
		autocmd = { enabled = true },
		ignore = { actions_without_kind = true },
	})

	require('illuminate').configure({
		should_enable = utils.isBufRealFile,
	})

	local actions = require('telescope.actions')
	local trouble = require('trouble.sources.telescope')

	telescope.setup({
		defaults = {
			prompt_prefix = ' ',
			selection_caret = ' ',
			path_display = { 'smart' },
			mappings = {
				i = {
					['<C-n>'] = actions.cycle_history_next,
					['<C-p>'] = actions.cycle_history_prev,
					['<C-j>'] = actions.move_selection_next,
					['<C-k>'] = actions.move_selection_previous,
					['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
					['<C-t>'] = trouble.open,
					['<C-c>'] = actions.close,
				},
				n = {
					['<C-t>'] = trouble.open,
					['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
				},
			},
		},
		pickers = {
			find_files = {
				theme = 'dropdown',
			},
			live_grep = {
				theme = 'ivy',
			},
			buffers = {
				theme = 'dropdown',
				previewer = false,
			},
			help_tags = {
				theme = 'ivy',
			},
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = 'smart_case',
			},
			-- Integrate with DAP if debugging tools are installed
			['dap'] = {
				configurations = {
					{
						name = 'Python',
						type = 'python',
						request = 'launch',
						program = '${file}',
					},
				},
			},
		},
	})

	loadTelescopeExtensions()
end
