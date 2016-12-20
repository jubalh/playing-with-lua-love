require "position"
require "maze"
require "route"

debug = false
playersign = 'p'
enemysign = 'e'
goalsign = 'g'
gamestate = {running = false, won = false, lost = false}

-- players
local player = {x=nil, y=nil, sign=playersign}
local enemy = {x=nil, y=nil, sign=enemysign, last_player_pos = {x=0, y=0}}
local goal = {x=nil, y=nil, sign=goalsign}
-- maze
local maze = {}
-- stores the way our path finding algo found to a certain goal
local player_route = {}
-- which step of the way we are at
local pr_index = 1

local enemy_route = {}
local er_index = 1

local walk_running = false
local move_timer = 0
local enemy_check_timer = 0

function playerWalkToGoal()
	if gamestate.running == true then
		if walk_running == true then
			if player_route[pr_index] ~= nil then
				setObjectPosition(maze, player, player_route[pr_index].x, player_route[pr_index].y)
				pr_index = pr_index + 1
			end
		end
	end
end

function enemyWalkToPlayer()
	if gamestate.running == true then
		if walk_running == true then
			if enemy_route[er_index] ~= nil then
				if maze[enemy_route[er_index].x][enemy_route[er_index].y] == playersign then
					gamestate.lost = true
					gamestate.running = false
				end
				setObjectPosition(maze, enemy, enemy_route[er_index].x, enemy_route[er_index].y)
				er_index = er_index + 1
			end
		end
	end
end

function love.load()
	love.window.setMode(800, 600, {resizable=true})
	love.graphics.setBackgroundColor(40,128,33)
	math.randomseed( os.time() )

	initMaze(maze)
	createObstacles(maze)

	setObjectPosition(maze, player, 2, 2)
	setObjectPosition(maze, enemy, 9, 8)
	setGoalPosition(9, 9)

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
		drawMaze(maze)
		debugOutput()
	elseif gamestate.won then
        love.graphics.setColor(255,233,0)
		love.graphics.print("You won!", 10, 250, 0, 2, 2)
	elseif gamestate.lost then
		love.graphics.setBackgroundColor(196,2,51)
        love.graphics.setColor(255,233,0)
		love.graphics.print("You lost!", 10, 250, 0, 2, 2)
	end
end

function love.update(dt)
	if gamestate.running then
		move_timer = move_timer + dt
		enemy_check_timer = enemy_check_timer + dt

		if enemy_check_timer > 1 then
			enemy_findway()
			enemy_check_timer = 0
		end

		if move_timer > 0.15 then
			playerWalkToGoal()
			enemyWalkToPlayer()

			if love.keyboard.isDown('s', 'down') then
				if maze[player.x][player.y+1] == ' ' then
					setObjectPosition(maze, player, player.x, player.y+1)
				elseif maze[player.x][player.y+1] == 'g' then
					gamestate.running = false
					gamestate.won = true
				end
			end
			if love.keyboard.isDown('w', 'up') then
				if maze[player.x][player.y-1] == ' ' then
					setObjectPosition(maze, player, player.x, player.y-1)
				elseif maze[player.x][player.y-1] == 'g' then
					gamestate.running = false
					gamestate.won = true
				end
			end
			if love.keyboard.isDown('d', 'right') then
				if maze[player.x+1][player.y] == ' ' then
					setObjectPosition(maze, player, player.x+1, player.y)
				elseif maze[player.x+1][player.y] == 'g' then
					gamestate.running = false
					gamestate.won = true
				end
			end
			if love.keyboard.isDown('a', 'left') then
				if maze[player.x-1][player.y] == ' ' then
					setObjectPosition(maze, player, player.x-1, player.y)
				elseif maze[player.x-1][player.y] == 'g' then
					gamestate.running = false
					gamestate.won = true
				end
			end

			move_timer = 0
		end
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.push('quit')
	end
	-- walk to goal
	if key == 'return' then
		--player_route = findWay(maze, player, goal, player_route)
		enemy_findway()
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

--TODO:
--also use setObjectPosition and maybe return something if we
--kill another thing on that position?
function setGoalPosition(x, y)
	if goal.x ~= nil then
		-- in case player walked onto goal field
		if maze[goal.x][goal.y] == player.sign then
			tmp = {}
			tmp.x = goal.x
			tmp.y = goal.y
			setObjectPosition(maze, goal, x, y)
			setObjectPosition(maze, player, tmp.x, tmp.y)
		end
	end
	setObjectPosition(maze, goal, x, y)
end

function enemy_findway()
	-- if player moved position
	if enemy.last_player_pos.x ~= player.x or enemy.last_player_pos.y ~= player.y then
		-- calculate new way
		enemy_route = findWay(maze, enemy, player, enemy_route)
		--walk_running = true

		enemy.last_player_pos.x = player.x
		enemy.last_player_pos.y = player.y
	end
end
