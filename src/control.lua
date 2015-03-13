require "defines"

local displaceDirt = true
local throwRocks = true
local maximumRockThrowDistance = 10
local loaded
local bombs

function loaded()
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
end

game.onload(loaded)
game.oninit(loaded)

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
				createWater(x, y, 1)
				throwDirt(x, y, 1)
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

function createWater(x, y, size)
	local players = game.findentitiesfiltered({area = {{x - size - 1, y - size - 1}, {x + size + 1, y + size + 1}}, type="player"})
	-- Setting tiles to water where players are standing deletes the player and sets them to god mode.
	if #players ~= 0 then
		return
	end
	
	local waterTiles = {}
	x = math.floor(x)
	y = math.floor(y)
	
	for wx = x - size, x + size, 1 do
		for wy = y - size, y + size, 1 do
			table.insert(waterTiles, {name="water", position={wx, wy}})
		end
	end
	
	game.settiles(waterTiles)
end

function throwDirt(x, y, size)
	local dirtTiles = {}
	local tileName
	local floor = math.floor
	local distX,distY
	
	if displaceDirt == true then
		x = floor(x)
		y = floor(y)
		
		for xx = x - (size + 2), x + (size + 2), 1 do
			for yy = y - (size + 2), y + (size + 2), 1 do
				distX = math.abs(x - xx)
				distY = math.abs(y - yy)
				
				if floor(math.sqrt((distX * distX) + (distY * distY))) >= 2 then
					table.insert(dirtTiles, {name = "grass", position = {xx, yy}})
				end
			end
		end
		
		if #dirtTiles ~= 0 then
			game.settiles(dirtTiles)
		end
	end
end

function createRandomStone(position)
	local x,y
	local tileName
	local floor = math.floor
	local random = math.random
	
	if throwRocks == true then
		x = position.x
		y = position.y
		
		if random() > 0.5 then
			x = x - floor(random(2, maximumRockThrowDistance))
		else
			x = x + floor(random(2, maximumRockThrowDistance))
		end
		
		if random() < 0.5 then
			y = y - floor(random(2, maximumRockThrowDistance))
		else
			y = y + floor(random(2, maximumRockThrowDistance))
		end
		
		tileName = game.gettile(floor(x), floor(y)).name
		
		if tileName == "water" or tileName == "deepwater" then
			game.settiles({{name="grass", position={floor(x), floor(y)}}})
		else
			game.createentity({name = "stone", position = {x, y}}).amount = floor(random(13, 27))
			game.createentity({name = "explosion", position = {x, y}})
			game.createentity({name = "smoke", position = {x, y}})
		end
	end
end

