local window=window.create(Multitask.parentTerm,1,1,Screen.Width,Screen.Height+1,true)
local scroll,Process,Icons,_color,tPos=0,Multitask.Processes,{},Draw.sColor,{}
term.redirect(window)
Draw.clear(512)
Draw.setStatusColor(512)
Draw.status()
for i=1,#Process do
if Process[i].path~="System" then
Icons[i]=Draw.loadIcon(Process[i].path.."/icon",true)
else
Icons[i]=Draw.loadIcon("System/Images/icon",true)
end
if Process[i].aPath=="System/Task.lua" then table.remove(Icons,i) end
end
selected=Multitask.selected
local function drawIcons()
for i=1,3 do
local sc=math.floor(scroll/10)-1
if sc<0 then sc=0 end
if Icons[i+sc] then
paintutils.drawLine(math.ceil((Screen.Width-9)/2)+(10*(i-1))-scroll-1,5,math.ceil((Screen.Width-9)/2)+(10*(i-1))-scroll-1,15,512)
paintutils.drawLine(math.ceil((Screen.Width-9)/2)+(10*(i-1))-scroll+10,5,math.ceil((Screen.Width-9)/2)+(10*(i-1))-scroll+10,15,512)
Draw.icon(Icons[i+sc],math.ceil((Screen.Width-9)/2)+(10*(i-1))-scroll,5)
paintutils.drawLine(1,5,1,15,512)
paintutils.drawLine(Screen.Width,5,Screen.Width,15,512)
tPos[i]={}
tPos[i]["sX"]=math.ceil((Screen.Width-9)/2)+(10*(i-1))-scroll
tPos[i]["eX"]=math.ceil((Screen.Width-9)/2)+(10*(i-1))-scroll+9
tPos[i]["co"]=i+sc
term.setCursorPos(math.ceil((Screen.Width-9)/2)+(10*(i-1))-scroll-1,15)
term.setTextColor(1)
term.setBackgroundColor(512)
if Process[i+sc] then
term.write(" "..Process[i+sc].title.." ")
end
end
end
end
drawIcons()
while window do
tEvent={os.pullEventRaw()}
oldscroll=scroll
if tEvent[1]=="timer" and tEvent[2]==Core.timer then Draw.status() Core.timer=os.startTimer(60/72)
elseif tEvent[1]=="key" and tEvent[2]==keys.right then scroll=scroll+1
if #Icons==1 then scroll=0 end
if scroll>(#Icons)*5 then scroll=(#Icons)*5 end
if scroll~=oldscroll then drawIcons() end
elseif tEvent[1]=="key" and tEvent[2]==keys.left then scroll=scroll-1
if scroll<0 then scroll=0 end
if scroll~=oldscroll then drawIcons() end
elseif tEvent[1]=="mouse_click" and tEvent[2]==1 then
local x,y=tEvent[3],tEvent[4]
if y>4 and y<16 then
for i=1,#tPos do
	if x>=tPos[i]["sX"] and x<=tPos[i]["eX"] then
		window=nil
		Draw.setStatusColor(_color)
		Draw.status()
		term.redirect(Multitask.Processes[tPos[i]["co"]].window)
		Multitask.Processes[tPos[i]["co"]].window.redraw()
		tEvent={}
		coroutine.resume(Multitask.Processes[tPos[i]["co"]].co)
		end
	end
end
elseif tEvent[1]=="key" and tEvent[2]==keys.f1 then window=nil Draw.setStatusColor(_color) Draw.status() term.redirect(Multitask.Processes[1].window) Multitask.Processes[1].window.redraw() end
end