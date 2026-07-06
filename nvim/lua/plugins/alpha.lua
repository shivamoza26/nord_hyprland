return {
	"goolord/alpha-nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	event = "VimEnter",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Build icon glyphs reliably from Nerd Font codepoints
		local function icon(codepoint)
			return vim.fn.nr2char(codepoint)
		end

		local icons = {
			find_file = icon(0xf002), --  search
			new_file = icon(0xf15b), --  file
			find_text = icon(0xf002), --  search
			recent = icon(0xf1da), --  history
			project = icon(0xf07c), --  open folder
			config = icon(0xf085), --  gears
			lazy = icon(0xf0632), -- 󰒲 lazy
			quit = icon(0xf011), --  power
		}

		-- Your ASCII art
		dashboard.section.header.val = {
			[[                                                    ]],
			[[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ]],
			[[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ]],
			[[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ]],
			[[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ]],
			[[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ]],
			[[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ]],
			[[                                                    ]],
		}

		-- Open a project folder from ~/Projects
		local function open_project()
			local projects_dir = vim.fn.expand("~/Projects")
			local handle = vim.loop.fs_scandir(projects_dir)
			if not handle then
				vim.notify("Could not read " .. projects_dir, vim.log.levels.ERROR)
				return
			end

			local dirs = {}
			while true do
				local name, type = vim.loop.fs_scandir_next(handle)
				if not name then
					break
				end
				if type == "directory" then
					table.insert(dirs, name)
				end
			end

			table.sort(dirs)

			vim.ui.select(dirs, { prompt = "Select Project:" }, function(choice)
				if not choice then
					return
				end
				local path = projects_dir .. "/" .. choice
				vim.cmd("cd " .. vim.fn.fnameescape(path))
				require("telescope.builtin").find_files({ cwd = path })
			end)
		end
		_G.OpenProject = open_project

		-- Menu buttons
		dashboard.section.buttons.val = {
			dashboard.button("f", icons.find_file .. "  Find File", ":Telescope find_files <CR>"),
			dashboard.button("n", icons.new_file .. "  New File", ":ene <BAR> startinsert <CR>"),
			dashboard.button("g", icons.find_text .. "  Find Text", ":Telescope live_grep <CR>"),
			dashboard.button("r", icons.recent .. "  Recent Files", ":Telescope oldfiles <CR>"),
			dashboard.button("p", icons.project .. "  Open Project", ":lua OpenProject()<CR>"),
			dashboard.button(
				"c",
				icons.config .. "  Config",
				":Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<CR>"
			),
			dashboard.button("l", icons.lazy .. "  Lazy", ":Lazy<CR>"),
			dashboard.button("q", icons.quit .. "  Quit", ":qa<CR>"),
		}

		dashboard.section.header.opts.hl = "AlphaHeader"
		dashboard.section.buttons.opts.hl = "AlphaButtons"

		alpha.setup(dashboard.opts)

		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function()
				vim.opt.foldenable = false
			end,
		})
	end,
}
