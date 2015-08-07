local Class = {}
Class.__index = Class

setmetatable(Class, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

Class.new = function(classes, bone, C0)
	local self = setmetatable({}, Class)
	self.classes = classes
	self.Bone = bone
	self.C0 = C0
	self.Type = script.Name
	self.BeingChanged = false
	
	self.Connection = self.Bone.Part.Changed:connect(function(property)
		if self.BeingChanged == false then
			if self.Bone.LinkedBoneParent then
				self.Bone.LinkedBoneParent:AddVertex(self.Bone)
				self.Connection:disconnect()
			end
		end
	end)
	return self
end

return Class
