tData=getData()
if tData["modemOn"] and peripheral.isPresent("back") then x,y,z=gps.locate() end
if x and y and z then
x=math.floor(x)
y=math.floor(y)
z=math.floor(z)
paintutils.drawFilledBox((w-12)/2,h-12,(w+12)/2,h-6,128)
term.setBackgroundColor(256)
term.setTextColor(1)
term.setCursorPos((w-12)/2+2,h-11)
print("X="..x," ")
term.setCursorPos((w-12)/2+2,h-9)
print("Y="..y," ")
term.setCursorPos((w-12)/2+2,h-7)
print("Z="..z," ")
else
paintutils.drawFilledBox((w-18)/2,h-12,(w+18)/2,h-9,128)
term.setCursorPos((w-18)/2+1,h-10)
print("Can't get position")
end
os.startTimer(60/72)
local app=true
while app do
tEvent={os.pullEventRaw()}
if tE[1]=="mouse_click" then
drawApps(m)
app=false
shell.run("System/Desktop.lua")
elseif tE[1]=="timer" then
status(128,false)
os.startTimer(60/72)
end
end