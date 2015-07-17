data:extend(
	{
		{
			type = "decorative",
			name = "landfill2by2",
			icon = "__Landfill__/graphics/icons/landfill.png",
			flags = {"placeable-neutral", "player-creation"},
			collision_box = {{-0.99, -0.99}, {0.99, 0.99}},
			collision_mask = {"object-layer"},
			selection_box = {{-1, -1}, {1, 1}},
			minable = {mining_time = 1, result = "landfill2by2", count = 0},
			max_health = 1000,
			corpse = "big-remnants",
			repair_sound = { filename = "__base__/sound/manual-repair-simple.ogg" },
			mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
			render_layer = "tile",
			pictures =
			{
				{
					filename = "__Landfill__/graphics/entity/landfill.png",
					width = 120,
					height = 120
				}
			}
		},
		{
			type = "decorative",
			name = "landfill4by4",
			icon = "__Landfill__/graphics/icons/landfill2.png",
			flags = {"placeable-neutral", "player-creation"},
			collision_box = {{-1.99, -1.99}, {1.99, 1.99}},
			collision_mask = {"object-layer"},
			selection_box = {{-2, -2}, {2, 2}},
			minable = {mining_time = 1, result = "landfill4by4", count = 0},
			max_health = 1000,
			corpse = "big-remnants",
			repair_sound = { filename = "__base__/sound/manual-repair-simple.ogg" },
			mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
			render_layer = "tile",
			pictures =
			{
				{
					filename = "__Landfill__/graphics/entity/landfill2.png",
					width = 240,
					height = 240
				}
			}
		},
		{
			type = "decorative",
			name = "water-be-gone",
			icon = "__Landfill__/graphics/icons/water-be-gone - 3.png",
			flags = {"placeable-neutral", "player-creation", "placeable-off-grid"},
			collision_box = {{-0.5, -0.5}, {0.5, 0.5}},
			collision_mask = {"object-layer"},
			selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
			--    minable = {mining_time = 1, result = "water-be-gone", count = 0},
			max_health = 1000,
			--    corpse = "big-remnants",
			--    repair_sound = { filename = "__base__/sound/manual-repair-simple.ogg" },
			--    mined_sound = { filename = "__base__/sound/deconstruct-bricks.ogg" },
			render_layer = "tile",
			pictures =
			{
				{
					filename = "__Landfill__/graphics/icons/water-be-gone - 3.png",
					width = 32,
					height = 32
				}
			}
		},
		-- ********************************
		-- Landfill Fade
		-- Placeholder after landfill use to prevent accidental spam
		-- ********************************
		{
			type = "corpse",
			name = "landfill-fade",
			icon = "__Landfill__/graphics/icons/landfill.png",
			flags = {"placeable-neutral", "not-on-map"},
			subgroup="remnants",
			order="d[remnants]-c[wall]",
			selection_box = {{-1, -1}, {1, 1}},
			collision_box = {{-0.99, -0.99}, {0.99, 0.99}},
			collision_mask = {"object-layer"},
			selectable_in_game = false,
			time_before_removed = 10, -- disappear after 0.75 seconds
			final_render_layer = "remnants",
			animation = 
			{
				{
					filename = "__Landfill__/graphics/null.png",
					width = 1,
					height = 1,
					frame_count = 1,
					direction_count = 1,
				}
			}
		},
		{
			type = "corpse",
			name = "landfill-fade-2",
			icon = "__Landfill__/graphics/icons/landfill2.png",
			flags = {"placeable-neutral", "not-on-map"},
			subgroup="remnants",
			order="d[remnants]-c[wall]",
			selection_box = {{-2, -2}, {2, 2}},
			collision_box = {{-1.99, -1.99}, {1.99, 1.99}},
			collision_mask = {"object-layer"},
			selectable_in_game = false,
			time_before_removed = 10, -- disappear after 1 seconds
			final_render_layer = "remnants",
			animation = 
			{
				{
					filename = "__Landfill__/graphics/null.png",
					width = 1,
					height = 1,
					frame_count = 1,
					direction_count = 1,
				}
			}
		},
		{
			type = "accumulator",
			name = "water-bomb-area",
			icon = "__Landfill__/graphics/icons/Bomb.png",
			flags = {"placeable-neutral", "player-creation"},
			max_health = 500,
			corpse = "small-remnants",
			collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
			selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
			energy_source =
			{
				type = "electric",
				buffer_capacity = "50MJ",
				usage_priority = "primary-input",
				input_flow_limit = "1500kW",
				output_flow_limit = "0kW"
			},
			picture =
			{
				filename = "__Landfill__/graphics/entity/Bomb - Area.png",
				priority = "extra-high",
				width = 160,
				height = 160,
				shift = {-0.01625, 0}
			},
			charge_cooldown = 45,
			discharge_cooldown = 90,
			order="b[bomb]",
			subgroup = "equipment"
		},
		{
			type = "accumulator",
			name = "water-bomb",
			icon = "__Landfill__/graphics/icons/Bomb.png",
			flags = {"placeable-neutral", "player-creation"},
			minable = {mining_time = 3, result = "water-bomb"},
			max_health = 500,
			corpse = "small-remnants",
			collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
			selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
			energy_source =
			{
				type = "electric",
				buffer_capacity = "50MJ",
				usage_priority = "primary-input",
				input_flow_limit = "1500kW",
				output_flow_limit = "0kW"
			},
			picture =
			{
				filename = "__Landfill__/graphics/entity/Bomb.png",
				priority = "extra-high",
				width = 72,
				height = 62,
				shift = {0.49145, -0.25}
			},
			charge_animation =
			{
				filename = "__Landfill__/graphics/entity/Bomb - Charging.png",
				width = 72,
				height = 62,
				line_length = 4,
				frame_count = 4,
				shift = {0.49145, -0.25},
				animation_speed = 0.5
			},
			charge_cooldown = 45,
			discharge_cooldown = 90,
			order="b[bomb]",
			subgroup = "equipment"
		}
	}
)