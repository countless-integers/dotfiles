return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		-- disabled because using snacks for messages and notifications
		messages = { enabled = false },
		notify = { enabled = false },
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
	},
}
