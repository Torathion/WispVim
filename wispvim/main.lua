local VimVSCode = {}
package.path = package.path .. ';' .. vim.fn.stdpath('config') .. '/wispvim/?.lua'

local utils = require('utils')

function VimVSCode.run()
	print('Hello!')
	utils.safeRun(function()
		-- Check deps first for plugins. If any of them are not met, stop the build.
		require('checkDeps')()
		require('boot')()
		require('vimConfig')()
		require('loadPlugins')()
		require('hooks')()
		require('actions')()
		require('keybinds')()
		require('ui')()
		require('syntax-highlight')()
		require('intellisense')()
		require('lint')()
		require('post')()
	end)
end

return VimVSCode
