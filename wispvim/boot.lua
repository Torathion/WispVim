local function bootMiniNvim()
	local path_package = vim.fn.stdpath('data') .. '/site'
	local mini_path = path_package .. '/pack/deps/start/mini.nvim'
	if not vim.loop.fs_stat(mini_path) then
		vim.cmd('echo "Installing `mini.nvim`" | redraw')
		local clone_cmd = {
			'git',
			'clone',
			'--filter=blob:none',
			'--branch',
			'stable',
			'https://github.com/echasnovski/mini.nvim',
			mini_path,
		}
		vim.fn.system(clone_cmd)
		vim.cmd('packadd mini.nvim | helptags ALL')
	end
end

local function bootLazy()
	local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
		local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
		local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
		if vim.v.shell_error ~= 0 then
			vim.api.nvim_echo({
				{ 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
				{ out, 'WarningMsg' },
				{ '\nPress any key to exit...' },
			}, true, {})
			vim.fn.getchar()
			os.exit(1)
		end
	end
	vim.opt.rtp:prepend(lazypath)
end

return function()
	bootMiniNvim()
	bootLazy()
end
