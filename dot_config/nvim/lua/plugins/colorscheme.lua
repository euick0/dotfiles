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
			-- paint no background, so nvim and Claude Code show the terminal's own color
			transparent_background = true,
			custom_highlights = function(colors)
				-- VS Code-style spell checking: keep the text color, only add a wavy underline
				return {
					SpellBad = spell(colors.blue),
					SpellCap = spell(colors.overlay0),
					SpellRare = spell(colors.overlay0),
					SpellLocal = spell(colors.overlay0),
					-- keep snacks terminals (Claude Code) on the terminal background when unfocused
					SnacksNormalNC = { link = "Normal" },
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
