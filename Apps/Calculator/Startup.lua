paintutils.drawFilledBox(2,7,w-1,11,128)
status(128,false)
term.setCursorPos(3,8)
cwrite("&0$7")
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
	   cprint("&eSyntax error!&0")
end
os.startTimer(60/72)
local calc=true
while calc do
tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then
calc=false
shell.run("System/Desktop.lua")
elseif tEvent[1]=="timer" then
status(128,false)
os.startTimer(60/72)
end
end