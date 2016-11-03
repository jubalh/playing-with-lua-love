function love.load()
	love.graphics.setColor(0,0,0,225)
	love.graphics.setBackgroundColor(225,153,0)
end

function love.draw()
	love.graphics.circle("fill",200,300,50,50)
	love.graphics.rectangle("fill",	300,300,100,100)
	love.graphics.arc("fill",450,300,100,math.pi/5,math.pi/2)
end
