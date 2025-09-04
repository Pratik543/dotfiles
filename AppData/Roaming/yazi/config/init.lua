-- [plugins] - git
require("git"):setup()

-- [plugins] - full-border
require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

-- [plugins] - zoxide (builtin)
require("zoxide"):setup {
	update_db = true, -- update db.zo automatically whenever move directories
}