local utils = require('utils')

local silentOpts = { noremap = true, silent = true }
local visualModes = { 'n', 'v' }
local allModes = { 'n', 'v', 'x', 'i' }
local map = vim.keymap.set
local feed = vim.api.nvim_feedkeys
local replaceTermCodes = vim.api.nvim_replace_termcodes

local function cmd(command) return table.concat({ '<Cmd>', command, '<CR>' }) end

return function()
	-- Copy (Ctrl+C)
	map(visualModes, '<C-c>', '"+y', silentOpts) -- Copy to clipboard
	map('i', '<C-c>', '<Esc>"+y', silentOpts) -- Copy current line in insert mode

	-- Cut (Ctrl+X)
	map('v', '<C-x>', '"+d', silentOpts) -- Cut to clipboard
	map('i', '<C-x>', '<Esc>"+d', silentOpts) -- Cut current line in insert mode

	-- Paste (Ctrl+V)
	map(visualModes, '<C-v>', '"+p', silentOpts) -- Paste from clipboard in normal/visual mode
	map('i', '<C-v>', '<Esc>"+p', silentOpts)

	-- Undo (Ctrl+Z)
	map('n', '<C-z>', 'u', silentOpts) -- Undo in normal mode
	map('i', '<C-z>', '<C-o>u', silentOpts) -- Redo in insert mode (temporarily change to normal mode)

	-- Redo (Ctrl+Y)
	map('n', '<C-y>', '<C-r>', silentOpts) -- Redo in normal and insert mode
	map('i', '<C-y>', '<C-o><C-r>', silentOpts) -- Redo in insert mode (temporarily change to normal mode)

	-- Save (Ctrl+S)
	map(visualModes, '<C-s>', ':w<CR>', silentOpts) -- Save in visual modes
	map('i', '<C-s>', '<C-o>:w<CR>', silentOpts) -- Save in insert mode

	-- Select All (Ctrl+A)
	map(visualModes, '<C-a>', 'ggVG', silentOpts) -- Select the entire buffer
	map('i', '<C-a>', '<Esc>ggVG', silentOpts) -- Select all from insert mode

	-- Delete code and selections like in insert mode
	map(visualModes, '<BS>', 'x', silentOpts)

	-- Move lines up and down
	map('n', '<A-Down>', cmd('m .+1'), silentOpts)
	map('n', '<A-Up>', cmd('m .-2'), silentOpts)
	map('i', '<A-Down>', '<C-o>:m .+1<CR>', silentOpts)
	map('i', '<A-Up>', '<C-o>:m .-2<CR>', silentOpts)
	map('v', '<A-Down>', ":m '>+1<CR>gv=gv", silentOpts)
	map('v', '<A-Up>', ":m '<-2<CR>gv=gv", silentOpts)

	map('v', '"', function() feed('sa"', 'v', true) end, silentOpts) -- Surround with double quotes
	map('v', "'", function() feed("sa'", 'v', true) end, silentOpts) -- Surround with single quotes
	map('v', '(', function() feed('sa(', 'v', true) end, silentOpts) -- Surround with parentheses
	map('v', '{', function() feed('sa{', 'v', true) end, silentOpts) -- Surround with curly braces
	map('v', '[', function() feed('sa[', 'v', true) end, silentOpts) -- Surround with square brackets

	-- Enable right click context menu
	map(allModes, '<RightMouse>', utils.openContextMenu)

	-- Deactivate middle mouse button copying
	map(allModes, '<MiddleMouse>', '<Nop>', silentOpts)
	-- Add minty
	map(allModes, '<C-S-A-c>', cmd('Shades'), silentOpts)

	-- Telescope keybinds
	vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find files' })
	vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { desc = 'Buffers' })
	vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { desc = 'Help tags' })
	vim.keymap.set('n', '<leader>fr', '<cmd>Telescope lsp_references<CR>', { desc = 'LSP References' })
	vim.keymap.set('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>', { desc = 'LSP Document Symbols' })
	vim.keymap.set('n', '<leader>fd', '<cmd>Telescope diagnostics<CR>', { desc = 'LSP Diagnostics' })
end
