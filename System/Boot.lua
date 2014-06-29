w,h=term.getSize()
tData={}
tData["path"]=tPath
if fs.exists(tData["path"].."Apps/Time/Table.lua") then
f=fs.open(tData["path"].."Apps/Time/Table.lua","r")
tTime=textutils.unserialize(f.readAll())
Alarms=tTime.Alarms
tTime=nil
f.close()
for i=1,#Alarms.Times do
if Alarms.Active[i] then
hour=string.sub(Alarms.Times[i],1,2)
minute=string.sub(Alarms.Times[i],4,5)
os.setAlarm(tonumber(hour.."."..math.ceil(tonumber(minute)*100/60)))
end
end
end
if type(m)~="number" then m=1 end
if type(oldm)~="number" then oldm=1 end
oldx,oldy=1,1
tChatHistory={}
nCount=0
for i=1,17 do
tChatHistory[i]=""
end
function textutils.formatTime( nTime, bTwentyFourHour )
    local sTOD = nil
    if not bTwentyFourHour then
        if nTime >= 12 then
            sTOD = "PM"
        else
            sTOD = "AM"
        end
        if nTime >= 13 then
            nTime = nTime - 12
        end
    end
    local nHour = math.floor(nTime)
    local nMinute = math.floor((nTime - nHour)*60)
    if sTOD then
        return string.format( "%02d:%02d %s", nHour, nMinute, sTOD )
    else
        return string.format( "%02d:%02d", nHour, nMinute )
    end
