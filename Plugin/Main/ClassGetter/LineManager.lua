local Class = {}
Class.__index = Class

setmetatable(Class, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

Class.new = function(classes)
	local self = setmetatable({}, Class)
	self.classes = classes
	self.Lines = {}
	return self
end

Class.NewLine = function(self, v1, v2)
	self:AddLine(self.classes["Line"](self.classes, self, v1, v2))
end

Class.AddLine = function(self, line)
	table.insert(self.Lines, line)
end

Class.Render = function(self)
	for i=1, #self.Lines do
		self.Lines[i]:RenderLoop()
	end
end

Class.DeRender = function(self)
	for i=1, #self.Lines do
		self.Lines[i]:RemoveLine()
	end
	self.Lines = {}
end


return Class
