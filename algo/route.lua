function calculateDistance(m,x,y)
	if tonumber(m[x][y]) ~= nil then
	if x+1 < grid_size then
		if m[x+1][y] ~= 'w' and m[x+1][y] ~= 'g' and m[x+1][y] ~= 'p' then
			if m[x+1][y] == ' ' or m[x+1][y] > m[x][y] then
				m[x+1][y] = m[x][y] + 1
				calculateDistance(m, x+1, y)
			end
		end
	end
	if x-1 > 1 then
		if m[x-1][y] ~= 'w' and m[x-1][y] ~= 'g' and m[x-1][y] ~= 'p' then
			if m[x-1][y] == ' ' or m[x-1][y] > m[x][y] then
				m[x-1][y] = m[x][y] + 1
				calculateDistance(m, x-1, y)
			end
		end
	end
	if y+1 < grid_size then
		if m[x][y+1] ~= 'w' and m[x][y+1] ~= 'g' and m[x][y+1] ~= 'p' then
			if m[x][y+1] == ' ' or m[x][y+1] > m[x][y] then
				m[x][y+1] = m[x][y] + 1
				calculateDistance(m, x, y+1)
			end
		end
	end
	if y-1 > 1 then
		if m[x][y-1] ~= 'w' and m[x][y-1] ~= 'g' and m[x][y-1] ~= 'p' then
			if m[x][y-1] == ' ' or m[x][y-1] > m[x][y] then
				m[x][y-1] = m[x][y] + 1
				calculateDistance(m, x, y-1)
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
	if debug then
		print("player: x: "..player.x.." y:"..player.y)
		print("goal: x: "..goal.x.." y:"..goal.y)
	end

	-- copy maze
	local new_maze = {}
	for i=1,grid_size do
		new_maze[i] = {}
		for j=1,grid_size do
			-- substitute player sign with 0
			if maze[i][j] == player.sign then
				new_maze[i][j] = 0
			else
				new_maze[i][j] = maze[i][j]
			end
		end
	end

	-- calculate distance to every cell in grid
	calculateDistance(new_maze, player.x, player.y)
	-- set first point in the route to the goal
	way[1] = {}
	way[1].x = goal.x
	way[1].y = goal.y
	-- record from goal to 0
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
