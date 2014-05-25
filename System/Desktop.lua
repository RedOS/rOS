f=fs.open("Apps/.desktop","r")
sData=f.readAll()
tApps=textutils.unserialize(sData)
tApp=fs.list("Apps")
tApp[#tApp]=nil
f.close()
tData=getData()
if type(m)~="number" then m=1 end
function drawApps(m)
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
if tApps[m][(n-1)*3+i]=="Date" then
term.setCursorPos(math.ceil(w/3)*(i-1)+4,n*5-1)
local _y,_m,nD=date(os.day())
term.setTextColor(1)
term.setBackgroundColor(2^14)
if #tostring(nD)==1 then nD="O"..nD end
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
if x>2 and x<7 and y>2 and y<6 then nP=1 end
if x>11 and x<16 and y>2 and y<6 then nP=2 end
if x>20 and x<25 and y>2 and y<6 then nP=3 end
if x>2 and x<7 and y>7 and y<11 then nP=4 end
if x>11 and x<16 and y>7 and y<11 then nP=5 end
if x>20 and x<25 and y>7 and y<11 then nP=6 end
if x>2 and x<7 and y>12 and y<16 then nP=7 end
if x>11 and x<16 and y>12 and y<16 then nP=8 end
if x>20 and x<25 and y>12 and y<16 then nP=9 end
if tApps[m][nP] then shell.run("Apps/"..tApps[m][nP].."/startup") end
end
oldx,oldy=x,y
elseif tEvent[1]=="mouse_drag" then
if y>h-3 and tEvent[4]<19 and tEvent[4]<y-3 then
desktop=false
shell.run("System/Controll.lua")
end
if tEvent[3]<x-5 and tEvent[1]=="mouse_drag" then
if type(m)~="number" then m=1 end
m=m+1
if m>#tApps then m=#tApps end
if m~=oldm then drawApps(m) end
oldm=m
x,y=tEvent[3],tEvent[4]
elseif tEvent[3]>x+5 and tEvent[1]=="mouse_drag" then
if type(m)~="number" then m=1 end
m=m-1
if m<1 then m=1 end
if m~=oldm then drawApps(m) end
oldm=m
x,y=tEvent[3],tEvent[4]
end
elseif tEvent[1]=="terminate" then
desktop=false
elseif tEvent[1]=="timer" then
status(128,false)
os.startTimer(60/72)
end
end