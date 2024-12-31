local config = require('config')

local Utils = {}

Utils.isValidWinBuf = vim.api.nvim_win_is_valid
Utils.cwd = vim.loop.cwd

function Utils.mergeTable(t1, t2)
	local newTable = {}
	local seen = {}
	for _, value in ipairs(t1) do
		if not seen[value] then
			table.insert(newTable, value)
			seen[value] = true
		end
	end

	for _, value in ipairs(t2) do
		if not seen[value] then
			table.insert(newTable, value)
			seen[value] = true
		end
	end
	return newTable
end

function Utils.dirname(path) return vim.fn.fnamemodify(path, ':h') end

function Utils.isFullPath(path)
	if package.config:sub(1, 1) == '/' then
		-- For Unix-like systems, a full path starts with '/'
		return path:sub(1, 1) == '/'
	else
		-- For Windows, check if path starts with a drive letter and colon (e.g., "C:/") or a network path (e.g., "\\")
		return path:match('^[a-zA-Z]:\\') or path:match('^\\\\')
	end
end

function Utils.fileExists(path)
	local file = io.open(path, 'r')
	if file then
		file:close()
		return true
	else
		return false
	end
end

function Utils.normalizePath(path)
	-- Remove any leading/trailing whitespace and multiple slashes
	path = path:gsub('\\', '/'):gsub('//+', '/'):gsub('^%s*(.-)%s*$', '%1')

	-- Split the path into components by '/'
	local components = {}
	for component in path:gmatch('([^/]+)') do
		table.insert(components, component)
	end

	-- Normalize the path
	local normalized = {}
	for _, component in ipairs(components) do
		if component == '.' then
			-- Ignore '.' (current directory)
		elseif component == '..' then
			-- Remove the last directory if not at the root
			if #normalized > 0 then table.remove(normalized) end
		else
			-- Add the valid component to the normalized path
			table.insert(normalized, component)
		end
	end

	-- Rebuild the normalized path
	local normalizedPath = table.concat(normalized, '/')
	if Utils.isFullPath(normalizedPath) then
		return '/' .. normalizedPath
	else
		return normalizedPath
	end
end

function Utils.toFullPath(path)
	path = Utils.normalizePath(path)
	if Utils.isFullPath(path) then
		return path
	else
		return Utils.cwd() .. '/' .. path
	end
end

function Utils.removeFile(path)
	path = Utils.toFullPath(path)
	if Utils.fileExists(path) then os.remove(path) end
end

function Utils.isBufRealFile() return vim.bo.buftype ~= 'prompt' and vim.bo.buftype ~= 'nofile' end

function Utils.isFileModified() return vim.bo.modified end

function Utils.isBufferFile() return vim.bo.buftype == '' and vim.fn.bufname() ~= '' end

function Utils.getBufProp(buf, prop) return vim.api.nvim_get_option_value(prop, { buf = buf }) end

function Utils.getCurrentBufProp(option) return vim.api.nvim_get_option_value(option, { buf = vim.api.nvim_get_current_buf() }) end

function Utils.isMode(mode) return vim.fn.mode() == mode end

function Utils.canModify() return Utils.getCurrentBufProp('modifiable') end

function Utils.startInsert() vim.cmd('startinsert') end

function Utils.stopInsert() vim.cmd('stopinsert') end

function Utils.save() vim.cmd('silent! w') end

function Utils.leaveMode()
	if Utils.isMode('i') then
		Utils.stopInsert()
	else
		vim.cmd('normal! \\<Esc>')
		Utils.stopInsert()
	end
end

function Utils.isPopup(win) return vim.api.nvim_win_get_config(win).relative == 'editor' end

function Utils.getWinProp(win, prop)
	local buf = Utils.getWinBuf(win)
	if buf then
		return Utils.getBufProp(buf, prop)
	else
		return nil
	end
end

function Utils.getWinBuf(buf)
	if buf and Utils.isValidWinBuf(buf) then
		return vim.api.nvim_win_get_buf(buf)
	else
		return nil
	end
end

function Utils.getCurrentWin() return vim.api.nvim_get_current_win end

function Utils.canModifyWin(win) return Utils.getWinProp(win, 'modifiable') end

function Utils.getNewestPopup()
	local popup = nil
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if Utils.isPopup(win) then popup = win end
	end
	return popup
end

function Utils.getWinName(win)
	local buf = Utils.getWinBuf(win)
	if buf then
		return vim.api.nvim_buf_get_name(buf)
	else
		return nil
	end
end

function Utils.getWinByName(name)
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if Utils.isPopup(win) and Utils.getWinName(win):match(name) then return win end
	end
	return nil
end

function Utils.closeWin(win, time)
	vim.defer_fn(function() vim.api.nvim_win_close(win, true) end, time or 0)
end

function Utils.changeWin(win)
	-- If we change into a popup, reset to normal mode. If we don't guard the call, we won't be able to stay in insert mode while coding
	vim.api.nvim_set_current_win(win)
end

function Utils.safeRun(func)
	local ok, err = pcall(func)
	if not ok then
		local file = io.open(string.lower(config.Name) .. '_err_log.txt', 'w')
		if file then
			file:write(err .. '\n')
			file:close()
		end
	end
end

function Utils.openContextMenu()
	vim.cmd('wincmd p')
	vim.cmd('normal! \\<RightMouse>')
	require('menu').open(vim.bo.ft == 'NvimTree' and 'nvimtree' or 'default', { mouse = true, border = true })
end
return Utils
