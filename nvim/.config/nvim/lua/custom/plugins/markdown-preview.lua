-- Provides a synced Markdown preview in browser.

return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	ft = { "markdown" },
	-- mkdp#util#install downloads the prebuilt server binary. It is an autoload
	-- function, so the plugin has to be on the runtimepath before calling it
	build = function(plugin)
		vim.opt.runtimepath:append(plugin.dir)
		vim.fn["mkdp#util#install"]()
	end,
}
