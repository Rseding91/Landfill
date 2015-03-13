data:extend(
	{
		{
			type = "item",
			name = "landfill2by2",
			icon = "__Landfill__/graphics/icons/landfill.png",
			flags = {"goes-to-quickbar"},
			subgroup = "transport",
			order = "ca[landfill]",
			place_result = "landfill2by2",
			stack_size = 256
		},
		{
			type = "item",
			name = "landfill4by4",
			icon = "__Landfill__/graphics/icons/landfill2.png",
			flags = {"goes-to-quickbar"},
			subgroup = "transport",
			order = "cb[landfill]",
			place_result = "landfill4by4",
			stack_size = 256
		},
		{
			type = "item",
			name = "water-be-gone",
			icon = "__Landfill__/graphics/icons/water-be-gone - 3.png",
			flags = {"goes-to-quickbar"},
			subgroup = "transport",
			order = "cc[landfill]",
			place_result = "water-be-gone",
			stack_size = 64
		},
		{
			type = "item",
			name = "water-bomb",
			icon = "__Landfill__/graphics/icons/Bomb.png",
			flags = {"goes-to-quickbar"},
			subgroup = "equipment",
			order = "a[bomb]",
			place_result = "water-bomb-area",
			stack_size = 64
		}
	}
)