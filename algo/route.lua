function calculateDistance(maze,x,y)
	if tonumber(maze[x][y]) ~= nil then
	if x+1 < grid_size then
		if maze[x+1][y] ~= 'w' and maze[x+1][y] ~= 'g' and maze[x+1][y] ~= 'e' then
			if maze[x+1][y] == ' ' or maze[x+1][y] > maze[x][y] then
				maze[x+1][y] = maze[x][y] + 1
				calculateDistance(maze, x+1, y)
			end
		end
	end
	if x-1 > 1 then
		if maze[x-1][y] ~= 'w' and maze[x-1][y] ~= 'g' and maze[x-1][y] ~= 'e' then
			if maze[x-1][y] == ' ' or maze[x-1][y] > maze[x][y] then
				maze[x-1][y] = maze[x][y] + 1
				calculateDistance(maze, x-1, y)
			end
		end
	end
	if y+1 < grid_size then
		if maze[x][y+1] ~= 'w' and maze[x][y+1] ~= 'g' and maze[x][y+1] ~= 'e' then
			if maze[x][y+1] == ' ' or maze[x][y+1] > maze[x][y] then
				maze[x][y+1] = maze[x][y] + 1
				calculateDistance(maze, x, y+1)
			end
		end
	end
	if y-1 > 1 then
		if maze[x][y-1] ~= 'w' and maze[x][y-1] ~= 'g' and maze[x][y-1] ~= 'e' then
			if maze[x][y-1] == ' ' or maze[x][y-1] > maze[x][y] then
				maze[x][y-1] = maze[x][y] + 1
				calculateDistance(maze, x, y-1)
			end
		end
	end
end
end

function recordWay(maze, x, y, index, way)
	way[index] = {}
	value = 99
	if x+1 < grid_size then
		if tonumber(maze[x+1][y]) ~= nil then
			way[index].x = x+1
			way[index].y = y
			value = maze[x+1][y]
		end
	end
	if x-1 > 1 then
		if tonumber(maze[x-1][y]) ~= nil then
			if maze[x-1][y] < value then
			way[index].x = x-1
			way[index].y = y
			value = maze[x-1][y]
			end
		end
	end
	if y+1 < grid_size then
		if tonumber(maze[x][y+1]) ~= nil then
			if maze[x][y+1] < value then
			way[index].x = x
			way[index].y = y+1
			value = maze[x][y+1]
			end
		end
	end
	if y-1 > 1 then
		if tonumber(maze[x][y-1]) ~= nil then
			if maze[x][y-1] < value then
			way[index].x = x
			way[index].y = y-1
			value = maze[x][y-1]
			end
		end
	end
	if value == 0 then
		return
	else
		recordWay(maze, way[index].x, way[index].y, index+1, way)
	end
end

function findWay(maze, player, goal, way)
	print("player: x: "..player.x.." y:"..player.y)
	print("goal: x: "..goal.x.." y:"..goal.y)
	-- copy maze
	local new_maze = {}
	for i=1,grid_size do
		new_maze[i] = {}
		for j=1,grid_size do
			new_maze[i][j] = maze[i][j]
		end
	end
	-- find shortest way
	calculateDistance(new_maze, player.x, player.y)
	-- set first waypoint to goal
	way[1] = {}
	way[1].x = goal.x
	way[1].y = goal.y
	-- record the rest of the way
	recordWay(new_maze, goal.x, goal.y, 2, way)

	-- turn order around
	local n = 1
	turn = {}
	for i = #way, 1, -1 do
		turn[n] = {}
		turn[n].x = way[i].x
		turn[n].y = way[i].y
		n = n + 1
	end
	return turn
end
