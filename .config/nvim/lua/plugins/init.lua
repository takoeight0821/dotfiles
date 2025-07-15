return {
	{
		"Mofiqul/vscode.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme vscode]])
		end,
	},

	-- Example: Add which-key for better keybinding discovery
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
		},
	},

	-- Example: Add treesitter for better syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			ensure_installed = {
				"lua",
				"vim",
				"vimdoc",
				"query",
				"markdown",
				"markdown_inline",
				"bash",
				"c",
				"cpp",
				"go",
				"javascript",
				"typescript",
				"tsx",
				"json",
				"python",
				"rust",
				"yaml",
				"toml",
				"html",
				"css",
				"dockerfile",
				"gitignore",
				"make",
				"regex",
				"fsharp",
			},
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	-- Example: Add telescope for fuzzy finding
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
		},
	},

	-- Example: Add neo-tree for file explorer
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{ "<leader>fe", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
		},
	},

	-- Trouble for better diagnostics
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
		},
	},

	-- F# support with Ionide-vim
	{
		"ionide/Ionide-vim",
		ft = { "fsharp", "fs", "fsx", "fsi" },
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		config = function()
			-- Disable Ionide's built-in LSP since we're using fsautocomplete directly
			vim.g["fsharp#lsp_auto_setup"] = 0
			vim.g["fsharp#lsp_recommended_colorscheme"] = 0
			vim.g["fsharp#fsi_command"] = "dotnet fsi"
			vim.g["fsharp#fsi_keymap"] = "custom"

			-- F# Interactive keybindings
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "fsharp", "fs", "fsx", "fsi" },
				callback = function()
					local opts = { buffer = true, silent = true }
					-- Send current line to FSI
					vim.keymap.set("n", "<leader>fi", "<Plug>(fsharp-send-line)", opts)
					-- Send selection to FSI
					vim.keymap.set("v", "<leader>fi", "<Plug>(fsharp-send-selection)", opts)
					-- Toggle FSI window
					vim.keymap.set(
						"n",
						"<leader>ft",
						"<cmd>FsiShow<cr>",
						{ buffer = true, desc = "Toggle F# Interactive" }
					)
					-- Reset FSI
					vim.keymap.set(
						"n",
						"<leader>fr",
						"<cmd>FsiReset<cr>",
						{ buffer = true, desc = "Reset F# Interactive" }
					)
				end,
			})
		end,
	},
}
