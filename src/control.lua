require "defines"

local displaceDirt = true
local throwRocks = true
local maximumRockThrowDistance = 10
local loaded
local bombs

game.onload(function()
	if not loaded then
		loaded = true
		
		if glob.bombs ~= nil then
			bombs = glob.bombs
			game.onevent(defines.events.ontick, tickBombs)
			if glob.ticks == nil then
				glob.ticks = 0
			end
		end
	end
end)

game.oninit(function()
	loaded = true
	
	if glob.bombs ~= nil then
		bombs = glob.bombs
		game.onevent(defines.events.ontick, tickBombs)
		if glob.ticks == nil then
			glob.ticks = 0
		end
	end
end)

function tickBombs()
	if glob.ticks > 0 then glob.ticks = glob.ticks - 1 else glob.ticks = 10, executeTicks() end
end

function executeTicks()
	local x,y
	local distX,distY
	local energy
	
	for k,v in pairs(bombs) do
		if v[1].valid and v[2] == 0 then
			energy = v[1].energy
			
			if energy > 49000000 then
				x = v[1].position.x
				y = v[1].position.y
				
				for xx = x - 5.5,x + 5.5,1.5 do
					for yy = y - 5.5,y + 5.5,1.5 do
						distX = math.abs(x - xx)
						distY = math.abs(y - yy)
						
						if math.floor(math.sqrt((distX * distX) + (distY * distY))) <= 5 then
							game.createentity({name = "huge-explosion", position = {x = xx, y = yy}})
						end
					end
				end
				
				game.createentity({name = "water-bomb-detonation", position = v[1].position, target = v[1], speed = 1})
				v[4] = v[1].position
				v[1].destroy()
				v[2] = 1
				v[3] = game.tick
				createWater(x, y)
				throwDirt(x, y)
			else
				if energy > 40000000 then
					game.createentity({name = "smoke", position = v[1].position})
					game.createentity({name = "smoke", position = {x = v[1].position.x, y = v[1].position.y - 0.2}})
				elseif energy > 30000000 then
					game.createentity({name = "smoke", position = v[1].position})
				end
			end
		else
			if v[2] == 1 then
				if game.tick - v[3] > 90 then
					createRandomStone(v[4])
					createRandomStone(v[4])
					createRandomStone(v[4])
					v[2] = 0
				elseif game.tick - v[3] > 80 then
					createRandomStone(v[4])
					createRandomStone(v[4])
					createRandomStone(v[4])
				elseif game.tick - v[3] > 70 then
					createRandomStone(v[4])
				elseif game.tick - v[3] > 60 then
					createRandomStone(v[4])
					createRandomStone(v[4])
				end
			else
				table.remove(bombs, k)
				if #glob.bombs == 0 then
					bombs = nil
					glob.bombs = nil
					game.onevent(defines.events.ontick, nil)
				end
			end
		end
	end
end

function createWater(x, y)
	local waterTiles = {}
	
	x = math.floor(x)
	y = math.floor(y)
	
	for wx = x - 1, x + 1, 1 do
		for wy = y - 1, y + 1, 1 do
			table.insert(waterTiles, {name="water", position={wx, wy}})
		end
	end
	
	game.settiles(waterTiles)
end

function throwDirt(x, y)
	local dirtTiles = {}
	local tileName
	local dirtDisplaced = 0
	local floor = math.floor
	local distX,distY
	
	if displaceDirt == true then
		x = floor(x)
		y = floor(y)
		
		for xx = x - 3, x + 3, 1 do
			for yy = y - 3, y + 3, 1 do
				distX = math.abs(x - xx)
				distY = math.abs(y - yy)
				
				if floor(math.sqrt((distX * distX) + (distY * distY))) >= 2 then
					table.insert(dirtTiles, {name = "grass", position = {xx, yy}})
					dirtDisplaced = dirtDisplaced + 1
				end
			end
		end
		
		if dirtDisplaced ~= 0 then
			game.settiles(dirtTiles)
		end
	end
end

