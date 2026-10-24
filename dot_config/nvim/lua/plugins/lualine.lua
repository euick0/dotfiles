-- rounded statusline to match tmux's catppuccin "rounded" window style
return {
	"nvim-lualine/lualine.nvim",
	opts = function(_, opts)
		opts.options.theme = "catppuccin-macchiato"
		opts.options.section_separators = { left = "\u{e0b4}", right = "\u{e0b6}" }
		opts.options.component_separators = { left = "\u{e0b5}", right = "\u{e0b7}" }

		-- round off the outer ends of the bar
		opts.sections.lualine_a = { { "mode", separator = { left = "\u{e0b6}", right = "\u{e0b4}" } } }

		-- tmux shows the clock, so replace LazyVim's clock in z with the cursor location
		local y = opts.sections.lualine_y or {}
		for i = #y, 1, -1 do
			local name = type(y[i]) == "table" and y[i][1] or y[i]
			if name == "location" then
				table.remove(y, i)
			elseif name == "progress" then
				-- LazyVim gives progress no right padding since location used to follow it
				y[i].padding = { left = 1, right = 1 }
			end
		end
		opts.sections.lualine_z = { { "location", separator = { left = "\u{e0b6}", right = "\u{e0b4}" } } }
	end,
}
