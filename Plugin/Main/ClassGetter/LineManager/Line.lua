local Class = {}
Class.__index = Class

setmetatable(Class, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

Class.new = function(classes, linemanager, v1, v2)
	local self = setmetatable({}, Class)
	self.classes = classes
	self.LineManager = linemanager
	self.V1 = v1
	self.V2 = v2
	self.Line = nil
	self.Connection1 = nil
	self.Connection2 = nil
	self.RenderSteppedConnection = nil
	return self
end

Class.AddRenderSteppedConnection = function(self)
	if self.RenderSteppedConnection then
		self.RenderSteppedConnection:disconnect()
	end
	self.RenderSteppedConnection = nil
	self.RenderSteppedConnection = game["Run Service"].RenderStepped:connect(function()
		if self.V1.Part == nil then
			return
		end
		if self.V1.Part.Parent == nil then
			return
		end
		if self.V2.Part == nil then
			return
		end
		if self.V2.Part.Parent == nil then
			return
		end
		if self.RenderSteppedConnection then
			self.RenderSteppedConnection:disconnect()
		end
		self.RenderSteppedConnection = nil
		self:AddConnection()
	end)
end

Class.RenderLine = function(self, p1, p2)
	local line = Instance.new("LineHandleAdornment")
	line.Length = (p1.CFrame.p-p2.CFrame.p).magnitude
	line.CFrame = CFrame.new(Vector3.new(0,0,0), p2.CFrame.p-p1.CFrame.p)
	line.Parent = game.CoreGui
	line.Adornee = p1
	return line
end

Class.RemoveLine = function(self)
	if self.Connection1 ~= nil then
		self.Connection1:disconnect()
		self.Connection1 = nil
	end
	if self.Connection2 ~= nil then
		self.Connection2:disconnect()
		self.Connection2 = nil
	end
	self:DeRender()
end

Class.DeRender = function(self)
	if self.Line ~= nil then
		self.Line:Destroy()
	end
end

Class.Render = function(self)
	self:DeRender()
	if self.V1 and self.V2 then
		if self.V1.Part and self.V2.Part then
			self.Line = self:RenderLine(self.V1.Part, self.V2.Part)
		end
	end
end

Class.AddConnection = function(self)
	self:DeRender()
	if self.Connection1 ~= nil then
		self.Connection1:disconnect()
		self.Connection1 = nil
	end
	if self.Connection2 ~= nil then
		self.Connection2:disconnect()
		self.Connection2 = nil
	end
	if self.V1.Part ~= nil and self.V2.Part ~= nil then
		if self.V1.Part.Parent ~= nil and self.V2.Part.Parent ~= nil then
			self.Connection1 = self.V1.Part.Changed:connect(function(property)
				self:AddConnection()
			end)
			self.Connection2 = self.V2.Part.Changed:connect(function(property)
				self:AddConnection()
			end)
			self:Render()
			return
		end
	end
	self:AddRenderSteppedConnection()
end

	

Class.RenderLoop = function(self)
	self:AddConnection()
end


return Class
