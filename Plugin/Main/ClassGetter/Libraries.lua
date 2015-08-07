local module = {}

module.float2hex =  function(n)
	    if n == 0.0 then return 0.0 end
	
	    local sign = 0
	    if n < 0.0 then
	        sign = 0x80
	        n = -n
	    end
	
	    local mant, expo = math.frexp(n)
	    local hext = {}
	
	    if mant ~= mant then
	        hext[#hext+1] = string.char(0xFF, 0x88, 0x00, 0x00)
	
	    elseif mant == math.huge or expo > 0x80 then
	        if sign == 0 then
	            hext[#hext+1] = string.char(0x7F, 0x80, 0x00, 0x00)
	        else
	            hext[#hext+1] = string.char(0xFF, 0x80, 0x00, 0x00)
	        end
	
	    elseif (mant == 0.0 and expo == 0) or expo < -0x7E then
	        hext[#hext+1] = string.char(sign, 0x00, 0x00, 0x00)
	
	    else
	        expo = expo + 0x7E
	        mant = (mant * 2.0 - 1.0) * math.ldexp(0.5, 24)
	        hext[#hext+1] = string.char(sign + math.floor(expo / 0x2),
	                                    (expo % 0x2) * 0x80 + math.floor(mant / 0x10000),
	                                    math.floor(mant / 0x100) % 0x100,
	                                    mant % 0x100)
	    end
	
	    return tonumber(string.gsub(table.concat(hext),"(.)",
	    function (c) return string.format("%02X%s",string.byte(c),"") end), 16)
	end
	
module.splittobytes =  function(floatstring)
		local length = string.len(floatstring)
		for i=length, 7 do
			floatstring = "0" .. floatstring
		end
		return string.upper(floatstring)
end
module.Num = 0
module.ExportVertex = function(x,y,z, color3)
	local stringv = Instance.new("StringValue")
	stringv.Value = "asfasd"
	--[[if color3 ~= nil then --couldnt get materials to work right sadly
		local r = color3.r
		local g = color3.g
		local b = color3.b
	
		
		local part = Instance.new("Part")
		part.Parent = game.Workspace
		part.CFrame = CFrame.new(0,module.Num*2,0)
		part.BrickColor = BrickColor.new(color3)
		
		module.Num = module.Num +1
		
		print(r .. " " .. g .. " " .. b)
		
		r = string.upper(module.splittobytes(("%x"):format(module.float2hex(r))))
		g = string.upper(module.splittobytes(("%x"):format(module.float2hex(g))))
		b = string.upper(module.splittobytes(("%x"):format(module.float2hex(b))))
		stringv.Value = "FREE-D" .. " ADD VERT " .. string.upper(module.splittobytes(("%x"):format(module.float2hex(x)))) .. string.upper(module.splittobytes(("%x"):format(module.float2hex(y)))) .. string.upper(module.splittobytes(("%x"):format(module.float2hex(z)))) .. r .. g .. b
	else
		stringv.Value = "FREE-D" .. " ADD VERT " .. string.upper(module.splittobytes(("%x"):format(module.float2hex(x)))) .. string.upper(module.splittobytes(("%x"):format(module.float2hex(y)))) .. string.upper(module.splittobytes(("%x"):format(module.float2hex(z)))) .. "3F800000" .. "3F800000" .. "3F800000"	
	end--]]
	stringv.Value = "FREE-D" .. " ADD VERT " .. string.upper(module.splittobytes(("%x"):format(module.float2hex(x)))) .. string.upper(module.splittobytes(("%x"):format(module.float2hex(y)))) .. string.upper(module.splittobytes(("%x"):format(module.float2hex(z)))) .. "3F800000" .. "3F800000" .. "3F800000" 
end

module.ExportFace = function(v1, v2, v3)
	local stringv = Instance.new("StringValue")
	stringv.Value = "asfasd"
	stringv.Value = "FREE-D" .. " ADD FACE " .. module.splittobytes(("%x"):format(v1)) .. module.splittobytes(("%x"):format(v2)) .. module.splittobytes(("%x"):format(v3))
end

return module
