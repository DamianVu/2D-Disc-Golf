

person = {x = 500, y = 500, size = 60, speed = 300, color = {1,1,0}}
disc = {x=500,y=500,size=20, color={0,0,.75},}



function love.load()
	love.graphics.setBackgroundColor(.5,.5,.5)
end

function love.draw()

	x_translate_val = (love.graphics.getWidth() / 2) - person.x
	y_translate_val = (love.graphics.getHeight() / 2) - person.y

	love.graphics.push()
	love.graphics.translate(x_translate_val, y_translate_val)

	love.graphics.print("Hello",400,400)

	love.graphics.setColor(person.color)
	love.graphics.rectangle("fill", person.x - person.size/2, person.y - person.size/2, person.size, person.size)

	love.graphics.setColor(disc.color)
	love.graphics.circle("fill", disc.x - disc.size/2, disc.y - disc.size/2, disc.size)

	love.graphics.pop()

	love.graphics.print("This will be on the window in the same position, always",10,10)

end

function love.update(dt)



	--[[
	if love.keyboard.isDown("w","a","s","d") then
		if love.keyboard.isDown("w") then
			person.y = person.y - person.speed * dt
		end
		if love.keyboard.isDown("a") then
			person.x = person.x - person.speed * dt
		end
		if love.keyboard.isDown("s") then
			person.y = person.y + person.speed * dt
		end
		if love.keyboard.isDown("d") then
			person.x = person.x + person.speed * dt
		end
	end
	]]--

end