game.onevent(defines.events.onbuiltentity, function(event)
	local newBomb
	local bombEntity
	local player
	if event.playerindex then
		player = game.players[event.playerindex]
	end
	
	if event.createdentity.name == "landfill2by2"
		or event.createdentity.name == "landfill4by4"
		or event.createdentity.name == "water-be-gone" then
			if event.createdentity.name == "landfill2by2" then
				landfill2by2(event.createdentity.position, player)
			elseif event.createdentity.name == "landfill4by4" then
				landfill4by4(event.createdentity.position, player)
			elseif event.createdentity.name == "water-be-gone" then
				waterBeGone(event.createdentity.position, player)
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

function landfill(position, size)
	local tileName
	local tiles = {}
	local holes
	local xpos = position.x - (size / 2)
	local ypos = position.y - (size / 2)
	local count
	
	for x = 0,size / 2,1 do
		for y = 0,size / 2,1 do
			tileName = game.gettile(xpos + x, ypos + y).name
			if tileName == "water" or tileName == "deepwater" then
				table.insert(tiles,{name="grass", position={xpos + x, ypos + y}})
			end
		end
	end
	
	if #tiles ~= 0 then
		count = #tiles
		game.settiles(tiles)
		return count
	else
		holes = game.findentitiesfiltered({area = {{x = xpos, y = ypos}, {x = xpos + (size / 2), y = ypos + (size / 2)}}, name = "holes"})
		if #holes ~= 0 then
			for _,v in pairs(holes) do
				v.destroy()
			end
		end
		return 0
	end
end

function landfill2by2(position, player)
	if landfill(position, 2) == 0 and player then
		player.insert({name="landfill2by2", count=1})
	end
	
	game.createentity({name = "landfill-fade", position = position, force = getForceFromOptionalPlayer()})
end

function landfill4by4(position, player)
	local count = landfill(position, 4)
	
	if player then
		if count == 0 then
			player.insert({name="landfill4by4", count=1})
		elseif count % 4 ~= 0 then
			player.insert({name="landfill2by2", count=count % 4})
		end
	end
	
	game.createentity({name = "landfill-fade-2", position = position, force = getForceFromOptionalPlayer()})
end

function waterBeGone(position, player)
	-- Flood fills a body of water using landfills from the player's inventory
	local floor = math.floor
	local xpos = floor(position.x)
	local ypos = floor(position.y)
	local tiles = {}
	local stiles = {}
	local ntiles = {}
	local positions = {{-1, 0}, {0, -1}, {1, 0}, {0, 1}}
	local tileName
	local x,y
	local floorX
	local chunksEffected = {}
	local result
	
	tileName = game.gettile(xpos, ypos).name
	if tileName == "deepwater" or tileName == "water" then
		table.insert(tiles, {name = "grass", position = {xpos, ypos}})
		table.insert(stiles, {xpos, ypos})
	end
	
	for t in pairs(stiles) do
		for k,p in pairs(positions) do
			x = stiles[t][1] + p[1]
			y = stiles[t][2] + p[2]
			if ntiles[x] == nil or ntiles[x][y] == nil then
				result, tileName = pcall(game.gettile(x, y).name)
				if result and (tileName == "deepwater" or tileName == "water") then
					table.insert(tiles, {name = "grass", position = {x, y}})
					table.insert(stiles, {x, y})
					
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
	
	if #tiles ~= 0 then
		if not player then
			setTilesAndUpdateChunks(tiles, chunksEffected)
			return #tiles
		elseif useLandfills(#tiles, player) then
			setTilesAndUpdateChunks(tiles, chunksEffected, player)
		else
			player.insert{name="water-be-gone", count=1}
		end
	else if player then
		player.insert{name="water-be-gone", count=1}
	end
end

function setTilesAndUpdateChunks(tiles, chunks, player)
	game.settiles(tiles)
	
	-- Creates a stone entity in each chunk effected by the flood fill triggering a minimap update and then destroys it
	if chunks ~= nil then
		local force = getForceFromOptionalPlayer()
		for x in pairs(chunks) do
			for y in pairs(chunks[x]) do
				game.createentity({name = "stone", position = {x * 32, y * 32}, force = force}).destroy()
			end
		end
	end
end

function useLandfills(tileCount, player)
	if player.controllertype == defines.controllers.god then
		return true
	end
	
	-- Checks if the player has enough landfills to fill the tile count
	local landfill2by2Count = player.getitemcount("landfill2by2")
	local landfill4by4Count = player.getitemcount("landfill4by4")
	
	if landfill2by2Count * 4 + landfill4by4Count * 16 >= tileCount then
		tileCount = tileCount - (player.removeitem({name = "landfill2by2", count = math.ceil(tileCount / 4)}) * 4)
		
		if tileCount > 0 then
			player.removeitem({name = "landfill4by4", count = math.ceil(tileCount / 16)})
		end
		
		return true
	else
		player.print("Insufficient landfills to fill water body. Requires: " .. math.ceil(tileCount / 4) .. " Landfills or " .. math.ceil(tileCount / 16) .. " Bigger Landfills or a mixture.")
		return false
	end
end

function getForceFromOptionalPlayer(player)
	if player then
		return player.force
	else
		return game.forces.neutral
	end
end

remote.addinterface("landfill", {
	landfill,
	createWater,
	throwDirt,
	createRandomStone,
	useLandfills,
	waterBeGone
})