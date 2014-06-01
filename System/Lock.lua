local nDrag,nLast,lock,kpad=0,3,true,false
local function screen(nW)
if nW==nil or nW<0 then nW=0 end
if nW>24 then nW=24 end
term.setBackgroundColor(256)
term.clear()
if nW>12 then
status(128,false)
else
status(128,true)
end
term.setBackgroundColor(256)
term.setTextColor(1)
term.setCursorPos(math.ceil((w-#tData["time"])/2)+nW,3)
term.write(tData["time"])
term.setCursorPos(math.ceil((w-#tData["date"])/2)+nW,4)
term.write(tData["date"])
term.setCursorPos((w-17)/2+nW,h-3)
term.write("> Slide to unlock")
paintutils.drawImage(paintutils.loadImage("System/Images/keypad"),-w+nW+8,5)
term.setTextColor(2^15)
local numbers={"1","2","3","4","5","6","7","8","9","","0",""}
for i=1,4 do
for n=1,3 do
term.setCursorPos((6*n)-1-w+nW+4,(4*i)+2)
term.write(numbers[(i*3)-3+n])
end
end
for i=1,5 do
paintutils.drawPixel((i*2)-w+nW+9,3,128)
end
end
local tClr={2^15,128,256}
for i=1,3 do term.setBackgroundColor(tClr[i]) term.clear() os.sleep(.1) end
paintutils.drawImage(paintutils.loadImage("System/Images/boot"),math.ceil((w-9)/2),math.ceil((h-9)/2))
term.setBackgroundColor(256)
term.setTextColor(1)
term.setCursorPos((w-16)/2,h/2+5)
print("rOS by NEOparmen")
term.setCursorPos((w-8)/2,h/2+6)
print("(c) 2014")
os.sleep(1.5)
screen(0)
os.startTimer(60/72)
while lock do
local tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_drag" then
if nLast<tEvent[3] then
nDrag=nDrag+1
else
nDrag=nDrag-1
end
if nDrag==12 then
for i=1,12 do
screen(12+i)
os.sleep(0.02)
end
lock=false
kpad=true
break
else
nLast=tEvent[3]
screen(nDrag)
end
elseif tEvent[1]=="timer" then
if nDrag>12 then
status(128,false)
else
term.setBackgroundColor(256)
term.setTextColor(1)
term.setCursorPos(math.ceil((w-#tData["time"])/2)+nDrag,3)
term.write(tData["time"])
status(128,true)
end
os.startTimer(60/72)
end
end
os.startTimer(60/72)
local nTime=os.startTimer((60/72)*60)
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
if #nCodeOld~=#nCode then
try=try+1
end
elseif tEvent[1]=="timer" then
if tEvent[2]==nTime then
os.shutdown()
else
status(128,false)
os.startTimer(60/72)
end
end
if try then
if try>5 then try=5 end
for i=1,try do
paintutils.drawPixel((i*2)+7,3,1)
end
end
if try==5 then
if tonumber(nCode)==tData["code"] then
kpad=false
local clrs={2^15,128,256}
for i=1,3 do
term.setBackgroundColor(clrs[i])
term.clear()
os.sleep(.055)
end
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