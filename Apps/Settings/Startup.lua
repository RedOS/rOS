Settings={}
Settings.Table=textutils.unserialize(fs.open("Apps/Settings/Table.lua","r").readAll())
Settings.T=Settings.Table
Settings.Format={On=32,Off=16384}
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
    	if file==".DS_Store" then fs.delete(fs.combine(path,file)) else
      size = size + fs.getSize(fs.combine(path, file))
  	end
    end
  end
  end
  return size
end
function parseSize(size)
	local u={' B',' kB',' MB',' GB',' TB',' PB'}
	for i=1,6 do if size/1024^(i-1)<1024 then
		return tostring(math.floor(size/1024^(i-1)))..u[i]
	end
	end
end
Settings.Objects=Parse.render(Settings.Table,getfenv())
Settings.env = getfenv()
while Settings.Running do
	Event={os.pullEventRaw()}
	if Event[1]=="mouse_click" then
		Settings.x,Settings.y=Event[3],Event[4]
		for i=1,#Settings.Objects do
			if Settings.Objects[i] then
				if Settings.x>=Settings.Objects[i].size.sX and Settings.x<=Settings.Objects[i].size.eX and Settings.y>=Settings.Objects[i].size.sY and Settings.y<=Settings.Objects[i].size.eY and Settings.Objects[i].action then Settings.Objects[i].action() Settings.env = getfenv() Settings.Objects=Parse.render(Settings.Objects.Table,getfenv()) end
			end
		end
		if Settings.x>=Screen.Width/2-3 and Settings.x<=Screen.Width/2+3 and Settings.y==Screen.Height then Settings.Running=false end
	end
end