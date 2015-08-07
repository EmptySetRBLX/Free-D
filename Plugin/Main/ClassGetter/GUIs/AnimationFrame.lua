local Class = {}
Class.__index = Class

setmetatable(Class, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

Class.new = function(classes, animation, frame, index, plugin)
	local self = setmetatable({}, Class)
	self.classes = classes
	self.Frame = frame
	self.Animation = animation
	self.AnimationFrame = nil
	self.Index = index
	self.Plugin = plugin
	if self.Animation.Frames[self.Index] then
		self.AnimationFrame = self.Animation.Frames[self.Index]
	end
	if self.AnimationFrame then
		self.Frame.BackgroundColor3 = Color3.new(0, 130/255, 30/255)
	end
	self.Frame.MouseButton1Click:connect(function() --lel, used a text button cause 2lazy4newinput
		self:LMB()
	end)
	return self
end

Class.LMB = function(self)
	self.AnimationFrame = self.Animation.Frames[self.Index]
	--[[if self.AnimationFrame ~= nil then
		self.Animation.LineManager:DeRender()
		self.Animation.CurrentFrame:DeRender()
		self.Animation.CurrentFrame = self.AnimationFrame
		self.Animation.CurrentFrame:Render(game.Workspace, self.Animation.LineManager)
	end--]]
	local screengui = Instance.new("ScreenGui")
	screengui.Parent = game.CoreGui
	local maingui = script.FrameActions:Clone()
	maingui.Parent = screengui
	maingui = maingui:FindFirstChild("Frame")
	if self.AnimationFrame ~= nil then
		maingui.Select.TextColor3 = Color3.new(1,1,1)
		maingui.Select.BorderColor3 = Color3.new(1,1,1)
		maingui.Select.MouseButton1Click:connect(function()
			for i=1, self.Animation.FrameNumber do
				if self.Animation.Frames[i] == self.Animation.CurrentFrame then
					self.Animation.GUIFrames[i].Frame.BackgroundColor3 = Color3.new(0, 130/255, 30/255)
				end
			end
			self.Animation.LineManager:DeRender()
			self.Animation.CurrentFrame:DeRender()
			self.Animation.CurrentFrame = self.AnimationFrame
			self.Animation.CurrentFrame:Render(game.Workspace, self.Animation.LineManager)
			self.Frame.BackgroundColor3 = Color3.new(1,1,1)		
			screengui:Destroy()
		end)
		maingui.Copy.TextColor3 = Color3.new(1,1,1)
		maingui.Copy.BorderColor3 = Color3.new(1,1,1)
		maingui.Copy.MouseButton1Click:connect(function()
			self.Animation.CopyFrom = self.Animation.CurrentFrame
			--self.Animation.CurrentFrame:DoUnion(self.Animation.Plugin).Parent = game.Workspace
			screengui:Destroy()
		end)
	end
	if self.Animation.CopyFrom ~= nil then
		maingui.Paste.TextColor3 = Color3.new(1,1,1)
		maingui.Paste.BorderColor3 = Color3.new(1,1,1)
		maingui.Paste.MouseButton1Click:connect(function()
			self.Animation.Frames[self.Index] = self.Animation.CopyFrom:Clone()
			self.Frame.BackgroundColor3 = Color3.new(0, 130/255, 30/255)
			screengui:Destroy()
		end)
	end
	
	maingui.Cancel.MouseButton1Click:connect(function()
		screengui:Destroy()
	end)
end


Class.Destroy = function(self)
	
end


return Class
