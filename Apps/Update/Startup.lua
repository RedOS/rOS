local size=0
local function getSize(number,round)
if number<1024 then
unit=" B"
else
local units={" kB"," MB"," GB"," TB"," PB"}
for i=1,5 do
if number/1024^i < 768 then
number=number/1024^i
unit=units[i]
break
end
end
end
number=tostring(number)
if number:find(".",1,true) then number=number:sub(1,number:find(".",1,true)+2) end
number=tonumber(number)
return number, unit
end
Draw.setStatusColor(1)
Draw.isStatusVisible(true)
Draw.status()
Draw.clear(1)
if http then local tUpdates=http.get("github.com/url") end
if tUpdates then
tUpdates=textutils.unserialize(tUpdates.readAll())
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
        download("http://pastebin.com/raw.php?i=4nRg9CHU","Apps/Update/json")
end
os.loadAPI("Apps/Update/json")
if pre_dl then loadstring(pre_dl)() end
local data = json.decode(http.get("https://api.github.com/repos/RedOS/rOS/git/trees/master?recursive=1").readAll())
if data.message and data.message == "Not found" then error("Invalid repository",2) else
	for k,v in pairs(data.tree) do
		if v.size then
			size=size+v.size
		end
	end
	
	for k,v in pairs(data.tree) do
		if v.type == "tree" then
			fs.makeDir(v.path)
		end
	end
	for k,v in pairs(data.tree) do
		if v.type == "blob" then
			download("https://raw.github.com/RedOS/rOS/master/"..v.path,v.path)
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
shell.run("System/Desktop.lua")