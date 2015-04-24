w,h=term.getSize()
tGames=fs.list("Apps/Games/Content")
for i=1,#tGames do
if tGames[i] then
end
end
function drawGames()
local nIcon=1
tIcons={}
Draw.clear(1)
term.setTextColor(2^15)
term.setCursorPos(w/2-2,h)
term.write("Back")
Draw.setStatusColor(128)
Draw.isStatusVisible(true)
Draw.status()
for n=1,2 do
for i=1,2 do
if tGames[(n-1)*2+i] then
if fs.exists("Apps/Games/Content/"..tGames[(n-1)*2+i].."/icon") then
tIcon=Draw.loadIcon("Apps/Games/Content/"..tGames[(n-1)*2+i].."/icon")
else
tIcon=Draw.loadIcon("System/Images/default")
end
Draw.icon(tIcon,math.ceil(w/2)*(i-1)+3+(i-1)*4,n*8-4)
tIcons[nIcon]={}
tIcons[nIcon][1]=math.ceil(w/2)*(i-1)+4
tIcons[nIcon][2]=math.ceil(w/2)*(i-1)+11
tIcons[nIcon][3]=n*8-4
tIcons[nIcon][4]=n*8-1
tIcons[nIcon][5]=tGames[(n-1)*2+i]
nIcon=nIcon+1
term.setTextColor(2^15)
sName=nil
if #tGames[(n-1)*2+i]>12 then sName=tGames[(n-1)*2+i]:sub(1,9).."..." else sName=tGames[(n-1)*2+i] end
term.setCursorPos(math.ceil(w/2)*(i-1)+(12/#sName)*i+i-1,n*8-1)
term.setBackgroundColor(1)
term.write(sName)
term.setBackgroundColor(32768)
term.setTextColor(1)
end
end
end
end
nStatusTimer=os.startTimer(60/72)
drawGames()
local games=true
while games do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
x,y=tEvent[3],tEvent[4]
if oldx==x and oldy==y then
for i=1,#tIcons do
if x>=w/2-2 and x<=w/2+2 and y==h then games=false shell.run("System/Desktop.lua") end
if x>=tIcons[i][1] and x<=tIcons[i][2] and y>=tIcons[i][3] and y<=tIcons[i][4] then shell.run("Apps/Games/Content/"..tIcons[i][5].."/Startup.lua") end
drawGames()
end
end
oldx,oldy=x,y
end
end