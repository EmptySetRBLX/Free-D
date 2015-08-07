local toolbar = plugin:CreateToolbar("Free-D Mesh Injector")
local classes = require(script:FindFirstChild("ClassGetter"))
local state = "WaitForAssembly"
local currentanimation = nil
local currentmesh = nil
local GUIs = script.Parent:FindFirstChild("GUIs")
local main = GUIs.Main
local ready = GUIs.ReadyToInject
local waitingforinj = GUIs.WaitingForInjection
local obj = Instance.new("Script")
local mtl = Instance.new("Script")
local asmrenderstep = false
local active = false
local numofframesgui = GUIs.NumberOfFrames
local about = GUIs.About
local animation = nil
local animationframes = GUIs.AnimationFrames
local animationframe = script.Parent.AnimationFrame
obj.Parent = game.CoreGui
obj.Name = ".OBJ"
obj.Source = "#Paste the contents of your OBJ here"

mtl.Parent = game.CoreGui
mtl.Name = ".MTL"
mtl.Source = "" --It no work rn :(, I need to spend more countless hours staring at bytes

function HideGUIs()
	local children = GUIs:GetChildren()
	for i=1, #children do
		children[i].Visible = false
	end
end

local button = toolbar:CreateButton(
	"Free-D",
	"Converts a .OBJ into an auto assembler script",
	"http://www.roblox.com/asset/?id=270949662"
)

button.Click:connect(function()
	active = true
	GUIs.Parent = game.CoreGui
	HideGUIs()
	
	if state == "WaitForAssembly" then
		waitingforinj.Visible = true
		plugin:OpenScript(script.Parent.AutoAssembler:Clone())
		if asmrenderstep == false then
			asmrenderstep = true
			game["Run Service"]:BindToRenderStep("WaitingForInj", Enum.RenderPriority.Camera.Value, function()
				local teststring = Instance.new("StringValue")
				teststring.Value = "asdfgh"
				teststring.Value = "FREE-D TEST COMMAND "
				if teststring.Value ~= "FREE-D TEST COMMAND " then		
					game["Run Service"]:UnbindFromRenderStep("WaitingForInj")
					state = "Start"
					waitingforinj.Visible = false
					if active == true then
						main.Visible = true
					end
				end
			end)
		end
	else
		state = "Start"
		main.Visible = true
	end
	--[[local objfolder = game.Workspace:FindFirstChild("FreeD")
	if objfolder then
		if objfolder:FindFirstChild("OBJ") then
			local frame1 = classes["Frame"].FromObj(classes, 50, objfolder:FindFirstChild("OBJ").Source) 
			frame1:Render()
		else
			local obj = Instance.new("Script")
			obj.Name = "OBJ"
			obj.Parent = objfolder
		end
	else
		objfolder = Instance.new("Folder")
		objfolder.Name = "FreeD"
		objfolder.Parent = game.Workspace
		local obj = Instance.new("Script")
		obj.Name = "OBJ"
		obj.Parent = objfolder		
	end--]]
end)

main.Animate.MouseButton1Click:connect(function()
	state = "InjectAnimation"
	HideGUIs()
	ready.Visible = true
	plugin:OpenScript(obj)
	--plugin:OpenScript(mtl)
end)

main.About.MouseButton1Click:connect(function()
	state = "About"
	HideGUIs()
	about.Visible = true
end)

about.Cancel.MouseButton1Click:connect(function()
	state = "Start"
	HideGUIs()
	main.Visible = true
end)

main.Inject.MouseButton1Click:connect(function()
	state = "InjectMesh"
	HideGUIs()
	ready.Visible = true
	plugin:OpenScript(obj)
	--plugin:OpenScript(mtl)
end)

ready.Cancel.MouseButton1Click:connect(function()
	state = "Start"
	HideGUIs()
	main.Visible = true
end)

numofframesgui.Cancel.MouseButton1Click:connect(function()
	state = "Start"
	HideGUIs()
	main.Visible = true
end)

numofframesgui.Confirm.MouseButton1Click:connect(function()
	local number = tonumber(numofframesgui.FrameNumber.Text)
	if number == nil then
		numofframesgui.FrameNumber.Text = "30"
	else
		local frame1 = classes["Frame"].FromObj(classes, 50, obj.Source, mtl.Source)

		animation = classes["Animation"](classes, number, frame1, animationframes, animationframe, plugin)
		HideGUIs()
	end
end)

ready.Confirm.MouseButton1Click:connect(function()
	--state = "Start"
	HideGUIs()
	if state == "InjectMesh" then
		main.Visible = true
		local frame1 = classes["Frame"].FromObj(classes, 50, obj.Source, mtl.Source) 
		local unionop = frame1:DoUnion(plugin)
		unionop.Parent = game.Workspace
		--[[local unionop = plugin:Union({Instance.new("Part")})
		if unionop ~= nil then
			unionop.Parent = game.Workspace
		end--]]
		state = "Start"
	else
		state = "GetFrames"
		numofframesgui.FrameNumber.Text = "30"
		numofframesgui.Visible = true
	end
end)

plugin.Deactivation:connect(function()
	active = false
	HideGUIs()
end)
