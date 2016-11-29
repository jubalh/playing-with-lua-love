    square_size = 40
    grid_size = 10
     
    player = {x,y}
     
    maze = {}
    for i=1,20 do
            maze[i] = {}
            for j=1,20 do
                    maze[i][j] = ' '
            end
    end
     
    function setPlayerPosition(x, y)
            if player.x ~= nil then
                    maze[player.x][player.y] = ' '
            end
            player.x = x
            player.y = y
            maze[x][y] = 'p'
    end
     
    for i=1,grid_size do
            for j=1,grid_size do
                    if i == 1 or i == grid_size or j == 1 or j == grid_size then
                            maze[i][j] = 'w'
                    end
            end
    end
     
    setPlayerPosition(2, 2)
     
    function love.load()
            love.graphics.setBackgroundColor(40,128,33)
    end
     
    function love.draw()
            x = 5
            for i=1,grid_size do
                    y = 5
                    for j=1,grid_size do
     
                            if maze[i][j] == ' ' then
                                    love.graphics.rectangle('line', x, y, square_size, square_size)
                            elseif maze[i][j] == 'w' then
                                    love.graphics.rectangle('fill', x, y, square_size, square_size)
                            elseif maze[i][j] == 'p' then
                                    love.graphics.setColor(255,0,0)
                                    love.graphics.rectangle('fill', x, y, square_size, square_size)
                                    love.graphics.setColor(255,255,255)
                            end
                    y = y + 50
                    end
                    x = x + 50
            end
    end
     
    function love.update(dt)
            if love.keyboard.isDown('escape') then
                    love.event.push('quit')
            elseif love.keyboard.isDown('s') then
                    setPlayerPosition(player.x, player.y+1)
            end
    end

