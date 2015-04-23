local calendar=true
Draw.clear(256)
Draw.setStatusColor(128)
Draw.status()
term.setTextColor(1)
if not Time then os.loadAPI("System/API/Time") end
nYear,sMonth,nDay,sDay,nDayWeek,nMonth=Time.date(os.day())
term.setCursorPos(1,2)
Draw.cprint("&0$8 Today is "..sDay..",\n "..sMonth..nDay..", year "..nYear)
term.setCursorPos((Screen.Width-4)/2,Screen.Height-1)
write("Back")
while calendar do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" and tEvent[4]==Screen.Height then calendar=false term.setTextColor(1) term.setBackgroundColor(32768) term.setCursorPos(1,1) end
end