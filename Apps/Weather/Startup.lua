paintutils.drawFilledBox(1,1,w,h,1)
status(1,false)
tData=getData()
wTData=http.get("http://api.worldweatheronline.com/free/v1/weather.ashx?q="..tData["city"].."&format=xml&num_of_days=1&key=yzz7n8unxjwjvpxqzdmj77nc")
if wTData then
wData=wTData.readAll()
if wData:find("<error>") then
errorMsg = wData:match("<msg>(.+)</msg")
failed = true
l=7
else
failed = false
l=10
end
for i=1,l do paintutils.drawLine(3,2+i,w-3,2+i,128) end
term.setTextColor(1)
cWeather = wData:match("<current_condition>.+<weatherDesc><!%[CDATA%[([^>]+)%]%]></weatherDesc>.+</current_condition>")
tWeather = wData:match("<weather>.+<weatherDesc><!%[CDATA%[([^>]+)%]%]></weatherDesc>.+</weather>")
if tData["bTemp"] then
cTemp = wData:match("<temp_C>(.+)</temp_C>")
hTemp = wData:match("<tempMaxC>(.+)</tempMaxC>")
lTemp = wData:match("<tempMinC>(.+)</tempMinC>")
u=" C."
else
cTemp = wData:match("<temp_F>(.+)</temp_F>")
hTemp = wData:match("<tempMaxF>(.+)</tempMaxF>")
lTemp = wData:match("<tempMinF>(.+)</tempMinF>")
u=" F."
end
term.setCursorPos(4,4)
term.setTextColor(1)
local x=tData["date"]:find(",")
print(tData["date"]:sub(1,x+1))
term.setCursorPos(4,5)
print(tData["date"]:sub(x+2,#tData["date"]))
term.setCursorPos(4,7)
if #cWeather>18 then
local x=cWeather:find(" ",15)
b=cWeather:sub(1,x)
print(b)
term.setCursorPos(4,8)
local x=cWeather:find(" ",15)
a=cWeather:sub(x+1,#cWeather)
if a:find(" ")<2 then
a=a:sub(2,#a)
end
print(a)
else
print(cWeather)
end
cprint("$0  $7 Now is "..cTemp..u.."\n$0  $7 The high will be "..hTemp.."\n$0  $7 and low "..lTemp)
else
term.setCursorPos(4,7)
print("Could not get data.")
end
term.setCursorPos((w-4)/2,h)
cwrite("$0&fBack")
os.startTimer(60/72)
local weather=true
while weather do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" and tEvent[4]==h then
weather=false
shell.run("System/Desktop.lua")
elseif tEvent[1]=="timer" then
status(1,false)
os.startTimer(60/72)
end
end