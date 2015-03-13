data:extend(
	{
		{
			type = "recipe",
			name = "landfill2by2",
			enabled = "true",
			ingredients =
			{
				{"stone", 20}
			},
			result = "landfill2by2"
		},
		{
			type = "recipe",
			name = "landfill4by4",
			enabled = "true",
			ingredients =
			{
				{"landfill2by2", 4}
			},
			result = "landfill4by4"
		},
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