end
function status(nColor, bLock, sMessage, nColor2)
if sMessage then nCount=8 sLocalMessage=sMessage nLocalColor=nColor2 end
if nColor==1 then term.setTextColor(2^15) else term.setTextColor(1) end
tData=getData()
if tData["modemOn"] and peripheral.isPresent("back") then sTempModem="M " else sTempModem="" end
if tData["btooth"] then sTempBtooth="B " else sTempBtooth="" end
if tData["notice"] then sTempNotice="N " else sTempNotice="" end
if nCount<1 then
paintutils.drawLine(1,1,w,1,nColor)
term.setCursorPos(1,1)
print(tData["net"])
term.setCursorPos(w-(#sTempModem+#sTempBtooth+#sTempNotice)+2,1)
cprint(sTempModem..sTempNotice..sTempBtooth)
if not bLock then
term.setCursorPos(math.ceil((w-#tData["time"]+1)/2),1)
print(tData["time"])
end
else
paintutils.drawLine(1,1,w,1,nLocalColor)
term.setCursorPos(1,1)
if #sLocalMessage>w-6 then sLocalMessage=sLocalMessage:sub(1,w-6).."..." end
sLocalMessage=sLocalMessage:gsub("&%d","")
sLocalMessage=sLocalMessage:gsub("$%d","")
print(sLocalMessage)
nCount=nCount-1
end
if tData["modemOn"] and peripheral.isPresent("back") then
if not modem then modem=peripheral.find("modem") CHAT_CHANNEL=65530 end
if not modem.isOpen(CHAT_CHANNEL) then modem.open(CHAT_CHANNEL) end
end
end
local function setup()
if not fs.exists(tData["path"].."System/config") then
local setup=true
local tData={}
local tLines = {
	"Welcome to rOS!\n Please name your phone",
	"Enter your five-digit code",
	"Use Celsius or not?",
	"All done!\n System will now reboot"
}
f=fs.open(tData["path"].."System/Version.lua","r")
f.close()
tData["version"]=f.readAll()
local function drawBg(text)
term.setBackgroundColor(1)
term.clear()
paintutils.drawLine(1,1,w,1,128)
term.setCursorPos((w-5)/2,1)
term.setTextColor(1)
print("Setup")
term.setBackgroundColor(1)
term.setTextColor(2^15)
term.setCursorPos(2,3)
print(text)
end
drawBg(tLines[1])
paintutils.drawLine(2,6,w-8,6,128)
term.setCursorPos(3,6)
term.setTextColor(1)
label=read()
os.setComputerLabel(label)
local function code()
drawBg(tLines[2])
paintutils.drawLine(2,6,w-8,6,128)
term.setCursorPos(3,6)
term.setTextColor(1)
tData["code"]=tonumber(read())
if #tostring(tData["code"])~=5 then code() end
end
code()
drawBg(tLines[3])
term.setCursorPos(3,6)
term.setBackgroundColor(32)
write(" Yes ")
term.setCursorPos(9,6)
term.setBackgroundColor(2^14)
write(" No ")
while setup do
local tEvent={os.pullEvent("mouse_click")}
if tEvent[4]==6 then
if tEvent[3]>=3 and tEvent[3]<=8 then tData["bTemp"]=true setup=false end
if tEvent[3]>=9 and tEvent[3]<=13 then tData["bTemp"]=false setup=false end
end
end
tData["notice"]=true
tData["tFormat"]=false
f=fs.open(tData["path"].."System/Config.lua","w")
f.write(textutils.serialize(tData))
f.close()
drawBg(tLines[4])
os.sleep(3)
os.reboot()
end
end
function date(days,string)
day={"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"}
_mon={"Janurary","February","March","April","May","June","July","August","September","October","November","December"}
dNum=(days-math.floor(days/7)*7)+1
dayName=day[dNum]
local function isLeapYear(year)
return year % 4 == 0 and (year % 100 > 0 or year % 400 == 0)
end
local function daysInYear(year)
if isLeapYear(year) then
return 366
end
return 365
end 
local year=0
local mon=1
while days >= daysInYear(year) do
days=days - daysInYear(year);
year=year + 1;
end
local _temp={ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 }
if isLeapYear(year) then
_temp[2]=29
end
while days >= _temp[mon] do
days=days - _temp[mon];
mon=mon + 1;
end
mont=_mon[mon]
if string=="data" then
string=dayName..", "..mont.." "..days+1
return string
else
return year,mont,days+1,dayName,dNum,mon
end
end
function wait()
local clrs={1,256,128,2^15}
for i=1,4 do
term.setBackgroundColor(clrs[i])
term.clear()
os.sleep(0.055)
end
os.sleep(1)
tEvent={os.pullEventRaw()}
print(tEvent[1])
if tEvent then
os.reboot() end
end
function getData()
if not fs.exists(tData["path"].."System/Config.lua") then setup() end
f=fs.open(tData["path"].."System/Config.lua","r")
data=f.readAll()
f.close()
f=fs.open(tData["path"].."System/Version.lua","r")
cver=f.readAll()
f.close()
tData=textutils.unserialize(data)
tData["path"]=tPath or ""
if peripheral.isPresent("back") and tData["modemOn"] then
tData["net"]="Online" elseif peripheral.isPresent("back") and not tData["modemOn"] then
tData["net"]="Offline" else
tData["net"]="No modem" end
tData["time"]=textutils.formatTime(os.time(),tData["tFormat"])
tData["date"]=date(os.day(),"data")
tData["version"]=tostring(cver)
return tData
end
function cCode(h)
        if term.isColor() and term.isColor then
                return 2 ^ (tonumber(h, 16) or 0)
        else
                if h == "f" then
                        return colors.black
                else
                        return colors.white
                end
        end
end
function cwrite(text)
        text = tostring(text)
        local i = 0
        while true  do
                i = i + 1
                if i > #text then break end
                
                local c = text:sub(i, i)

                if c == "\\" then
                        if text:sub(i+1, i+1) == "&" then
                                write("&")
                                i = i + 1
                        elseif text:sub(i+1, i+1) == "$" then
                                write("$")
                                i = i + 1
                        else
                                write(c)
                        end
                elseif c == "&" then
                        term.setTextColor(cCode(text:sub(i+1, i+1)))
                        i = i + 1
                elseif c == "$" then
                        term.setBackgroundColor(cCode(text:sub(i+1, i+1)))
                        i = i + 1
                else
                        write(c)
                end
        end
        return
end
--[[function term.twrite(text,tImage,defClr)
x,y=term.getCursorPos()
        text = tostring(text)
        local i = 0
        while true do
                i = i + 1
                if i > #text then break end
                local c = text:sub(i,i)
				if tImage[x] and tImage[x][y] then
				if type(tImage[x][y])=="number" then
				if tImage[x][y]>0 and tImage[x][y]<=32768 then clr=tImage[x][y]
				else clr=defClr end
				else clr=defClr end
				else clr=defClr end
				term.setBackgroundColor(clr)
                term.write(c)
				x=x+1
        end
        return
end]]
function cprint(text)
cwrite(text.."\n")
end
function icon(text,x,y)
for i=1,3 do
term.setCursorPos(x,y+(i-1))
cwrite(text[i])
end
end
function loadIcon(path)
f=fs.open(path,"r")
text={}
for i=1,3 do
sLine=f.readLine()
text[i]=sLine
end
f.close()
return text
end