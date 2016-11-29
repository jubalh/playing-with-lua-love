player = {x = 200, y = 200, speed = 200, img = nil}

function love.load()
	player.img = love.graphics.newImage("assets/character1.png")
	--love.graphics.setColor(0,0,0,225)
	love.graphics.setBackgroundColor(225,153,0)
end

function love.draw()
	love.graphics.draw(player.img, player.x, player.y)
	love.graphics.rectangle('fill', player.x + (player.img:getWidth()/2), player.y, 30, 30)
end

function love.update(dt)
	if love.keyboard.isDown('escape') then
		love.event.push('quit')
	end

	if love.keyboard.isDown(' ') then
	end

	-- UP movement
	if love.keyboard.isDown('w') then
		if player.y > 0 then
			player.y = player.y - (player.speed*dt)
	    end
	-- DOWN movement
	elseif love.keyboard.isDown('s') then
		if player.y < (love.graphics.getHeight() - player.img:getHeight()) then
			player.y = player.y + (player.speed*dt)
		end
	-- LEFT movement
	elseif love.keyboard.isDown('a') then
		if player.x > 0 then
			player.x = player.x - (player.speed*dt)
		end
	-- RIGHT movement
	elseif love.keyboard.isDown('d') then
		if player.x < (love.graphics.getWidth() - player.img:getWidth()) then
			player.x = player.x + (player.speed*dt)
		end
	end
end
