function setup(path)
Desktop={}
Desktop.App={}
Desktop.Path=path or ""
Desktop.Applications=fs.list("Apps/"..Desktop.Path)
for i=1,#Desktop.Applications do
	if Desktop.Applications[i] == "icon" then table.remove(Desktop.Applications,i) end
	if Desktop.Applications[i] == ".DS_Store" then table.remove(Desktop.Applications,i) end
	if Desktop.Applications[i] == "folder" then table.remove(Desktop.Applications,i) end
end
Desktop.Icons=#Desktop.Applications
Desktop.x=0
Desktop.y=0
Desktop.oldx=0
Desktop.oldy=0
Desktop.CurrentPage=0
Desktop.AppsDrawn=0
Desktop.Rows=(math.floor(Screen.Width/9)*9+6<=Screen.Width and math.ceil(Screen.Width/9) or math.floor(Screen.Width/9))
Desktop.Lines=(math.floor(Screen.Height/5)*5+3<=Screen.Height and math.floor(Screen.Height/5) or math.floor(Screen.Height/5)-1)
Desktop.Pages=math.ceil(Desktop.Icons/(Desktop.Rows*Desktop.Lines))-1
Desktop.Running=true
end
setup()
local function setPage(number)
Desktop.CurrentPage=number
end
local function icon(path)
if fs.exists(path) then
	f=fs.open(path,"r")
	local iconData=textutils.unserialize(f.readAll()) or {}
	f.close()
	if iconData.text and iconData.bColor and iconData.tColor then
		local cursorx,cursory=term.getCursorPos()
		for line=1,3 do
			term.blit(iconData.text[line],iconData.tColor[line],iconData.bColor[line])
			term.setCursorPos(cursorx,cursory+line)
		end
		if iconData.specialCode then loadstring(iconData.specialCode)() end
	end
end
end
function draw(number)
term.clear(128)
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
				if fs.exists("Apps/"..Desktop.Path..Desktop.App[CurrentApp].name.."/icon")==true then path="Apps/"..Desktop.Path..Desktop.App[CurrentApp].name.."/icon" else path="System/Images/icon" end
				icon(path)
				term.setCursorPos(((math.floor(Screen.Width*row/Desktop.Rows)-Screen.Width/Desktop.Rows/2)+2-#Desktop.Applications[CurrentApp]/2)>1 and (math.floor(Screen.Width*row/Desktop.Rows)-Screen.Width/Desktop.Rows/2)+2-#Desktop.Applications[CurrentApp]/2 or 1,Desktop.App[CurrentApp].sY+3)
				term.write(Desktop.App[CurrentApp].name,1,128)
				Desktop.AppsDrawn=Desktop.AppsDrawn+1
			end
		end
	end
	for i=1,Desktop.Pages+1 do
		paintutils.drawPixel(Screen.Width/2+2*(i-1)-Desktop.Pages,Screen.Height-1,(i-1)==Desktop.CurrentPage and 1 or 256)
	end
	Draw.setStatusColor(Draw.StatusGlobal)
	Draw.isVisible(true)
	if Desktop.Path~="" then
		term.setCursorPos(Screen.Width/2-2,Screen.Height)
		term.write("Back",1,128)
	end
end
draw()
while Desktop.Running do
	local Event={os.pullEventRaw()}
	if Event[1]=="mouse_click" then
		Desktop.x,Desktop.y=Event[3],Event[4]
		if Desktop.Path~="" and Desktop.x>=Screen.Width/2-2 and Desktop.x<=Screen.Width/2+2 and Desktop.y==Screen.Height then setup("") draw(0) end
		if Desktop.oldx==Desktop.x and Desktop.oldy==Desktop.y and Event[2]==1 then
			for i=1,Desktop.AppsDrawn do
			local l=Desktop.CurrentPage*(Desktop.Rows*Desktop.Lines)
			if Desktop.App[l+i] then
			if Desktop.x>=Desktop.App[l+i].sX and Desktop.x<=Desktop.App[l+i].sX+4 and Desktop.y>=Desktop.App[l+i].sY and Desktop.y<=Desktop.App[l+i].sY+3 then
				if not fs.exists("Apps/"..Desktop.Path..Desktop.App[l+i].name.."/folder") then
					shell.run("Apps/"..Desktop.Path..Desktop.App[l+i].name.."/Startup.lua") draw()
				else
					setup(Desktop.App[l+i].name.."/")
					draw(1)
				end
			end
			end
			end
			Desktop.oldx,Desktop.oldy=Desktop.x,Desktop.y
		end
	elseif Event[1]=="mouse_drag" then
		if Event[3]<Desktop.x-4 then if Desktop.CurrentPage+1<=Desktop.Pages then draw(Desktop.CurrentPage+1) end end
		if Event[3]>Desktop.x+4 then if Desktop.CurrentPage-1>=0 then draw(Desktop.CurrentPage-1) end end
	end
	Desktop.oldx,Desktop.oldy=Desktop.x,Desktop.y
end