
require "constants"

person = {x = 500, y = 500, size = 60, color = {1,1,0}}
disc = {x=500,y=500, z=5,size=20, velocity = {0,0,0}, color={0,0,.75}}

STATE = THROWING

function love.load()
	love.graphics.setBackgroundColor(.5,.5,.5)
end

function love.draw()


	x_translate_val = (love.graphics.getWidth() / 2) - disc.x
	y_translate_val = (love.graphics.getHeight() / 2) - disc.y

	love.graphics.push()
	love.graphics.translate(x_translate_val, y_translate_val)

	love.graphics.print("Hello",400,400)

	love.graphics.setColor(disc.color)
	love.graphics.circle("fill", disc.x - disc.size/2, disc.y - disc.size/2, disc.size)

	love.graphics.setColor(person.color)
	love.graphics.rectangle("fill", person.x - person.size/2, person.y - person.size/2, person.size, person.size)

	love.graphics.pop()


	love.graphics.print("Disc Z: "..disc.z,10,10)

end

function love.update(dt)

	if STATE == FLYING then
		local modx = math.cos(disc.velocity[1])
		local mody = math.sin(disc.velocity[1])

		disc.x = disc.x + BASESPEED * modx * disc.velocity[2] * dt
		disc.y = disc.y + BASESPEED * mody * disc.velocity[2] * dt

		disc.z = disc.z + disc.velocity[3] * dt
		disc.velocity[3] = disc.velocity[3] - GRAVITY * dt


		if disc.z < 0 then
			disc.z = 0
			STATE = THROWING
			person.x = disc.x
			person.y = disc.y
		end
	end

end


function love.mousepressed(x,y,button)

	if STATE == THROWING and button == 1 then

		STATE = FLYING
		local relX = x - x_translate_val
		local relY = y - y_translate_val

		local angle = math.atan2(relY - person.y, relX - person.x)

		disc.velocity = {angle, 2, 30}
		disc.x = person.x
		disc.y = person.y
	end
end
