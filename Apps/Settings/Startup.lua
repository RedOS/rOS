Settings={}
Settings.Groups=textutils.unserialize(fs.open("Apps/Settings/Table.lua","r").readAll())
Settings.Format={On=32,Off=16384}
Settings.Big=Screen.Width>29 and true or false
Settings.Buttons={}
Settings.CurrentPage=0
Settings.x=0
Settings.y=0
Settings.Running=true
fs.getSizeFolder = function(path)
  local size = 0
  for _, file in ipairs(fs.list(path)) do
  if file~="rom" then
    if fs.isDir(fs.combine(path, file)) then
      size = size + fs.getSizeFolder(fs.combine(path, file))
    else
      size = size + fs.getSize(fs.combine(path, file))
    end
  end
  end
  return size
end
local function handleType(Type,Value,Action)
	local ox,oy=term.getCursorPos()
	if Type=="bool" then
		if type(Value)=="string" then Value=loadstring(Value)() end
		term.setCursorPos(Screen.Width-1,oy)
		term.setTextColor(1)
		term.setBackgroundColor(Value and Settings.Format.On or Settings.Format.Off)
		term.write(Value and "I" or "O")
		local size=#Settings.Buttons[Settings.CurrentPage]+1
		Settings.Buttons[Settings.CurrentPage][size]={}
		Settings.Buttons[Settings.CurrentPage][size].sX=Screen.Width-2
		Settings.Buttons[Settings.CurrentPage][size].eX=Screen.Width
		Settings.Buttons[Settings.CurrentPage][size].y=oy
		Settings.Buttons[Settings.CurrentPage][size].Action=loadstring(Action)
	elseif Type=="string" then
		if type(Value)=="string" then Value=loadstring(Value)() end
		paintutils.drawLine(Settings.Big and 20 or 2,oy+1,Screen.Width-2,oy+1,256)
		term.setTextColor(1)
		term.setCursorPos(Settings.Big and 21 or 3,oy+1)
		term.write(Value)
		local size=#Settings.Buttons[Settings.CurrentPage]+1
		Settings.Buttons[Settings.CurrentPage][size]={}
		Settings.Buttons[Settings.CurrentPage][size].sX=Settings.Big and 20 or 2
		Settings.Buttons[Settings.CurrentPage][size].eX=Screen.Width-2
		Settings.Buttons[Settings.CurrentPage][size].y=oy+1
		Settings.Buttons[Settings.CurrentPage][size].Action=loadstring(Action)
	elseif Type=="static" then
		if type(Value)=="string" then Value=loadstring(Value)() end
		term.setTextColor(32768)
		term.setBackgroundColor(1)
		term.setCursorPos(Screen.Width-#Value,oy)
		term.write(Value)
	elseif Type=="number" then
		if type(Value)=="string" then Value=loadstring(Value)() end
		term.setCursorPos(Screen.Width-#Value,oy)
		term.setTextColor(32768)
		term.setBackgroundColor(1)
		term.write(Value)
		local size=#Settings.Buttons[Settings.CurrentPage]+1
		Settings.Buttons[Settings.CurrentPage][size]={}
		Settings.Buttons[Settings.CurrentPage][size].sX=Screen.Width-2
		Settings.Buttons[Settings.CurrentPage][size].eX=Screen.Width
		Settings.Buttons[Settings.CurrentPage][size].y=oy
		Settings.Buttons[Settings.CurrentPage][size].Action=loadstring(Action)
	elseif Type=="list" then
		for n=1,#Value do
			term.setCursorPos(Settings.Big and 21 or 3,oy+n)
			term.setTextColor(32768)
			term.setBackgroundColor(1)
			term.write(Value[n].Name..":")
			local code=tostring(loadstring(Value[n].Code)())
			term.setCursorPos(Screen.Width-#code,oy+n)
			term.setTextColor(256)
			term.write(code)
		end
	end
end
local function draw(settings)
	if settings==0 then settings=nil end
	Settings.CurrentPage=settings or 0
	Draw.clear(1)
	Draw.setStatusColor(1)
	Draw.status()
	term.setCursorPos(Screen.Width/2-2,Screen.Height)
	term.setTextColor(1)
	term.setBackgroundColor(16384)
	term.write(" Exit ")
	if not settings or (settings and Settings.Big) then
		if Settings.Big then term.setTextColor(32768) for i=1,Screen.Height do term.setCursorPos(18,i) term.write("|") end end
		term.setBackgroundColor(1)
		for i=1,#Settings.Groups do
			Settings.Buttons[i]={}
			Settings.Buttons[i].sX=2
			Settings.Buttons[i].eX=#Settings.Groups[i].Name+1
			Settings.Buttons[i].y=i+1
			Settings.Buttons[i].Page=i
			term.setTextColor(32768)
			term.setCursorPos(2,i+1)
			term.write(Settings.Groups[i].Name)
			term.setCursorPos(Settings.Big and 16 or Screen.Width-1,i+1)
			term.setTextColor(256)
			term.write(">")
		end
	end
	if settings then
		paintutils.drawFilledBox(Settings.Big and 19 or 1,1,Screen.Width,Screen.Height,1)
		term.setCursorPos(math.ceil((Screen.Width-#Settings.Groups[settings].Name)/2),1)
		term.setTextColor(2048)
		term.write(Settings.Groups[settings].Name)
		term.setCursorPos(Settings.Big and 19 or 2,2)
		term.setTextColor(256)
		term.write("< Back")
		Settings.Buttons[Settings.CurrentPage][1]={sX=Settings.Big and 19 or 2,eX=Settings.Big and 25 or 6,y=2,Action=Settings.Draw}
		if Settings.Groups[settings].Items then
		for i=1,#Settings.Groups[settings].Items do
			term.setCursorPos(Settings.Big and 20 or 2,i+3)
			term.setTextColor(32768)
			term.setBackgroundColor(1)
			term.write(Settings.Groups[settings].Items[i].Type=="space" and "" or Settings.Groups[settings].Items[i].Name)
			if Settings.Groups[settings].Items[i].Value then handleType(Settings.Groups[settings].Items[i].Type,Settings.Groups[settings].Items[i].Value,Settings.Groups[settings].Items[i].Action) end
		end
		end
	end
end
Settings.Draw=draw; draw=nil
Settings.Draw()
while Settings.Running do
	Event={os.pullEventRaw()}
	if Event[1]=="mouse_click" then
		Settings.x,Settings.y=Event[3],Event[4]
		if Settings.CurrentPage==0 then
			for i=1,#Settings.Buttons do
				if Settings.CurrentPage==0 then if Settings.x>=Settings.Buttons[i].sX and Settings.x<=Settings.Buttons[i].eX and Settings.y==Settings.Buttons[i].y then Settings.Draw(Settings.Buttons[i].Page) end end
			end
		else
			for n=1,#Settings.Buttons[Settings.CurrentPage] do
				local i=Settings.CurrentPage
				if Settings.Buttons[i] then
					if Settings.Buttons[i][n] then
						if Settings.x>=Settings.Buttons[i][n].sX and Settings.x<=Settings.Buttons[i][n].eX and Settings.y==Settings.Buttons[i][n].y then Settings.Buttons[i][n].Action() Settings.x,Settings.y=0,0 Settings.Draw(Settings.CurrentPage) end
					end
				end
			end
		end
		if Settings.CurrentPage==0 and Settings.x>=Screen.Width/2-2 and Settings.x<=Screen.Width/2+2 and Settings.y==Screen.Height then Settings.Running=false end
	end
end