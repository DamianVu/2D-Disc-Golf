
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



	-- Finish hole options
	self.postHole = false
	self.printFinalResult = false
	self.printNumberOfStrokes = false
	self.printPar = false
end

function recapHandler:draw()
	local floor = math.floor
	if not self.postHole then
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
			love.graphics.print("Throw Distance: "..floor(self.throwDistance/7) .." feet", 430, 300)
		end
		if self.printDistanceToPin then
			love.graphics.setNewFont(40)
			if not self.calculatedPinDistance then
				local bx, by = CourseHandler:getBasketPosition()
				self.pinDistance = math.sqrt(((finalPosition[1] - bx) * (finalPosition[1] - bx)) + ((finalPosition[2] - by) * (finalPosition[2] - by)))
			end
			love.graphics.print("Distance to pin: "..floor(self.pinDistance/7) .." feet", 430, 360)
		end
	else
		if self.printPar then
			love.graphics.setColor(1,1,1)
			love.graphics.setNewFont(40)
			love.graphics.print("Hole "..RoundHandler.currentHole.." Par: "..RoundHandler:getHolePar(), 400, 300)
		end
		if self.printNumberOfStrokes then
			love.graphics.setColor(1,1,1)
			love.graphics.print("Strokes: "..numOfStrokes, 400, 360)
		end
		if self.printFinalResult then
			love.graphics.setColor(1,1,1)
			local res = self:getResult(numOfStrokes,RoundHandler:getHolePar())
			love.graphics.print("Result: "..res, 400, 420)
		end
	end
end

function recapHandler:update(dt)
	self.timer = self.timer + dt
	if not self.postHole then
		if (self.timer > .75 or self.skip) and not self.printCurrentStroke then 
			self.skip = false
			self.printCurrentStroke = true 
		end
		if (self.timer > 1.5 or self.skip) and not self.printThrowDistance then
			self.skip = false 
			self.printThrowDistance = true 
		end
		if (self.timer > 2.5 or self.skip) and not self.printDistanceToPin then 
			self.skip = false
			self.printDistanceToPin = true
			self.finalMessage = true
		end
		if self.timer > 6 or self.skip then
			self:default()
			disc.z = 5
			STATE = THROWING
		end
	else
		if (self.timer > .25 or self.skip) and not self.printPar then
			self.printPar = true
			self.skip = false
		end
		if (self.timer > .5 or self.skip) and not self.printNumberOfStrokes then 
			self.printNumberOfStrokes = true 
			self.skip = false
		end
		if (self.timer > .75 or self.skip) and not self.printFinalResult then 
			self.printFinalResult = true 
			self.skip = false
		end
		if self.timer > 5 or self.skip then
			self:default()
			RoundHandler:moveOn(numOfStrokes)
		end
	end
end

function recapHandler:getResult(strokes, par)
	if stroke == 1 then
		return "ACE"
	elseif strokes - par == -3 then
		return "Albatross"
	elseif strokes - par == -2 then
		return "Eagle"
	elseif strokes - par == -1 then
		return "Birdie"
	elseif strokes - par == 0 then
		return "Par"
	elseif strokes - par == 1 then
		return "Bogey"
	elseif strokes - par == 2 then
		return "Double Bogey"
	elseif strokes - par == 3 then
		return "Triple Bogey"
	elseif strokes - par == 4 then
		return "Quadruple Bogey"
	elseif strokes - par > 20 then
		return "Wow....."
	else
		return "+"..strokes - par
	end
end

return recapHandler