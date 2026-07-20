-- ============================================================================
-- FILE:  ~/. config/nvim/lua/plugins/snacks.lua
-- ============================================================================
-- Dashboard using snacks.nvim

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	---@type snacks.Config
	opts = {
		dashboard = {
			enabled = true,
			width = 60,
			row = nil,
			col = nil,
			pane_gap = 10, -- SPACE BETWEEN LEFT AND RIGHT COLUMNS
			preset = {
				-- Use fzf-lua as the picker
				pick = function(cmd, opts)
					local fzf = require("fzf-lua")
					opts = opts or {}
					if cmd == "files" then
						fzf.files(opts)
					elseif cmd == "live_grep" then
						fzf.live_grep(opts)
					elseif cmd == "oldfiles" then
						fzf.oldfiles(opts)
					end
				end,
				-- Custom keymaps with proper icons
				keys = {
					{ icon = "󰝒 ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = "󰝒", key = "n", desc = " New File", action = ": ene | startinsert" },
					{
						icon = " ",
						key = "g",
						desc = "Find Text",
						action = ":lua Snacks.dashboard.pick('live_grep')",
					},
					{
						icon = " ",
						key = "r",
						desc = "Recent Files",
						action = ": lua Snacks.dashboard.pick('oldfiles')",
					},
					{
						icon = " ",
						key = "c",
						desc = "Config",
						action = ": lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					},
					{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
					{
						icon = "󰒲 ",
						key = "l",
						desc = "Lazy",
						action = ": Lazy",
						enabled = package.loaded.lazy ~= nil,
					},
					{ icon = " ", key = "q", desc = "Quit", action = ": qa" },
				},

				-- NEOVIM header
				header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
			},

			-- ============================================================
			-- FORMATS SECTION - CONTROLS HOW ITEMS ARE DISPLAYED
			-- This removes the space between icon and text
			-- ============================================================
			formats = {
				key = function(item)
					return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
				end,
				icon = function(item)
					if item.file and (item.icon == "file" or item.icon == "directory") then
						-- Get the actual icon from nvim-web-devicons instead of using item.icon
						local icon, hl = require("nvim-web-devicons").get_icon(item.file, nil, { default = true })
						return { { icon or " ", hl = hl or "icon" } } -- Return as table of tables, no width property
					end
					return { { item.icon, hl = "icon" } } -- Return as table of tables
				end,
			},
			-- Two-pane layout
			sections = {
				{ pane = 2, text = " ", padding = -10 }, -- Negative padding pulls it UP
				-- ============================================================
				-- LEFT COLUMN: NEOVIM ASCII HEADER AT TOP
				-- ============================================================
				{ section = "header" },

				-- ============================================================
				-- RIGHT COLUMN: COLORFUL BLOCKS AT TOP
				-- Using colorscript for beautiful colored squares
				-- padding = space above/below this section
				-- INCREASE padding TO PUSH RIGHT SIDE DOWN
				-- ============================================================
				{
					pane = 2, -- pane = 2 means RIGHT column
					section = "terminal",
					cmd = "colorscript -e square", -- Colorful square pattern
					height = 5,
					padding = 1, -- CHANGE THIS TO PUSH RIGHT SIDE DOWN (try 8)
				},

				-- ============================================================
				-- LEFT COLUMN: MENU BUTTONS (Find File, New File, etc.)
				-- gap = space BETWEEN each menu item
				-- padding = space ABOVE and BELOW all menu items
				-- ============================================================
				{
					section = "keys",
					gap = 1, -- SPACE BETWEEN "Find File", "New File", etc.
					padding = 1, -- SPACE ABOVE/BELOW ENTIRE MENU
				},

				-- ============================================================
				-- RIGHT COLUMN: RECENT FILES SECTION
				-- indent = left spacing for file list
				-- padding = space ABOVE this section
				-- ============================================================
				{
					pane = 2, -- RIGHT column
					icon = "",
					title = "Recent Files",
					section = "recent_files",
					indent = 2, -- LEFT INDENT FOR FILE ITEMS
					padding = { 1, 1 }, -- SPACE ABOVE "Recent Files" title
					limit = 5,
				},

				-- ============================================================
				-- RIGHT COLUMN: PROJECTS SECTION
				-- ============================================================
				{
					pane = 2, -- RIGHT column
					icon = "󰉓",
					title = "Projects",
					section = "projects",
					indent = 2, -- LEFT INDENT FOR PROJECT ITEMS
					padding = { 1, 1 }, -- SPACE ABOVE "Projects" title
					limit = 4,
				},

				-- ============================================================
				-- RIGHT COLUMN: GIT STATUS SECTION
				-- ============================================================
				{
					pane = 2, -- RIGHT column
					icon = "",
					title = "Git Status",
					section = "terminal",
					enabled = function()
						return Snacks.git.get_root() ~= nil
					end,
					cmd = "echo '' && git status --short --branch --renames",
					height = 6,
					padding = { 1, 1 }, -- SPACE ABOVE "Git Status" title
					ttl = 5 * 60,
					indent = 3, -- LEFT INDENT FOR GIT STATUS ITEMS
				},

				-- ============================================================
				-- FOOTER: "Neovim loaded X plugins" AT BOTTOM
				-- ============================================================
				{ section = "startup" },
			},
		},
		-- Snacks git integration
		git = { enabled = true },
		gitbrowse = { enabled = true },
		-- Enable other useful Snacks features
		bigfile = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		quickfile = { enabled = true },
		statuscolumn = { enabled = false },
		words = { enabled = true },
		styles = {
			notification = {
				wo = { wrap = true },
			},
		},
	},
	keys = {
		{
			"<leader>.",
			function()
				Snacks.scratch()
			end,
			desc = "Toggle Scratch Buffer",
		},
		{
			"<leader>S",
			function()
				Snacks.scratch.select()
			end,
			desc = "Select Scratch Buffer",
		},
		{
			"<leader>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer",
		},
		{
			"<leader>gg",
			function()
				Snacks.lazygit()
			end,
			desc = "Lazygit",
		},
		{
			"<leader>gb",
			function()
				Snacks.git.blame_line()
			end,
			desc = "Git Blame Line",
		},
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
		},
		{
			"<leader>gf",
			function()
				Snacks.lazygit.log_file()
			end,
			desc = "Lazygit Current File History",
		},
		{
			"<leader>gl",
			function()
				Snacks.lazygit.log()
			end,
			desc = "Lazygit Log (cwd)",
		},
		{
			"<leader>cR",
			function()
				Snacks.rename()
			end,
			desc = "Rename File",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
		},
	},
	init = function()
		-- ============================================================
		-- TOKYO NIGHT COLOR SETUP FOR DASHBOARD
		-- ============================================================
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- ========================================================
				-- TOKYO NIGHT COLOR PALETTE
				-- You can use these color names below in highlight groups
				-- ========================================================
				local colors = {
					blue = "#7aa2f7", -- Blue color
					cyan = "#7dcfff", -- Cyan/Teal color
					green = "#9ece6a", -- Green color
					magenta = "#bb9af7", -- Magenta color
					orange = "#ff9e64", -- Orange color
					purple = "#9d7cd8", -- Purple color
					red = "#f7768e", -- Red/Pink color
					yellow = "#e0af68", -- Yellow color
					fg = "#c0caf5", -- Default foreground (white-ish)
					bg = "#1a1b26", -- Background color
					comment = "#565f89", -- For dimmed paths
				}

				-- ========================================================
				-- DASHBOARD COLOR HIGHLIGHT GROUPS
				-- Change the color after "fg = colors." to customize
				-- ========================================================
				--	vim.api.nvim_set_hl(0, "SnacksDashboardHeader", { fg = colors.blue, bold = true }) -- NEOVIM ASCII HEADER COLOR (top left)
				vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = colors.orange, bold = true }) -- KEYBINDING LETTERS COLOR (f, n, g, r, c, s, L, q)
				--	vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = colors.cyan }) -- MENU TEXT COLOR ("Find File", "New File", "Find Text", etc.) - Try:  colors.cyan, colors.purple, colors.blue, colors.green
				--	vim.api.nvim_set_hl(0, "SnacksDashboardIcon", { fg = colors.blue }) -- MENU ICONS COLOR (icons on left menu)
				--	vim.api.nvim_set_hl(0, "SnacksDashboardFooter", { fg = colors.cyan, italic = true }) -- FOOTER TEXT COLOR ("Neovim loaded X plugins")
				--	vim.api.nvim_set_hl(0, "SnacksDashboardTitle", { fg = colors.cyan, bold = true }) -- SECTION TITLES COLOR ("Recent Files", "Projects", "Git Status")
				vim.api.nvim_set_hl(0, "SnacksDashboardFile", { fg = colors.cyan }) -- FILE NAMES COLOR (init.lua, image.lua, telescope.lua, etc.) - Try: colors.cyan, colors.purple, colors.green
				vim.api.nvim_set_hl(0, "SnacksDashboardDir", { fg = colors.comment }) -- DIRECTORY/PATH COLOR (path prefixes)
				vim.api.nvim_set_hl(0, "SnacksDashboardSpecial", { fg = colors.purple }) -- SPECIAL ELEMENTS COLOR

				-- ========================================================
				-- DEBUG GLOBALS
				-- ========================================================
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd

				-- ========================================================
				-- TOGGLE MAPPINGS
				-- ========================================================
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
			end,
		})
	end,
}
