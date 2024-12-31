local utils = require('utils')
local config = require('config')

-- Post initializing and cleanup steps
return function()
	-- Delete error log, if it exists
	utils.removeFile('./' .. string.lower(config.Name) .. '_err_log.txt')
end
