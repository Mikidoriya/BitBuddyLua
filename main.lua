local Pet = require("src.pet")

local state = "menu" -- menu, playing, gameover
local petTypes = {"Cat","Dog"}
local selected = 1
local pet
local sprites = {}

local button = {}
button.w = 120
button.h = 36

local function startGame()
	pet = Pet.new("Buddy", petTypes[selected])
	pet.sprite = sprites[pet.type]
	pet.scale=sprites[pet.type].scale

	pet.x = love.graphics.getWidth()/2 - 150
	pet.y = 40

	local ok, err = pcall(function()
		pet = Pet.new("Buddy", petTypes[selected])
	end)
	if not ok then
		print("Error creating pet: " .. err)
		return
	end
	state = "playing"
end

function love.load()
	if not love.window or not love.window.setTitle then
		error("Love2D window module not available")
	end
	love.window.setTitle("BitBuddy")
	if not love.graphics or not love.graphics.newFont then
		error("Love2D graphics module not available")
	end
	font = love.graphics.newFont(14)
	love.graphics.setFont(font)

	sprites = {
		Dog = {
			img= love.graphics.newImage("images/dog.png"),
			scale = 0.25
		},
		Cat = {
			img = love.graphics.newImage("images/cat.png"),
			scale = 2.5
		}
	}
	ripImg = love.graphics.newImage("images/rip.png")
end

function love.update(dt)
	if state == "playing" and pet then
		local ok, err = pcall(function()
			pet:update(dt)
		end)
		if not ok then
			print("Error updating pet: " .. err)
			state = "gameover"
			return
		end
		if not pet.alive then
			state = "gameover"
		end
	end
end

local function drawBar(x,y,w,h, value, max, col)
	love.graphics.setColor(0.2,0.2,0.2)
	love.graphics.rectangle("fill", x, y, w, h)
	local pct = math.max(0, math.min(1, value / max))
	love.graphics.setColor(col)
	love.graphics.rectangle("fill", x+2, y+2, (w-4)*pct, h-4)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line", x, y, w, h)
end

