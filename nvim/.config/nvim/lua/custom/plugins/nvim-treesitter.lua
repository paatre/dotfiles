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
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup()

		local ts = require("nvim-treesitter")

		ts.install({
			"bash",
			"c",
			"diff",
			"git_config",
			"gitcommit",
			"html",
			"lua",
			"luadoc",
			"markdown",
			"python",
			"vim",
			"vimdoc",
		})

		-- Some languages depend on vim's regex highlighting system (such as Ruby)
		-- for indent rules.
		local additional_vim_regex_highlighting = { ruby = true }
		local indent_disable = { ruby = true }

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("CustomTreesitter", { clear = true }),
			callback = function(ev)
				local lang = vim.treesitter.language.get_lang(ev.match)
				if not lang then
					return
				end

				local function start()
					if not pcall(vim.treesitter.start, ev.buf, lang) then
						return
					end
					if additional_vim_regex_highlighting[ev.match] then
						vim.bo[ev.buf].syntax = "on"
					end
					if not indent_disable[ev.match] then
						vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					end
				end

				if vim.list_contains(ts.get_installed(), lang) then
					start()
				elseif vim.list_contains(ts.get_available(), lang) then
					-- replaces auto_install
					ts.install(lang):await(function()
						vim.schedule(start)
					end)
				end
			end,
		})

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
