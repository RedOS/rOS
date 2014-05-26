local args = {"RedOS","rOS"}
term.setTextColor(1)
tData=getData()
if http.get("https://raw.githubusercontent.com/RedOS/rOS/master/System/Version.lua").readAll()==tData["version"] and not force then
paintutils.drawFilledBox(w/2-9,h/2-1,w/2+9,h/2+2,128)
term.setCursorPos(w/2-7,h/2)
term.setTextColor(1)
term.setBackgroundColor(128)
print("No update found")
term.setCursorPos(w/2-6,h/2+1)
print("Force update?")
term.setCursorPos(w/2-7,h/2+2)
print("Yes")
term.setCursorPos(w/2+6,h/2+2)
print("No")
local update=true
os.startTimer(60/72)
while update do
local tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
if tEvent[4]>=h/2-1 and tEvent[4]<=h/2+2 then
if tEvent[4]==h/2+2 then
if tEvent[3]>=w/2-8 and tEvent[3]<=w/2-4 then
force=true
update=false
shell.run("Apps/Update/Startup.lua")
else
update=false
shell.run("System/Desktop.lua")
end
end
else
update=false
shell.run("System/Desktop.lua")
end
elseif tEvent[1]=="timer" then
status(128,false)
os.startTimer(60/72)
end
end
else
local function loading()
local img=paintutils.loadImage("Apps/Update/load")
paintutils.drawFilledBox(w/2-7,h/2-1,w/2+7,h/2+2,128)
paintutils.drawImage(img,w/2-4,h/2+1)
term.setCursorPos((w-9)/2,h/2)
term.setTextColor(1)
term.setBackgroundColor(128)
print("Updating...")
status(128,false)
for i=1,5 do
paintutils.drawImage(img,w/2-4,h/2+1)
paintutils.drawPixel(w/2-4+2*(i-1),h/2+1,1)
os.sleep(.085)
end
status(128,false)
paintutils.drawImage(img,w/2-4,h/2+1)
end
args[3] = args[3] or "master"
args[4] = args[4] or ""
if not automated and #args < 2 then
        print("Usage:\n"..shell.getRunningProgram().." <user> <repo> [branch=master] [path=/]") error()
end
local function save(data,file)
        local file = shell.resolve(file)
        if not (fs.exists(string.sub(file,1,#file - #fs.getName(file))) and fs.isDir(string.sub(file,1,#file - #fs.getName(file)))) then
                if fs.exists(string.sub(file,1,#file - #fs.getName(file))) then fs.delete(string.sub(file,1,#file - #fs.getName(file))) end
                fs.makeDir(string.sub(file,1,#file - #fs.getName(file)))
        end
        local f = fs.open(file,"w")
        f.write(data)
        f.close()
end
local function download(url, file)
        save(http.get(url).readAll(),file)
end
if not fs.exists("Apps/Update/json") then
        print("")
        download("http://pastebin.com/raw.php?i=4nRg9CHU","Apps/Update/json")
end
os.loadAPI("Apps/Update/json")
loading()
if pre_dl then loadstring(pre_dl)() else print("") end
local data = json.decode(http.get("https://api.github.com/repos/"..args[1].."/"..args[2].."/git/trees/"..args[3].."?recursive=1").readAll())
if data.message and data.message == "Not found" then error("Invalid repository",2) else
	for k,v in pairs(data.tree) do
	loading()
		-- Make directories
		if v.type == "tree" then
			fs.makeDir(fs.combine(args[4],v.path))
			if not hide_progress then
			end
		end
	end
	for k,v in pairs(data.tree) do
	loading()
		-- Download files
		if v.type == "blob" then
			download("https://raw.github.com/"..args[1].."/"..args[2].."/"..args[3].."/"..v.path,fs.combine(args[4],v.path))
			if not hide_progress then
			end
		end
	end
end
if fs.exists("System/delete") then
f=fs.open("System/delete","r")
data=f.readAll()
f.close()
data=textutils.unserialize(data)
for i=1,#data do
if fs.exists(data[i]) then
fs.delete(data[i])
end
end
end
os.sleep(0.01)
os.reboot()
end
update=false
shell.run("System/Desktop.lua")