function love.draw()
	love.graphics.clear(0.12,0.12,0.12)
	love.graphics.setColor(1,1,1)
	love.graphics.printf("BitBuddy - Digital Pet", 0, 8, love.graphics.getWidth(), "center")

	if state == "menu" then
		love.graphics.printf("Choose a pet (press 1 or 2) and click Start", 0, 40, love.graphics.getWidth(), "center")
		
		--local previewType = petTypes[selected]
		--if sprites[previewType] then
		--	love.graphics.draw(sprites[previewType], 100, 100, 0, 0.5, 0.5)
		--end

		local screenW = love.graphics.getWidth()

		local boxW = 180
		local boxH = 120
		local spacing = 40
		local totalW = boxW * 2 + spacing

		local startX = (screenW - totalW) / 2
		local y = 100

		for i, t in ipairs(petTypes) do
    	local x = startX + (i-1)*(boxW + spacing)

    -- box
    	love.graphics.rectangle("line", x, y, boxW, boxH)
		
		--for i,t in ipairs(petTypes) do
			--local x = 80 + (i-1)*220
			--love.graphics.rectangle("line", x, 100, 180, 120)
			

		if sprites[t] then
        	local sprite = sprites[t]
        	love.graphics.draw(
            sprite.img,
            x + boxW/2,
            y + boxH/2 - 10,
            0,
            sprite.scale,
            sprite.scale,
            sprite.img:getWidth()/2,
            sprite.img:getHeight()/2
        )
    	end

			--love.graphics.printf(t, x, 200, 180, "center")
			love.graphics.printf(t, x, y + 95 , boxW, "center")
			if i == selected then
				love.graphics.setColor(0,1,0)
				--love.graphics.rectangle("line", x-2,98,184,124)
				love.graphics.rectangle("line", x-2, y-2, boxW+4, boxH+4)
				love.graphics.setColor(1,1,1)
			end
		end

		love.graphics.rectangle("line", love.graphics.getWidth()/2 - 60, 240, 120, 40)
		love.graphics.printf("Start", love.graphics.getWidth()/2 - 60, 248, 120, "center")

	elseif state == "playing" then
		love.graphics.printf("Pet: " .. pet.name .. " ("..pet.type..")", 8, 40, 300)
		
		if pet.sprite then
			local img = pet.sprite.img
			local scale = pet.sprite.scale
			love.graphics.draw(
				img,
				pet.x,
				pet.y,
				0,
				scale,
				scale,
				img:getWidth()/2 ,
				img:getHeight()/2
			)
		end
		
		drawBar(8,80,300,28, pet.hunger, pet.max, {1,0.4,0.4})
		love.graphics.print("Hunger", 320, 84)
		drawBar(8,120,300,28, pet.happiness, pet.max, {0.4,1,0.6})
		love.graphics.print("Happiness", 320, 124)
		drawBar(8,160,300,28, pet.energy, pet.max, {0.4,0.6,1})
		love.graphics.print("Energy", 320, 164)

		-- buttons
		local bx = 8
		local by = 210
		local pad = 8
		love.graphics.rectangle("line", bx, by, button.w, button.h)
		love.graphics.printf("Feed", bx, by+10, button.w, "center")

		love.graphics.rectangle("line", bx + (button.w+pad), by, button.w, button.h)
		love.graphics.printf("Play", bx + (button.w+pad), by+10, button.w, "center")

		love.graphics.rectangle("line", bx + 2*(button.w+pad), by, button.w, button.h)
		love.graphics.printf("Sleep", bx + 2*(button.w+pad), by+10, button.w, "center")

		love.graphics.printf("Press R to restart", 8, 270, 400)

	elseif state == "gameover" then
		love.graphics.printf("Your pet became Sad. Game Over.", 0, 120, love.graphics.getWidth(), "center")
		love.graphics.printf("Press R to restart", 0, 160, love.graphics.getWidth(), "center")
		
		if ripImg then
			love.graphics.draw(
				ripImg,
				love.graphics.getWidth()/2,
				200,
				0,
				0.4,
				0.4,
				ripImg:getWidth()/2 ,
				0
			)
		end
	end
end

function love.mousepressed(x,y,buttonid)
	if not x or not y then
		print("Warning: Invalid mouse coordinates")
		return
	end
	if state == "menu" then
		local sx = love.graphics.getWidth()/2 - 60
		if x >= sx and x <= sx + 120 and y >= 240 and y <= 280 then
			startGame()
		end
		for i=1,#petTypes do
			local px = 80 + (i-1)*220
			if x >= px and x <= px+180 and y >= 100 and y <= 220 then
				selected = i
			end
		end
	elseif state == "playing" and pet then
		local bx = 8
		local by = 210
		local pad = 8
		-- Feed
		if x >= bx and x <= bx+button.w and y >= by and y <= by+button.h then
			local ok, err = pcall(function() pet:feed() end)
			if not ok then print("Error feeding pet: " .. err) end
		end
		-- Play
		if x >= bx + (button.w+pad) and x <= bx + (button.w+pad) + button.w and y >= by and y <= by+button.h then
			local ok, err = pcall(function() pet:play() end)
			if not ok then print("Error playing with pet: " .. err) end
		end
		-- Sleep
		if x >= bx + 2*(button.w+pad) and x <= bx + 2*(button.w+pad) + button.w and y >= by and y <= by+button.h then
			local ok, err = pcall(function() pet:sleep() end)
			if not ok then print("Error putting pet to sleep: " .. err) end
		end
	elseif state == "gameover" then
		-- ignore
	end
end

function love.keypressed(k)
	if not k then
		print("Warning: Invalid key pressed")
		return
	end
	if state == "menu" then
		if k == "1" then selected = 1 end
		if k == "2" then selected = 2 end
	end
	if k == "r" then
		state = "menu"
		pet = nil
	end
end

