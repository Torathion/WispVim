return function()
	-- ALE config
	vim.g.ale_enabled = 1
	vim.g.ale_fix_on_save = 1
	vim.g.ale_sign_column_always = 1
	vim.g.ale_lint_on_insert_leave = 1
	vim.g.ale_echo_cursor = 1
	vim.g.ale_set_highlights = 1
	vim.g.ale_virtualtext_cursor = 1
	vim.g.ale_virtualtext_prefix = '✎ '
	vim.g.ale_sign_error = '✗'
	vim.g.ale_sign_warning = '⚠'
	vim.g.ale_lint_delay = 500
	vim.g.ale_completion_enabled = 1
	vim.g.ale_linters = {
		python = { 'flake8', 'pylint' },
		javascript = { 'eslint' },
		lua = { 'luacheck' },
		css = { 'stylelint' },
		html = { 'tidy' },
		arkdown = { 'markdownlint' },
	}

	local jsFixers = { 'eslint', 'prettier' }

	vim.g.ale_fixers = {
		python = { 'black', 'isort' },
		javascript = jsFixers,
		typescript = jsFixers,
		lua = { 'stylua' },
		css = { 'prettier', 'stylelint' },
		html = { 'prettier', 'tidy' },
		markdown = { 'prettier', 'markdownlint' },
	}

	-- Enable formatter
	local WebOpts = { 'prettier' }
	require('conform').setup({
		formatters_by_ft = {
			lua = { 'stylua' },
			python = { 'isort', 'black' },
			javascript = WebOpts,
			typescript = WebOpts,
			html = WebOpts,
		},
		format_after_save = {
			async = true,
			enabled = true,
			timeout_ms = 500,
			lsp_format = 'fallback',
			silent = true,
		},
	})
end
