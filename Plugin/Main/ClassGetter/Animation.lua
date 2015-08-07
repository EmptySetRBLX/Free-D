local Class = {}
Class.__index = Class

setmetatable(Class, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

Class.new = function(classes, framenumber, initialframe, animationframes, frames, plugin)
	local self = setmetatable({}, Class)
	self.classes = classes
	self.Type = script.Name
	self.Frames = {}
	self.FrameNumber = framenumber
	self.Frames[1] = initialframe
	self.CurrentFrame = self.Frames[1]
	self.Plugin = plugin
	self.LineManager = classes["LineManager"](classes)
	initialframe:Render(game.Workspace, self.LineManager)
	self.GUI = animationframes:Clone()
	self.GUI.Visible = true
	self.GUIFrames = {}
	self.CopyFrom = nil
	self.SelectedBone = nil
	local container = Instance.new("ScreenGui")
	container.Parent = game.CoreGui
	self.GUI.Parent = container
	for i=1, framenumber do
		local frame = frames:Clone()
		local interval  = 1/framenumber
		frame.Position = UDim2.new(interval*(i-1),0,0,0)
		frame.Size = UDim2.new(interval,0,1,0)
		self.GUIFrames[i] = classes["AnimationFrame"](classes, self, frame, i)--frame
		self.GUIFrames[i].Frame.Parent = self.GUI
	end
	self.GUIFrames[1].Frame.BackgroundColor3 = Color3.new(1,1,1)
	
	local bonegui = script.BoneFunctions:Clone()
	local bonescreen = Instance.new("ScreenGui")
	bonescreen.Parent = game.CoreGui
	bonegui.Parent = bonescreen
	
	bonegui.Export.MouseButton1Click:connect(function()
		self.SelectorConnect:disconnect()
		bonescreen:Destroy()
		container:Destroy()
		self.LineManager:DeRender()
		self.CurrentFrame:DeRender()
		if self.Frames[self.FrameNumber] == nil then
			self.Frames[self.FrameNumber] = self.Frames[1]:Clone()
		end
		for i=1, self.FrameNumber do
			if self.Frames[i] == nil then
				local nextvalidframe = nil
				local nextvalidindex = nil
				
				for k=i, self.FrameNumber do
					if self.Frames[k] ~= nil then
						if nextvalidframe == nil then
							nextvalidframe = self.Frames[k]
							nextvalidindex = k
						end
					end
				end
				
				for k=i, nextvalidindex-1 do
					self.Frames[k] = self.Frames[i-1]:Lerp(nextvalidframe, k/nextvalidindex)
				end
				--self.Frames[i] = self.Frames[i-1]:Lerp(nextvalidframe, ((i-1)/nextvalidindex))
			end
		end
		
		for i=1, self.FrameNumber do
			local export = self.Frames[i]:DoUnion(self.Plugin)
			export.Parent = game.Workspace
			export.Name = i
		end
	end)
	
	bonegui.SelectBone.MouseButton1Click:connect(function()
		local selection = game.Selection:Get()
		if #selection == 1 then
			local bone = self.CurrentFrame:GetBone(selection[1])
			if bone then
				self.SelectedBone = bone
			end
		end
	end)
	
	bonegui.MakeBone.MouseButton1Click:connect(function()
		local selection = game.Selection:Get()
		if #selection == 1 then
			if self.CurrentFrame:IsPartOf(selection[1]) == false then
				table.insert(self.CurrentFrame.Bones, self.classes["Bone"](self.classes, selection[1]))
				bonegui.MakeBone.TextColor3 = Color3.new(100/255,100/255,100/255)
			end
		end
	end)
	
	bonegui.LinkBone.MouseButton1Click:connect(function()
		local selection = game.Selection:Get()
		if #selection == 1 then
			local bone = self.CurrentFrame:GetBone(selection[1])
			if bone then
				if self.SelectedBone then
					self.SelectedBone:AddVertex(bone)
					self.SelectedBone:SetActive()
				end
			end
		end
	end)
	
	bonegui.LinkVertex.MouseButton1Click:connect(function()
		local selection = game.Selection:Get()
		local bone = self.SelectedBone
		if bone == nil then
			return
		end
		local selectedvertices = {}
		for i=1, #selection do
			if self.CurrentFrame:IsPartOf(selection[i]) == true then
				local selectionbone = self.CurrentFrame:GetBone(selection[i])
				if selectionbone ~= nil then
					return
				else
					table.insert(selectedvertices, self.CurrentFrame:GetVertice(selection[i]))
				end
			else
				return
			end
		end
		if #selectedvertices == 0 then
			return
		end
		for i=1, #selectedvertices do
			for k=1, #self.CurrentFrame.Bones do
				self.CurrentFrame.Bones[k]:RemoveVertex(selectedvertices[i])
			end
			bone:AddVertex(selectedvertices[i])
		end
		bone:SetActive()
		
		print("VALID LINK WITH")
		print(#selectedvertices .. " Vertexes")
	end)
	
	self.SelectorConnect = game.Selection.SelectionChanged:connect(function()
		if bonegui then
			bonegui.LinkBone.TextColor3 = Color3.new(100/255,100/255,100/255)
			bonegui.LinkVertex.TextColor3 = Color3.new(100/255,100/255,100/255)
			bonegui.MakeBone.TextColor3 = Color3.new(100/255,100/255,100/255)
			bonegui.SelectBone.TextColor3 = Color3.new(100/255,100/255,100/255)
			
			local selection = game.Selection:Get()
			if #selection == 1 then
				local bone = self.CurrentFrame:GetBone(selection[1])
				if bone then
					bonegui.SelectBone.TextColor3 = Color3.new(1,1,1)
					if self.SelectedBone and bone ~= self.SelectedBone then
						bonegui.LinkBone.TextColor3 = Color3.new(1,1,1)
					end
				end
			end
			
			if #selection == 1 then
				if self.CurrentFrame:IsPartOf(selection[1]) == false then
					bonegui.MakeBone.TextColor3 = Color3.new(1,1,1)
				end
			end
			
			local bone = self.SelectedBone
			if bone == nil then
				return
			end
			local selectedvertices = {}
			for i=1, #selection do
				if self.CurrentFrame:IsPartOf(selection[i]) == true then
					local selectionbone = self.CurrentFrame:GetBone(selection[i])
					if selectionbone ~= nil then
						return
					else
						table.insert(selectedvertices, self.CurrentFrame:GetVertice(selection[i]))
					end
				else
					return
				end
			end
			if #selectedvertices == 0 then
				return
			end
			bonegui.LinkVertex.TextColor3 = Color3.new(1,1,1)
		end
	end)
	
	return self
end

return Class
