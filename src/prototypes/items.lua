data:extend(
	{
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