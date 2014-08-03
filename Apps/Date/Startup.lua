Draw.clear(256)
Draw.setStatusColor(128)
Draw.status()
nYear,sMonth,nDay,sDay,nDayWeek,nMonth=Time.date(os.day())
Draw.cprint("$8\n\n Today is "..sDay..",\n "..sMonth.." "..nDay..", year "..nYear)
term.setCursorPos((Screen.Width-4)/2,Screen.Height)
write("Back")
local calendar=true
while calendar do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" and tEvent[4]==Screen.Height then calendar=false shell.run("System/Desktop.lua")
end
end