bEnd=false
f=fs.open("Apps/.desktop","r")
sData=f.readAll()
tApps=textutils.unserialize(sData)
tApp=fs.list("Apps")
tApp[#tApp]=nil
f.close()
tData=getData()
if type(m)~="number" then m=1 end
function drawApps(m)
local nIcon=1
tIcons={}
term.setBackgroundColor(1)
term.clear()
status(128,false)
term.setTextColor(2^15)
for n=1,3 do
for i=1,3 do
if tApps[m][(n-1)*3+i] then
if fs.exists("Apps/"..tApps[m][(n-1)*3+i].."/icon") then
tIcon=loadIcon("Apps/"..tApps[m][(n-1)*3+i].."/icon")
else
tIcon=loadIcon("System/Images/default")
end
icon(tIcon,math.ceil(w/3)*(i-1)+3,n*5-2)
tIcons[nIcon]={}
tIcons[nIcon][1]=math.ceil(w/3)*(i-1)+3
tIcons[nIcon][2]=math.ceil(w/3)*(i-1)+6
tIcons[nIcon][3]=n*5-2
tIcons[nIcon][4]=n*5+1
tIcons[nIcon][5]=tApps[m][(n-1)*3+i]
nIcon=nIcon+1
if tApps[m][(n-1)*3+i]=="Date" then
term.setCursorPos(math.ceil(w/3)*(i-1)+4,n*5-1)
local _y,_m,nD=date(os.day())
term.setTextColor(1)
term.setBackgroundColor(2^14)
if #tostring(nD)==1 then nD="0"..nD end
print(nD)
end
term.setTextColor(2^15)
sName=nil
sName2=nil
if #tApps[m][(n-1)*3+i]>10 then sName=tApps[m][(n-1)*3+i]:sub(1,9) sName2=tApps[m][(n-1)*3+i]:sub(9,#tApps[m][(n-1)*3+i]) else sName=tApps[m][(n-1)*3+i] end
term.setCursorPos(math.ceil(w/3)*(i-1)+(7/#sName)*2,n*5+1)
term.setBackgroundColor(1)
write(sName)
if sName2 then
term.setCursorPos(math.ceil(w/3)*(i-1)+3,n*5+2)
write(sName2)
end
end
end
end
local tPixs={}
for i=1,#tApps do paintutils.drawPixel((w-#tApps)/2+2*(i-1),h-1,256) tPixs[i]=(w-#tApps)/2+2*(i-1) end
paintutils.drawPixel(tPixs[m],h-1,128)
end
os.startTimer(60/72)
drawApps(m)
local desktop=true
while desktop do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
x,y=tEvent[3],tEvent[4]
if oldx==x and oldy==y then
for i=1,#tIcons do
if x>=tIcons[i][1] and x<=tIcons[i][2] and y>=tIcons[i][3] and y<=tIcons[i][4] then shell.run("Apps/"..tIcons[i][5].."/Startup.lua") end
end
end
oldx,oldy=x,y
elseif tEvent[1]=="mouse_drag" then
if y>h-3 and tEvent[4]<19 and tEvent[4]<y-3 then
desktop=false
shell.run("System/Controll.lua")
end
if tEvent[3]<x-5 then
if type(m)~="number" then m=1 end
m=m+1
if m>#tApps then m=#tApps end
if m~=oldm then drawApps(m) end
oldm=m
x,y=tEvent[3],tEvent[4]
end
if tEvent[3]>x+5 then
if type(m)~="number" then m=1 end
m=m-1
if m<1 then m=1 end
if m~=oldm then drawApps(m) end
oldm=m
x,y=tEvent[3],tEvent[4]
end
elseif tEvent[1]=="key" and tEvent[2]==keys.f1 then
bEnd=true
desktop=false
elseif tEvent[1]=="timer" then
status(128,false)
os.startTimer(60/72)
elseif tEvent[1]=="modem_message" then
if tEvent[3]==65533 then
if tData["notice"] then status(128,false,tEvent[5],32) end
for i=2,17 do
tChatHistory[i-1]=tChatHistory[i]
end
tChatHistory[17]=tEvent[5]
end
end
end