Game={}
Game.Rows=(math.floor(Screen.Width/9)*9+6<=Screen.Width and math.ceil(Screen.Width/9) or math.floor(Screen.Width/9))
Game.Lines=(math.floor(Screen.Height/5)*5+3<=Screen.Height and math.floor(Screen.Height/5) or math.floor(Screen.Height/5)-1)
Game.Pages=math.ceil(Game.Icons/(Game.Rows*Game.Lines))-1
local function draw(number)
Draw.clear(1)
local number=number or 0
Game.App={}
Game.Applications=fs.list("Apps/Games/Content")
Game.Icons=#Game.Applications
Game.x=0
Game.y=0
Game.oldx=0
Game.oldy=0
Game.CurrentPage=0
Game.AppsDrawn=0
if number<0 then number=0 end
if number>Game.Pages then number=Game.Pages end
	Game.CurrentPage=number
	for line=1,Game.Lines do
		for row=1,Game.Rows do
			CurrentApp=(number*(Game.Lines*Game.Rows))+(line-1)*Game.Rows+row
				if Game.Applications[CurrentApp] then
				Game.App[CurrentApp]={}
				Game.App[CurrentApp].sX=math.floor(math.floor(Screen.Width*row/Game.Rows)-Screen.Width/Game.Rows/2)
				Game.App[CurrentApp].sY=line*5-3
				Game.App[CurrentApp].name=Game.Applications[CurrentApp]
				term.setCursorPos(Game.App[CurrentApp].sX,Game.App[CurrentApp].sY)
				if fs.exists("Apps/Games/Content"..Game.App[CurrentApp].name.."/icon")==true then path="Apps/Games/Content/"..Game.App[CurrentApp].name.."/icon" else path="System/Images/icon" end
				Draw.icon(path)
				term.setBackgroundColor(1)
				term.setTextColor(32768)
				term.setCursorPos(((math.floor(Screen.Width*row/Game.Rows)-Screen.Width/Game.Rows/2)+2-#Game.Applications[CurrentApp]/2)>1 and (math.floor(Screen.Width*row/Game.Rows)-Screen.Width/Game.Rows/2)+2-#Game.Applications[CurrentApp]/2 or 1,Game.App[CurrentApp].sY+3)
				term.write(Game.App[CurrentApp].name)
				Game.AppsDrawn=Game.AppsDrawn+1
			end
		end
	end
	for i=1,Game.Pages+1 do
		paintutils.drawPixel(Screen.Width/2+2*(i-1)-Game.Pages,Screen.Height-1,(i-1)==Game.CurrentPage and 128 or 256)
	end
	Draw.setStatusColor(Draw.StatusGlobal)
	Draw.isStatusVisible(true)
	Draw.status()
end
Game.Running=true
Game.draw=draw; draw=nil
Game.draw()
while Game.Running do
	local Event={os.pullEventRaw()}
	if Event[1]=="mouse_click" then
		Game.x,Game.y=Event[3],Event[4]
		if Game.oldx==Game.x and Game.oldy==Game.y then
			for i=1,Game.AppsDrawn do
			local l=Game.CurrentPage*(Game.Rows*Game.Lines)
			if Game.x>=Game.App[l+i].sX and Game.x<=Game.App[l+i].sX+4 and Game.y>=Game.App[l+i].sY and Game.y<=Game.App[l+i].sY+4 then
				shell.run("Apps/Games/Content/"..Game.App[l+i].name.."/Startup.lua") Game.draw()
			end
			end
			Game.oldx,Game.oldy=Game.x,Game.y
		end
	elseif Event[1]=="mouse_drag" then
		if Event[3]<Game.x-4 then if Game.CurrentPage+1<=Game.Pages then Game.draw(Game.CurrentPage+1) end end
		if Event[3]>Game.x+4 then if Game.CurrentPage-1>=0 then Game.draw(Game.CurrentPage-1) end end
	end
	Game.oldx,Game.oldy=Game.x,Game.y
end