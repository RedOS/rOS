Desktop={}
Desktop.App={}
Desktop.Applications=fs.list("Apps/")
Desktop.Icons=#Desktop.Applications
Desktop.x=0
Desktop.y=0
Desktop.oldx=0
Desktop.oldy=0
Desktop.CurrentPage=0
Desktop.Rows=(math.floor(Screen.Width/9)*9+6<=Screen.Width and math.ceil(Screen.Width/9) or math.floor(Screen.Width/9))
Desktop.Lines=(math.floor(Screen.Height/5)*5+3<=Screen.Height and math.floor(Screen.Height/5) or math.floor(Screen.Height/5)-1)
Desktop.Pages=math.ceil(Desktop.Icons/(Desktop.Rows*Desktop.Lines))-1
local function setPage(number)
Desktop.CurrentPage=number
end
local function draw(number)
Draw.clear(1)
local number=number or 0
if number<0 then number=0 end
if number>Desktop.Pages then number=Desktop.Pages end
	Desktop.CurrentPage=number
	for line=1,Desktop.Lines do
		for row=1,Desktop.Rows do
			CurrentApp=(number*(Desktop.Lines*Desktop.Rows))+(line-1)*Desktop.Rows+row
				if Desktop.Applications[CurrentApp] then
				Desktop.App[CurrentApp]={}
				Desktop.App[CurrentApp].sX=math.floor(math.floor(Screen.Width*row/Desktop.Rows)-Screen.Width/Desktop.Rows/2)
				Desktop.App[CurrentApp].sY=line*5-3
				Desktop.App[CurrentApp].name=Desktop.Applications[CurrentApp]
				term.setCursorPos(Desktop.App[CurrentApp].sX,Desktop.App[CurrentApp].sY)
				if fs.exists("Apps/"..Desktop.App[CurrentApp].name.."/icon")==true then path="Apps/"..Desktop.App[CurrentApp].name.."/icon" else path="System/Images/icon" end
				Draw.icon(path)
				term.setBackgroundColor(1)
				term.setTextColor(32768)
				term.setCursorPos(((math.floor(Screen.Width*row/Desktop.Rows)-Screen.Width/Desktop.Rows/2)+2-#Desktop.Applications[CurrentApp]/2)>1 and (math.floor(Screen.Width*row/Desktop.Rows)-Screen.Width/Desktop.Rows/2)+2-#Desktop.Applications[CurrentApp]/2 or 1,Desktop.App[CurrentApp].sY+3)
				term.write(Desktop.App[CurrentApp].name)
			end
		end
	end
	for i=1,Desktop.Pages+1 do
		paintutils.drawPixel(Screen.Width/2+2*(i-1)-Desktop.Pages,Screen.Height-1,(i-1)==Desktop.CurrentPage and 128 or 256)
	end
	Desktop.AppsDrawn=CurrentApp
	Draw.setStatusColor(Draw.StatusGlobal)
	Draw.isStatusVisible(true)
	Draw.status()
end
Desktop.Running=true
Desktop.draw=draw; draw=nil
Desktop.draw()
while Desktop.Running do
	local Event={os.pullEventRaw()}
	if Event[1]=="mouse_click" then
		Desktop.x,Desktop.y=Event[3],Event[4]
		if Desktop.oldx==Desktop.x and Desktop.oldy==Desktop.y then
			for i=1,Desktop.AppsDrawn do
			local l=(Desktop.Pages-1)*(Desktop.Rows*Desktop.Lines)
			if Desktop.x>=Desktop.App[l+i].sX and Desktop.x<=Desktop.App[l+i].sX+4 and Desktop.y>=Desktop.App[l+i].sY and Desktop.y<=Desktop.App[l+i].sY+4 then
				shell.run("Apps/"..Desktop.App[l+i].name.."/Startup.lua") Desktop.draw()
			end
			end
			Desktop.oldx,Desktop.oldy=Desktop.x,Desktop.y
		end
	elseif Event[1]=="mouse_drag" then
		if Event[3]<Desktop.x-4 then if Desktop.CurrentPage+1<=Desktop.Pages then Desktop.draw(Desktop.CurrentPage+1) end end
		if Event[3]>Desktop.x+4 then if Desktop.CurrentPage-1>=0 then Desktop.draw(Desktop.CurrentPage-1) end end
	end
	Desktop.oldx,Desktop.oldy=Desktop.x,Desktop.y
end