Core.last="System/Desktop.lua"
f=fs.open("Apps/.desktop","r")
tApps=textutils.unserialize(f.readAll())
f.close()
tApp=fs.list("Apps")
for i=1,#tApps do
if tApp[i]==".desktop" then table.remove(tApp,i) end
end
for i=1,3 do
for k=1,#tApp do
for n=1,#tApps do
for i=1,#tApps[n] do
if tApp[k]==tApps[n][i] then table.remove(tApp,k) end
end
end
end
end
if tApp then
for i=1,math.ceil(#tApp/9) do
tApps[i+2]={}
for n=1,9 do
tApps[i+2][n]=tApp[(i-1)*9+n]
end
end
end
Data=Core.getData()
if type(m)~="number" then m=1 end
local function drawApps(m)
local nIcon=1
tIcons={}
Draw.clear(1)
Draw.setStatusColor(128)
Draw.isStatusVisible(true)
Draw.status()
term.setTextColor(2^15)
for n=1,3 do
for i=1,3 do
if tApps[m][(n-1)*3+i] then
tIcon=Draw.loadIcon("System/Images/default")
if fs.exists("Apps/"..tApps[m][(n-1)*3+i].."/icon") then
tIcon=Draw.loadIcon("Apps/"..tApps[m][(n-1)*3+i].."/icon")
if tIcon==nil then tIcon=Draw.loadIcon("System/Images/default") end
end
Draw.icon(tIcon,math.ceil(Screen.Width/3)*(i-1)+3,n*5-3)
tIcons[nIcon]={}
tIcons[nIcon][1]=math.ceil(Screen.Width/3)*(i-1)+3
tIcons[nIcon][2]=math.ceil(Screen.Width/3)*(i-1)+6
tIcons[nIcon][3]=n*5-2
tIcons[nIcon][4]=n*5+1
tIcons[nIcon][5]=tApps[m][(n-1)*3+i]
nIcon=nIcon+1
if tApps[m][(n-1)*3+i]=="Date" then
term.setCursorPos(math.ceil(Screen.Width/3)*(i-1)+4,n*5-2)
if Time.date then
_y,_m,nD=Time.date(os.day())
else
nD="--"
end
term.setTextColor(1)
term.setBackgroundColor(2^14)
if #tostring(nD)==1 then nD="0"..nD end
print(nD)
end
term.setTextColor(2^15)
sName=nil
sName2=nil
if #tApps[m][(n-1)*3+i]>10 then sName=tApps[m][(n-1)*3+i]:sub(1,9) sName2=tApps[m][(n-1)*3+i]:sub(9,#tApps[m][(n-1)*3+i]) else sName=tApps[m][(n-1)*3+i] end
term.setCursorPos(math.ceil(Screen.Width/3)*(i-1)+(7/#sName)*2,n*5)
term.setBackgroundColor(1)
write(sName)
if sName2 then
term.setCursorPos(math.ceil(Screen.Width/3)*(i-1)+3,n*5+1)
write(sName2)
end
end
end
end
local tPixs={}
for i=1,#tApps do paintutils.drawPixel((Screen.Width-#tApps)/2+2*(i-1),Screen.Height-1,256) tPixs[i]=(Screen.Width-#tApps)/2+2*(i-1) end
paintutils.drawPixel(tPixs[m],Screen.Height-1,128)
end
drawApps(m)
local desktop=true
while desktop do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
x,y=tEvent[3],tEvent[4]
if oldx==x and oldy==y then
for i=1,#tIcons do
if x>=tIcons[i][1] and x<=tIcons[i][2] and y>=tIcons[i][3] and y<=tIcons[i][4] then shell.run("Apps/"..tIcons[i][5].."/Startup.lua") drawApps(m) end
end
end
oldx,oldy=x,y
elseif tEvent[1]=="mouse_drag" then
if tEvent[3]<x-7 then
if type(m)~="number" then m=1 end
m=m+1
if m>#tApps then m=#tApps end
if m~=oldm then drawApps(m) end
oldm=m
x,y=tEvent[3],tEvent[4]
end
if tEvent[3]>x+7 then
if type(m)~="number" then m=1 end
m=m-1
if m<1 then m=1 end
if m~=oldm then drawApps(m) end
oldm=m
x,y=tEvent[3],tEvent[4]
end
end
end