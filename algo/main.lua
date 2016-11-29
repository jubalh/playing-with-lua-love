square_size = 40
grid_size = 10
player = {x=nil,y=nil}
goal = {x=nil,y=nil}
maze = {}
gamestate = {}
move_timer = 0

function setObjectPosition(obj, x, y, sign)
	if obj.x ~= nil then
		maze[obj.x][obj.y] = ' '
	end
	obj.x = x
	obj.y = y
	maze[x][y] = sign
end

function setPlayerPosition(x, y)
	setObjectPosition(player, x, y, 'p')
end

function setGoalPosition(x, y)
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

function love.load()
	-- init empty maze
	for i=1,20 do
		maze[i] = {}
		for j=1,20 do
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
	love.graphics.setBackgroundColor(40,128,33)
	-- make some obstacles
	create_obstacles()
	-- set a goal
	setGoalPosition(9, 7)

	gamestate.running = true
end

function love.draw()
	if gamestate.running then
		local x = 5
		for i=1,grid_size do
			local y = 5
			for j=1,grid_size do
				if maze[i][j] == ' ' then
					love.graphics.rectangle('line', x, y, square_size, square_size)
				elseif maze[i][j] == 'w' then
					love.graphics.rectangle('fill', x, y, square_size, square_size)
				elseif maze[i][j] == 'p' then
					love.graphics.setColor(255,0,0)
					love.graphics.rectangle('fill', x, y, square_size, square_size)
					love.graphics.setColor(255,255,255)
				elseif maze[i][j] == 'g' then
					love.graphics.setColor(255,233,0)
					love.graphics.rectangle('fill', x, y, square_size, square_size)
					love.graphics.setColor(255,255,255)
				end
				y = y + 50
			end
			x = x + 50
		end
	elseif gamestate.won then
        love.graphics.setColor(255,233,0)
		love.graphics.print("You won!", 10, 250, 0, 2, 2)
	end
end

function love.update(dt)
	move_timer = move_timer + dt

	if key == 'escape' then
		love.event.push('quit')
	end

	if move_timer > 0.1 then
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
		move_timer = 0
	end
end

function love.keypressed(key)
end
