function setObjectPosition(maze, obj, x, y)
	if obj.x ~= nil then
		maze[obj.x][obj.y] = ' '
	end
	obj.x = x
	obj.y = y
	maze[x][y] = obj.sign
end

function getRandomPosition()
	local pos = {}

	pos.x = math.random(grid_size - 2) + 1
	pos.y = math.random(grid_size - 2) + 1

	return pos
end

function getRandomEmptyPosition(maze)
	pos = {}
	repeat
		pos = getRandomPosition()
	until maze[pos.x][pos.y] == ' '

	return pos
end
