-- love.graphics.newQuads:flip was removed in love 0.9.0
-- love.graphics.draw provides all we need though
-- with a x scale of -1 we can turn the image around
-- we need to set the y scale explicitly since it defaults
-- to the x scale otherwise

function love.load()
	quads = {}
	for i=1, 8 do
		quads[i] = love.graphics.newQuad((i-1)*32, 0, 32, 32, 256, 32)
	end

	character = {}
	character.player = love.graphics.newImage("sprite.png")
	character.x = 50
	character.y = 50
	direction = "right"
	iteration = 1 

	max = 8

	idle = true
	timer = 0.1
end

function love.update(dt)
	if idle == false then
		timer = timer + dt
		if timer > 0.2 then
			timer = 0.1
			iteration = iteration + 1
			if love.keyboard.isDown('right') then
				character.x = character.x + 5
			end
			if love.keyboard.isDown('left') then
				character.x = character.x - 5
			end
			if iteration > max then
				iteration = 1
			end
		end
	end
end

function love.keypressed(key)
	if key == 'right' or key == 'left' then
		direction = key
		idle = false
	end
end

function love.keyreleased(key)
	if direction == key then
		idle = true
		iteration = 1
		direction = 'right'
	end
end

function love.draw()
	if direction == 'right' then
		love.graphics.draw(character.player, quads[iteration], character.x, character.y)
	else
		-- we need to add 32 (width of the quad) because of the turning
		lov.graphics.draw(character.player, quads[iteration], character.x + 32, character.y, 0, -1, 1)
	end
end
