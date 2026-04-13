local Pet = require("src.pet")

local state = "menu" -- menu, playing, gameover
local petTypes = {"Cat","Dog"}
local selected = 1
local pet

local button = {}
button.w = 120
button.h = 36

local function startGame()
	pet = Pet.new("Buddy", petTypes[selected])
	state = "playing"
end

function love.load()
	love.window.setTitle("BitBuddy")
	font = love.graphics.newFont(14)
	love.graphics.setFont(font)
end

function love.update(dt)
	if state == "playing" and pet then
		pet:update(dt)
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

-- helper function to determine pet mood
local function getMood(pet)
	if not pet.alive then
		return "Sad"
	elseif pet.hunger < 25 then
		return "Hungry"
	elseif pet.energy < 25 then
		return "Sleepy"
	elseif pet.happiness < 25 then
		return "Unhappy"
	elseif pet.hunger > 70 and pet.energy > 70 and pet.happiness > 70 then
		return "Happy"
	else
		return "Okay"
	end
end

-- helper function for drawing simple buttons
local function drawButton(x, y, w, h, text)
	love.graphics.setColor(1,1,1)
	love.graphics.rectangle("line", x, y, w, h)
	love.graphics.printf(text, x, y+10, w, "center")
end

function love.draw()
	love.graphics.clear(0.12,0.12,0.12)
	love.graphics.setColor(1,1,1)
	love.graphics.printf("BitBuddy - Digital Pet", 0, 8, love.graphics.getWidth(), "center")

	if state == "menu" then
		love.graphics.printf("Choose a pet (press 1 or 2) and click Start", 0, 40, love.graphics.getWidth(), "center")
		for i,t in ipairs(petTypes) do
			local x = 80 + (i-1)*220
			love.graphics.rectangle("line", x, 100, 180, 120)
			love.graphics.printf(t, x, 140, 180, "center")
			if i == selected then
				love.graphics.setColor(0,1,0)
				love.graphics.rectangle("line", x-2,98,184,124)
				love.graphics.setColor(1,1,1)
			end
		end
		love.graphics.rectangle("line", love.graphics.getWidth()/2 - 60, 240, 120, 40)
		love.graphics.printf("Start", love.graphics.getWidth()/2 - 60, 248, 120, "center")

	elseif state == "playing" then
		love.graphics.printf("Pet: " .. pet.name .. " ("..pet.type..")", 8, 40, 300)
		love.graphics.printf("Mood: " .. getMood(pet), 8, 60, 300)

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
		drawButton(bx, by, button.w, button.h, "Feed")
		drawButton(bx + (button.w+pad), by, button.w, button.h, "Play")
		drawButton(bx + 2*(button.w+pad), by, button.w, button.h, "Sleep")

		love.graphics.printf("Press R to restart", 8, 270, 400)

	elseif state == "gameover" then
		love.graphics.printf("Your pet became Sad. Game Over.", 0, 120, love.graphics.getWidth(), "center")
		love.graphics.printf("Press R to restart", 0, 160, love.graphics.getWidth(), "center")
	end
end

function love.mousepressed(x,y,buttonid)
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
			pet:feed()
		end
		-- Play
		if x >= bx + (button.w+pad) and x <= bx + (button.w+pad) + button.w and y >= by and y <= by+button.h then
			pet:play()
		end
		-- Sleep
		if x >= bx + 2*(button.w+pad) and x <= bx + 2*(button.w+pad) + button.w and y >= by and y <= by+button.h then
			pet:sleep()
		end
	elseif state == "gameover" then
		-- ignore
	end
end

function love.keypressed(k)
	if state == "menu" then
		if k == "1" then selected = 1 end
		if k == "2" then selected = 2 end
	end
	if k == "r" then
		state = "menu"
		pet = nil
	end
end

--
