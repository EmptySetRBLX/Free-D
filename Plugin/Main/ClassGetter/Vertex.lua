local Class = {}
Class.__index = Class

setmetatable(Class, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

Class.new = function(classes, X, Y, Z, IndexedNumber)
	local self = setmetatable({}, Class)
	self.classes = classes
	self.Type = script.Name
	self.OriginalX = X
	self.OriginalY = Y
	self.OriginalZ = Z
	self.X = X
	self.Y = Y
	self.Z = Z
	self.Color = nil
	self.Part = nil
	self.BrickColor = nil
	self.DeBounce = false
	self.KillConnection = false
	self.ChangedConnection = nil
	self.ShouldRender = false
	self.LinkedBone = nil
	self.BeingChanged = false
	self.Index = IndexedNumber
	return self
end

Class.ConnectMe = function(self, property, scale, parent)
	if self.ShouldRender == true then
		if self.Part.Parent == nil then
			self:BuildConnection(scale, parent)
		else
			self.X = self.Part.Position.X/scale
			self.Y = self.Part.Position.Y/scale
			self.Z = self.Part.Position.Z/scale
			if self.BeingChanged == false then
				if self.LinkedBone then
					self.LinkedBone:AddVertex(self)
				end
			end
		end
	else
		self.ChangedConnection:disconnect()
	end
end

Class.BuildConnection = function(self, scale, parent)
	if self.ChangedConnection then
		self.ChangedConnection:disconnect()
	end
	pcall(function() self.Part:Destroy() end)
	self.Part = nil	
	if self.ShouldRender == true then
		local part = script:FindFirstChild("Part"):Clone()
		if self.BrickColor ~= nil then
			part.BrickColor = self.BrickColor
		end
		part.CFrame = CFrame.new(self.X*scale, self.Y*scale, self.Z*scale)
		self.Part = part
		self.Part.Parent = parent
		
		self.ChangedConnection = self.Part.Changed:connect(function(property)
			self:ConnectMe(property, scale, parent)
		end)
	else
		self.ChangedConnection:disconnect()
	end
end

Class.Render = function(self, scale, parent) --this needs a big change
	--perhaps a new class for easc
	self.ShouldRender = true
	self:BuildConnection(scale, parent)
	
	--[[if self.Part == nil then
		local part = script:FindFirstChild("Part"):Clone()
		part.CFrame = CFrame.new(self.X*scale, self.Y*scale, self.Z*scale)
		self.Part = part
		self.Part.Parent = parent
		self.ChangedConnnection = self.Part.Changed:connect(function(property)
			self.DeBounce = true
			if property == "Position" then
				self.X = part.Position.X/scale
				self.Y = part.Position.Y/scale
				self.Z = part.Position.Z/scale
			end
			if property == "Parent" then
				self:DeRender()
				if self.Part ~= nil then
					self.Part.Parent = nil
					self.Part:Destroy()
				end
				self.Part = nil
				if self.KillConnection == false then
					self:Render(scale, parent)
				end
			end
			self.DeBounce = false
		end)
	end--]]
	return self.Part
end

Class.DeRender = function(self)
	self.ShouldRender = false
	self.ChangedConnection:disconnect()
	pcall(function() self.Part:Destroy() end)
end


return Class
