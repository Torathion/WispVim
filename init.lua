dofile(vim.fn.stdpath('config') .. '/wispvim/main.lua').run()

-- Enable syntax
vim.cmd([[
  syntax enable
  augroup Fugitive
    autocmd!
    autocmd FileType fugitive setlocal nolist
  augroup END
]])

require('neogit').setup({
	integrations = {
		diffview = true,
	},
})

require('toggleterm').setup({
	size = 20,
	open_mapping = [[<C-\>]],
	direction = 'horizontal',
})

require('barbar').setup({
	animation = true,
	auto_hide = true,
	clickable = true,
	tabpages = true,
	focus_on_close = 'left',
	highlight_visible = true,
	icons = {
		-- Configure the base icons on the bufferline.
		-- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
		buffer_index = false,
		buffer_number = false,
		button = '',
		-- Enables / disables diagnostic symbols
		diagnostics = {
			[vim.diagnostic.severity.ERROR] = { enabled = true, icon = 'ﬀ' },
			[vim.diagnostic.severity.WARN] = { enabled = false },
			[vim.diagnostic.severity.INFO] = { enabled = false },
			[vim.diagnostic.severity.HINT] = { enabled = true },
		},
		gitsigns = {
			added = { enabled = true, icon = '+' },
			changed = { enabled = true, icon = '~' },
			deleted = { enabled = true, icon = '-' },
		},
		filetype = {
			-- Sets the icon's highlight group.
			-- If false, will use nvim-web-devicons colors
			custom_colors = false,

			-- Requires `nvim-web-devicons` if `true`
			enabled = true,
		},
		separator = { left = '▎', right = '' },

		-- If true, add an additional separator at the end of the buffer list
		separator_at_end = true,

		-- Configure the icons on the bufferline when modified or pinned.
		-- Supports all the base icon options.
		modified = { button = '●' },
		pinned = { button = '', filename = true },

		-- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
		preset = 'default',

		-- Configure the icons on the bufferline based on the visibility of a buffer.
		-- Supports all the base icon options, plus `modified` and `pinned`.
		alternate = { filetype = { enabled = false } },
		current = { buffer_index = true },
		inactive = { button = '×' },
		visible = { modified = { buffer_number = false } },
	},
})
