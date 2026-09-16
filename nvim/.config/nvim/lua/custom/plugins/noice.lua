-- Replaces messages, cmdline and popupmenu with floating windows

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- Backend for noice's `notify` view; without it those routes have nowhere to go
		{
			"rcarriga/nvim-notify",
			opts = {
				-- gruvbox runs with transparent_mode, so Normal carries no background
				-- for nvim-notify to fade against. This is the colour showing through
				-- from Ptyxis's Gruvbox palette, and what opaque gruvbox sets Normal to.
				background_colour = "#282828",
			},
		},
	},
}
