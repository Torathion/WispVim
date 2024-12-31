local utils = require('utils')
local config = require('config')

local hl = vim.api.nvim_set_hl
local map = vim.keymap.set

return function()
	vim.cmd.colorscheme('night-owl')
	require('smear_cursor').toggle()

	local neoscroll = require('neoscroll')
	neoscroll.setup({
		hide_cursor = true, -- Keep cursor visible while scrolling
		stop_eof = false, -- Stop at end of file
		respect_scrolloff = true, -- Respect 'scrolloff' setting
		cursor_scrolls_alone = false, -- Don't scroll the cursor independently
	})

	local scrollOpts = { move_cursor = false, duration = 250, easing = 'quadratic' }

	local ScrollKeyMap = {
		['<ScrollWheelUp>'] = function() neoscroll.scroll(-0.2, scrollOpts) end,
		['<ScrollWheelDown>'] = function() neoscroll.scroll(0.2, scrollOpts) end,
	}

	for key, func in pairs(ScrollKeyMap) do
		vim.keymap.set({ 'n', 'v', 'x', 'i' }, key, func)
	end

	require('notify').setup({
		background_colour = '#000000',
	})

	-- Setup tree view
	require('nvim-tree').setup({
		update_cwd = true,
		diagnostics = {
			enable = true,
			icons = {
				hint = '',
				info = '',
				warning = '',
				error = '',
			},
		},
		update_focused_file = {
			enable = true,
			update_cwd = true,
		},
		renderer = {
			highlight_git = true,
			highlight_opened_files = 'all',
			indent_markers = { enable = true },
			icons = {
				show = {
					file = true,
					folder = true,
					folder_arrow = true,
					git = true,
				},
			},
		},
		on_attach = function(bufNr)
			local api = require('nvim-tree.api')
			local function opts(desc) return { desc = 'nvim-tree: ' .. desc, buffer = bufNr, noremap = true, silent = true, nowait = true } end

			api.config.mappings.default_on_attach(bufNr)

			map('n', '<C-Up>', api.tree.change_root_to_parent, opts('Up'))
			map('n', '?', api.tree.toggle_help, opts('Help'))
			-- Deactivate defaqult right-click behavior for nvzone/menu to attach
			map('n', '<RightMouse>', utils.openContextMenu, opts('Open context menu'))
		end,
	})

	require('barbecue').setup({
		create_autocmd = false,
	})

	-- Setup minimap
	vim.g.neominimap = {
		auto_enable = true,
		layout = 'float',
		float = {
			z_index = 10,
		},
		diagnostic = { enabled = true },
		git = {
			enabled = true,
			mode = 'line',
		},
		search = {
			enabled = true,
			mode = 'sign',
		},
		win_filter = function(winId) return winId == utils.getCurrentWin() end,
	}

	-- link NeominimapGitAddLine highlight to DiffAdd
	hl(0, 'NeominimapGitAddLine', { link = 'DiffAdd' })
	hl(0, 'NeominimapGitChangeLine', { link = 'DiffChange' })
	hl(0, 'NeominimapGitDeleteLine', { link = 'DiffDelete' })

	require('lualine').setup({
		sections = {
			lualine_a = { 'mode' },
			lualine_b = { 'branch' },
			lualine_x = { 'aerial' },
			lualine_y = {
				{
					'aerial',
					sep = '',
					colored = true,
				},
			},
		},
		options = {
			icons_enabled = true,
			theme = 'night-owl',
			globalstatus = vim.o.laststatus == 3,
			section_separators = { left = '', right = '' },
			component_separators = { left = '', right = '' },
			disabled_filetypes = { statusline = { 'dashboard', 'alpha', 'ministarter', 'snacks_dashboard' } },
		},
		extensions = { 'neo-tree', 'lazy', 'fzf' },
	})

	require('noice').setup({
		enabled = true,
		view = 'cmdline_popup',
		lsp = {
			-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
			override = {
				['vim.lsp.util.convert_input_to_markdown_lines'] = true,
				['vim.lsp.util.stylize_markdown'] = true,
				['cmp.entry.get_documentation'] = true,
			},
			progress = {
				enabled = false,
			},
		},
		routes = {
			{
				filter = {
					mode = 'i',
				},
				opts = {
					skip = true,
				},
				view = 'mini',
			},
		},
		presets = {
			bottom_search = true, -- use a classic bottom cmdline for search
			command_palette = true, -- position the cmdline and popupmenu together
			long_message_to_split = true, -- long messages will be sent to a split
			inc_rename = false, -- enables an input dialog for inc-rename.nvim
			lsp_doc_border = false, -- add a border to hover docs and signature help
		},
	})

	require('dashboard').setup({
		theme = 'hyper',
		config = {
			header = {
				'',
				'Welcome to ' .. config.Name .. '!',
				'',
			},
			shortcut = {
				{ desc = 'Open File', group = '@property', action = 'Telescope find_files', key = 'f' },
				{ desc = 'Recent Files', group = '@property', action = 'Telescope oldfiles', key = 'r' },
			},
		},
	})
end
