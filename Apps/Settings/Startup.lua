local on="$5&0 I$0&f"
local off="$e&0I $0&f"
local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
local function revert(value)
if value==true then return false else return true end
end
local function getSize(path)
  local size = 0
  for _, file in ipairs(fs.list(path)) do
  if file~="rom" then
    if fs.isDir(fs.combine(path, file)) then
      --# if it is a directory, recurse.
      size = size + getSize(fs.combine(path, file))
    else
      size = size + fs.getSize(fs.combine(path, file))
    end
  end
  end
  return size
end
fs.getSpaceLimit = function(_path, _space, _final)
local final = true
if(_final ~= nil) then
final = _final
end 
local space = 0
if(_space ~= nil) then
space = _space
end
local sDir = ""
if _path ~= nil then sDir = _path end
local tContent = fs.list( sDir )
for i, j in pairs( tContent ) do
local sPath = fs.combine( sDir, j )
if fs.isDir( sPath ) then
if(sPath ~= "rom") then
space = space + 512
space = fs.getSpaceLimit(sPath, space, false)
end
else
space = space + fs.getSize(sPath)
end 
end
if(final == true) then
return space + fs.getFreeSpace(_path)
else
return space
end
end
local function getSpace(number,round)
if number<1024 then
unit=" B"
else
local units={" kB"," MB"," GB"," TB"," PB"}
for i=1,5 do
if number/1024^i < 768 then
number=number/1024^i
unit=units[i]
break
end
end
end
return number, unit
end
Data=Core.getData()
nUsed,sUsedUnit=getSpace(getSize("/"))
nFree,sFreeUnit=getSpace(fs.getSpaceLimit("/")-getSize("/"))
local settings=true
Draw.clear(1)
Draw.isStatusVisible(true)
Draw.setStatusColor(1)
Draw.status()
term.setBackgroundColor(1)
paintutils.drawLine(7,4,Screen.Width-4,4,256)
term.setCursorPos(8,4)
print(os.getComputerLabel())
term.setBackgroundColor(1)
term.setCursorPos(2,4)
Draw.cprint("&fName")
term.setCursorPos(1,6)
Draw.cprint(" OS Version "..Data.Version.."\n &8Update&f")
term.setCursorPos(Screen.Width-2,8)
Draw.cprint("\n HTTP ")
term.setCursorPos(Screen.Width-2,9)
Draw.cprint(http and on or off.."$0")
Draw.cprint(" Modem ")
term.setCursorPos(Screen.Width-2,10)
Draw.cprint(Data.bModem==true and on or off.."$0")
Draw.cprint(" Notifications ")
term.setCursorPos(Screen.Width-2,11)
Draw.cprint(Data.Notification==true and on or off.."$0")
Draw.cprint(" Use AM/PM ")
term.setCursorPos(Screen.Width-2,12)
Draw.cprint(Data.H24==false and on or off.."$0")
print("\n "..round(nFree,2)..sFreeUnit.." Available")
print(" "..round(nUsed,2)..sUsedUnit.." Used")
term.setCursorPos((Screen.Width-4)/2,Screen.Height)
write("Back")
while settings do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
if tEvent[4]==4 then
paintutils.drawLine(7,4,Screen.Width-4,4,256)
term.setCursorPos(8,4)
label=read()
os.setComputerLabel(label)
term.setCursorPos(8,4)
Draw.cprint(label.."$0")
change=true
elseif tEvent[4]==10 then
Data.bModem=revert(Data.bModem)
term.setCursorPos(1,10)
Draw.cprint("$0&f Modem ")
term.setCursorPos(Screen.Width-2,10)
Draw.cprint(Data.bModem==true and on or off.."$0")
elseif tEvent[4]==11 then
Data.Notification=revert(Data.Notification)
term.setCursorPos(1,11)
Draw.cprint("$0&f Notifications ")
term.setCursorPos(Screen.Width-2,1)
Draw.cprint(Data.Notification==true and on or off.."$0")
elseif tEvent[4]==12 then
Data.H24=revert(Data.H24)
term.setCursorPos(1,12)
Draw.cprint("$0&f Use AM/PM ")
term.setCursorPos(Screen.Width-2,12)
Draw.cprint(Data.H24==false and on or off.."$0")
elseif tEvent[4]==7 then
shell.run("Apps/Update/Startup.lua")
elseif tEvent[4]==Screen.Height then
settings=false
f=fs.open("System/Config.lua","w")
f.write(textutils.serialize(Data))
f.close()
shell.run("System/Desktop.lua")
end
f=fs.open("System/Config.lua","w") f.write(textutils.serialize(Data)) f.close()
end
end