function createRandomStone(position)
	local x,y
	local tileName
	
	if throwRocks == true then
		x = position.x
		y = position.y
		
		if math.random() > 0.5 then
			x = x - math.floor(math.random(2, maximumRockThrowDistance))
		else
			x = x + math.floor(math.random(2, maximumRockThrowDistance))
		end
		
		if math.random() < 0.5 then
			y = y - math.floor(math.random(2, maximumRockThrowDistance))
		else
			y = y + math.floor(math.random(2, maximumRockThrowDistance))
		end
		
		tileName = game.gettile(math.floor(x), math.floor(y)).name
		
		if tileName == "water" or tileName == "deepwater" then
			game.settiles({{name="grass", position={math.floor(x), math.floor(y)}}})
		else
			game.createentity({name = "stone", position = {x, y}}).amount = math.floor(math.random(13, 27))
			game.createentity({name = "explosion", position = {x, y}})
			game.createentity({name = "smoke", position = {x, y}})
		end
	end
end

game.onevent(defines.events.onbuiltentity, function(event)
	local doFade = false
	local newBomb
	local bombEntity
	local player
	if event.playerindex then
		player = game.players[event.playerindex]
	end
	
	if event.createdentity.name == "landfill2by2"
		or event.createdentity.name == "landfill8by8"
		or event.createdentity.name == "water-be-gone" then
			if event.createdentity.name == "landfill2by2" then
				doFade = 1
				landfill2by2(event.createdentity.position, player)
			elseif event.createdentity.name == "landfill8by8" then
				doFade = 2
				landfill8by8(event.createdentity.position, player)
			elseif event.createdentity.name == "water-be-gone" then
				waterBeGone(event.createdentity.position, player)
			end
			
			if doFade == 1 then
				game.createentity({name = "landfill-fade", position = event.createdentity.position, force = game.forces.player})
			elseif doFade == 2 then
				game.createentity({name = "landfill-fade-2", position = event.createdentity.position, force = game.forces.player})
			end
			event.createdentity.destroy()
	elseif event.createdentity.name == "water-bomb-area" then
		bombEntity = game.createentity({name = "water-bomb", position = event.createdentity.position, force = game.forces.player})
		event.createdentity.destroy()
		
		if glob.bombs == nil then
			glob.bombs = {}
			bombs = glob.bombs
			game.onevent(defines.events.ontick, tickBombs)
			if glob.ticks == nil then
				glob.ticks = 0
			end
		end
		
		newBomb = {}
		newBomb[1] = bombEntity				-- Bomb entity
		newBomb[2] = 0						-- Bomb state (charging:0, detonated:1)
		newBomb[3] = 0						-- Tick detonation occurred
		
		table.insert(bombs, newBomb)
	end
end)

function landfill2by2(position, player)
	local tileName
	local xpos = position.x - 1
	local ypos = position.y - 1
	local tiles = {}
	local holes
	
	for x = 0,1,1 do
		for y = 0,1,1 do
			tileName = game.gettile(xpos + x, ypos + y).name
			if tileName == "water" or tileName == "deepwater" then
				table.insert(tiles,{name="grass", position={xpos + x, ypos + y}})
			end
		end
	end
	
	if #tiles ~= 0 then
		game.settiles(tiles)
		checkIfPlayerStuck()
	else
		holes = game.findentitiesfiltered({area = {{x = xpos, y = ypos}, {x = xpos + 2, y = ypos + 2}}, name = "holes"})
		
		if #holes ~= 0 then
			for k,v in pairs(holes) do
				v.destroy()
			end
		else
			if player then
				player.insert{name="landfill2by2", count=1}
			end
		end
	end
end

function landfill8by8(position, player)
	local tileName
	local xpos = position.x - 2
	local ypos = position.y - 2
	local tiles = {}
	local holes
	
	for x = 0,3,1 do
		for y = 0,3,1 do
			tileName = game.gettile(xpos + x, ypos + y).name
			if tileName == "water" or tileName == "deepwater" then
				table.insert(tiles,{name="grass", position={xpos + x, ypos + y}})
			end
		end
	end
	
	if #tiles ~= 0 then
		game.settiles(tiles)
		checkIfPlayerStuck()
	else
		holes = game.findentitiesfiltered({area = {{x = xpos, y = ypos}, {x = xpos + 4, y = ypos + 4}}, name = "holes"})
		
		if #holes ~= 0 then
			for k,v in pairs(holes) do
				v.destroy()
			end
		else
			if player then
				player.insert{name="landfill8by8", count=1}
			end
		end
	end
