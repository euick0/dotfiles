-- Ghostty draws colored wavy underlines natively
local function spell(color)
	return { fg = "NONE", sp = color, undercurl = true }
end

return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {
			-- match tmux (catppuccin macchiato) and ghostty (Catppuccin Macchiato)
			flavour = "macchiato",
			custom_highlights = function(colors)
				-- VS Code-style spell checking: keep the text color, only add a wavy underline
				return {
					SpellBad = spell(colors.blue),
					SpellCap = spell(colors.overlay0),
					SpellRare = spell(colors.overlay0),
					SpellLocal = spell(colors.overlay0),
				}
			end,
		},
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin-macchiato",
		},
	},
}
