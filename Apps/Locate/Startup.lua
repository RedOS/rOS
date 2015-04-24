Data=Core.getData()
paintutils.drawFilledBox((Screen.Width-18)/2,Screen.Height/2-3,(Screen.Width+18)/2,Screen.Height/2+1,256)
tPos={}
tPos.x,tPos.y,tPos.z=nil,nil,nil
if Data.bModem and peripheral.getType("back")=="modem" then x,y,z=gps.locate() end
if tPos.x and tPos.y and tPos.z then
tPos.x=math.floor(tPos.x)
tPos.y=math.floor(tPos.y)
tPos.z=math.floor(tPos.z)
paintutils.drawLine(Screen.Width/2-3,Screen.Height/2-4,Screen.Width/2+5,Screen.Height/2-4,32768)
paintutils.drawLine(Screen.Width/2+5,Screen.Height/2-3,Screen.Width/2+5,Screen.Height/2,32768)
term.setTextColor(1)
term.setCursorPos((Screen.Width-8)/2+2,Screen.Height/2-2)
print("X="..tPos.x," ")
term.setCursorPos((Screen.Width-8)/2+2,Screen.Height/2-1)
print("Y="..tPos.y," ")
term.setCursorPos((Screen.Width-8)/2+2,Screen.Height/2)
print("Z="..tPos.z," ")
else
term.setCursorPos((Screen.Width-18)/2+1,Screen.Height/2-1)
print("Can't get position")
end
local app=true
while app do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
app=false
end
end