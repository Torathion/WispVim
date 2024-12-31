local comform = require('conform')

local utils = require('utils')
local config = require('config')

local autocmd = vim.api.nvim_create_autocmd

local function augroup(name) return vim.api.nvim_create_augroup(string.lower(config.Name) .. name, { clear = true }) end

local function autoSaveOnLeave(buf)
	if utils.isBufRealFile() and utils.canModify() then
		if utils.isFileModified() then
			utils.save()
			comform.format({ buf = buf })
		end
		utils.leaveMode()
	end
end

return function()
	-- Auto create dir when saving a file, in case some intermediate directory does not exist
	autocmd('BufWritePre', {
		group = augroup('auto_create_dir'),
		callback = function(event)
			if event.match:match('^%w%w+:[\\/][\\/]') then return end
			local file = vim.uv.fs_realpath(event.match) or event.match
			vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
		end,
	})

	autocmd('BufEnter', {
		group = augroup('enter_code'),
		callback = function()
			if utils.isBufRealFile() then
				utils.startInsert()
			else
				utils.leaveMode()
			end
		end,
	})

	autocmd('BufLeave', {
		pattern = '*',
		callback = function(args) autoSaveOnLeave(args.buf) end,
	})

	autocmd('WinNew', {
		callback = function()
			local popup = utils.getNewestPopup()
			-- Change focus to newest popup. Ignore notifications
			if not utils.getWinName(popup):match('nvim%-notify') then utils.changeWin(popup) end
		end,
	})

	autocmd('WinEnter', {
		pattern = '*',
		callback = function(args)
			local buf = utils.getWinBuf(args.buf)
			if buf then
				if utils.isPopup(args.buf) then utils.leaveMode() end
				if utils.canModifyWin(args.buf) then utils.startInsert() end
			end
		end,
	})

	autocmd('WinLeave', {
		pattern = '*',
		callback = function(args)
			if utils.canModifyWin(args.buf) then autoSaveOnLeave(args.buf) end
		end,
	})

	-- Resize splits when the window is resized
	autocmd('VimResized', {
		group = augroup('resize_splits'),
		callback = function()
			vim.cmd('tabdo wincmd =')
			vim.cmd('tabnext ' .. vim.fn.tabpagenr())
		end,
	})

	-- Check if we need to reload the file when it changes
	autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
		group = augroup('checktime'),
		callback = function() vim.cmd.checktime() end,
	})

	-- Highlight pasted text
	autocmd('TextYankPost', {
		group = augroup('highlight_yank'),
		callback = function() vim.highlight.on_yank() end,
	})

	autocmd('FileType', {
		group = augroup('close_with_Esc'),
		pattern = {
			'checkhealth',
			'git',
			'help',
			'lspinfo',
			'man',
			'notify',
			'qf',
			'startuptime',
		},
		callback = function(event)
			vim.bo[event.buf].buflisted = false
			vim.schedule(function()
				vim.keymap.set('n', 'Esc', function()
					vim.cmd('close')
					pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
				end, {
					buffer = event.buf,
					silent = true,
					noremap = true,
					desc = 'Close window',
				})
			end)
		end,
	})

	-- make it easier to close man-files when opened inline
	autocmd('FileType', {
		group = augroup('man_unlisted'),
		pattern = { 'man' },
		callback = function(event) vim.bo[event.buf].buflisted = false end,
	})

	-- wrap and check for spell in text filetypes
	autocmd('FileType', {
		group = augroup('wrap_spell'),
		pattern = { 'text', 'plaintex', 'typst', 'gitcommit', 'markdown' },
		callback = function()
			vim.opt_local.wrap = true
			vim.opt_local.spell = true
		end,
	})

	-- Fix conceallevel for json files
	autocmd('FileType', {
		group = augroup('json_conceal'),
		pattern = { 'json', 'jsonc', 'json5' },
		callback = function() vim.opt_local.conceallevel = 0 end,
	})

	-- Improve winbar performance
	autocmd({
		'WinScrolled', -- or WinResized on NVIM-v0.9 and higher
		'BufWinEnter',
		'CursorHold',
		'InsertLeave',
	}, {
		group = vim.api.nvim_create_augroup('barbecue.updater', {}),
		callback = function() require('barbecue.ui').update() end,
	})

	autocmd('VimEnter', {
		callback = function(data)
			local filePath = data.file
			-- Change cmd to opened file or directory
			if filePath ~= '' then
				if vim.fn.isdirectory(filePath) == 1 then
					vim.cmd.cd(filePath)
				elseif vim.fn.filereadable(filePath) == 1 then
					vim.cmd.cd(utils.dirname(filePath))
				end
				-- Open tree view
				require('nvim-tree.api').tree.open()
				require('barbecue.ui').toggle(true)
			end

			-- Automatically check for updates
			local lazy = require('lazy')
			lazy.update({
				show = true,
			})
			utils.leaveMode()
			-- Focus on top most popup
			local popup = utils.getNewestPopup()
			if popup then
				utils.changeWin(popup)
				vim.defer_fn(function() vim.api.nvim_win_close(popup, true) end, 2000)
			elseif utils.getCurrentBufProp('buftype') == '' then
				vim.cmd('normal! zz') -- Center cursor on screen
			end
		end,
	})
end
