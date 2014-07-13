paintutils.drawFilledBox(1,1,w,h,256)
status(128,false)
nYear,sMonth,nDay,sDay,nDayWeek,nMonth=date(os.day())
cprint("$8\n Today is "..sDay..",\n "..sMonth.." "..nDay..", year "..nYear)
term.setCursorPos((w-4)/2,h)
write("Back")
nStatusTimer=os.startTimer(60/72)
local calendar=true
while calendar do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" and tEvent[4]==h then calendar=false shell.run("System/Desktop.lua")
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