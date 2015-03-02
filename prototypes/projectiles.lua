data:extend(
	{
		{
			type = "projectile",
			name = "water-bomb-detonation",
			flags = {"not-on-map"},
			acceleration = 0,
			action =
			{
				type = "direct",
				action_delivery =
				{
					type = "instant",
					target_effects =
					{
						{
							type = "nested-result",
							action =
							{
								type = "area",
								perimeter = 5,
								action_delivery =
								{
									type = "instant",
									target_effects =
									{
										{
											type = "damage",
											damage = {amount = 561, type = "explosion"}
										}
									}
								}
							}
						},
						{
							type = "nested-result",
							action =
							{
								type = "area",
								perimeter = 10,
								action_delivery =
								{
									type = "instant",
									target_effects =
									{
										{
											type = "damage",
											damage = {amount = 39, type = "explosion"}
										}
									}
								}
							}
						}
					}
				}
			},
			animation =
			{
				filename = "__Landfill__/graphics/null.png",
				frame_count = 1,
				width = 1,
				height = 1,
				priority = "high"
			},
			light = {intensity = 1, size = 4},
			smoke = capsule_smoke,
		}
	}
)