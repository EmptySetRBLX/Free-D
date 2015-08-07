local Class = {}
Class.__index = Class

setmetatable(Class, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

Class.new = function(classes, part)
	local self = setmetatable({}, Class)
	self.classes = classes
	self.Part = part
	if part then
		self.LastPos = self.Part.CFrame
	end
	self.LinkedTo = {}
	self.C0s = {}
	self.Connection = nil
	self.LinkedBoneParent = nil
	self.LinkedBones = {}
	
	self.Type = script.Name
	
	return self
end

Class.SetActive = function(self)
	if self.Connection then
		self.Connection:disconnect()
		self.Connection = nil
	end
	for i=1, #self.LinkedTo do
		if self.LinkedTo[i].Part then
			self.LinkedTo[i].BrickColor = self.Part.BrickColor
			self.LinkedTo[i].Part.BrickColor = self.Part.BrickColor
		end
	end
	self.Connection = self.Part.Changed:connect(function(property)
		if self.Part then
			for i=1, #self.LinkedTo do
				if self.LinkedTo[i].Part then
					self.LinkedTo[i].BeingChanged = true
					self.LinkedTo[i].Part.CFrame = (self.Part.CFrame * self.C0s[i])
					--self.LinkedTo[i].Part.CFrame =
					self.LinkedTo[i].BrickColor = self.Part.BrickColor
					self.LinkedTo[i].BeingChanged = false
					self.LinkedTo[i].Part:Destroy()
				end
			end
			for i=1, #self.LinkedBones do
				self.LinkedBones[i].BeingChanged = true
				self.LinkedBones[i].Bone.Part.CFrame = (self.Part.CFrame* self.LinkedBones[i].C0)
				self.LinkedBones[i].BeingChanged = false
			end
			self.LastPos = self.Part.CFrame
		else
			if self.Connection then
				self.Connection:disconnect()
				self.Connection = nil
			end
		end
	end)
end

Class.SetInactive = function(self)
	if self.Connection then
		self.Connection:disconnect()
		self.Connection = nil
	end
end

Class.RemoveVertex = function(self, vertex)
	if vertex.Type == "Vertex" then
		local oldvertex = nil
		for i=1, #self.LinkedTo do
			if self.LinkedTo[i] == vertex then
				oldvertex = i
			end
		end
		if oldvertex then
			table.remove(self.LinkedTo, oldvertex)
			table.remove(self.C0s, oldvertex)
			self:RemoveVertex(vertex)
		end
	end
end

Class.AddVertex = function(self, vertex)
	if vertex.Type == "Vertex" then
		local oldvertex = nil
		for i=1, #self.LinkedTo do
			if self.LinkedTo[i] == vertex then
				oldvertex = i
			end
		end
		if oldvertex ~= nil then
			table.remove(self.LinkedTo, oldvertex)
			table.remove(self.C0s, oldvertex)
		end
		table.insert(self.LinkedTo, vertex)
		table.insert(self.C0s, self.Part.CFrame:inverse() * vertex.Part.CFrame)
	elseif vertex.Type == "Bone" then --Im lazy, k? Dun judge. K, judge. But pls only a little :'(.
		if vertex ~= self and vertex ~= self.LinkedBoneParent then
			local oldbone = nil
			for i=1, #self.LinkedBones do
				if self.LinkedBones[i].Bone == vertex then
					oldbone = i
				end
			end
			if oldbone then
				table.remove(self.LinkedBones, oldbone)
			end
			vertex.LinkedBoneParent = self
			table.insert(self.LinkedBones, self.classes["BoneConnection"](self.classes, vertex, self.Part.CFrame:inverse() * vertex.Part.CFrame))
		end
	end
end


return Class
