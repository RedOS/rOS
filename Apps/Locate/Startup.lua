Locate={}
Locate.Pos={}
Locate.Loading=true
Locate.Running=true
local function loading()
	local table={"/","-","\\","|",}
	while Locate.Loading do
		for i=1,4 do
			if Locate.Loading then
			term.setCursorPos(Screen.Width/2,Screen.Height/2)
			term.write(table[i])
			os.sleep(.33)
			end
		end
	end
end
local function locate()
	Locate.Pos={gps.locate()} or nil
	if #Locate.Pos>0 then
		paintutils.drawFilledBox(Screen.Width/2-2,Screen.Height/2-1,Screen.Width/2+2,Screen.Height/2+1,1)
		for i=1,3 do
			term.setCursorPos(Screen.Width/2-2,Screen.Height/2-2+i)
			term.write(math.floor(Locate.Pos[i]))
		end
	else
		paintutils.drawFilledBox(Screen.Width/2-4,Screen.Height/2-1,Screen.Width/2+4,Screen.Height/2+1,1)
		term.setCursorPos(Screen.Width/2-2,Screen.Height/2)
		term.write("Error")
	end
	Locate.Loading=false
end
term.setTextColor(32768)
paintutils.drawFilledBox(Screen.Width/2-1,Screen.Height/2-1,Screen.Width/2+1,Screen.Height/2+1,1)
while Locate.Running do
	parallel.waitForAll(loading,locate)
	Event={os.pullEventRaw()}
	if Event[1]==("mouse_click" or "key") then Locate.Running=false end
end