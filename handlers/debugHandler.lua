
debughandler = {}

function debughandler:init()
	obj = {}
	setmetatable(obj,self)
	self.__index = self

	return obj
end

function debughandler:default()
	self.showDebug = false
end

function debughandler:draw()
	if self.showDebug then
		love.graphics.setNewFont(12)
		love.graphics.setColor(1,1,1)
		love.graphics.print("Disc Z: "..disc.z,10,10)
		love.graphics.print("STATE: "..STATE, 10, 30)
		love.graphics.print("Disc Location: "..disc.x..", "..disc.y, 10, 50)
		love.graphics.print("Disc Selection: "..currentDisc, 10, 70)
		love.graphics.print("Disc Angle: "..disc.velocity[1], 10, 90)
		love.graphics.print("Disc Speed: "..disc.velocity[2] / 7 .. " ft/s", 10, 110)
		love.graphics.print("Disc Height: "..disc.z, 10, 130)
		love.graphics.print("Time Flying: "..timeFlying, 10, 150)
		love.graphics.print("Time Guess: "..timeGuess, 10, 170)

		love.graphics.print("Colliding : "..tostring(CollisionHandler.colliding), 10, 210)
	end
end

function debughandler:toggle()
	self.showDebug = not self.showDebug
end


return debughandler