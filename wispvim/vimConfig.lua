return function()
	local o = vim.o
	local g = vim.g
	-- Fix server issues
	o.backup = false
	o.writebackup = false
	o.updatetime = 300
	o.updatetime = 200
	-- Fix visual stuff
	o.signcolumn = 'yes'
	-- Fix wl-clipboard no connection error by using xclip instead
	vim.o.clipboard = 'unnamedplus' -- Use the systems clipboard
	g.clipboard = {
		name = 'xclip',
		copy = { ['+'] = 'xclip -selection clipboard', ['*'] = 'xclip -selection primary' },
		paste = { ['+'] = 'xclip -selection clipboard -o', ['*'] = 'xclip -selection primary -o' },
		cache_enabled = true,
	}
	-- Misc
	o.number = true -- Enable line numbers
	g.deprecations = false -- Hide deprecation warnings
	-- Better mouse support
	o.termguicolors = true
	o.cursorline = true -- Highlight current line
	o.ruler = true -- Highlight cursor position in the status line
	o.mouse = 'a' -- Enable mouse support in all modes
	o.virtualedit = 'block' -- Allow cursor to move where there is no text in a visual block mode
	-- Better autocompletion
	o.completeopt = 'menu,menuone,noselect'
	o.conceallevel = 2
	-- Better search options
	o.ignorecase = true
	o.smartcase = true
	o.incsearch = true
	o.hlsearch = true
	-- Better indentation
	o.expandtab = true -- Convert tabs into spaces
	o.tabstop = 4
	o.shiftwidth = 4
	o.softtabstop = 4
	o.smartindent = true
	o.autoindent = true
	-- Better window management
	o.scrolloff = 3 -- Keep 3 lines above and below the cursor visible
	o.sidescrolloff = 36 -- Scrolloff earlier to allow space for the minimap
	o.splitright = true -- Vertical window splits open to the right
	o.splitbelow = true -- Horizontal splits open below
	o.laststatus = 3
	o.splitkeep = 'screen'
	o.pumblend = 10 -- Popup blend
	o.pumheight = 10 -- Maximum number of entires in a popup
	o.winminwidth = 10 -- Minimum window width
	o.winwidth = 10
	o.equalalways = false
	o.wrap = false -- Disable line wrap
	o.smoothscroll = true
	-- Session management
	o.spelllang = 'en'
	o.undofile = true
	o.undolevels = 10000
	-- Better file management
	o.autowrite = true
	o.autoread = true -- Auto-relead files if modified outside nvim
	-- Disable netrw for nvim-tree
	g.loaded_netrw = 1
	g.loaded_netrwPlugin = 1
	-- Fix mappings for lazy
	g.mapleader = ' '
	g.maplocalleader = '\\'
	-- Add filetypes for markdown-preview
	g.mkdp_filetypes = { 'markdown' }
	-- Additional config for startuptime plugin
	g.startuptime_tries = 10
	-- Enable code folding
	o.foldmethod = 'expr'
	o.foldexpr = 'nvim_treesitter#foldexpr()'
	o.foldenable = false -- Start unfolded
	o.foldlevel = 99
	-- conform formatting
	o.formatexpr = "v:lua.require'conform'.formatexpr()"
	-- Trouble options
	g.trouble_lualine = true
	-- Command line
	o.wildmode = 'longest:full,full'
end
