
coursehandler = {}

function coursehandler:init()
	obj = {
		tilesets = {},
		quads = {}
	}
	setmetatable(obj,self)
	self.__index = self

	return obj
end

function coursehandler:loadTilesets()
	local files = love.filesystem.getDirectoryItems("images/tilesets/")
	self.tilesets = {}
	self.quads = {}
	for i = 1, #files do
		local filename,_ = files[i]:match("(%a+).(.*)")
		local currentTilesetIndex = #self.tilesets + 1
		self.tilesets[currentTilesetIndex] = love.graphics.newImage("images/tilesets/"..filename..".png")
		local currentQuadIndex = #self.quads + 1
		self.quads[currentQuadIndex] = {}
		local imgw, imgh = self.tilesets[currentTilesetIndex]:getDimensions()

		for j = 1, imgw/64 do
			for k = 1, imgh/64 do
				self.quads[currentQuadIndex][#self.quads[currentQuadIndex] + 1] = love.graphics.newQuad((j - 1) * 64, (k - 1) * 64, 64, 64, imgw, imgh)
			end
		end
	end
end

function coursehandler:load(course)
	self.map = require "courses.centennial.hole2"
	self.basket = love.graphics.newImage("images/sprites/Basket.png")
end

function coursehandler:draw()
	love.graphics.setColor(1,1,1,1)

	-- Calculate current view
	local rowStartIndex
	local rowEndIndex
	local colStartIndex
	local colEndIndex

	local ceil = math.ceil
	local floor = math.floor

	rowStartIndex = floor(-y_translate_val / 64)
	if rowStartIndex < 1 then rowStartIndex = 1 end
	colStartIndex = floor(-x_translate_val / 64)
	if colStartIndex < 1 then colStartIndex = 1 end

	rowEndIndex = floor((((rowStartIndex * 64) + h) / zoomFactor) / 64) + 2
	colEndIndex = floor((((colStartIndex * 64) + w) / zoomFactor) / 64) + 2
	if rowEndIndex > #self.map.grid then rowEndIndex = #self.map.grid end


	for rowIndex = rowStartIndex, rowEndIndex do
		local eInd = colEndIndex
		if eInd > #self.map.grid[rowIndex] then eInd = #self.map.grid[rowIndex] end
		for columnIndex = colStartIndex, eInd do
			local x, y = ((columnIndex - 1) * 64), ((rowIndex - 1) * 64)
			love.graphics.draw(self.tilesets[1], self.quads[1][self.map.grid[rowIndex][columnIndex]], x, y)
		end
	end

	-- Draw the basket
	love.graphics.draw(self.basket, (self.map.basket[1] - 1) * 64, (self.map.basket[2] - 1) * 64)
end

function coursehandler:getBasketPosition()
	return ((self.map.basket[1] - 1) * 64) + 32, ((self.map.basket[2] - 1) * 64) + 32
end



return coursehandler