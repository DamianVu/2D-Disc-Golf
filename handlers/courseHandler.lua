
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
	self.waterTile = love.graphics.newImage("images/sprites/Water.png")
	self.teepad = love.graphics.newImage("images/sprites/Teepad.png")
end

function coursehandler:load(course)
	local files = love.filesystem.getDirectoryItems("courses/"..course.."/")
	self.holes = {}
	for i = 1, #files do
		local filename,_ = files[i]:match("(%a+%d+).(.*)")
		self.holes[#self.holes + 1] = require ("courses."..course.."."..filename)
	end
	RoundHandler:setTotalHoles(#files)
	self.basket = love.graphics.newImage("images/sprites/Basket.png")
end

function coursehandler:setHole(holeNumber)
	self.map = self.holes[holeNumber]
	STATE = THROWING
	local tx, ty = unpack(self.map.teepad)
	disc.x = (tx + 2) * 64 + 32
	disc.y = (ty + 2) * 64 + 32
end

function coursehandler:createCanvas()
	love.graphics.setColor(1,1,1,1)

	-- Calculate current view
	local rowStartIndex
	local rowEndIndex
	local colStartIndex
	local colEndIndex
	local cv = love.graphics.newCanvas(#self.map.grid[1] * 64 + 396, #self.map.grid * 64 + 396)
	local sb = love.graphics.newSpriteBatch(self.waterTile)

	love.graphics.setCanvas(cv)
	for i = 1, #self.map.grid[1] + 6 do
		for j = 1, #self.map.grid + 6 do
			if i <= 3 or j <= 3 or i >= #self.map.grid[1] + 4 or j >= #self.map.grid + 4 then
				sb:add((i - 1) * 64,(j - 1) * 64)
			else
				love.graphics.draw(self.tilesets[1], self.quads[1][self.map.grid[j - 3][i - 3]], (i - 1) * 64, (j - 1) * 64)
			end
		end
	end
	-- love.graphics.draw(self.tilesets[1], self.quads[1][self.map.grid[rowIndex][columnIndex]], x, y)

	-- Draw the basket
	love.graphics.draw(self.basket, (self.map.basket[1] + 2) * 64, (self.map.basket[2] + 2) * 64)
	love.graphics.draw(sb)
	love.graphics.draw(self.teepad, (self.map.teepad[1] + 2) * 64, (self.map.teepad[2] + 2) * 64)
	love.graphics.setCanvas()
	return cv
end

function coursehandler:getBasketPosition()
	return ((self.map.basket[1] + 2) * 64) + 32, ((self.map.basket[2] + 2) * 64) + 32
end

function coursehandler:getHolePar()
	return self.map.par
end

return coursehandler