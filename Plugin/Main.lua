--Free-D mesh injection by OTRainbowDash5000/YAYZMAN23

local toolbar = plugin:CreateToolbar("TESTA")

local button = toolbar:CreateButton(
	"TEST",
	"Converts a .OBJ into an auto assembler script",
	"http://www.roblox.com/asset/?id=270949662"
)

local test = Instance.new("StringValue")
test.Value = "FREE-D" .. " TESTING"

function float2hex (n)
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
			hext[#hext+1] = string.char(sign + math.floor(expo / 0x2), (expo % 0x2) * 0x80 + math.floor(mant / 0x10000), math.floor(mant / 0x100) % 0x100, mant % 0x100)
		end
	return tonumber(string.gsub(table.concat(hext),"(.)",
	function (c) return string.format("%02X%s",string.byte(c),"") end), 16)
end

function splittobytes(floatstring)
	local length = string.len(floatstring)
		for i=length, 7 do
			floatstring = "0" .. floatstring
		end
	return (string.sub(floatstring,7,8) .. string.sub(floatstring,5,6) .. string.sub(floatstring,3,4) .. string.sub(floatstring,1,2))
end

button.Click:connect(function()
	test.Value = "FREE-D" .. " ADD FACE " .. string.upper(splittobytes(("%x"):format(float2hex(2.23123123))))
	print(test.Value)
end)