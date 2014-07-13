tData=getData()
x,y,z=nil,nil,nil
if tData["modemOn"] and peripheral.isPresent("back") then x,y,z=gps.locate() end
if x and y and z then
x=math.floor(x)
y=math.floor(y)
z=math.floor(z)
paintutils.drawLine(w/2-3,h/2-3,w/2+5,h/2-3,32768)
paintutils.drawLine(w/2+5,h/2-2,w/2+5,h/2+1,32768)
paintutils.drawFilledBox((w-8)/2,h/2-2,(w+8)/2,h/2+2,256)
term.setTextColor(1)
term.setCursorPos((w-10)/2+2,h/2-1)
print("X="..x," ")
term.setCursorPos((w-10)/2+2,h/2)
print("Y="..y," ")
term.setCursorPos((w-10)/2+2,h/2+1)
print("Z="..z," ")
else
paintutils.drawFilledBox((w-18)/2,h-12,(w+18)/2,h-9,32)
term.setCursorPos((w-18)/2+1,h-10)
print("Can't get position")
end
os.startTimer(60/72)
local app=true
while app do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
app=false
shell.run("System/Desktop.lua")
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