 w,h=term.getSize()
 tArgs={...}
 tHistory={}
 nHistory=0
 tFiles={}
 sPath=tArgs[1] or "Apps/"
 nScroll=0
 sFile=nil
 x=0
 y=0
 tMenu={" Rename "," Delete "," Open "," Edit "}
function drawBrowser(sPath,bMode,selected)
if fs.exists(sPath) and fs.isDir(sPath) then 
tFiles=fs.list(sPath)
if #tFiles==0 then tFiles[1]="$0&8Folder is empty&f" end
else
tFiles={"$0&8Folder not found&f"}
end
if not bMode then
for i=1,#tFiles do
if tFiles[i] then
if tFiles[i]:sub(1,1)=="." then table.remove(tFiles,i) end
end
end
end
if tHistory[#tHistory-1]~=sPath or tHistory[#tHistory]~=sPath then tHistory[#tHistory+1]=sPath nHistory=nHistory+1 nScroll=0 end
local function cleanHistory(tHistory)
if tHistory[#tHistory]==tHistory[#tHistory-1] then table.remove(tHistory,#tHistory) nHistory=nHistory-1 cleanHistory(tHistory) end
end
cleanHistory(tHistory)
if nHistory<1 then nHistory=1 end
if nHistory>#tHistory then nHistory=#tHistory end
term.setBackgroundColor(1)
term.clear()
paintutils.drawFilledBox(1,1,w,3,256)
status(256,false)
nStatusTimer=os.startTimer(60/72)
term.setCursorPos(2,2)
if #sPath>w-10 then sLocalPath=sPath:sub(1,w-13).."..." else sLocalPath=sPath end
cwrite("$0&8 < > $8   $0 "..sLocalPath.." $8&f")
term.setCursorPos(2,5)
if nHistory>1 and nHistory==#tHistory then
term.setCursorPos(3,2)
cwrite("$0&b< &8>&f")
elseif nHistory>1 and nHistory~=#tHistory then
term.setCursorPos(3,2)
cwrite("$0&b< >&f")
elseif nHistory==1 and #tHistory>1 then
term.setCursorPos(3,2)
cwrite("$0&8< &b>&f")
end
nSize=h-5
term.setCursorPos(1,5)
if nSize>#tFiles then nSize=#tFiles end
for i=1,nSize do
term.setCursorPos(1,4+i)
if tFiles[i+nScroll] then
if tFiles[i+nScroll]==selected then
cwrite("$0&b")
cwrite(" "..tFiles[i+nScroll])
else
cwrite("$0&f "..tFiles[i+nScroll])
end
end
end
term.setCursorPos(w/2-2,h)
cwrite("$0&8Exit")
end
files=true
drawBrowser(sPath)
while files do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
oldx,oldy=x,y
x,y=tEvent[3],tEvent[4]
if tEvent[2]==1 then
if x==3 and y==2 then
if nHistory~=1 then
sPath=tHistory[nHistory-1]
nHistory=nHistory-1
drawBrowser(sPath)
end
elseif x>10 and x<=#sLocalPath+10 and y==2 then
paintutils.drawLine(10,2,#sLocalPath+11,2,1)
term.setCursorPos(11,2)
cwrite("$0&8")
sPath=read(nil,tHistory)
if sPath:sub(-1,-1)~="/" then sPath=sPath.."/" end
drawBrowser(sPath)
elseif x==5 and y==2 then
if #tHistory>nHistory then
sPath=tHistory[nHistory+1] nHistory=nHistory+1
drawBrowser(sPath)
end
elseif y>=4 and (oldx~=x or oldy~=y) and y<h then
if tFiles[nScroll+y-4] then
drawBrowser(sPath,nil,tFiles[nScroll+y-4])
selected=tFiles[nScroll+y-4]
else
selected=nil
drawBrowser(sPath)
end
elseif y>4 and oldx==x and oldy==y and y<h then
if tFiles[nScroll+y-4] then
if fs.exists(sPath..tFiles[nScroll+y-4]) then
if not fs.isDir(sPath..tFiles[nScroll+y-4]) then
shell.run(sPath..tFiles[nScroll+y-4])
else
sPath=sPath..tFiles[nScroll+y-4].."/"
 x=0
 y=0
drawBrowser(sPath)
end
end
end
elseif y==h and oldy==y then files=false shell.run("System/Desktop.lua") end
end
elseif tEvent[1]=="mouse_scroll" then
oldScroll=nScroll
nScroll=nScroll+tEvent[2]*3
if nScroll>#tFiles-(h-5) then nScroll=#tFiles-(h-5) end
if nScroll<0 then nScroll=0 end
if nScroll~=oldScroll then
drawBrowser(sPath)
end
elseif tEvent[1]=="key" then
--if tEvent[2]==keys.enter and selected then if not fs.isDir(selected) then files=false shell.run(selected) else sPath=sPath..selected drawBrowser(sPath) end end
if tEvent[2]==keys.f4 then files=false shell.run("System/Desktop.lua") end
elseif tEvent[1]=="timer" and tEvent[2]==nStatusTimer then
status(128,false)
nStatusTimer=os.startTimer(60/72)
elseif tEvent[1]=="modem_message" then
if tEvent[3]==CHAT_CHANNEL then
if tData["notice"] then status(128,false,tEvent[5],32) end
for i=2,17 do
tChatHistory[i-1]=tChatHistory[i]
end
tChatHistory[17]=tEvent[5]
end
elseif tEvent[1]=="alarm" then
if tData["notice"] then status(128,false,"Alarm at "..tData["time"],16384) end
os.setAlarm(os.time())
end
end