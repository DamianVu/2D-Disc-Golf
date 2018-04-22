
collisionhandler = {}

function collisionhandler:init()
	obj = {}

	setmetatable(obj,self)
	self.__index = self

	return obj
end

function collisionhandler:default()
	self.objects = {}
	self.colliding = false
end

function collisionhandler:addObject(object)
	self.objects[#self.objects + 1] = object
end

function collisionhandler:update(dt)
	-- Only need to check collision from disc to objects. Nice, that's only N operations.
	-- The circle is round
	self.colliding = false
	for i = 1, #self.objects do
		if self:checkCollision(self.objects[i]) then
			self:resolveCollision(self.objects[i])
			self.colliding = true
		end
	end
end

function collisionhandler:drawCollisionObjects()
	for i = 1, #self.objects do
		local o = self.objects[i]
		love.graphics.setColor(1,0,0)
		love.graphics.rectangle("line", o.x, o.y, o.size, o.size)
		love.graphics.setColor(1,1,0)
		love.graphics.circle("line", o.x + o.size/2, o.y + o.size/2, math.sqrt(2 * (o.size * o.size))/2)
	end
end

function collisionhandler:drawObjectHeights()
	for i = 1, #self.objects do
		local o = self.objects[i]
		love.graphics.setColor(1,1,1)
		love.graphics.print(o.height, o.x + 10, o.y + 10)
	end
end

function collisionhandler:checkCollision(object)
	if (disc.z <= object.height) then
		local objCenterX = object.x + object.size/2
		local objCenterY = object.y + object.size/2

		local outerCircleRadius = math.sqrt(2 * (object.size * object.size))/2
		local innerCircleRadius = object.size / 2

		local distanceBetweenCenters = math.sqrt(((objCenterX - disc.x) * (objCenterX - disc.x)) + ((objCenterY - disc.y) * (objCenterY - disc.y)))

		if distanceBetweenCenters > outerCircleRadius + disc.size then
			return false
		end
		if distanceBetweenCenters < innerCircleRadius + disc.size then
			return true
		end

		local angleFromDiscToObj = math.atan2(disc.y - objCenterY, disc.x - objCenterX)
		local outerX = math.cos(angleFromDiscToObj) * disc.size
		local outerY = math.sin(angleFromDiscToObj) * disc.size

		if outerX >= object.x and outerX <= object.x + object.size and outerY >= object.y and outerY <= object.y + object.size then
			return true
		else
			return false
		end
	end
end

function collisionhandler:resolveCollision(object)
	local objCenterX = object.x + object.size/2
	local objCenterY = object.y + object.size/2

	local angleFromDiscToObj = math.atan2(disc.y - objCenterY, disc.x - objCenterX)



end

function collisionhandler:handleDiscCollision(object)
	
end


return collisionhandler