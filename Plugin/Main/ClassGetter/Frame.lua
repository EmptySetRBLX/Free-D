local Class = {}
Class.__index = Class

setmetatable(Class, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

Class.new = function(classes, scale, vertexlist, facelist)
	local self = setmetatable({}, Class)
	self.classes = classes
	self.Type = script.Name
	self.Vertexes = vertexlist
	self.Faces = facelist
	self.Scale = scale
	self.ShouldRender = false
	self.Bones = {}
	return self
end

Class.Lerp = function(self, goal, fraction)
	local returnvertexes = {}
	local returnfaces = {}
	for i=1, #self.Vertexes do
		local selfcframe = CFrame.new(self.Vertexes[i].X, self.Vertexes[i].Y, self.Vertexes[i].Z)
		local goalcframe = CFrame.new(goal.Vertexes[i].X, goal.Vertexes[i].Y, goal.Vertexes[i].Z)
		local result = selfcframe:lerp(goalcframe, fraction)
		returnvertexes[i] = self.classes["Vertex"](self.classes, result.x, result.y, result.z, i-1)
	end
	for i=1, #self.Faces do
		local face = self.classes["Face"](self.classes, returnvertexes[self.Faces[i].V1.Index+1], returnvertexes[self.Faces[i].V2.Index+1], returnvertexes[self.Faces[i].V3.Index+1], self.Faces[i].Color)
		returnfaces[i] = face
	end
	return self.classes["Frame"](self.classes, self.Scale, returnvertexes, returnfaces)
end

Class.FindVertexFromIndex = function(self, index)
	for i=1, #self.Vertexes do
		if self.Vertexes[i].Index == index then
			return self.Vertexes[i]
		end
	end
	return nil
end

Class.Clone = function(self)
	local clonevertex = {}
	local clonefacelist = {}
	local bones = {}
	for i=1, #self.Vertexes do
		local currentvertex = self.Vertexes[i]
		local newvertex = self.classes["Vertex"](self.classes, currentvertex.X, currentvertex.Y, currentvertex.Z, currentvertex.Index)
		clonevertex[i] = newvertex
	end
	for i=1, #self.Faces do
		local face = self.classes["Face"](self.classes, clonevertex[self.Faces[i].V1.Index+1], clonevertex[self.Faces[i].V2.Index+1], clonevertex[self.Faces[i].V3.Index+1], self.Faces[i].Color)
		table.insert(clonefacelist, face)	
	end
	
	local frame = self.classes["Frame"](self.classes, self.Scale, clonevertex, clonefacelist)
	for i=1, #self.Bones do
		
		if self.Bones[i].Part then
			bones[i] = self.classes["Bone"](self.classes, self.Bones[i].Part:Clone(), i)
		else
			bones[i] = self.classes["Bone"](self.classes, nil)
		end
		
		for k=1, #self.Bones[i].LinkedTo do
			table.insert(bones[i].LinkedTo, frame:FindVertexFromIndex(self.Bones[i].LinkedTo[k].Index))
		end
		for k=1, #self.Bones[i].C0s do
			table.insert(bones[i].C0s, self.Bones[i].C0s[k])
		end
	end
	for i=1, #bones do
		local function getindexfrombone(bone)
			for i=1, #self.Bones do
				if self.Bones[i] == bone then
					return i
				end
			end
		end
		if self.Bones[i].LinkedBoneParent then
			bones[i].LinkedBoneParent = bones[getindexfrombone(self.Bones[i].LinkedBoneParent)]
		end
		for k=1, #self.Bones[i].LinkedBones do
			--bones[i].LinkedBones[k] = bones[getindexfrombone(self.Bones[i].LinkedBones[k])]
			local weee = bones[getindexfrombone(self.Bones[i].LinkedBones[k].Bone)]		
			bones[i].LinkedBones[k] = self.classes["BoneConnection"](self.classes, weee, self.Bones[i].LinkedBones[k].C0)
		end
	end
	if #bones > 0 then
		frame.Bones = bones
	end
	return frame
end

Class.DoUnion = function(self, plugin)
	for i=1, #self.Faces do
		if self.Faces[i].Color then
			if self.Faces[i].V1.Color == nil then
				self.Faces[i].V1.Color = self.Faces[i].Color
			end
			if self.Faces[i].V2.Color == nil then
				self.Faces[i].V2.Color = self.Faces[i].Color
			end
			if self.Faces[i].V3.Color == nil then
				self.Faces[i].V3.Color = self.Faces[i].Color
			end
		end
	end
	for i=1, #self.Vertexes do
		for k=1, #self.Vertexes do
			if self.Vertexes[k].Index == i-1 then
				self.classes["Libraries"].ExportVertex(self.Vertexes[k].X, self.Vertexes[k].Y, self.Vertexes[k].Z, self.Vertexes[k].Color)
			end
		end
	end
	for i=1, #self.Faces do
		self.classes["Libraries"].ExportFace(self.Faces[i].V1.Index, self.Faces[i].V2.Index, self.Faces[i].V3.Index)
	end
	local stringv = Instance.new("StringValue")
	stringv.Value = "Asdfgasa"
	stringv.Value = "FREE-D" .. " SET START"
	local part = Instance.new("Part")
	part.BrickColor = BrickColor.new("Really red")
	
	local maxx = nil
	local minx = nil
	
	local maxy = nil
	local miny = nil
	
	local maxz = nil
	local minz = nil
	
	for i=1, #self.Vertexes do
		if maxx == nil then
			maxx = self.Vertexes[i].X
			minx = self.Vertexes[i].X
			
			maxy = self.Vertexes[i].Y
			miny = self.Vertexes[i].Y
			
			maxz = self.Vertexes[i].Z
			minz = self.Vertexes[i].Z
		end
		if maxx < self.Vertexes[i].X then
			maxx = self.Vertexes[i].X
		end
		if minx > self.Vertexes[i].X then
			minx = self.Vertexes[i].X
		end
		
		if maxy < self.Vertexes[i].Y then
			maxy = self.Vertexes[i].Y
		end
		if miny > self.Vertexes[i].Y then
			miny = self.Vertexes[i].Y
		end
		
		if maxz < self.Vertexes[i].Z then
			maxz = self.Vertexes[i].Z
		end
		if minz > self.Vertexes[i].Z then
			minz = self.Vertexes[i].Z
		end
		
	end
	local union = plugin:Union({part})
	if union == nil then
		print("INJECTION FAILED :(, TRY REDUCING YOUR TRIANGLE COUNT")
		union = Instance.new("Part")
	end
	union.CFrame = CFrame.new(((maxx+minx)/2),((maxy+miny)/2),((maxz+minz)/2))
	return union
end

Class.Render = function(self, parent, linemanager)
	self.ShouldRender = true
	for i=1, #self.Faces do
		self.Faces[i]:Render(self.Scale, parent, linemanager)
	end
	for i=1, #self.Bones do
		if self.Bones[i].Part then
			self.Bones[i].Part.Parent = game.Workspace
			self.Bones[i]:SetActive()
		end
	end
	linemanager:Render()
end

Class.GetBone = function(self, part)
	for i=1, #self.Bones do
		if part == self.Bones[i].Part then
			return self.Bones[i]
		end
	end
	return nil
end

Class.GetVertice = function(self, part)
	for i=1, #self.Vertexes do
		if part == self.Vertexes[i].Part then
			return self.Vertexes[i]
		end
	end
	return nil
end

Class.IsPartOf = function(self, part)
	for i=1, #self.Vertexes do
		if part == self.Vertexes[i].Part then
			return true
		end
	end
	for i=1, #self.Bones do
		if self.Bones[i].Part == part then
			return true
		end
	end
	return false
end

Class.DeRender = function(self)
	self.ShouldRender = false
	print("called")
	for i=1, #self.Faces do
		self.Faces[i]:DeRender()
	end
	for i=1, #self.Bones do
		if self.Bones[i].Part then
			pcall(function() self.Bones[i].Part.Parent = nil end)
		end
	end
end

Class.FromObj = function(classes, scale, objFile, mtlFile) 
	--totally just copy/pasted most of this to save time
	--credit to magnalite for the parser
	
	local function parseMaterials()
		materials = {}
		filePos = 0	
		local endfile = false
		while endfile == false do 
			endFile     = true
			materialPos = string.find(mtlFile, "newmtl" ,filePos)
			
			if materialPos then
				materialNameStartPos = string.find(mtlFile, "%s", materialPos+1)
				materialNameEndPos   = string.find(mtlFile, "%s", materialNameStartPos+1)
				materialName         = string.sub(mtlFile,materialNameStartPos+1,materialNameEndPos-1)
				
				colorPos      = string.find(mtlFile,	"Kd", materialNameEndPos)
				colorStartPos = string.find(mtlFile, "%s", colorPos)
				colorEndPos   = string.find(mtlFile, "Ks", colorStartPos)
				color         = string.sub(mtlFile, colorStartPos+1,colorEndPos-2)
				
				color1EndPos  = string.find(color, " ")
				color1        = string.sub(color,0,color1EndPos-1)
				
				color2EndPos  = string.find(color, " ", color1EndPos+1)
				color2        = string.sub(color,color1EndPos+1,color2EndPos-1)
				
				color3        = string.sub(color,color2EndPos+1)
				
				endColor      = Color3.new(tonumber(color1),tonumber(color2),tonumber(color3))
				
				materials[materialName] = endColor
				
				filePos = colorEndPos
				
			else
				endFile = true
				break 
			end
		
		end
	end
	
	local function parseVertexes()
		vertexes = {}
		filePos = 0	
		local endfile = false
		while not endfile do 
			local vertexPos = string.find(objFile, "v ",filePos)
			
			if vertexPos then		
				local startPos      = string.find(objFile, "%S", vertexPos+1)
				local firstCordPos  = string.find(objFile, " ", startPos)
				local firstCord     = string.sub(objFile,vertexPos+1,firstCordPos-1)
				
				local secondCordPos = string.find(objFile, " ", firstCordPos+1)
				local secondCord    = string.sub(objFile,firstCordPos+1,secondCordPos-1)
				
				local thirdCordPos  = string.find(objFile, "%s", secondCordPos+1)
				local thirdCord     = string.sub(objFile,secondCordPos+1,thirdCordPos-1)		
				
				filePos = thirdCordPos
				
	
	
				local vertex = Vector3.new(tonumber(firstCord),tonumber(secondCord),tonumber(thirdCord))
				
				
				table.insert(vertexes,vertex)
			
			else
				print("Number of vertices : " .. ("%x"):format(#vertexes))
				endfile = true
			end
		end
	end
	
	local function parseFaces()
		faces = {}
		filePos = 0	
		local endfile = false
		while not endfile do 
			local faceStringPos = string.find(objFile, "f ",filePos)
			
			useMaterial = string.find(objFile, "usemtl",filePos)	
			
			if useMaterial and useMaterial < faceStringPos then
				
				materialNameStartPos = string.find(objFile, "%s", useMaterial)
				materialNameEndPos   = string.find(objFile, "%s", materialNameStartPos+1)
				materialName         = string.sub(objFile,materialNameStartPos+1,materialNameEndPos-1)
				
				useColor = materials[materialName]
				
			end
			
			if faceStringPos then
				
				local face2startPos  = string.find(objFile," ",faceStringPos+2)	
				local face3startPos  = string.find(objFile," ",face2startPos+1)		
				
				local facePos1String = objFile:match("%d+",faceStringPos)
				local facePos2String = objFile:match("%d+",face2startPos)
				local facePos3String = objFile:match("%d+",face3startPos)		
				
				local face1Pos = vertexes[tonumber(facePos1String)]
				local face2Pos = vertexes[tonumber(facePos2String)]
				local face3Pos = vertexes[tonumber(facePos3String)]
				
				table.insert(faces,{face1Pos,face2Pos,face3Pos, useColor})
							
				filePos = face3startPos+1
			else
				print("Number of faces : " .. ("%x"):format(#faces))
				endfile = true
			end
		end	
	end
	parseMaterials()
	parseVertexes()
	parseFaces()
	
	local finalfaces = {}
	
	for i=1, #faces do
		finalfaces[i] = {}
		for k=1, #vertexes do
			if vertexes[k] == faces[i][1] then
				finalfaces[i][1] = k
			end
			if vertexes[k] == faces[i][2] then
				finalfaces[i][2] = k
			end
			if vertexes[k] == faces[i][3] then
				finalfaces[i][3] = k
			end
		end
		finalfaces[i][4] = faces[i][4]
	end
	
	faces = finalfaces
	
	local returnvertexes = {}
	local returnfaces = {}
	for i=1, #vertexes do
		local vert = classes["Vertex"](classes, vertexes[i].X, vertexes[i].Y, vertexes[i].Z, i-1)
		table.insert(returnvertexes, vert)
	end
	
	for i=1, #faces do
		local v1 = returnvertexes[faces[i][1]]
		local v2 = returnvertexes[faces[i][2]]
		local v3 = returnvertexes[faces[i][3]]
		local color = faces[i][4]
		local face = classes["Face"](classes, v1, v2, v3, color)
		table.insert(returnfaces, face)
	end
	
	return classes["Frame"](classes, scale, returnvertexes, returnfaces)
end


return Class
