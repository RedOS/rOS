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
tData=getData()
nUsed,sUsedUnit=getSpace(getSize("/"))
nFree,sFreeUnit=getSpace(fs.getSpaceLimit("/")-getSize("/"))
local settings=true
paintutils.drawFilledBox(1,1,w,h,1)
status(256,false)
paintutils.drawLine(7,4,w-4,4,256)
term.setCursorPos(8,4)
print(os.getComputerLabel())
term.setBackgroundColor(1)
term.setCursorPos(2,4)
cprint("&fName")
term.setCursorPos(1,6)
cprint(" OS Version "..tData["version"].."\n &8Update&f")
term.setCursorPos(w-2,8)
cprint("\n HTTP ")
term.setCursorPos(w-2,9)
cprint(http and on or off.."$0")
cprint(" Modem ")
term.setCursorPos(w-2,10)
cprint(tData.modemOn==true and on or off.."$0")
cprint(" Use Celsius ")
term.setCursorPos(w-2,11)
cprint(tData.bTemp==true and on or off.."$0")
cprint(" Notifications ")
term.setCursorPos(w-2,12)
cprint(tData.notice==true and on or off.."$0")
cprint(" Use AM/PM ")
term.setCursorPos(w-2,13)
cprint(tData.tFormat==false and on or off.."$0")
print("\n "..round(nFree,2)..sFreeUnit.." Available")
print(" "..round(nUsed,2)..sUsedUnit.." Used")
term.setCursorPos((w-4)/2,h)
write("Back")
nStatusTimer=os.startTimer(60/72)
while settings do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
if tEvent[4]==4 then
paintutils.drawLine(7,4,w-4,4,256)
term.setCursorPos(8,4)
label=read()
os.setComputerLabel(label)
term.setCursorPos(8,4)
cprint(label.."$0")
change=true
elseif tEvent[4]==10 then
tData.modemOn=revert(tData.modemOn)
term.setCursorPos(1,10)
cprint("$0&f Modem ")
term.setCursorPos(w-2,10)
cprint(tData.modemOn==true and on or off.."$0")
elseif tEvent[4]==11 then
tData.bTemp=revert(tData.bTemp)
term.setCursorPos(1,11)
cprint("$0&f Use Celsius ")
term.setCursorPos(w-2,11)
cprint(tData.bTemp==true and on or off.."$0")
elseif tEvent[4]==12 then
tData.notice=revert(tData.notice)
term.setCursorPos(1,12)
cprint("$0&f Notifications ")
term.setCursorPos(w-2,12)
cprint(tData.notice==true and on or off.."$0")
elseif tEvent[4]==13 then
tData.tFormat=revert(tData.tFormat)
term.setCursorPos(1,13)
cprint("$0&f Use AM/PM ")
term.setCursorPos(w-2,13)
cprint(tData.tFormat==false and on or off.."$0")
elseif tEvent[4]==7 then
shell.run("Apps/Update/Startup.lua")
elseif tEvent[4]==h then
settings=false
f=fs.open("System/Config.lua","w")
f.write(textutils.serialize(tData))
f.close()
shell.run("System/Desktop.lua")
end
f=fs.open("System/Config.lua","w") f.write(textutils.serialize(tData)) f.close()
elseif tEvent[1]=="timer" and tEvent[2]==nStatusTimer then
status(256,false)
nStatusTimer=os.startTimer(60/72)
elseif tEvent[1]=="modem_message" then
if tEvent[3]==CHAT_CHANNEL then
if tData["notice"] then status(1,false,tEvent[5],32) end
for i=2,17 do
tChatHistory[i-1]=tChatHistory[i]
end
tChatHistory[17]=tEvent[5]
end
elseif tEvent[1]=="alarm" then
if tData["notice"] then status(1,false,"Alarm at "..tData["time"],16384) end
os.setAlarm(os.time())
end
end