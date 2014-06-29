for i=1,4 do
paintutils.drawLine(1,h-i+1,w,h-i+1,256)
os.sleep(0.025)
end
local function invert(value)
if value==true then return false else return true end
end
local function draw()
term.setBackgroundColor(256)
if tData["modemOn"] and peripheral.isPresent("back") then sTempModem="&0M " else sTempModem="&7M " end
if tData["btooth"] then sTempBtooth="&0B " else sTempBtooth="&7B " end
if tData["notice"] then sTempNotice="&0N " else sTempNotice="&7N &0" end
term.setTextColor(1)
term.setCursorPos(w/2-2,h-2)
cprint(sTempModem..sTempBtooth..sTempNotice)
term.setCursorPos(2,h-1)
print("Lock")
term.setCursorPos(9,h-1)
print("Shutdown")
term.setCursorPos(20,h-1)
print("Reboot")
end
draw()
local controll=true
while controll do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
x,y=tEvent[3],tEvent[4]
if y==h-2 then
if x==w/2-2 then tData["modemOn"]=invert(tData["modemOn"]) draw() end
--if x==w/2 then tData["btooth"]=invert(tData["btooth"]) draw() end
if x==w/2+2 then tData["notice"]=invert(tData["notice"]) draw() end
f=fs.open(tData["path"].."System/Config.lua","w")
f.write(textutils.serialize(tData))
f.close()
end
if x>2 and x<8 and y==h-1 then shell.run(tData["path"].."System/Lock.lua") end
if x>8 and x<17 and y==h-1 then os.shutdown() end
if x>20 and x<27 and y==h-1 then os.reboot() end
elseif tEvent[1]=="mouse_drag" then
if y>h-5 and tEvent[4]>y+2 then
controll=false
for i=1,5 do
drawApps(m)
paintutils.drawLine(1,h-1+i,w,h-4+i,256)
paintutils.drawLine(1,h-3+i,w,h-3+i,256)
paintutils.drawLine(1,h-2+i,w,h-2+i,256)
paintutils.drawLine(1,h-1+i,w,h-1+i,256)
os.sleep(0.025)
end
shell.run(tData["path"].."System/Desktop.lua")
end
elseif tEvent[1]=="timer" then
status(128,false)
os.startTimer(60/72)
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