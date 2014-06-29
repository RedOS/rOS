local on="$5 I$8"
local off="$eI $8"
if http then sHttp=on else sHtpp=off end
if tData["modemOn"] then sModem=on else sModem=off end
if tData["notice"] then sNotice=on else sNotice=off end
if tData["bTemp"] then sTemp=on else sTemp=off end
if tData["tFormat"] then sTime=off else sTime=on end
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
local settings=true
paintutils.drawFilledBox(1,1,w,h,256)
status(128,false)
paintutils.drawLine(7,4,w-4,4,128)
term.setCursorPos(8,4)
print(os.getComputerLabel())
paintutils.drawLine(7,5,w-4,5,128)
term.setCursorPos(8,5)
print(tData["city"])
term.setBackgroundColor(256)
term.setCursorPos(2,4)
print("Name")
term.setCursorPos(2,5)
print("City")
term.setCursorPos(1,7)
cprint(" OS Version "..tData["version"].."\n &7Update&0")
term.setCursorPos(w-2,9)
cprint("\n HTTP ")
term.setCursorPos(w-2,10)
cprint(sHttp.."$8")
cprint(" Modem ")
term.setCursorPos(w-2,11)
cprint(sModem.."$8")
cprint(" Use Celsius ")
term.setCursorPos(w-2,12)
cprint(sTemp.."$8")
cprint(" Notifications ")
term.setCursorPos(w-2,13)
cprint(sNotice.."$8")
cprint(" Use AM/PM ")
term.setCursorPos(w-2,14)
cprint(sTime.."$8")
print("\n "..round(nFree,2)..sFreeUnit.." Available")
print(" "..round(nUsed,2)..sUsedUnit.." Used")
term.setCursorPos((w-4)/2,h)
write("Back")
os.startTimer(60/72)
while settings do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
if tEvent[4]==4 then
paintutils.drawLine(7,4,w-4,4,128)
term.setCursorPos(8,4)
label=read()
os.setComputerLabel(label)
term.setCursorPos(8,4)
cprint(label.."$8")
change=true
elseif tEvent[4]==5 then
paintutils.drawLine(7,5,w-4,5,128)
term.setCursorPos(8,5)
tData["city"]=read()
term.setCursorPos(8,5)
cprint(tData["city"].."$8")
change=true
elseif tEvent[4]==11 then
if tData["modemOn"]==true then tData["modemOn"]=false sModem=off else tData["modemOn"]=true sModem=on end
term.setCursorPos(1,11)
cprint("$8 Modem ")
term.setCursorPos(w-2,11)
cprint(sModem.."$8")
change=true
elseif tEvent[4]==12 then
if tData["bTemp"]==true then tData["bTemp"]=false sTemp=off else tData["bTemp"]=true sTemp=on end
term.setCursorPos(1,12)
cprint("$8 Use Celsius ")
term.setCursorPos(w-2,12)
cprint(sTemp.."$8")
change=true
elseif tEvent[4]==13 then
if tData["notice"]==true then tData["notice"]=false sNotice=off else tData["notice"]=true sNotice=on end
term.setCursorPos(1,13)
cprint("$8 Notifications ")
term.setCursorPos(w-2,13)
cprint(sNotice.."$8")
change=true
elseif tEvent[4]==14 then
if tData["tFormat"]==true then tData["tFormat"]=false sTime=on else tData["tFormat"]=true sTime=off end
term.setCursorPos(1,14)
cprint("$8 Use AM/PM ")
term.setCursorPos(w-2,14)
cprint(sTime.."$8")
change=true
elseif tEvent[4]==8 then
shell.run(tData["path"].."Apps/Update/Startup.lua")
elseif tEvent[4]==h then
settings=false
f=fs.open(tData["path"].."System/Config.lua","w")
f.write(textutils.serialize(tData))
f.close()
shell.run(tData["path"].."System/Desktop.lua")
end
if change then f=fs.open(tData["path"].."System/Config.lua","w") f.write(textutils.serialize(tData)) f.close() change=nil end
elseif tEvent[1]=="timer" then
status(128,false)
os.startTimer(60/72)
elseif tEvent[1]=="modem_message" then
if tEvent[3]==CHAT_CHANNEL then
if tData["notice"] then status(128,false,tEvent[5],32) end
for i=2,17 do
tChatHistory[i-1]=tChatHistory[i]
end
tChatHistory[17]=tEvent[5]
end
elseif tEvent[1]=="alarm" then
if tData["notice"] then status(128,false,"Alarm at "..tData["time"],16384) end
os.setAlarm(os.time())
end
end