end

function checkIfPlayerStuck()
	local ptiles = {}
	local px
	local py
	
	for _,player in pairs(game.players) do
		px = player.position.x
		py = player.position.y
		for i = -0.2, 0.2, 0.4 do
			for j = -0.2, 0.2, 0.4 do
				if game.gettile(px + j, py + i).collideswith("player-layer") then
					table.insert(ptiles, {name="grass", position={px + j, py + i}})
				end
			end
		end
	end

	game.settiles(ptiles)
end


function waterBeGone(position, player)
	-- Flood fills a body of water using landfills from the player's inventory
	local xpos = math.floor(position.x)
	local ypos = math.floor(position.y)
	local tiles = {}
	local stiles = {}
	local ntiles = {}
	local positions = {{-1, 0}, {0, -1}, {1, 0}, {0, 1}}
	local totalReplaced = 0
	local tileName
	local x,y
	local floor = math.floor
	local floorX
	local chunksEffected = {}
	
	tileName = game.gettile(xpos, ypos).name
	if tileName == "deepwater" or tileName == "water" then
		table.insert(tiles, {name = "grass", position = {xpos, ypos}})
		table.insert(stiles, {xpos, ypos})
		totalReplaced = 1
	end
	
	for t in pairs(stiles) do
		for k,p in pairs(positions) do
			x = stiles[t][1] + p[1]
			y = stiles[t][2] + p[2]
			if ntiles[x] == nil or ntiles[x][y] == nil then
				tileName = game.gettile(x, y).name
				if tileName == "deepwater" or tileName == "water" then
					table.insert(tiles, {name = "grass", position = {x, y}})
					table.insert(stiles, {x, y})
					totalReplaced = totalReplaced + 1
					
					floorX = floor(x / 32)
					if chunksEffected[floorX] == nil then
						chunksEffected[floorX] =  {}
					end
					
					chunksEffected[floorX][floor(y / 32)] = 1
				end
				
				if ntiles[x] == nil then
					ntiles[x] = {}
				end
				ntiles[x][y] = true
			end
		end
	end
	
	if totalReplaced ~= 0 then
		if useLandfills(totalReplaced, player) == true then
			game.settiles(tiles)
			
			-- Creates a stone entity owned by the player in each chunk effected by the flood fill triggering a minimap update and then destroys it
			if chunksEffected ~= nil then
				for x in pairs(chunksEffected) do
					for y in pairs(chunksEffected[x]) do
						game.createentity({name = "stone", position = {x * 32, y * 32}, force = game.forces.player}).destroy()
					end
				end
			end
		else
			if player then
				player.insert{name="water-be-gone", count=1}
			end
		end
	else
		if player then
			player.insert{name="water-be-gone", count=1}
		end
	end
end

function useLandfills(tileCount, player)
	if not player then
		return false
	end
	-- Checks if the player has enough landfills to fill the tile count
	local landfill2by2Count = player.getitemcount("landfill2by2")
	local landfill8by8Count = player.getitemcount("landfill8by8")
	
	if landfill2by2Count * 4 + landfill8by8Count * 16 >= tileCount then
		tileCount = tileCount - (player.removeitem({name = "landfill2by2", count = math.ceil(tileCount / 4)}) * 4)
		
		if tileCount > 0 then
			player.removeitem({name = "landfill8by8", count = math.ceil(tileCount / 16)})
		end
		
		return true
	else
		player.print("Insufficient landfills to fill water body. Requires: " .. math.ceil(tileCount / 4) .. " Landfills or " .. math.ceil(tileCount / 16) .. " Bigger Landfills or a mixture.")
		return false
	end
end