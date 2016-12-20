game = {}

function game.load()
	game.clock = 0

	game.enemy_size = imgs["enemy"]:getWidth()
	game.enemies = {}
	game.enemy_dt = 0
	game.enemy_rate = 2

	game.player_size = imgs["player"]:getWidth()
	game.playerx = (wwidth/2)*scale
	game.playery = (wheight-12)*scale

	game.ammo = 10
	game.recharge_dt = 0
	game.recharge_rate = 1
	game.bullet_size = imgs["bullet"]:getWidth()
	game.bullets = {}

	game.score = 0
end

function game.draw()
	for i = 0, 4 do
		for j = -1, 4 do
			love.graphics.draw(imgs["background"], i*32*scale, (j+game.clock%1)*32*scale, 0, scale, scale)
		end
	end

	for _, v in ipairs(game.enemies) do
		love.graphics.draw(imgs["enemy"], v.x, v.y, 0, scale,scale, game.enemy_size/2, game.enemy_size/2)
		if debug then
			love.graphics.circle("line", v.x, v.y, game.enemy_size/2*scale)
		end
	end

	love.graphics.draw(imgs["player"], game.playerx, game.playery, 0, scale, scale, game.player_size/2, game.player_size/2)
	if debug then
		love.graphics.circle("line", game.playerx, game.playery, game.player_size/2*scale)
	end

	for _, v in ipairs(game.bullets) do
		love.graphics.draw(imgs["bullet"], v.x, v.y, 0, scale, scale, game.bullet_size/2*scale, game.bullet_size/2*scale)
		if debug then
			love.graphics.circle("line", v.x, v.y, game.bullet_size/2*scale)
		end
	end

	love.graphics.setColor(fontcolor.r, fontcolor.g, fontcolor.b)
	love.graphics.printf("score: " .. game.score .. " ammo: " .. game.ammo, 0, 0, love.graphics.getWidth(), "center")
	if debug then
		love.graphics.print(
		"enemies: " .. #game.enemies ..
		"\nbullets: " .. #game.bullets ..
		"\nenemy_rate: " .. game.enemy_rate ..
		"\nFPT: " .. love.timer.getFPS(),
		0, 14*scale)
	end
	love.graphics.setColor(255, 255, 255)
end

function game.update(dt)
	game.clock = game.clock + dt

	game.enemy_dt = game.enemy_dt + dt
	if game.enemy_dt > game.enemy_rate then
		game.enemy_dt = game.enemy_dt - game.enemy_rate
		game.enemy_rate = game.enemy_rate - 0.01 * game.enemy_rate
		local enemy = {}
		enemy.x = math.random((8)*scale, (wwidth-8)*scale)
		enemy.y = -game.enemy_size
		table.insert(game.enemies, enemy)
	end

	for ei, ev in ipairs(game.enemies) do
		ev.y = ev.y + 70*dt*scale
		if ev.y > wheight*scale then
			table.remove(game.enemies, ei)
		end

		-- player too close?
		-- 12 = half of player size
		-- 8 = half of enemy size
		if game.dist(game.playerx, game.playery, ev.x, ev.y) < (12+8)*scale then
			splash.load()
			state = "splash"
		end
	end

	if love.keyboard.isDown("right") then
		game.playerx = game.playerx + 100*dt*scale
	end
	if love.keyboard.isDown("left") then
		game.playerx = game.playerx - 100*dt*scale
	end
	if game.playerx > wwidth*scale then
		game.playerx = 160*scale
	end
	if game.playerx < 0 then
		game.playerx = 0
	end

	for bi, bv in ipairs(game.bullets) do
		bv.y = bv.y - 100*dt*scale
		if bv.y < 0 then
			table.remove(game.bullets, bi)
		end
		for ei, ev in ipairs(game.enemies) do
			if game.dist(bv.x, bv.y, ev.x, ev.y) < (2+8)*scale then
				game.score = game.score + 1
				table.remove(game.enemies, ei)
--				table.remove(game.bullets, bi)
			end
		end
	end

	game.recharge_dt = game.recharge_dt + dt
	if game.recharge_dt > game.recharge_rate then
		game.recharge_dt = game.recharge_dt - game.recharge_rate
		game.ammo = game.ammo + 1
		if game.ammo > 10 then
			game.ammo = 10
		end
	end
end

function game.keypressed(key)
	if key == "space" and game.ammo > 0 then
		love.audio.play(shoot)
		game.ammo = game.ammo - 1
		local bullet = {}
		bullet.x = game.playerx + game.player_size
		bullet.y = game.playery
		table.insert(game.bullets, bullet)
	end
end

function game.dist(x1, y1, x2, y2)
	return math.sqrt((x1-x2)^2 + (y1-y2)^2)
end
