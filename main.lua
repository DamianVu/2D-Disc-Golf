
require "constants"
require "handlers.menuHelperFunctions"
basket = love.graphics.newImage("images/sprites/Basket.png")

CourseHandler = require "handlers.courseHandler"
MenuHandler = require "handlers.menuhandler"
RoundHandler = require "handlers.roundhandler"
CollisionHandler = require "handlers.collisionHandler"
RecapHandler = require "handlers.recapHandler"
DebugHandler = require "handlers.debugHandler"
ScorecardHandler = require "handlers.scorecardHandler"

person = {x = 500, y = 500, size = 60, color = {1,1,0}}
disc = {x = 850, y = 500, z = 5, size = 20, noseAngle = 0, velocity = {0,0,0}, fade = 5, glide = 7, turn = -1, color = {0,0,.75}}
powerBar = {y = 800, speed = 120, direction = "up"}
heightBar = {y = 840, speed = 120, direction = "up"}
throwingChoice = "power"
numOfStrokes = 0
initialThrowAngle = 0
mouse = {angle = 0, length = 200}
x_translate_val = 0
y_translate_val = 0

timeFlying = 0
timeGuess = 0

zoomFactor = 1

initialDirection = 0
finalDirection = 0

STATE = MAINMENU
currentDisc = "Driver"

function love.load()
	love.graphics.setBackgroundColor(.5,.5,.5)
	CourseHandler:init()
	CourseHandler:loadTilesets()
	MenuHandler:init()
	MenuHandler:loadMenus()
	CollisionHandler:init()
	CollisionHandler:default()
	RecapHandler:init()
	RecapHandler:default()
	RoundHandler:initialize()
	ScorecardHandler:init()
	ScorecardHandler:default()

	-- Add objects to collision handler
	testColObj1 = {x = 64, y = 64, size = 64, height = 50}
	testColObj2 = {x = 1028, y = 128, size = 64, height = 30}
	testColObj3 = {x = 512, y = 64, size = 64, height = 120}
	testColObj4 = {x = 128, y = 128, size = 64, height = 40}
	testColObj5 = {x = 256, y = 1028, size = 64, height = 80}
	CollisionHandler:addObject(testColObj1)
	CollisionHandler:addObject(testColObj2)
	CollisionHandler:addObject(testColObj3)
	CollisionHandler:addObject(testColObj4)
	CollisionHandler:addObject(testColObj5)


	w = love.graphics.getWidth()
	h = love.graphics.getHeight()
end

function love.draw()

	if STATE ~= MAINMENU then
		x_translate_val = (w / 2) - disc.x * zoomFactor
		y_translate_val = (h / 2) - disc.y * zoomFactor

		love.graphics.push()
		love.graphics.translate(x_translate_val, y_translate_val)
		love.graphics.scale(zoomFactor)

		RoundHandler:draw()

		CollisionHandler:drawCollisionObjects()
		CollisionHandler:drawObjectHeights()

		love.graphics.print("Hello",400,400)


		love.graphics.setColor(person.color)
		--love.graphics.rectangle("fill", person.x - person.size/2, person.y - person.size/2, person.size, person.size)

		love.graphics.setColor(disc.color)
		love.graphics.circle("fill", disc.x, disc.y, disc.size + (disc.z - 5)/4)


		love.graphics.pop()

		DebugHandler:draw()
		--stroke counter stuff
		----background
		love.graphics.setColor(1, .5, 1)
		love.graphics.rectangle("fill", 1500, 800, 100, 100)
		----words
		love.graphics.setColor(.25, 0, .95)
		love.graphics.print("# of Strokes", 1500, 800)
		----stroke number
		love.graphics.setNewFont(70)
		love.graphics.print(numOfStrokes, 1505, 820)
		love.graphics.setNewFont(12)

		if STATE == THROWING then
			--background boarder
			love.graphics.setColor(person.color)
			love.graphics.rectangle("fill", 0, 770, 5, 130)
			love.graphics.rectangle("fill", 160, 770, 5, 130)
			love.graphics.rectangle("fill", 5, 770, 155, 5)
			love.graphics.rectangle("fill", 5, 895, 155, 5)

			--background rectangle
			love.graphics.setColor(.5, .5, .5)
			love.graphics.rectangle("fill", 5, 775, 155, 120)

			--powerBar
			love.graphics.setColor(.25, 0, .95)
			love.graphics.print("Power Bar", 15, 775)
			love.graphics.rectangle("fill", 15, 795, 35, 100)

			love.graphics.setColor(.43, .95, .53)
			love.graphics.rectangle("fill", 15, powerBar.y, 35, 10)

			--heightBar
			love.graphics.setColor(.25, 0, .95)
			love.graphics.print("Height Bar", 95, 775)
			love.graphics.rectangle("fill", 95, 795, 35, 100)

			love.graphics.setColor(.43, .95, .53)
			love.graphics.rectangle("fill", 95, heightBar.y, 35, 10)

			love.graphics.setColor(1, 1, 1)
			love.graphics.line(w/2, h/2, mouse.drawX, mouse.drawY)
		end

		if STATE == RECAP then
			RecapHandler:draw()
		end

		if STATE == PAUSED then
			ScorecardHandler:draw()
			love.graphics.setNewFont(40)
			love.graphics.setColor(0,0,.3)
			if pauseMenuItem == 2 then
				love.graphics.print("Resume (Esc)", w/2 - 131, h/2 + 101)
				love.graphics.print("Resume (Esc)", w/2 - 129, h/2 + 101)
				love.graphics.print("Resume (Esc)", w/2 - 131, h/2 + 99)
				love.graphics.print("Resume (Esc)", w/2 - 129, h/2 + 99)
			else
				love.graphics.print("Quit", w/2 - 49, h/2 + 201)
				love.graphics.print("Quit", w/2 - 51, h/2 + 201)
				love.graphics.print("Quit", w/2 - 49, h/2 + 199)
				love.graphics.print("Quit", w/2 - 51, h/2 + 199)
			end

			love.graphics.setColor(1,1,1)
			love.graphics.print("Resume (Esc)", w/2 - 130, h/2 + 100)
			love.graphics.print("Quit", w/2 - 50, h/2 + 200)
		end
	else
		love.graphics.setNewFont(24)
		MenuHandler:draw()
		love.graphics.setNewFont(12)
		love.graphics.print("Selection: "..MenuHandler.selection, 10, 10)
	end
