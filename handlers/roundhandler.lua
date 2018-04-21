
roundhandler = {}

function roundhandler:init()
	obj = {}
	setmetatable(obj,self)
	self.__index = self

	return obj
end

function roundhandler:start()
	
end

function roundhandler:draw()

end

return roundhandler