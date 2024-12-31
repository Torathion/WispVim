local allDeps = true

local function isInstalled(command)
	local handle = io.popen(command .. ' --version 2>/dev/null')
	if not handle then return false end
	local result = handle:read('*a')
	handle:close()
	return #result > 0 -- If output is non-empty, the command is likely installed
end
local function checkCommand(command)
	local output = vim.fn.system(command)
	allDeps = vim.v.shell_error == 0
	return allDeps, output
end

local tools = { 'rustup', 'cargo', 'node', 'cmake' }

local function checkTools()
	for _, tool in ipairs(tools) do
		if not isInstalled(tool) then error(tool .. 'is not installed!') end
	end
end

return function()
	checkTools()
	local nightly, nightlyOutput = checkCommand('rustup show')
	if not nightly and not nightlyOutput:find('nightly') then error('Nightly (rust) is not installed!') end

	return allDeps
end
