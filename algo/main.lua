square_size = 20
square_distance = 25
grid_size = 15
player = {x=nil,y=nil}
goal = {x=nil,y=nil}
--enemy = {x=nil,y=nil}
maze = {}
way = {}
way_index = 1
gamestate = {}
move_timer = 0

walk_running = false

function walkToGoal()
	if gamestate.running == true then
		if walk_running == true then
			if way[way_index] ~= nil then
				setPlayerPosition(way[way_index].x, way[way_index].y)
				way_index = way_index + 1
			end
		end
	end
end

function setObjectPosition(obj, x, y, sign)
	if obj.x ~= nil then
		maze[obj.x][obj.y] = ' '
	end
	obj.x = x
	obj.y = y
	maze[x][y] = sign
end

function setPlayerPosition(x, y)
	setObjectPosition(player, x, y, 0)
end

function setGoalPosition(x, y)
	if goal.x ~= nil then
		-- in case player walked onto goal field
		if maze[goal.x][goal.y] == 0 then
			tmp = {}
			tmp.x = goal.x
			tmp.y = goal.y
			setObjectPosition(goal, x, y, 'g')
			setPlayerPosition(tmp.x, tmp.y)
		end
	end
	setObjectPosition(goal, x, y, 'g')
end

function create_obstacles()
	for n=4,6 do
		maze[3][n] = 'w'
	end
	for n=4,6 do
		maze[n][6] = 'w'
	end
end

function calculate_distance(maze,x,y)
	if x+1 < grid_size then
		if maze[x+1][y] ~= 'w' and maze[x+1][y] ~= 'g' then
			if maze[x+1][y] == ' ' or maze[x+1][y] > maze[x][y] then
				maze[x+1][y] = maze[x][y] + 1
				calculate_distance(maze, x+1, y)
			end
		end
	end
	if x-1 > 1 then
		if maze[x-1][y] ~= 'w' and maze[x-1][y] ~= 'g' then
			if maze[x-1][y] == ' ' or maze[x-1][y] > maze[x][y] then
				maze[x-1][y] = maze[x][y] + 1
				calculate_distance(maze, x-1, y)
			end
		end
	end
	if y+1 < grid_size then
		if maze[x][y+1] ~= 'w' and maze[x][y+1] ~= 'g' then
			if maze[x][y+1] == ' ' or maze[x][y+1] > maze[x][y] then
				maze[x][y+1] = maze[x][y] + 1
				calculate_distance(maze, x, y+1)
			end
		end
	end
	if y-1 > 1 then
		if maze[x][y-1] ~= 'w' and maze[x][y-1] ~= 'g' then
			if maze[x][y-1] == ' ' or maze[x][y-1] > maze[x][y] then
				maze[x][y-1] = maze[x][y] + 1
				calculate_distance(maze, x, y-1)
			end
		end
	end
end

function recordway(maze, x, y, index)
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
		recordway(maze, way[index].x, way[index].y, index+1)
	end
end

function findway()
	local new_maze = {}
	for i=1,grid_size do
		new_maze[i] = {}
		for j=1,grid_size do
			new_maze[i][j] = maze[i][j]
		end
	end
	calculate_distance(new_maze, player.x, player.y)
	way[1] = {}
	way[1].x = goal.x
	way[1].y = goal.y
	recordway(new_maze, goal.x, goal.y, 2)

	-- turn order around
	local n = 1
	turn = {}
	for i = #way, 1, -1 do
		turn[n] = {}
		turn[n].x = way[i].x
		turn[n].y = way[i].y
		n = n + 1
	end
	way = turn
end

function love.load()
	love.window.setMode(800, 600, {resizable=true})
	math.randomseed( os.time() )
	-- init empty maze
	for i=1,grid_size do
		maze[i] = {}
		for j=1,grid_size do
			maze[i][j] = ' '
		end
	end
	-- make some walls
	for i=1,grid_size do
		for j=1,grid_size do
			if i == 1 or i == grid_size or j == 1 or j == grid_size then
				maze[i][j] = 'w'
			end
		end
	end
	-- set player position
	setPlayerPosition(2, 2)
	--setObjectPosition(enemy, 9, 9, 'e')
	--setGoalPosition(9, 7)
	setGoalPosition(9, 9)
	love.graphics.setBackgroundColor(40,128,33)
	-- make some obstacles
	create_obstacles()

	gamestate.running = true
