for i=1,w/2 do
paintutils.drawFilledBox((w-2*i)/2,(w-2*i)/2,(w+2*i)/2,(w+2*i)/2,256)
end
paintutils.drawBox(1,1,w,h,128)
status(128,false)
local images=true
while images do
if not cImg then cImg=1 end
term.setBackgroundColor(256)
tImgs=fs.list("Apps/Images/gallery")
if #tImgs==0 then term.setCursorPos((w-8)/2,h/2) print("No Images") else
paintutils.drawImage(paintutils.loadImage("Apps/Images/gallery/"..cImg),2,2)
paintutils.drawBox(1,1,w,h,128)
status(128,false)
end
os.startTimer(60/72)
term.setBackgroundColor(256)
local app=true
term.setCursorPos(3,h-1)
print("Paint")
term.setCursorPos(10,h-1)
print("Back")
term.setCursorPos(16,h-1)
print("Edit")
local app=true
while app do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
if tEvent[4]==h-1 and tEvent[3]>9 and tEvent[3]<15 then
app=false
images=false
shell.run("System/Desktop.lua")
elseif tEvent[4]==h-1 and tEvent[3]>3 and tEvent[3]<9 then
shell.run("paint","Apps/Images/gallery/"..tostring(#tImgs+1))
shell.run("Apps/Images/startup")
elseif tEvent[4]==h-1 and tEvent[3]>15 and tEvent[3]<23 then
shell.run("paint","Apps/Images/gallery/"..cImg)
shell.run("Apps/Images/startup")
end
elseif tEvent[1]=="key" and tEvent[2]==205 then
cImg=cImg+1
if cImg>#tImgs-1 then cImg=#tImgs-1 end
paintutils.drawFilledBox(1,1,w,h,256)
paintutils.drawBox(1,1,w,h,128)
status(128,false)
term.setBackgroundColor(128)
local app=true
term.setCursorPos(3,h-1)
print("Paint")
term.setCursorPos(10,h-1)
print("Back")
term.setCursorPos(16,h-1)
print("Reload")
paintutils.drawImage(paintutils.loadImage("Apps/Images/gallery/"..cImg),2,2)
elseif tEvent[1]=="key" and tEvent[2]==203 then
cImg=cImg-1
if cImg<0 then cImg=0 end
paintutils.drawFilledBox(1,1,w,h,256)
paintutils.drawBox(1,1,w,h,128)
status(128,false)
term.setBackgroundColor(128)
local app=true
term.setCursorPos(3,h-1)
print("Paint")
term.setCursorPos(10,h-1)
print("Back")
term.setCursorPos(16,h-1)
print("Reload")
paintutils.drawImage(paintutils.loadImage("Apps/Images/gallery/"..cImg),2,2)
elseif tEvent[1]=="timer" then
paintutils.drawBox(1,1,w,h,128)
status(128,false)
os.startTimer(60/72)
end
end
end