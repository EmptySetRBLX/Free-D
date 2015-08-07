# Free-D Mesh Injector

## Written by OTRainbowDash5000

Free-D is a free and open-source modification to the roblox CSG system, written by OTRainbowDash5000 aka YAYZMAN23.

Feel free to contribute in any productive way to this project through github

This mod is released with the hopes of sparking a new generation of games with the maximum graphical potential provided by CSG. Feel free to modify it and redistribute it. 

It is asked that you please respect all roblox rules while using this mod. While I do not wish for you to use this to do something that is not in the spirit of roblox, I can not stop you either. I will not be responsible for anything that happens as a consequence of using this mod to inject anything phallic in nature, if you catch my drift.

In other words, dont be a complete dumbass with this please.

##API

The assembly API is passed commands by creating a stringobject giving it a random value, and then setting its value to specific commands

These commands are:


```
stringv = Instance.new("StringValue")
stringv.Value = "asdasfas"
stringv.Value = "FREE-D TEST COMMAND "
```

stringv.Value will be changed to "IT WORKED YAAAAAAAAY"

can be used to check if the injection succeeded

```
local stringv = Instance.new("StringValue")
stringv.Value = "Asdfgasa"
stringv.Value = "FREE-D" .. " SET START"
```

Causes the next union to be called with the faces and vertexes stored by the ADD FACE and ADD VERT commands

For the ADD FACE and ADD VERT command usage, see Plugin.Main.ClassGetter.Libraries

##File structure

```
PLUGIN ROOT
	AutoAssembler.lua (called Main.asm in GitHub)
	main.lua
		ClassGetter.lua (module script)
			Vertex.lua (module script)
				Part.rbxmx
			LineManager.lua (module script)
				Line.lua (module script)
			Libraries.lua (module script)
			Frame.lua (module script)
			Bone.lua (module script)
				BoneConnection.lua (module script)
			Animation.lua (module script)
			GUIs
				AnimationFrame.lua (module script)
					FrameActions.rbxmx
	guis.rbxmx
	animationframe.rbxmx
```