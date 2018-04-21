
menuhandler = {}

function menuhandler:init()
	obj = {}
	setmetatable(obj,self)
	self.__index = self

	return obj
end

function menuhandler:loadMenus()
	self.mainmenu = require "menus.mainmenu"
	self.currentMenu = "main"
end

function menuhandler:changeMenu(menu)
	if menu == "main" then
		self.currentMenu = "main"
	else
		self.currentMenu = "highscores"
	end
end

function menuhandler:draw()
	love.graphics.setBackgroundColor(.3686, .4235, .5098)


	love.graphics.setColor(.9373, .9373, .9373)

	if self.currentMenu == "main" then
		local options = self.mainmenu.options
		local offset = 0
		for i = 1, #options do
			local item = options[i][1]
			local w, h = love.graphics.getDimensions()
			love.graphics.print(item, w/2 - 100, h/4 + offset)
			offset = offset + 60
		end
	elseif self.currentMenu == "highscores" then

	end
end


return menuhandler