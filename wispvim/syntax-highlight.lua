local ibl = require('ibl')

return function()
	require('nvim-treesitter.install').update({ with_sync = true })
	require('nvim-treesitter.configs').setup({
		ensure_installed = 'all',
		auto_install = true,
		sync_install = false,
		highlight = { enable = true },
		indent = { enable = true },
		endwise = { enable = true },
		textsubjects = {
			enable = true,
			prev_selection = '-',
			keymaps = {
				[','] = 'textsubjects-smart',
				['.'] = 'textsubjects-container-outer',
				['i;'] = { 'textsubjects-container-inner', desc = 'Select inside containers (classes, functions, etc.)' },
			},
		},
	})

	local highlight = {
		'RainbowYellow',
		'RainbowViolet',
		'RainbowBlue',
	}

	ibl.setup({
		whitespace = {
			remove_blankline_trail = false,
		},
		scope = {
			enabled = true,
		},
	})
	vim.g.rainbow_delimiters = { highlight = highlight }
	local hooks = require('ibl.hooks')
	hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
end
