Screen.Width,Screen.Height=term.getSize()
Lock={}
Lock.Number={}
Lock.Drag=0
Lock.Running=true
Lock.Code=""
Lock.x=0
Lock.y=0
Data=Core.getData()
Draw.clear(1)
Draw.setStatusColor(256)
Draw.status()
for line=1,3 do
	for row=1,3 do
		paintutils.drawFilledBox(Screen.Width/2+(row-1)*6-7,4*line,Screen.Width/2+(row-1)*6-5,4*line+2,256)
		term.setCursorPos(Screen.Width/2+(row-1)*6-6,4*line+1)
		term.setTextColor(1)
		local CurrentNumber=(line-1)*3+row
		term.write(tostring(CurrentNumber))
		Lock.Number[CurrentNumber]={}
		Lock.Number[CurrentNumber].sX=math.floor(Screen.Width/2+(row-1)*6-7)
		Lock.Number[CurrentNumber].sY=math.floor(4*line)
		Lock.Number[CurrentNumber].number=CurrentNumber
	end
end
paintutils.drawFilledBox(Screen.Width/2-1,16,Screen.Width/2+1,18,256)
term.setCursorPos(Screen.Width/2,17)
term.write("0")
Lock.Number[0]={}
Lock.Number[0].sX=Screen.Width/2-1
Lock.Number[0].sY=16
Lock.Number[0].number=0
for i=1,5 do
	paintutils.drawPixel(Screen.Width/2-6+2*i,2,128)
end
while Lock.Running do
	Event={os.pullEventRaw()}
	if Event[1]=="mouse_click" then
		Lock.x,Lock.y=Event[3],Event[4]
		for number=0,9 do
			if Lock.x>=Lock.Number[number].sX and Lock.x<=Lock.Number[number].sX+2 and Lock.y>=Lock.Number[number].sY and Lock.y<=Lock.Number[number].sY+2 then Lock.Code=Lock.Code..number end
		end
	elseif Event[1]=="char" and type(tonumber(Event[2]))=="number" then Lock.Code=Lock.Code..tostring(Event[2])
	elseif #Lock.Code==5 then 
		if tonumber(Lock.Code)==Data.Code then Lock.Runnning=false 
		shell.run("System/Desktop.lua") else
			for i=1,2 do 
				for n=1,5 do 
					paintutils.drawPixel(Screen.Width/2-6+2*n,2,i==1 and 16384 or 128) 
				end 
				if i==1 then os.sleep(1) end 
			end
			Lock.Code=""
		end
	end
end