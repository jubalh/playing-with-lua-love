-- size of each square
square_size = 20
-- distance between squares
square_distance = 25
-- size of the whole grid / gamefield
grid_size = 15

function initMaze(m)
	-- init empty maze
	for i=1, grid_size do
		m[i] = {}
		for j=1,grid_size do
			m[i][j] = ' '
		end
	end
	-- create surrounding walls
	for i=1,grid_size do
		for j=1,grid_size do
			if i == 1 or i == grid_size or j == 1 or j == grid_size then
				m[i][j] = 'w'
			end
		end
	end
end

function createObstacles(m)
	for n=4,6 do
		m[3][n] = 'w'
	end
	for n=4,6 do
		m[n][6] = 'w'
	end
end

function drawMaze(m)
	local x = 5
	for i=1,grid_size do
		local y = 5
		for j=1,grid_size do
			if m[i][j] == 'w' then
				love.graphics.rectangle('fill', x, y, square_size, square_size)
			elseif m[i][j] == playersign then
				love.graphics.setColor(255,0,0)
				love.graphics.rectangle('fill', x, y, square_size, square_size)
				love.graphics.setColor(255,255,255)
			elseif m[i][j] == goalsign then
				love.graphics.setColor(255,233,0)
				love.graphics.rectangle('fill', x, y, square_size, square_size)
				love.graphics.setColor(255,255,255)
			elseif m[i][j] == enemysign then
				love.graphics.setColor(0,0,0)
				love.graphics.rectangle('fill', x, y, square_size, square_size)
				love.graphics.setColor(255,255,255)
			else --if m[i][j] == ' ' then
				love.graphics.rectangle('line', x, y, square_size, square_size)
			end
			y = y + square_distance
		end
		x = x + square_distance
	end
end
