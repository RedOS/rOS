if not fs.exists("Apps/Time/Table.lua") then
file=fs.open("Apps/Time/Table.lua","w")
file.write(textutils.serialize({["Alarms"]={["Times"]={},["Active"]={}},["Stopwatch"]=0,["Timer"]=0,["Menu"]={"Alarm","Stopwatch","Timer"},["TimerStart"]=0,["Selected"]=1,Buttons={}}))
file.close()
end
file=fs.open("Apps/Time/Table.lua","r")
Time=textutils.unserialize(file.readAll())
file.close()
file=nil
activeStwatch=false
local function drawTimeMenu()
paintutils.drawFilledBox(1,1,Screen.Width,Screen.Height,1)
Draw.setStatusColor(1)
Draw.isStatusVisible(true)
Draw.status()
term.setCursorPos(1,Screen.Height-1)
Draw.cwrite("$0&eExit")
for i=1,#Time.Menu do
term.setCursorPos((((Screen.Width-#Time.Menu[i])/#Time.Menu)*(i-1))+3*(i-1)+1,Screen.Height)
Time.Buttons[i]={}
Time.Buttons[i][1]=math.floor((((Screen.Width-#Time.Menu[i])/#Time.Menu)*(i-1))+3*(i-1)+1)
Time.Buttons[i][2]=math.ceil(Time.Buttons[i][1]+#Time.Menu[i])
term.setTextColor(256)
if i==Time.Selected then term.setTextColor(16384) end
term.write(Time.Menu[i])
end
end
local function drawButton(state)
x,y=term.getCursorPos()
term.setCursorPos(Screen.Width-4,y)
if state then
Draw.cwrite("&0$5 I$0")
else
Draw.cwrite("&0$eI $0")
end
end
local function drawAlarms(table)
Time.Selected=1
drawTimeMenu()
term.setCursorPos(Screen.Width-6,2)
if not edit then
Draw.cwrite("&8   Edit&0")
else
Draw.cwrite("&eEditing&0")
end
if #table.Alarms.Times>0 then
term.setCursorPos(1,3)
for i=1,#table.Alarms.Times do
term.setCursorPos(Screen.Width-1,i+2)
Draw.cwrite("$e&0X$0")
if table.Alarms.Active[i] then drawButton(true) term.setTextColor(16384) else drawButton(false) term.setTextColor(256) end
term.setCursorPos(1,i+2)
write(string.format(" %02d:%02d",table.Alarms.Times[i]:sub(1,2),table.Alarms.Times[i]:sub(4,5)))
end
end
end
local function drawStwatch(table)
Time.Selected=2
drawTimeMenu()
term.setCursorPos(math.ceil((Screen.Width-7)/2),5)
term.setTextColor(16384)
minutes,seconds,mseconds=0,0,0
function parse(number)
if number>599 then
minutes=minutes+1
number=number-600
parse(number)
elseif number>9 and number<600 then
seconds=seconds+1
number=number-10
parse(number)
else
mseconds=number
end
end
parse(Time.Stopwatch)
print(string.format("%02d:%02d:%d",tostring(minutes),tostring(seconds),tostring(mseconds)))
if activeStwatch then
paintutils.drawFilledBox(Screen.Width/2-7,7,Screen.Width/2-1,9,16384)
term.setCursorPos(Screen.Width/2-6,8)
Draw.cwrite("$e&0Stop")
else
paintutils.drawFilledBox(Screen.Width/2-7,7,Screen.Width/2-1,9,32)
term.setCursorPos(Screen.Width/2-6,8)
Draw.cwrite("$5&0Start")
end
paintutils.drawFilledBox(Screen.Width/2+1,7,Screen.Width/2+7,9,256)
term.setCursorPos(Screen.Width/2+2,8)
Draw.cwrite("$8&0Reset")
end
local function drawTimer(table)
minutes,seconds=0,0
function parseTimer(number)
minutes=math.floor(number/60)
seconds=number-minutes*60
end
Time.Selected=3
drawTimeMenu()
term.setCursorPos(Screen.Width/2-2,5)
parseTimer(Time.Timer)
write(string.format("%02d:%02d",tonumber(minutes),tonumber(seconds)))
if activeCountdown then
paintutils.drawFilledBox(Screen.Width/2-7,7,Screen.Width/2-1,9,16384)
term.setCursorPos(Screen.Width/2-6,8)
Draw.cwrite("$e&0Stop")
else
paintutils.drawFilledBox(Screen.Width/2-7,7,Screen.Width/2-1,9,32)
term.setCursorPos(Screen.Width/2-6,8)
Draw.cwrite("$5&0Start")
end
paintutils.drawFilledBox(Screen.Width/2+1,7,Screen.Width/2+7,9,256)
term.setCursorPos(Screen.Width/2+2,8)
Draw.cwrite("$8&0Cancel")
paintutils.drawLine(Screen.Width/2-5,12,Screen.Width/2+5,12,256)
paintutils.drawLine(Screen.Width/2-5,12,(Screen.Width/2-5)+(10-math.ceil((Time.Timer/Time.TimerStart)*10)),12,16384)
end
local function getMenu()
if Time.Selected==1 then drawAlarms(Time) end
if Time.Selected==2 then drawStwatch(Time) end
if Time.Selected==3 then drawTimer(Time) end
end
local function getTimer()
slct=1
mins,secs=0,0
enter=true
while enter do
term.setCursorPos(Screen.Width/2-2,5)
term.setCursorBlink(true)
event={os.pullEventRaw("key")}
if slct==1 then
if event[2]==keys.up then
mins=mins+1
if mins>23 then mins=23 end
elseif event[2]==keys.down then
mins=mins-1
if mins<0 then mins=0 end
elseif event[2]==keys.right then
slct=2
elseif event[2]==keys.enter then
term.setCursorBlink(false)
enter=false
end
term.setCursorPos(Screen.Width/2-2,5)
write(string.format("%02d",mins))
elseif slct==2 then
if event[2]==keys.up then
secs=secs+1
if secs>59 then secs=59 end
elseif event[2]==keys.down then
secs=secs-1
if secs<0 then secs=0 end
elseif event[2]==keys.left then
slct=1
elseif event[2]==keys.enter then
term.setCursorBlink(false)
enter=false
end
term.setCursorPos(Screen.Width/2+1,5)
write(string.format("%02d",secs))
end
end
times=(mins*60)+secs
if times==0 then times=1 end
Time.TimerStart=times
return times
end
local function setAlarm(number,oldTime)
n,o=1,1
hours={}
for i=0,23 do
hours[i+1]=i
end
minutes={}
for i=0,59 do
minutes[i+1]=i
end
slct=1
enter=true
hour,minute=0,0
while enter do
term.setCursorPos(2,y)
term.setCursorBlink(true)
event={os.pullEventRaw("key")}
if slct==1 then
if event[2]==keys.up then
n=n+1
if n>24 then n=1 end
elseif event[2]==keys.down then
n=n-1
if n<1 then n=24 end
elseif event[2]==keys.right then
slct=2
elseif event[2]==keys.enter then
enter=false
end
hour=hours[n]
term.setCursorPos(2,y)
write(string.format("%2d",hour))
elseif slct==2 then
if event[2]==keys.up then
o=o+1
if o>60 then o=1 end
elseif event[2]==keys.down then
o=o-1
if o<1 then o=60 end
elseif event[2]==keys.left then
slct=1
elseif event[2]==keys.enter then
enter=false
end
minute=minutes[o]
term.setCursorPos(5,y)
write(string.format("%2d",minute))
end
if not enter then
nTime=string.format("%2d:%2d",hour,minute+0.001)
Time.Alarms.Times[number]=nTime
Time.Alarms.Active[number]=true
os.setAlarm(tonumber(hour.."."..math.floor(tonumber(minute)*100/60))+0.001)
term.setCursorBlink(false)
end
end
end
getMenu()
timeApp=true
while timeApp do
tEvent={os.pullEventRaw()}
if tEvent[1]=="timer" then
if tEvent[2]==stWatch and activeStwatch then
Time.Stopwatch=Time.Stopwatch+1
stWatch=os.startTimer(60/72/10)
if Time.Selected==2 then
minutes,seconds,mseconds=0,0,0
parse(Time.Stopwatch)
term.setTextColor(16384)
term.setBackgroundColor(1)
term.setCursorPos(math.ceil((Screen.Width-7)/2),5)
print(string.format("%02d:%02d:%d",tostring(minutes),tostring(seconds),tostring(mseconds)))
end
elseif tEvent[2]==count and activeCountdown then
Time.Timer=Time.Timer-1
if Time.Timer<=0 then activeCountdown=false Time.Timer=Time.TimerStart drawTimer(Time) else
count=os.startTimer(60/72)
if Time.Selected==3 then
minutes,seconds=0,0
parseTimer(Time.Timer)
term.setTextColor(16384)
term.setBackgroundColor(1)
term.setCursorPos(Screen.Width/2-2,5)
print(string.format("%02d:%02d",tostring(minutes),tostring(seconds)))
paintutils.drawLine(Screen.Width/2-5,12,Screen.Width/2+5,12,256)
paintutils.drawLine(Screen.Width/2-5,12,(Screen.Width/2-5)+(10-math.ceil((Time.Timer/Time.TimerStart)*10)),12,16384)
end
end
end
elseif tEvent[1]=="mouse_click" then
x,y=tEvent[3],tEvent[4]
if y==Screen.Height then
for i=1,#Time.Buttons do if x>=Time.Buttons[i][1] and x<=Time.Buttons[i][2] then Time.Selected=i getMenu() x,y=0,0 end end
elseif y==Screen.Height-1 then
timeApp=false
activeCountdown=false
activeStwatch=false
file=fs.open("Apps/Time/Table.lua","w")
file.write(textutils.serialize(Time))
file.close()
shell.run("System/Desktop.lua")
else
if Time.Selected==2 then
if x>=Screen.Width/2-7 and y>= 7 and x<= Screen.Width/2-1 and y<=9 then
if activeStwatch then activeStwatch=false else activeStwatch=true stWatch=os.startTimer(60/72/10) end
drawStwatch(Time)
elseif x>=Screen.Width/2+1 and y>=7 and x<=Screen.Width/2+7 and y<=9 then
activeStwatch=false
Time.Stopwatch=0
paintutils.drawFilledBox(Screen.Width/2-7,7,Screen.Width/2-1,9,32)
term.setCursorPos(Screen.Width/2-6,8)
cwrite("$5&0Start")
term.setTextColor(16384)
term.setBackgroundColor(1)
term.setCursorPos(math.ceil((Screen.Width-13)/2),5)
print("   00:00:0   ")
end
elseif Time.Selected==1 then
if y==2 then
if edit==true then edit=false else edit=true end
term.setCursorPos(Screen.Width-6,2)
if not edit then
cwrite("&8   Edit&0")
else
cwrite("&eEditing&0")
end
else
if x<Screen.Width-2 then
if edit then
if Time.Alarms.Times[y-2] then nAlarm=y-2 else nAlarm=#Time.Alarms.Times+1 end
term.setCursorPos(2,nAlarm)
setAlarm(nAlarm)
else
if Time.Alarms.Active[y-2]==true and Time.Alarms.Times[y-2] then Time.Alarms.Active[y-2]=false elseif Time.Alarms.Active[y-2]==false and Time.Alarms.Times[y-2] then Time.Alarms.Active[y-2]=true end
end
drawAlarms(Time)
elseif x==Screen.Width-1 then
table.remove(Time.Alarms.Active,y-2)
table.remove(Time.Alarms.Times,y-2)
drawAlarms(Time)
end
end
elseif Time.Selected==3 then
if y==5 then
Time.Timer=getTimer()
drawTimer(Time)
end
if x>=Screen.Width/2-7 and y>= 7 and x<= Screen.Width/2-1 and y<=9 then
if activeCountdown then activeCountdown=false else activeCountdown=true count=os.startTimer(60/72) end
drawTimer(Time)
elseif x>=Screen.Width/2+1 and y>= 7 and x<= Screen.Width/2+7 and y<=9 then
activeCountdown=false
Time.Timer=0
drawTimer(Time)
end
end
end
elseif tEvent[2]==keys.right then
Time.Selected=Time.Selected+1
if Time.Selected>#Time.Menu then Time.Selected=#Time.Menu end
getMenu()
elseif tEvent[2]==keys.left then
Time.Selected=Time.Selected-1
if Time.Selected<1 then Time.Selected=1 end
getMenu()
end
end