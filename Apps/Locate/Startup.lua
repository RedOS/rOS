Data=Core.getData()
x,y,z=nil,nil,nil
if Data.bModem and peripheral.getType("back")=="modem" then x,y,z=gps.locate() end
if x and y and z then
x=math.floor(x)
y=math.floor(y)
z=math.floor(z)
paintutils.drawLine(Screen.Width/2-3,Screen.Height/2-4,Screen.Width/2+5,Screen.Height/2-4,32768)
paintutils.drawLine(Screen.Width/2+5,Screen.Height/2-3,Screen.Width/2+5,Screen.Height/2,32768)
paintutils.drawFilledBox((Screen.Width-8)/2,Screen.Height/2-3,(Screen.Width+8)/2,Screen.Height/2+1,256)
term.setTextColor(1)
term.setCursorPos((Screen.Width-10)/2+2,Screen.Height/2-2)
print("X="..x," ")
term.setCursorPos((Screen.Width-10)/2+2,Screen.Height/2-1)
print("Y="..y," ")
term.setCursorPos((Screen.Width-10)/2+2,Screen.Height/2)
print("Z="..z," ")
else
paintutils.drawFilledBox((Screen.Width-18)/2,Screen.Height-13,(Screen.Width+18)/2,Screen.Height-10,32)
term.setCursorPos((Screen.Width-18)/2+1,Screen.Height-10)
print("Can't get position")
end
local app=true
while app do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
app=false
end
end