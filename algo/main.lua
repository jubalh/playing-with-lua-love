require "position"
require "maze"
require "route"

debug = false

-- size of each square
square_size = 20
-- distance between squares
square_distance = 25
-- size of the whole grid / gamefield
grid_size = 15
-- players
player = {x=nil,y=nil}
enemy = {x=nil,y=nil}
goal = {x=nil,y=nil}
-- maze
maze = {}
-- stores the way our path finding algo found to a certain goal
player_route = {}
-- which step of the way we are at
pr_index = 1

enemy_route = {}
er_index = 1

gamestate = {running = false, won = false}
walk_running = false
move_timer = 0

function playerWalkToGoal()
	if gamestate.running == true then
		if walk_running == true then
			if player_route[pr_index] ~= nil then
				setPlayerPosition(player_route[pr_index].x, player_route[pr_index].y)
				pr_index = pr_index + 1
			end
		end
	end
end

function enemyWalkToPlayer()
	if gamestate.running == true then
		if walk_running == true then
			if enemy_route[er_index] ~= nil then
				print (enemy_route[er_index].x)--TODO: remove
				setObjectPosition(enemy, enemy_route[er_index].x, enemy_route[er_index].y, 'e')
				er_index = er_index + 1
			end
		end
	end
end

function love.load()
	love.window.setMode(800, 600, {resizable=true})
	love.graphics.setBackgroundColor(40,128,33)
	math.randomseed( os.time() )

	initMaze()
	createObstacles()

	setPlayerPosition(2, 2)
	setObjectPosition(enemy, 9, 8, 'e')
	setGoalPosition(9, 9)
	--[[
	setPlayerPosition(9, 8)
	setObjectPosition(enemy, 2, 2, 'e')
	setGoalPosition(2, 2)
	--]]

	gamestate.running = true
end

function debugOutput()
	if debug then
		love.graphics.print("Player: X:" .. player.x .. " Y: " .. player.y , 100, 500, 0, 2, 2)
		love.graphics.print("Goal: X:" .. goal.x .. " Y: " .. goal.y , 100, 520, 0, 2, 2)
		love.graphics.print("Enemy: X:" .. enemy.x .. " Y: " .. enemy.y , 100, 540, 0, 2, 2)
		love.graphics.print("out: " .. maze[player.x-1][player.y] , 100, 560 )
	end
end

function love.draw()
	if gamestate.running then
		drawMaze()
		debugOutput()
	elseif gamestate.won then
        love.graphics.setColor(255,233,0)
		love.graphics.print("You won!", 10, 250, 0, 2, 2)
	end
end

function love.update(dt)
	move_timer = move_timer + dt

	if move_timer > 0.2 then

		playerWalkToGoal()
		enemyWalkToPlayer()

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

		if gamestate.running and not gamestate.won then
		end
		--[[
		if enemy.x > 2 then
			setObjectPosition(enemy, enemy.x-1, enemy.y, 'e')
		end
		--]]
		move_timer = 0
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.push('quit')
	end
	-- walk to goal
	if key == 'return' then
		player_route = findWay(maze, player, goal, player_route)
		--enemy_route = findWay(maze, enemy, player, enemy_route)
		walk_running = true
	end
	-- set goal to new position
	if key == 'r' then
        pos = getRandomEmptyPosition(maze)
		setGoalPosition(pos.x, pos.y)
		player_route = {}
		pr_index = 1
		walk_running = false
	end
end
