paintutils.drawFilledBox(1,1,w,h,256)
status(128,false)
nYear,sMonth,nDay,sDay,nDayWeek,nMonth=date(os.day())
cprint("$8\n Today is "..sDay..",\n "..sMonth.." "..nDay..", year "..nYear)
term.setCursorPos((w-4)/2,h)
write("Back")
os.startTimer(60/72)
local calendar=true
while calendar do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" and tEvent[4]==h then calendar=false shell.run("System/Desktop.lua")
elseif tEvent[1]=="timer" then status(128,false) os.startTimer(60/72) end
end