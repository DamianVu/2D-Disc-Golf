
roundhandler = {}

function roundhandler:init()
	obj = {}
	setmetatable(obj,self)
	self.__index = self

	return obj
end

function roundhandler:initialize()
	self.strokes = 0
	self.holeStrokes = {}
end

function roundhandler:start()
	self.currentHole = 1
	STATE = THROWING
	CourseHandler:load("centennial")
	CourseHandler:setHole(1)
	self.canvas = CourseHandler:createCanvas()
end

function roundhandler:draw()
	love.graphics.setColor(1,1,1,1)
	love.graphics.draw(self.canvas)
end

function roundhandler:setTotalHoles(total)
	self.totalHoles = total
end

function roundhandler:moveOn(strokes)
	self.holeStrokes[self.currentHole] = strokes
	self.strokes = self.strokes + strokes
	numOfStrokes = 0
	if self.currentHole ~= self.totalHoles then
		print("Attempting to move on")
		self.currentHole = self.currentHole + 1
		CourseHandler:setHole(self.currentHole)
	else
		print("Fuck")
		STATE = MAINMENU
	end
end

function roundhandler:getHolePar()
	return CourseHandler:getHolePar()
end

return roundhandler