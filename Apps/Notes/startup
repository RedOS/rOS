local list = {}
local notes=true
local maxX,maxY = term.getSize()
function listtomon()
        if list then
		term.setBackgroundColor(1)
		term.setTextColor(2^15)
        term.setCursorPos(2,3)
                for k,v in pairs(list) do
                        print(k..". "..v)
                        x,y = term.getCursorPos()
                        term.setCursorPos(x+1,y)
                end
        end
end
local function saveAll()
        save = fs.open("Apps/Notes/notes","w")
        save.write(textutils.serialize(list))
        save.close()
end
local function loadAll()
        if fs.exists("Apps/Notes/notes") then
                load = fs.open("Apps/Notes/notes","r")
                list = textutils.unserialize(load.readAll())
                load.close()
        end
end
function drawScreen()
        loadAll()
		term.setBackgroundColor(1)
        term.clear()
		status(128,false)
        term.setCursorPos(1,1)
        term.setBackgroundColor(1)
		term.setTextColor(2^15)
        listtomon()
end
os.startTimer(60/72)
drawScreen()
while notes do
listtomon()
print("Use: del <id> add <text>\n or exit")
tEvent={os.pullEventRaw()}
if tEvent[1]=="timer" then
status(128,false)
os.startTimer(60/72)
else
ax,ay=term.getCursorPos()
term.setCursorPos(2,ay)
input = read()
print(" ")
if string.sub(input,0,3) == "del" then
key = string.sub(input,5)
for k,v in pairs(list) do
if tostring(k) == key then
list[k] = nil
break
end
end
saveAll()
elseif string.sub(input,0,3) == "add" then
table.insert(list, string.sub(input,5))
saveAll()
elseif string.sub(input,0,4) == "exit" then
notes=false
saveAll()
shell.run("System/Desktop.lua")
end
drawScreen()
end
end