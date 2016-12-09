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