end

function love.update(dt)
	if STATE ~= MAINMENU then
		if STATE == FLYING then
			zoomFactor = 20 / (disc.size + (disc.z - 5)/7)
			if disc.z < 5 then
				zoomFactor = 1
			end
			timeFlying = timeFlying + dt
			local modx = math.cos(disc.velocity[1])
			local mody = math.sin(disc.velocity[1])

			disc.x = disc.x + modx * disc.velocity[2] * dt
			disc.y = disc.y + mody * disc.velocity[2] * dt

			disc.velocity[2] = disc.velocity[2] - math.sqrt(disc.velocity[2]) * 2 * dt
			if disc.velocity[2] < 0 then disc.velocity[2] = 0 end

			disc.z = disc.z + disc.velocity[3] * dt

			-- Only when falling should we factor in glide.
			if disc.velocity[3] < 0 then
				disc.velocity[3] = disc.velocity[3] - GRAVITY * dt / (((disc.glide + 2) / 3) * (math.pi/2 - disc.noseAngle))
			else
				disc.velocity[3] = disc.velocity[3] - GRAVITY * dt
			end



			-- Make the disc Hyzer
			-- We want the disc to hyzer more based on how slow it is traveling compounded with its turn value
			-- Higher turn value means that it doesn't flip much, and thus most overstable.

			if disc.velocity[2] < initialSpeed * .8 then
				disc.velocity[1] = disc.velocity[1] - dt/2
			end

			-- Normalize Disc Velocity vector to stay between -pi and pi
			if disc.velocity[1] < -math.pi then
				local difference = math.abs(disc.velocity[1] + math.pi)
				disc.velocity[1] = math.pi - difference
			elseif disc.velocity[1] > math.pi then
				local difference = math.abs(disc.velocity[1] - math.pi)
				disc.velocity[1] = -math.pi + difference
			end

			CollisionHandler:update(dt)


			if disc.z < 0 then
				STATE = RECAP
				finalPosition = {disc.x, disc.y}
				recapTimer = 0
				person.x = disc.x
				person.y = disc.y
				CollisionHandler.colliding = false
			end
		end

		if STATE == THROWING then
			local x, y = love.mouse.getPosition()

			local relX = x - x_translate_val
			local relY = y - y_translate_val

			mouse.angle = math.atan2(relY - disc.y, relX - disc.x)
			mouse.drawX = w/2 + math.cos(mouse.angle) * mouse.length
			mouse.drawY = h/2 + math.sin(mouse.angle) * mouse.length

			if throwingChoice == "power" then
				if powerBar.y > 885 then
					powerBar.y = 885
					powerBar.y = powerBar.y - powerBar.speed * dt
					powerBar.direction = "down"
				elseif powerBar.y < 795 then
					powerBar.y = 795
					powerBar.y = powerBar.y + powerBar.speed * dt
					powerBar.direction = "up"
				else
					if powerBar.direction == "up" then
						powerBar.y = powerBar.y + powerBar.speed * dt
					else
						powerBar.y = powerBar.y - powerBar.speed * dt
					end
		 		end
			elseif throwingChoice == "height" then
				if heightBar.y > 885 then
					heightBar.y = 885
					heightBar.y = heightBar.y - heightBar.speed * dt
					heightBar.direction = "down"
				elseif heightBar.y < 795 then
					heightBar.y = 795
					heightBar.y = heightBar.y + heightBar.speed * dt
					heightBar.direction = "up"
				else
					if heightBar.direction == "up" then
						heightBar.y = heightBar.y + heightBar.speed * dt
					else
						heightBar.y = heightBar.y - heightBar.speed * dt
					end
		 		end
			end

		end

		if STATE == RECAP then
			RecapHandler:update(dt)
		end
	end
