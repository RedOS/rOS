for i=1,3 do
paintutils.drawLine(1,h-i+1,w,h-i+1,128)
os.sleep(0.025)
end
term.setTextColor(1)
term.setCursorPos(2,h-1)
print("Lock")
term.setCursorPos(9,h-1)
print("Shutdown")
term.setCursorPos(20,h-1)
print("Reboot")
local controll=true
while controll do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
x,y=tEvent[3],tEvent[4]
if x>2 and x<8 and y==h-1 then shell.run("System/Lock.lua") end
if x>8 and x<17 and y==h-1 then os.shutdown() end
if x>20 and x<27 and y==h-1 then os.reboot() end
elseif tEvent[1]=="mouse_drag" then
if y>h-5 and tEvent[4]>h-2 then
controll=false
for i=1,4 do
drawApps(m)
paintutils.drawLine(1,h-3+i,w,h-3+i,128)
paintutils.drawLine(1,h-2+i,w,h-2+i,128)
paintutils.drawLine(1,h-1+i,w,h-1+i,128)
os.sleep(0.025)
end
shell.run("System/Desktop.lua")
end
elseif tEvent[1]=="timer" then
status(128,false)
os.startTimer(60/72)
end
end