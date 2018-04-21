
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
		print("Test: "..currentTilesetIndex)
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
	self.map = require "courses.centennial.hole1"
end

function coursehandler:draw()

	love.graphics.setColor(1,1,1,1)
	for rowIndex = 1, #self.map.grid do
		for columnIndex = 1, #self.map.grid[rowIndex] do
			local x, y = ((columnIndex - 1) * 64), ((rowIndex - 1) * 64)
			love.graphics.draw(self.tilesets[1], self.quads[1][self.map.grid[rowIndex][columnIndex]], x, y)
		end
	end
end



return coursehandler