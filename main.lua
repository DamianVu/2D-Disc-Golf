
require "constants"
basket = love.graphics.newImage("images/sprites/Basket.png")

CourseHandler = require "handlers.courseHandler"
MenuHandler = require "handlers.menuhandler"

person = {x = 500, y = 500, size = 60, color = {1,1,0}}
disc = {x=500,y=500, z=5,size=20, velocity = {0,0,0}, glide = 7, color={0,0,.75}}
powerBar = {y = 800, speed = 120, direction = "up"}

STATE = THROWING
currentDisc = "Driver"

function love.load()
	love.graphics.setBackgroundColor(.5,.5,.5)
	CourseHandler:init()
	CourseHandler:loadTilesets()
	CourseHandler:load()
	MenuHandler:init()
	MenuHandler:loadMenus()
end

function love.draw()


	x_translate_val = (love.graphics.getWidth() / 2) - disc.x
	y_translate_val = (love.graphics.getHeight() / 2) - disc.y

	love.graphics.push()
	love.graphics.translate(x_translate_val, y_translate_val)

	CourseHandler:draw()

	love.graphics.print("Hello",400,400)

	love.graphics.setColor(disc.color)
	love.graphics.circle("fill", disc.x - disc.size/2, disc.y - disc.size/2, disc.size)

	love.graphics.setColor(person.color)
	love.graphics.rectangle("fill", person.x - person.size/2, person.y - person.size/2, person.size, person.size)

	love.graphics.pop()


	love.graphics.print("Disc Z: "..disc.z,10,10)
	love.graphics.print("STATE: "..STATE, 10, 30)
	love.graphics.print("Disc Location: "..disc.x..", "..disc.y, 10, 50)
	love.graphics.print("Disc Selection: "..currentDisc, 10, 70)

	if STATE == THROWING then
		love.graphics.setColor(.43, .95, .53)
		love.graphics.print("Power Bar", 10, 730)
		love.graphics.rectangle("fill", 10, 750, 35, 100)

		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 10, powerBar.y, 35, 10)
	end
end

function love.update(dt)

	if STATE == FLYING then
		local modx = math.cos(disc.velocity[1])
		local mody = math.sin(disc.velocity[1])

		disc.x = disc.x + BASESPEED * modx * disc.velocity[2] * dt
		disc.y = disc.y + BASESPEED * mody * disc.velocity[2] * dt

		disc.z = disc.z + disc.velocity[3] * dt
		disc.velocity[3] = disc.velocity[3] - GRAVITY / (disc.glide / 7 * 2) * dt


		if disc.z < 0 then
			disc.z = 5
			STATE = THROWING
			person.x = disc.x
			person.y = disc.y
		end
	end

	if STATE == THROWING then
		if powerBar.y > 840 then
			powerBar.y = powerBar.y - powerBar.speed * dt
			powerBar.direction = "down"
		elseif powerBar.y < 750 then
			powerBar.y = powerBar.y + powerBar.speed * dt
			powerBar.direction = "up"
		else
			if powerBar.direction == "up" then
				powerBar.y = powerBar.y + powerBar.speed * dt
			else
				powerBar.y = powerBar.y - powerBar.speed * dt
			end
 		end
	end

end

function love.keypressed(key)
	if STATE == THROWING then
		if key == "1" then
			disc.color = {0,0,.75}
			currentDisc = "Driver"
			disc.glide = 7
		end
		if key == "2" then
			disc.color = {0,.25, 0}
			currentDisc = "MidRange"
			disc.glide = 3.5
		end
		if key == "3" then
			disc.color = {.5,0, .6}
			currentDisc = "Putter"
			disc.glide = 1
		end
	end
end

function love.mousepressed(x,y,button)

	if STATE == THROWING and button == 1 then

		STATE = FLYING
		local relX = x - x_translate_val
		local relY = y - y_translate_val

		local angle = math.atan2(relY - person.y, relX - person.x)

		local discSpeed = math.abs((powerBar.y - 740) - 100) / 50
		disc.velocity = {angle, discSpeed, 30}
		disc.x = person.x
		disc.y = person.y
	end
end
