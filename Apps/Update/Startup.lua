Draw.setStatusColor(Draw.StatusGlobal)
Draw.status()
term.clear(1)
term.setCursorPos(Screen.Width/2-4,Screen.Height/2)
term.setTextColor(32768)
term.setBackgroundColor(1)
term.write("Updating")
local path="/"
local function save(data,file)
	local file = shell.resolve(file:gsub("%%20"," "))
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
local data = json.decode(http.get("https://api.github.com/repos/RedOS/rOS/git/trees/master?recursive=1").readAll())
if data.message and data.message:find("API rate limit exceeded") then error("Out of API calls, try again later") end
if data.message and data.message == "Not found" then error("Invalid repository",2) else
	for k,v in pairs(data.tree) do
		if v.type == "tree" then
			fs.makeDir(fs.combine(path,v.path))
			if not hide_progress then
			end
		end
	end
	local filecount = 0
	local downloaded = 0
	local paths = {}
	local failed = {}
	for k,v in pairs(data.tree) do
		if v.type == "blob" then
			v.path = v.path:gsub("%s","%%20")
			local url = "https://raw.github.com/RedOS/rOS/master/"..v.path,fs.combine(path,v.path)
			if async then
				http.request(url)
				paths[url] = fs.combine(path,v.path)
				filecount = filecount + 1
			else
				download(url, fs.combine(path, v.path))
			end
		end
	end
	while downloaded < filecount do
		local e, a, b = os.pullEvent()
		if e == "http_success" then
			save(b.readAll(),paths[a])
			downloaded = downloaded + 1
		elseif e == "http_failure" then
			failed[os.startTimer(3)] = a
		elseif e == "timer" and failed[a] then
			http.request(failed[a])
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
os.reboot()