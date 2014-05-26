for i=1,w/2 do
paintutils.drawFilledBox((w-2*i)/2,(w-2*i)/2,(w+2*i)/2,(w+2*i)/2,256)
end
status(128,false)
f=fs.open("Apps/Time/city","r")
city=textutils.unserialize(f.readAll())
f.close()
for k,v in pairs(city) do
paintutils.drawLine(1,1+k,w,1+k,1)
term.setTextColor(2^15)
term.setCursorPos(2,1+k)
print(v)
end
tTime={}
tTimeMin={}
for k,v in pairs(city) do
if v=="Los Angels" then v="LA" end
if v=="New York" then v="NY" end
address=textutils.urlEncode(v)
wData=http.get("http://api.worldweatheronline.com/free/v1/tz.ashx?key=yzz7n8unxjwjvpxqzdmj77nc&q="..address.."&format=xml")
if wData then
wData=wData.readAll()
tTime[k],tTimeMin[k]=wData:match(" (%d+):(%d+)</localtime>")
tTime[k]=tonumber(tTime[k])
tTimeMin[k]=tonumber(tTimeMin[k])
if tTime[k]>12 then tTime[k]=tTime[k]-12 t=" &8PM&f" else t=" &8AM&f" end
term.setCursorPos(w-7,1+k)
cwrite(tTime[k]..":"..tTimeMin[k]..t)
end
end
os.startTimer(60/72)
local app=true
term.setCursorPos((w-4)/2-4,h-1)
print("Back")
term.setCursorPos((w+4)/2,h-1)
print("Reload")
while app do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
if tEvent[4]==h-1 and tEvent[3]<w/2 and tEvent[3]>w/4 then
app=false
shell.run("System/Desktop.lua")
elseif tEvent[4]==h-1 and tEvent[3]>w/2 and tEvent[3]<w/4*3 then
shell.run("Apps/Time/startup")
end
elseif tEvent[1]=="timer" then
status(128,false)
os.startTimer(60/72)
end
end