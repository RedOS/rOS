local nDrag,nLast,lock,kpad=0,3,true,true
local clrs={2^15,128,256}
for i=1,3 do
term.setBackgroundColor(clrs[i])
term.clear()
os.sleep(.055)
end
term.setBackgroundColor(256)
term.clear()
status(128,false)
paintutils.drawImage(paintutils.loadImage("System/Images/keypad"),6,5)
term.setTextColor(2^15)
local numbers={"1","2","3","4","5","6","7","8","9","","0",""}
for i=1,4 do
for n=1,3 do
term.setCursorPos((6*n)-1+2,(4*i)+2)
term.write(numbers[(i*3)-3+n])
end
end
for i=1,5 do
paintutils.drawPixel((i*2)+7,3,128)
end
os.startTimer(60/72)
local function number()
n=""
if tEvent[3]>5 and tEvent[3]<9 and tEvent[4]>4 and tEvent[4]<8 then n=1 end
if tEvent[3]>11 and tEvent[3]<15 and tEvent[4]>4 and tEvent[4]<8 then n=2 end
if tEvent[3]>17 and tEvent[3]<21 and tEvent[4]>4 and tEvent[4]<8 then n=3 end
if tEvent[3]>5 and tEvent[3]<9 and tEvent[4]>8 and tEvent[4]<12 then n=4 end
if tEvent[3]>11 and tEvent[3]<15 and tEvent[4]>8 and tEvent[4]<12 then n=5 end
if tEvent[3]>17 and tEvent[3]<21 and tEvent[4]>8 and tEvent[4]<12 then n=6 end
if tEvent[3]>5 and tEvent[3]<9 and tEvent[4]>12 and tEvent[4]<16 then n=7 end
if tEvent[3]>11 and tEvent[3]<15 and tEvent[4]>12 and tEvent[4]<16 then n=8 end
if tEvent[3]>17 and tEvent[3]<21 and tEvent[4]>12 and tEvent[4]<16 then n=9 end
if tEvent[3]>11 and tEvent[3]<15 and tEvent[4]>16 and tEvent[4]<20 then n=0 end
return tostring(n)
end
local nCode=""
local try=0
while kpad do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
nCodeOld=nCode
nCode=nCode..number()
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
elseif tEvent[1]=="timer" then
status(128,false)
os.startTimer(60/72)
end
if try then
if try>5 then try=5 end
for i=1,try do
paintutils.drawPixel((i*2)+7,3,1)
end
end
if try==5 then
if tonumber(nCode)==tData["code"] then
for i=1,3 do
term.setBackgroundColor(clrs[i])
term.clear()
os.sleep(.055)
end
kpad=false
shell.run("System/Desktop.lua")
else
for i=1,5 do paintutils.drawPixel((i*2)+7,3,2^14) end
os.sleep(.33)
for i=1,5 do paintutils.drawPixel((i*2)+7,3,128) end
try=0
nCode=""
end
end
end