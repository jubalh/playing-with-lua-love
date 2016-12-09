function initMaze()
	-- init empty maze
	for i=1,grid_size do
		maze[i] = {}
		for j=1,grid_size do
			maze[i][j] = ' '
		end
	end
	-- create surrounding walls
	for i=1,grid_size do
		for j=1,grid_size do
			if i == 1 or i == grid_size or j == 1 or j == grid_size then
				maze[i][j] = 'w'
			end
		end
	end
end

function createObstacles()
	for n=4,6 do
		maze[3][n] = 'w'
	end
	for n=4,6 do
		maze[n][6] = 'w'
	end
end

function drawMaze()
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
end