end

function love.keypressed(key)
	if key == "d" then
		DebugHandler:toggle()
	end
	if STATE == THROWING then
		if key == "1" then
			disc.color = {0,0,.75}
			currentDisc = "Driver"
			disc.glide = 7
			disc.fade = 5
			disc.turn = -1
		end
		if key == "2" then
			disc.color = {1,.25, 0}
			currentDisc = "MidRange"
			disc.glide = 3.5
			disc.fade = 3
			disc.turn = 0
		end
		if key == "3" then
			disc.color = {.8, .25, .56}
			currentDisc = "Putter"
			disc.glide = 1
			disc.fade = 1
			disc.turn = 0
		end
		if key == "space" then
			if throwingChoice == "power" then
				throwingChoice = "height"
			elseif throwingChoice == "height" then
				throwingChoice = "direction"
			end
		end
	end

	if STATE == MAINMENU then
		if key == "up" or key == "w" then
			MenuHandler:changeSelection(true)
		end
		if key == "down" or key == "s" then
			MenuHandler:changeSelection(false)
		end
		if key == "return" then
			MenuHandler:selectOption()
		end
		if key == "escape" then
			love.event.quit()
		end
	end

	if STATE == RECAP then
		if key == "space" then
			RecapHandler.skip = true
		end
	end


	if STATE ~= MAINMENU and key == "escape" then
		if STATE == PAUSED then
			STATE = prevState
		else
			prevState = STATE
			pauseMenuItem = 1
			STATE = PAUSED
			ScorecardHandler:updateOnce()
		end
	end

	if STATE == PAUSED then
		if key == "w" or key == "up" or key == "s" or key == "down" then
			if pauseMenuItem == 1 then pauseMenuItem = 2 else pauseMenuItem = 1 end
		end

		if key == "return" then
			if pauseMenuItem == 1 then
				STATE = prevState
			else
				person = {x = 500, y = 500, size = 60, color = {1,1,0}}
				disc = {x = 850, y = 500, z = 5, size = 20, noseAngle = 0, velocity = {0,0,0}, fade = 5, glide = 7, turn = -1, color = {0,0,.75}}
				powerBar = {y = 800, speed = 120, direction = "up"}
				heightBar = {y = 840, speed = 120, direction = "up"}
				throwingChoice = "power"
				numOfStrokes = 0
				initialThrowAngle = 0
				mouse = {angle = 0, length = 200}
				x_translate_val = 0
				y_translate_val = 0

				timeFlying = 0
				timeGuess = 0

				zoomFactor = 1

				initialDirection = 0
				finalDirection = 0

				STATE = MAINMENU
				currentDisc = "Driver"
			end
		end
	end
end

function love.mousepressed(x,y,button)

	if STATE == THROWING and button == 1 and throwingChoice == "direction" then
		timeFlying = 0
		STATE = FLYING
		throwingChoice = "power"
		initialPosition = {disc.x, disc.y}
		numOfStrokes = numOfStrokes + 1
		local relX = x - x_translate_val
		local relY = y - y_translate_val

		local abs = math.abs

		local direction = math.atan2(relY - disc.y, relX - disc.x)

		local releaseSpeed = abs(powerBar.y - 895) -- Will range from 10-100

		local zVel = abs(heightBar.y - 885) / 90 -- Will range from 0 - 100

		-- The height will be the height above throwing it flat.
		-- There is no point in throwing straight up and down, so we will say we can throw it at a max of 80 degrees above flat.
		local releaseAngle = zVel * (math.pi / 2)* 8 / 9

		-- This is really tough because we don't factor in drag...
		-- Now we factor in the disc speed...
		-- We want the disc to have the longest flight when it is thrown at 45 degrees?
		zVel = math.sin(releaseAngle) * releaseSpeed

		local discSpeed = math.cos(releaseAngle) * releaseSpeed * 7

		disc.noseAngle = releaseAngle


		disc.velocity = {direction, discSpeed, zVel}
		initialDirection = direction
		initialSpeed = discSpeed
	end
	if STATE == RECAP and button == 1 then
		RecapHandler.skip = true
	end
end
