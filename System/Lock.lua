Screen.Width,Screen.Height=term.getSize()
Data=Core.getData()
Draw.clear(1)
Draw.setStatusColor(256)
Draw.isStatusVisible(true)
Draw.status()
paintutils.drawImage(paintutils.loadImage("System/Images/keypad"),Screen.Width/2-6,4)
term.setTextColor(1)
local nDrag,nLast,lock,kpad=0,3,true,true
local numbers={"1","2","3","4","5","6","7","8","9","","0",""}
for i=1,4 do
for n=1,3 do
term.setCursorPos(Screen.Width/2+(n-1)*6-5,(4*i)+1)
write(numbers[(i*3)-3+n])
end
end
for i=1,5 do
paintutils.drawPixel(Screen.Width/2+(i*2)-5,2,128)
end
local nCode=""
local try=0
while kpad do
tEvent={os.pullEvent()}
if tEvent[1]=="mouse_click" then
local num=""
for i=1,3 do
for n=1,3 do
if tEvent[3]>=Screen.Width/2+(n-1)*6-6 and tEvent[3]<=Screen.Width/2+(n-1)*6-4 and tEvent[4]>=4*i and tEvent[4]<=4*i+2 then 
num=(i-1)*3+n
end
end
end
if tEvent[3]>=Screen.Width/2-1 and tEvent[3]<Screen.Width/2+1 and tEvent[4]>15 and tEvent[4]<19 then num=0 end
tostring(num)
nCodeOld=nCode
nCode=nCode..num
os.sleep(.001)
if #nCodeOld~=#nCode then
try=try+1
end
elseif tEvent[1]=="char" then
tEvent[2]=tonumber(tEvent[2])
if type(tEvent[2])=="number" then
nCodeOld=nCode
nCode=nCode..tEvent[2]
if #nCodeOld~=#nCode then
try=try+1
end
end
end
if try then
if try>5 then try=5 end
for i=1,try do
paintutils.drawPixel(Screen.Width/2+(i*2)-5,2,32)
end
end
if try==5 then
if tonumber(nCode)==Data.Code then
Draw.clear(1)
kpad=false
shell.run("System/Desktop.lua")
else
for i=1,5 do paintutils.drawPixel(Screen.Width/2+(i*2)-5,2,2^14) end
os.sleep(.33)
for i=1,5 do paintutils.drawPixel(Screen.Width/2+(i*2)-5,2,128) end
try=0
nCode=""
end
end
end