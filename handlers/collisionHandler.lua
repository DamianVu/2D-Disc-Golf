
collisionhandler = {}

function collisionhandler:init()
	obj = {}

	setmetatable(obj,self)
	self.__index = self

	return obj
end

function collisionhandler:update(dt)

end

function collisionhandler:handleDiscCollision(object)
	
end


return collisionhandler