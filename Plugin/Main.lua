--Free-D mesh injection by OTRainbowDash5000/YAYZMAN23

local toolbar = plugin:CreateToolbar("TESTA")

local button = toolbar:CreateButton(
	"TEST",
	"Converts a .OBJ into an auto assembler script",
	"http://www.roblox.com/asset/?id=270949662"
)

local test = Instance.new("StringValue")
test.Value = "FREE-D" .. " TESTING"

button.Click:connect(function()
	test.Value = "FREE-D" .. " TEST COMMAND "
	print(test.Value)
end)
