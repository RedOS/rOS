w,h=term.getSize()
if type(m)~="number" then m=1 end
if type(oldm)~="number" then oldm=1 end
oldx,oldy=1,1
function status(nColor, bLock)
if nColor==1 then term.setTextColor(2^15) else term.setTextColor(1) end
paintutils.drawLine(1,1,w,1,nColor)
tData=getData()
term.setCursorPos(1,1)
print(tData["net"])
if not bLock then
term.setCursorPos(math.ceil((w-#tData["time"]+1)/2),1)
print(tData["time"])
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
f=fs.open("System/config","r")
data=f.readAll()
f.close()
f=fs.open("System/Version.lua","r")
cver=f.readAll()
f.close()
tData=textutils.unserialize(data)
if peripheral.isPresent("back") and tData["modemOn"] then
tData["net"]="Online" elseif peripheral.isPresent("back") and not tData["modemOn"] then
tData["net"]="Offline" else
tData["net"]="No modem" end
tData["time"]=textutils.formatTime(os.time(),false)
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