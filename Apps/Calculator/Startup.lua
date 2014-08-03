paintutils.drawFilledBox(2,7,Screen.Width-1,11,128)
Draw.setStatusColor(128)
Draw.status()
term.setCursorPos(3,8)
Draw.cwrite("&0$7")
msg=read()
local banned = {"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
local formula = msg:sub(1, -1):lower()
for k,v in pairs(banned) do
formula = formula:gsub(v,"")
end
local func = loadstring("return " .. formula)
local r, resp = pcall(func)
term.setCursorPos(3,9)
if r and ((type(resp) == "number") or (type(resp) == "string")) then
       print("= "..resp)
else
	   Draw.cprint("&eSyntax error!&0")
end
nStatusTimer=os.startTimer(60/72)
local calc=true
while calc do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" or (tEvent[1]=="key" and tEvent[2]==keys.enter) then
calc=false
shell.run("System/Desktop.lua")
end
end