end

function love.draw()
	if gamestate.running then
		-- debug output
		--[[
		love.graphics.print("Player: X:" .. player.x .. " Y: " .. player.y , 100, 500, 0, 2, 2)
		love.graphics.print("Goal: X:" .. goal.x .. " Y: " .. goal.y , 100, 520, 0, 2, 2)
		love.graphics.print("out: " .. maze[player.x-1][player.y] , 100, 540 )
		--]]
		local x = 5
		for i=1,grid_size do
			local y = 5
			for j=1,grid_size do
				if maze[i][j] == 'w' then
					love.graphics.rectangle('fill', x, y, square_size, square_size)
				elseif maze[i][j] == 0 then
					love.graphics.setColor(255,0,0)
					love.graphics.rectangle('fill', x, y, square_size, square_size)
					love.graphics.setColor(255,255,255)
				elseif maze[i][j] == 'g' then
					love.graphics.setColor(255,233,0)
					love.graphics.rectangle('fill', x, y, square_size, square_size)
					love.graphics.setColor(255,255,255)
				elseif maze[i][j] == 'e' then
					love.graphics.setColor(0,0,0)
					love.graphics.rectangle('fill', x, y, square_size, square_size)
					love.graphics.setColor(255,255,255)
				else --if maze[i][j] == ' ' then
					love.graphics.rectangle('line', x, y, square_size, square_size)
				end
				y = y + square_distance
			end
			x = x + square_distance
		end
	elseif gamestate.won then
        love.graphics.setColor(255,233,0)
		love.graphics.print("You won!", 10, 250, 0, 2, 2)
	end
end

function love.update(dt)
	move_timer = move_timer + dt

	if move_timer > 0.2 then
		walkToGoal()
		if love.keyboard.isDown('s', 'down') then
			if maze[player.x][player.y+1] == ' ' then
				setPlayerPosition(player.x, player.y+1)
			elseif maze[player.x][player.y+1] == 'g' then
				gamestate.running = false
				gamestate.won = true
			end
    	elseif love.keyboard.isDown('w', 'up') then
			if maze[player.x][player.y-1] == ' ' then
				setPlayerPosition(player.x, player.y-1)
			elseif maze[player.x][player.y-1] == 'g' then
				gamestate.running = false
				gamestate.won = true
			end
    	elseif love.keyboard.isDown('d', 'right') then
			if maze[player.x+1][player.y] == ' ' then
				setPlayerPosition(player.x+1, player.y)
			elseif maze[player.x+1][player.y] == 'g' then
				gamestate.running = false
				gamestate.won = true
			end
    	elseif love.keyboard.isDown('a', 'left') then
			if maze[player.x-1][player.y] == ' ' then
				setPlayerPosition(player.x-1, player.y)
			elseif maze[player.x-1][player.y] == 'g' then
				gamestate.running = false
				gamestate.won = true
			end
		end

		--[[
		if enemy.x > 2 then
			setObjectPosition(enemy, enemy.x-1, enemy.y, 'e')
		end
		]]--
		move_timer = 0
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.push('quit')
	end
	-- walk to goal
	if key == 'return' then
		findway()
		walk_running = true
	end
	-- set goal to new position
	if key == 'r' then
		pos = {}
		repeat
			pos = getRandomPosition()
		until maze[pos.x][pos.y] == ' '
		setGoalPosition(pos.x, pos.y)
		way = {}
		way_index = 1
		walk_running = false
	end
end

function getRandomPosition()
	local pos = {}

	pos.x = math.random(grid_size - 2) + 1
	pos.y = math.random(grid_size - 2) + 1

	return pos
end
