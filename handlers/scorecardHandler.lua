scorecardhandler = {}

function scorecardhandler:init()
	obj = {	}
	setmetatable(obj,self)
	self.__index = self

	return obj
end

function scorecardhandler:default()
	self.strokes = 0
	self.currentHole = 0
	self.holes = 0
	self.pars = {}
	self.scores = {}
	self.totalScore = 0
end

function scorecardhandler:updateOnce()
	self.scores = RoundHandler.holeStrokes
	for i = 1, #CourseHandler.holes do
		self.pars[i] = CourseHandler.holes[i].par
	end
	self.currentHole = RoundHandler.currentHole
	self.holes = RoundHandler.totalHoles
	self.totalScore = 0
	for i = 1, #self.scores do
		self.totalScore = self.totalScore + self.scores[i]
	end
end

function scorecardhandler:draw()
	local bw = 1200
	local bh = 300

	love.graphics.setColor(1,1,1,.7)
	love.graphics.rectangle("fill", 200, 70, bw, bh)
	love.graphics.setColor(0,0,0,.7)
	for i = 1, 4 do
		love.graphics.line(275, 50 + (i * 60), 1310, 50 + (i * 60))
	end
	love.graphics.line(275, 110, 275, 290)
	for i = 1, 19 do
		love.graphics.line(360 + i * 50, 110, 360 + i * 50, 290)
	end

	-- Draw words
	love.graphics.setNewFont(40)
	love.graphics.setColor(0,0,0,.7)
	love.graphics.print("Holes", 285, 116)
	love.graphics.setColor(0,.4,0,.7)
	love.graphics.print("Par", 285, 176)
	love.graphics.setColor(0,0,0,.7)
	love.graphics.print("Score", 285, 236)

	for i = 1, self.holes do
		love.graphics.setColor(0,0,0,.7)
		love.graphics.print(i, 372 + i * 50, 117)
		local par = CourseHandler.holes[i].par
		love.graphics.setColor(0,.4,0,.7)
		love.graphics.print(par, 372 + i * 50, 177)

		if i <= #self.scores then
			if self.scores[i] < par then
				love.graphics.setColor(.9,.9,0,.7)
			elseif self.scores == par then
				love.graphics.setColor(0,.4,0,.7)
			else
				love.graphics.setColor(1,0,0,.7)
			end
			love.graphics.print(self.scores[i], 372 + i * 50, 237)
		end
	end

	love.graphics.setColor(0,0,0,.7)
	love.graphics.print("Total Score: "..self.totalScore, 285, 307)




	love.graphics.setColor(1,1,1,1)
end


return scorecardhandler