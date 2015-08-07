Screen.Width,Screen.Height=term.getSize()
Lock={}
Lock.Number={}
Lock.Running=true
Lock.Code=""
Lock.x=0
Lock.y=0
Draw.setStatusColor(256)
term.setCursorBlink(false)
if not runned then runned=true  local c={32768,128,256,1,256,128} for i=1,6 do os.sleep(.1) term.clear(c[i]) end else term.clear(128) end
for line=1,4 do
	for row=1,3 do
		paintutils.drawFilledBox(Screen.Width/2+(row-1)*6-7,4*line,Screen.Width/2+(row-1)*6-5,4*line+2,(line==4 and row~=2) and 128 or 256)
		term.setCursorPos(Screen.Width/2+(row-1)*6-6,4*line+1)
		if not (line==4 and row~=2) then
		local CurrentNumber=(line==4 and row==2) and 0 or (line-1)*3+row
		term.write(tostring(CurrentNumber),1,256)
		Lock.Number[CurrentNumber]={}
		Lock.Number[CurrentNumber].sX=math.floor(Screen.Width/2+(row-1)*6-7)
		Lock.Number[CurrentNumber].sY=math.floor(4*line)
		Lock.Number[CurrentNumber].number=CurrentNumber
		end
	end
end
local function Check()
if #Lock.Code==5 then 
	if tonumber(Lock.Code)==Core.getData("Code") then Lock.Runnning=false shell.run("System/Desktop.lua") else
		for i=1,2 do 
			for n=1,5 do 
				paintutils.drawPixel(Screen.Width/2-6+2*n,2,i==1 and 16384 or 1) 
			end 
			if i==1 then os.sleep(1) end 
		end
		Lock.Code=""
	end
end
end
Lock.Check=Check
for i=1,5 do
	paintutils.drawPixel(Screen.Width/2-6+2*i,2,1)
end
while Lock.Running do
	Event={os.pullEventRaw()}
	if Event[1]=="mouse_click" then
		Lock.x,Lock.y=Event[3],Event[4]
		for number=0,9 do
			if Lock.x>=Lock.Number[number].sX and Lock.x<=Lock.Number[number].sX+2 and Lock.y>=Lock.Number[number].sY and Lock.y<=Lock.Number[number].sY+2 then Lock.Code=Lock.Code..number paintutils.drawPixel(Screen.Width/2-6+2*#Lock.Code,2,32) end
		end
		Lock.Check()
	elseif Event[1]=="char" and type(tonumber(Event[2]))=="number" then Lock.Code=Lock.Code..tostring(Event[2]) paintutils.drawPixel(Screen.Width/2-6+2*#Lock.Code,2,32) Lock.Check()
	end
end