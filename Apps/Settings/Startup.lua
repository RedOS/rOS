if http then sHttp="$5 On " else sHtpp="$e Off " end
if tData["modemOn"] then sModem="$5 On " else sModem="$e Off " end
local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
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
tData=getData()
nUsed,sUsedUnit=getSpace(getSize("/"))
nFree,sFreeUnit=getSpace(fs.getSpaceLimit("/")-getSize("/"))
if tData["bTemp"] then sTemp="$5 Yes " else sTemp="$e No " end
local settings=true
paintutils.drawFilledBox(1,1,w,h,256)
status(128,false)
paintutils.drawLine(2,4,w-8,4,128)
term.setCursorPos(3,4)
print(os.getComputerLabel())
paintutils.drawLine(2,7,w-8,7,128)
term.setCursorPos(3,7)
print(tData["city"])
term.setBackgroundColor(256)
term.setCursorPos(2,3)
print("Phone name")
term.setCursorPos(2,7)
print("City")
term.setCursorPos(1,9)
cprint(" OS Version "..tData["version"].."\n &7Update&0")
cprint("\n HTTP "..sHttp.."$8")
cprint(" Modem "..sModem.."$8")
cprint(" Use Celsius "..sTemp.."$8")
print("\n "..round(nFree,2)..sFreeUnit.." Available")
print(" "..round(nUsed,2)..sUsedUnit.." Used")
term.setCursorPos((w-4)/2,h)
write("Back")
os.startTimer(60/72)
while settings do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
if tEvent[4]==4 then
term.setCursorPos(3,4)
label=read()
os.setComputerLabel(label)
term.setCursorPos(3,4)
cprint(label.."$8")
elseif tEvent[4]==7 then
term.setCursorPos(3,7)
tData["city"]=read()
term.setCursorPos(3,4)
cprint(tData["city"].."$8")
f=fs.open("System/config","w")
f.write(textutils.serialize(tData))
f.close()
elseif tEvent[4]==14 then
if tData["bTemp"]==true then tData["bTemp"]=false sTemp="$e No $8 " else tData["bTemp"]=true sTemp="$5 Yes " end
term.setCursorPos(1,11)
cprint("$8 Use Celsius "..sTemp.."$8")
f=fs.open("System/config","w")
f.write(textutils.serialize(tData))
f.close()
elseif tEvent[4]==13 then
if tData["modemOn"]==true then tData["modemOn"]=false sModem="$e Off " else tData["modemOn"]=true sModem="$5 On $8 " end
term.setCursorPos(1,10)
cprint("$8 Modem "..sModem.."$8")
f=fs.open("System/config","w")
f.write(textutils.serialize(tData))
f.close()
elseif tEvent[4]==10 then
shell.run("Apps/Update/Startup.lua")
elseif tEvent[4]==h then
settings=false
f=fs.open("System/config","w")
f.write(textutils.serialize(tData))
f.close()
shell.run("System/Desktop.lua")
end
elseif tEvent[1]=="timer" then
status(128,false)
os.startTimer(60/72)
end
end