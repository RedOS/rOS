Calendar = {}
Calendar.Days = {"Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"}
Calendar.NDay = {Monday=1,Tuesday=2,Wednesday=3,Thursday=4,Friday=5,Saturday=6,Sunday=7}
Calendar.Monthname = {"January","February","March","April","May","June","July","August","September","October","November","December"}
Calendar.Month = {31,28,31,30,31,30,31,31,30,31,30,31}
Calendar.Running = true
Calendar.CurMonth = tonumber(Time.Date("f:m"))
Calendar.CurDay = tonumber(Time.Date("f:d"))
Calendar.CurYear = tonumber(Time.Date("f:y"))
Calendar.StartMonth = Calendar.CurMonth
Calendar.StartYear = Calendar.CurYear
local function drawMonth()
Calendar.CurDayNum = Calendar.NDay[Time.GetDayName(Time.GetTimestamp("01."..Calendar.CurMonth.."."..Calendar.CurYear))]
Calendar.LastDayNum = Calendar.NDay[Time.GetDayName(Time.GetTimestamp(Calendar.Month[Calendar.CurMonth].."."..Calendar.CurMonth.."."..Calendar.CurYear))]
term.clear(1)
paintutils.drawFilledBox(1,1,Screen.Width,3,8192)
term.setCursorPos(Screen.Width/2-math.ceil((#(" "..Calendar.Monthname[Calendar.CurMonth].." "..Calendar.CurYear.." ")-1)/2),2)
term.write(" "..Calendar.Monthname[Calendar.CurMonth].." "..Calendar.CurYear.." ",1,8192)
local t=1
for i=1,Calendar.Month[Calendar.CurMonth] do
	if Time.GetDayName(Time.GetTimestamp(i.."."..Calendar.CurMonth.."."..Calendar.CurYear))=="Monday" and i~=1 then
		t = (t and t or 1) + 1
	end
end
for i=1,7 do term.setCursorPos(3*i,3) term.write(" "..Calendar.Days[i]:sub(1,2).." ",1,8192) end
for i=1,t do
	for k=1,7 do
		term.setCursorPos(3*k+1,2*i+3)
		a=(Calendar.CurMonth==Calendar.StartMonth and Calendar.CurYear==Calendar.StartYear)
		if (i==1 and Calendar.CurDayNum>k) then
			local x = Calendar.Month[Calendar.CurMonth==1 and 12 or Calendar.CurMonth-1]-Calendar.CurDayNum+k+1
			term.write(a and x==Calendar.CurDay and #tostring(x)==1 and " "..x or x,a and x==Calendar.CurDay and 1 or 256,a and x==Calendar.CurDay and 256 or 1)
		elseif 7*(i-1)+k-Calendar.CurDayNum+1>Calendar.Month[Calendar.CurMonth] then
			local x = -Calendar.NDay[Time.GetDayName(Time.GetTimestamp(Calendar.Month[Calendar.CurMonth].."."..Calendar.CurMonth.."."..Calendar.CurYear))]+k
			term.write(a and x==Calendar.CurDay and #tostring(x)==1 and " "..x or x,a and x==Calendar.CurDay and 1 or 256,a and x==Calendar.CurDay and 256 or 1)
		else
			local x = 7*(i-1)+k-Calendar.CurDayNum+1
			term.write(a and x==Calendar.CurDay and #tostring(x)==1 and " "..x or x,a and x==Calendar.CurDay and 1 or 32768,a and x==Calendar.CurDay and 8192 or 1)
		end
	end
end
term.setCursorPos(Screen.Width/2-3,Screen.Height)
term.write(" Back ",1,128)
end
Draw.setStatusColor(8192)
drawMonth(Calendar.CurMonth)
while Calendar.Running do
local Event={os.pullEventRaw()}
if Event[1]=="mouse_click" and Event[3]<=Screen.Width/2+3 and Event[3]>=Screen.Width/2-3 and Event[4]==Screen.Height then Calendar.Running=false end
if Event[1]=="key" and Event[2]==keys.left then if not (Calendar.CurMonth==1 and Calendar.CurYear==0) then if Calendar.CurMonth==1 then Calendar.CurMonth=12 Calendar.CurYear=Calendar.CurYear-1 else Calendar.CurMonth=Calendar.CurMonth-1 end drawMonth(Calendar.CurMonth) end end
if Event[1]=="key" and Event[2]==keys.right then if Calendar.CurMonth==12 then Calendar.CurMonth=1 Calendar.CurYear=Calendar.CurYear+1 else Calendar.CurMonth=Calendar.CurMonth+1 end drawMonth(Calendar.CurMonth) end
end