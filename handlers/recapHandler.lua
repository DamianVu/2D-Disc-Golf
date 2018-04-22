
recapHandler = {}

function recapHandler:init()
	obj = {}
	setmetatable(obj,self)
	self.__index = self

	return obj
end

function recapHandler:default()
	self.timer = 0
	self.printCurrentStroke = false
	self.printThrowDistance = false
	self.calculatedThrowDistance = false
	self.throwDistance = 0
	self.printDistanceToPin = false
	self.calculatedPinDistance = false
	self.finalMessage = false
	self.pinDistance = 0
	self.skip = false
end

function recapHandler:draw()
	if self.printCurrentStroke then
		love.graphics.setColor(1,1,1)
		love.graphics.setNewFont(72)
		love.graphics.print("Stroke "..numOfStrokes..":", 400, 200)
	end
	if self.printThrowDistance then
		love.graphics.setNewFont(40)
		if not self.calculatedThrowDistance then
			self.throwDistance = math.sqrt(((initialPosition[1] - finalPosition[1]) * (initialPosition[1] - finalPosition[1])) + ((initialPosition[2] - finalPosition[2]) * (initialPosition[2] - finalPosition[2])))
			self.calculatedThrowDistance = true
		end
		love.graphics.print("Throw Distance: "..self.throwDistance/7 .." feet", 430, 300)
	end
	if self.printDistanceToPin then
		love.graphics.setNewFont(40)
		if not self.calculatedPinDistance then
			local bx, by = CourseHandler:getBasketPosition()
			self.pinDistance = math.sqrt(((finalPosition[1] - bx) * (finalPosition[1] - bx)) + ((finalPosition[2] - by) * (finalPosition[2] - by)))
		end
		love.graphics.print("Distance to pin: "..self.pinDistance/7 .." feet", 430, 360)
	end
end

function recapHandler:update(dt)
	self.timer = self.timer + dt
	if self.timer > .75 and not self.printCurrentStroke then self.printCurrentStroke = true end
	if self.timer > 1.5 and not self.printThrowDistance then self.printThrowDistance = true end
	if self.timer > 2.5 and not self.printDistanceToPin then 
		self.printDistanceToPin = true
		self.finalMessage = true
	end
	if self.timer > 6 or self.skip then
		self:default()
		disc.z = 5
		STATE = THROWING
	end
end

return recapHandler