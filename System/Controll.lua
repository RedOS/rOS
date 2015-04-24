term.redirect(Multitask.parentTerm)
Multitask.Processes[1].window.redraw()
Data=Core.getData()
Draw.statusTime="right"
local _color=Draw.sColor
paintutils.drawLine(1,1,Screen.Width,1,1)
Draw.setStatusColor(1)
Draw.status()
term.setCursorPos(1,1)
Draw.cwrite("&9M &5L &1R &eS&f")
term.setCursorPos((Screen.Width-4)/2,1)
Draw.cwrite((Data.bModem and "&fM " or "&8M ")..(Data.Notification and "&fN " or "&8N ")..(Data.H24 and "&fH " or "&8H "))
local c=true
while c do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
local x,y=tEvent[3],tEvent[4]
if tEvent[4]==1 then
if tEvent[3]==(Screen.Width-4)/2 then if Data.bModem then Data.bModem=false else Data.bModem=true end
elseif x==(Screen.Width-4)/2+2 then if Data.Notification then Data.Notification=false else Data.Notification=true end
elseif x==(Screen.Width-4)/2+4 then if Data.H24 then Data.H24=false else Data.H24=true end
elseif x==3 then c=nil Draw.setStatusColor(_color); Draw.statusTime="center"; shell.run({},"System/Lock.lua")
elseif x==5 then c=nil os.reboot()
elseif x==7 then c=nil os.shutdown() end
term.setCursorPos((Screen.Width-4)/2,1)
Draw.cwrite((Data.bModem and "&fM " or "&8M ")..(Data.Notification and "&fN " or "&8N ")..(Data.H24 and "&fH " or "&8H "))
f=fs.open("System/Config.lua","w")
f.write(textutils.serialize(Data))
f.close()
else
c=nil
Draw.setStatusColor(_color)
Draw.statusTime="center"
Draw.status()
term.redirect(Multitask.Processes[1].window)
end
end
end