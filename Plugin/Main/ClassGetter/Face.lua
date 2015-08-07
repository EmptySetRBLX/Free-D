local Class = {}
Class.__index = Class

setmetatable(Class, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

Class.new = function(classes, V1, V2, V3, color)
	local self = setmetatable({}, Class)
	self.classes = classes
	self.Type = script.Name
	if V1 == nil then
		print("V1 nil")
	end
	if V2 == nil then
		print("V2 nil")
	end
	if V3 == nil then
		print("V3 nil")
	end
	self.V1 = V1
	self.V2 = V2
	self.V3 = V3
	self.Lines = {}
	self.ShouldRender = false
	self.ConnectionHolder = {}
	self.Color = color --place holder for later
	return self
end

Class.SwitchVertex = function (self, vertex)
	if self.V2 == vertex then
		self.V2 = self.V1
		self.V1 = vertex
	elseif self.V3 == vertex then
		self.V3 = self.V1
		self.V1 = vertex
	end
end

Class.Render = function(self, scale, parent, linemanager)
	local v1 = self.V1:Render(scale, parent)
	local v2 = self.V2:Render(scale, parent)
	local v3 = self.V3:Render(scale, parent)
	linemanager:NewLine(self.V1, self.V2)
	linemanager:NewLine(self.V2, self.V3)
	linemanager:NewLine(self.V3, self.V1)
end

Class.DeRender = function(self)
	self.V1:DeRender()
	self.V2:DeRender()
	self.V3:DeRender()
end

--[[
	self.ChangedConnnection = self.Part.Changed:connect(function(property)
		if property == "Position" then
			print("pos changed")
			self.X = part.Position.X/scale
			self.Y = part.Position.Y/scale
			self.Z = part.Position.Z/scale
		end
	end)
--]]


return Class