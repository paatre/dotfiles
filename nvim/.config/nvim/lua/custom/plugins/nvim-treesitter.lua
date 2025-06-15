-- Firt and foremost, nvim-treesitter provides an interface for tree-sitter in Neovim: https://tree-sitter.github.io/tree-sitter/.
-- Tree-sitter is used to parse code into a syntax tree, which allows editors like Neovim to understand the structure of the code.
-- This enables advanced features such as:
-- Syntax highlighting
-- Code folding
-- Incremental selection 
-- etc.
-- Tree-sitter parses code incrementally as you type, which means it can provide real-time feedback and updates to the syntax tree.
--
-- On top of the syntax tree functionality, nvim-treesitter also provides a parser installation manager with :TSInstall and :TSUpdate commands.

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	opts = {
		ensure_installed = {
			"bash",
			"c",
			"diff",
			"git_config",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"vim",
			"vimdoc",
		},
		-- Autoinstall languages that are not installed
		auto_install = true,
		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },
	},
	config = function(_, opts)
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

		-- Prefer git instead of curl in order to improve connectivity in some environments
		require("nvim-treesitter.install").prefer_git = true
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup(opts)

		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects

		-- Set the filetype for "requirements_*.txt" so it’s treated like "requirements.txt"
		vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
			pattern = "requirements_*.*",
			callback = function()
				vim.bo.filetype = "requirements"
			end,
		})

		-- Set the filetype for "gitconfig-*" files so they are treated like "gitconfig"
		vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
			group = vim.api.nvim_create_augroup("CustomGitConfig", { clear = true }),
			pattern = ".gitconfig-*",
			callback = function()
				vim.bo.filetype = "gitconfig"
			end,
		})
	end,
}
