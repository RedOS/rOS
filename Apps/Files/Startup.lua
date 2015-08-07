 tArgs={...}
 tHistory={}
 nHistory=0
 tFiles={}
 sPath=tArgs[1] or "Apps/"
 nScroll=0
 oldScroll=0
 sFile=nil
 x=0
 y=0
 tMenu={" Rename "," Delete "," Open "," Edit "}
function drawBrowser(sPath,bMode,selected)
if fs.exists(sPath) and fs.isDir(sPath) then 
tFiles=fs.list(sPath)
if #tFiles==0 then tFiles[1]="Folder is empty" end
else
tFiles={"Folder not found"}
end
if not bMode then
for i=1,#tFiles do
if tFiles[i] then
if tFiles[i]:sub(1,1)=="." then table.remove(tFiles,i) end
end
end
end
if tHistory[#tHistory-1]~=sPath or tHistory[#tHistory]~=sPath then tHistory[#tHistory+1]=sPath nHistory=nHistory+1 end
local function cleanHistory(tHistory)
if tHistory[#tHistory]==tHistory[#tHistory-1] then table.remove(tHistory,#tHistory) nHistory=nHistory-1 cleanHistory(tHistory) end
end
cleanHistory(tHistory)
if nHistory<1 then nHistory=1 end
if nHistory>#tHistory then nHistory=#tHistory end
term.clear(1)
paintutils.drawFilledBox(1,1,Screen.Width,2,256)
Draw.isVisible(true)
Draw.setStatusColor(256)
term.setCursorPos(2,1)
if #sPath>Screen.Width-10 then sLocalPath=sPath:sub(1,Screen.Width-13).."..." else sLocalPath=sPath end
term.blit(" < >     "..sLocalPath.."  ","888888888"..string.rep("8",#sLocalPath).."ff","000008880"..string.rep("0",#sLocalPath).."08")
term.setCursorPos(3,1)
if nHistory>1 and nHistory==#tHistory then
term.blit("< > ","b08f","0008")
elseif nHistory>1 and nHistory~=#tHistory then
term.blit("< > ","b0bf","0008")
elseif nHistory==1 and #tHistory>1 then
term.blit("< > ","80bf","0008")
end
nSize=Screen.Height-5
term.setCursorPos(1,4)
if nSize>#tFiles then nSize=#tFiles end
for i=1,nSize do
if tFiles[i+nScroll] then
if fs.isDir(sPath..tFiles[i+nScroll]) then term.setCursorPos(1,3+i) term.write("_",1,16) else term.setCursorPos(1,3+i) term.write("_",1,256) end
term.setCursorPos(2,i+3)
if tFiles[i+nScroll]==selected then
term.write(" "..tFiles[i+nScroll],2048,1)
else
term.write(" "..tFiles[i+nScroll],32768,1)
end
end
end
term.setCursorPos(Screen.Width/2-2,Screen.Height)
term.write("Exit",256,1)
end
files=true
drawBrowser(sPath)
while files do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
oldx,oldy=x,y
x,y=tEvent[3],tEvent[4]
if tEvent[2]==1 then
if x==3 and y==1 then
if nHistory~=1 then
sPath=tHistory[nHistory-1]
nHistory=nHistory-1
nScroll=0
drawBrowser(sPath)
end
elseif x>10 and x<=#sLocalPath+10 and y==1 then
paintutils.drawLine(10,1,#sLocalPath+11,1,1)
term.setCursorPos(11,1)
term.write("",256,1)
sPath=read(nil,tHistory)
if sPath:sub(-1,-1)~="/" then sPath=sPath.."/" end
drawBrowser(sPath)
elseif x==5 and y==1 then
if #tHistory>nHistory then
sPath=tHistory[nHistory+1] nHistory=nHistory+1
nScroll=0
drawBrowser(sPath)
end
elseif y>=3 and (oldx~=x or oldy~=y) and y<Screen.Height then
if tFiles[nScroll+y-3] then
drawBrowser(sPath,nil,tFiles[nScroll+y-3])
selected=tFiles[nScroll+y-3]
else
selected=nil
drawBrowser(sPath)
end
elseif y>=3 and oldx==x and oldy==y and y<Screen.Height then
if tFiles[nScroll+y-3] then
if fs.exists(sPath..tFiles[nScroll+y-3]) then
if not fs.isDir(sPath..tFiles[nScroll+y-3]) then
shell.run(sPath..tFiles[nScroll+y-3])
else
sPath=sPath..tFiles[nScroll+y-3].."/"
 x=0
 y=0
drawBrowser(sPath)
end
end
end
elseif y==Screen.Height and oldy==y then files=false end
end
elseif tEvent[1]=="mouse_scroll" then
oldScroll=nScroll
if tEvent[2]==1 then nScroll=nScroll+3 end
if tEvent[2]==-1 then nScroll=nScroll-3 end
if nScroll>#tFiles-Screen.Height+6 then nScroll=#tFiles-Screen.Height+6 end
if nScroll<0 then nScroll=0 end
if nScroll~=oldScroll then
drawBrowser(sPath)
end
elseif tEvent[1]=="key" then
--if tEvent[2]==keys.enter and selected then if not fs.isDir(selected) then files=false shell.run(selected) else sPath=sPath..selected drawBrowser(sPath) end end
end
end