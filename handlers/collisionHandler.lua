
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
		local col, kind = self:checkCollision(self.objects[i])
		if col then
			self:resolveCollision(self.objects[i], kind)
			self.colliding = true
		end
	end

	-- Check if level is over
	if self:checkCollision(CourseHandler.map.basket) then
		-- Trigger end of hole recap and move on
		RecapHandler.postHole = true
		STATE = RECAP

	end
end

function collisionhandler:drawCollisionObjects()
	for i = 1, #self.objects do
		local o = self.objects[i]
		love.graphics.setColor(1,0,0)
		love.graphics.rectangle("line", o.x, o.y, o.size, o.size)
	end
end

function collisionhandler:drawObjectHeights()
	for i = 1, #self.objects do
		local o = self.objects[i]
		love.graphics.setColor(1,1,1)
		love.graphics.setNewFont(16)
		love.graphics.print(o.height, o.x + 10, o.y + 10)
	end
end

function collisionhandler:checkCollision(object)
	local objX
	local objY
	local objCenterX
	local objCenterY
	local oSize
	local oHeight
	if not object.x then
		objCenterX, objCenterY = CourseHandler:getBasketPosition()
		objX = objCenterX - 32
		objY = objCenterY - 32
		oSize = 64
		oHeight = 6.5
	else
		objX = object.x
		objY = object.y
		objCenterX = object.x + object.size/2
		objCenterY = object.y + object.size/2
		oSize = object.size
		oHeight = object.height
	end

	local sqrt = math.sqrt

	local distanceBetweenCenters = sqrt(((objCenterX - disc.x) * (objCenterX - disc.x)) + ((objCenterY - disc.y) * (objCenterY - disc.y)))
	local outerCircleRadius = sqrt(2 * (oSize * oSize))/2
	if distanceBetweenCenters > outerCircleRadius + disc.size then
		return false, -1
	end
	if (disc.z <= oHeight) then

		local innerCircleRadius = oSize / 2

		

		
		if distanceBetweenCenters < innerCircleRadius + disc.size then
			return true, 1
		end

		local angleFromDiscToObj = math.atan2(disc.y - objCenterY, disc.x - objCenterX)
		local outerX = math.cos(angleFromDiscToObj) * disc.size
		local outerY = math.sin(angleFromDiscToObj) * disc.size

		if outerX >= objX and outerX <= objX + oSize and outerY >= objY and outerY <= objY + oSize then
			return true, 2
		else
			return false, -1
		end
	end
end

function collisionhandler:resolveCollision(object, type)
	local objCenterX = object.x + object.size/2
	local objCenterY = object.y + object.size/2

	local angleFromObjToDisc = math.atan2(objCenterY - disc.y, objCenterX - disc.x)

	-- Can we normalize the disc velocity vector? Between -pi to pi

	-- Find out if horizontal or vertical correction.
	if math.abs(disc.x - objCenterX) > math.abs(disc.y - objCenterY) then
		-- Horizontal Correction
		-- Find out if we should correct to the left or the right
		if disc.x - objCenterX > 0 then
			-- Correct to the right
			disc.x = objCenterX + object.size/2 + disc.size + .001
		else
			-- Correct to the left
			disc.x = objCenterX - object.size/2 - disc.size - .001
		end
		-- We need to flip the disc velocity vector across the Y axis
		-- This has 4 different cases
		if disc.velocity[1] < 0 then
			if disc.velocity[1] < -math.pi/2 then
				local diff = math.abs(disc.velocity[1] + math.pi/2)
				disc.velocity[1] = diff - math.pi/2
			else
				local diff = math.abs(disc.velocity[1] + math.pi/2)
				disc.velocity[1] = -math.pi/2 - diff
			end
		else
			if disc.velocity[1] > math.pi/2 then
				local diff = math.abs(disc.velocity[1] - math.pi/2)
				disc.velocity[1] = math.pi/2 - diff
			else
				local diff = math.abs(disc.velocity[1] - math.pi/2)
				disc.velocity[1] = diff + math.pi/2
			end
		end
	else
		-- Vertical Correction
		-- Find out if we should correct upwards or downwards
		if disc.y - objCenterY > 0 then
			-- Downwards
			disc.y = objCenterY + object.size/2 + disc.size + .001
		else
			-- Upwards
			disc.y = objCenterY - object.size/2 - disc.size - .001
		end
		-- We need to flip the disc velocity vector across the X axis
		disc.velocity[1] = -disc.velocity[1]
	end

	-- Now we want to decide how much speed to take off...



end


return collisionhandler