return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",

		config = function()
			local ts = require("nvim-treesitter")

			-- PARSERS

			local parsers = {
				"lua",
				"java",
				"vim",
				"vimdoc",
				"bash",
				"python",
				"javascript",
				"typescript",
				"tsx",
				"html",
				"css",
				"json",
				"jsonc",
				"yaml",
				"toml",
				"markdown",
				"markdown_inline",
				"regex",
				"c",
				"cpp",
				"rust",
				"go",
			}

			ts.install(parsers)

			-- HIGHLIGHTING + INDENTATION

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local buf = args.buf

					-- Disable Treesitter for files > 1 MiB
					local max_filesize = 1024 * 1024
					local filename = vim.api.nvim_buf_get_name(buf)

					local ok, stats = pcall(vim.uv.fs_stat, filename)

					if ok and stats and stats.size > max_filesize then
						return
					end

					-- Start Treesitter highlighting
					pcall(vim.treesitter.start, buf)

					-- Treesitter indentation
					vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end,
			})
		end,
	},

	-- TREESITTER TEXTOBJECTS

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",

		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},

		config = function()
			local select = require("nvim-treesitter-textobjects.select")

			local move = require("nvim-treesitter-textobjects.move")

			local swap = require("nvim-treesitter-textobjects.swap")

			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,

					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "V",
					},

					include_surrounding_whitespace = false,
				},

				move = {
					set_jumps = true,
				},
			})

			-- HELPER

			local function select_object(query)
				return function()
					select.select_textobject(query, "textobjects")
				end
			end

			-- SELECT FUNCTIONS

			vim.keymap.set(
				{ "x", "o" },
				"<leader>tfa",
				select_object("@function.outer"),
				{ desc = "Treesitter: Around function" }
			)

			vim.keymap.set(
				{ "x", "o" },
				"<leader>tfi",
				select_object("@function.inner"),
				{ desc = "Treesitter: Inside function" }
			)

			-- SELECT CLASSES

			vim.keymap.set(
				{ "x", "o" },
				"<leader>tca",
				select_object("@class.outer"),
				{ desc = "Treesitter: Around class" }
			)

			vim.keymap.set(
				{ "x", "o" },
				"<leader>tci",
				select_object("@class.inner"),
				{ desc = "Treesitter: Inside class" }
			)

			-- SELECT ARGUMENTS / PARAMETERS

			vim.keymap.set(
				{ "x", "o" },
				"<leader>taa",
				select_object("@parameter.outer"),
				{ desc = "Treesitter: Around argument" }
			)

			vim.keymap.set(
				{ "x", "o" },
				"<leader>tai",
				select_object("@parameter.inner"),
				{ desc = "Treesitter: Inside argument" }
			)

			-- SELECT CONDITIONALS

			vim.keymap.set(
				{ "x", "o" },
				"<leader>tia",
				select_object("@conditional.outer"),
				{ desc = "Treesitter: Around conditional" }
			)

			vim.keymap.set(
				{ "x", "o" },
				"<leader>tii",
				select_object("@conditional.inner"),
				{ desc = "Treesitter: Inside conditional" }
			)

			-- SELECT LOOPS

			vim.keymap.set(
				{ "x", "o" },
				"<leader>tla",
				select_object("@loop.outer"),
				{ desc = "Treesitter: Around loop" }
			)

			vim.keymap.set(
				{ "x", "o" },
				"<leader>tli",
				select_object("@loop.inner"),
				{ desc = "Treesitter: Inside loop" }
			)

			-- MOVE: FUNCTIONS

			vim.keymap.set({ "n", "x", "o" }, "<leader>tfn", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "Treesitter: Next function" })

			vim.keymap.set({ "n", "x", "o" }, "<leader>tfp", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Treesitter: Previous function" })

			vim.keymap.set({ "n", "x", "o" }, "<leader>tfe", function()
				move.goto_next_end("@function.outer", "textobjects")
			end, { desc = "Treesitter: Next function end" })

			vim.keymap.set({ "n", "x", "o" }, "<leader>tfE", function()
				move.goto_previous_end("@function.outer", "textobjects")
			end, { desc = "Treesitter: Previous function end" })

			-- MOVE: CLASSES

			vim.keymap.set({ "n", "x", "o" }, "<leader>tcn", function()
				move.goto_next_start("@class.outer", "textobjects")
			end, { desc = "Treesitter: Next class" })

			vim.keymap.set({ "n", "x", "o" }, "<leader>tcp", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Treesitter: Previous class" })

			-- MOVE: ARGUMENTS / PARAMETERS

			vim.keymap.set({ "n", "x", "o" }, "<leader>tan", function()
				move.goto_next_start("@parameter.inner", "textobjects")
			end, { desc = "Treesitter: Next argument" })

			vim.keymap.set({ "n", "x", "o" }, "<leader>tap", function()
				move.goto_previous_start("@parameter.inner", "textobjects")
			end, { desc = "Treesitter: Previous argument" })

			-- SWAP ARGUMENTS / PARAMETERS

			vim.keymap.set("n", "<leader>tsn", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Treesitter: Swap next argument" })

			vim.keymap.set("n", "<leader>tsp", function()
				swap.swap_previous("@parameter.inner")
			end, { desc = "Treesitter: Swap previous argument" })

			-- INCREMENTAL SELECTION

			vim.keymap.set("n", "<leader>tvs", function()
				vim.treesitter.start()

				local node = vim.treesitter.get_node()

				if not node then
					return
				end

				vim.treesitter._range.add_bytes(node:range())
			end, { desc = "Treesitter: Start selection" })
		end,
	},
}
