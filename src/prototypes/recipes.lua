data:extend(
	{
		{
			type = "recipe",
			name = "water-be-gone",
			enabled = "true",
			ingredients =
			{
				{"electronic-circuit", 1}
			},
			result = "water-be-gone"
		},
		{
			type = "recipe",
			name = "water-bomb",
			energy_required = 5,
			enabled = "true",
			category = "crafting-with-fluid",
			ingredients =
			{
				{"steel-plate", 32},
				{"electric-engine-unit", 4},
				{"processing-unit", 1},
				{type="fluid", name="water", amount=32},
				{"explosives", 24},
			},
			result = "water-bomb"
		}
	}
)