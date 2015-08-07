Chat={}
Chat.History={}
Chat.Running=true
Chat.Modem=peripheral.find("modem")
Chat.Modem.open(CHAT_CHANNEL)
for i=1,Screen.Height-2 do Chat.History[i]="" end
local function update(Message)
	paintutils.drawFilledBox(1,2,Screen.Width,Screen.Height-1,1)
	term.setTextColor(256)
	term.setCursorPos(2,Screen.Height-1)
	term.write("/exit for exit")
	Chat.History[Screen.Height-2]=Message
	for i=2,Screen.Height-2 do
			Chat.History[i-1]=Chat.History[i]
			term.setCursorPos(2,i)
			term.setTextColor(32768)
			term.setBackgroundColor(1)
			term.write(Chat.History[i])
	end
	term.setCursorPos(2,Screen.Height)
	paintutils.drawLine(1,Screen.Height,Screen.Width,Screen.Height,256)
	term.setCursorPos(2,Screen.Height)
	term.setTextColor(1)
end
local function receive()
while Chat.Running do
	Event={os.pullEventRaw()}
	if Event[1]=="modem_message" and Event[4]==CHAT_CHANNEL then
		update(Event[5])
	end
end	
end
local function send(Message)
while Chat.Running do
	Chat.Message=read()
	if Chat.Message:lower()=="/exit" then Chat.Modem.transmit(CHAT_CHANNEL,CHAT_CHANNEL,"&8"..Chat.Nickname.." left") Chat.Running=false else
	Chat.Modem.transmit(CHAT_CHANNEL,CHAT_CHANNEL,Chat.Nickname..": "..Chat.Message)
	update("You: "..Chat.Message)
	end
end
end
Draw.setStatusColor(1)
Draw.status()
term.clear(1)
term.setTextColor(256)
term.setCursorPos(2,Screen.Height-1)
term.write("Enter your nickname",256,1)
paintutils.drawLine(1,Screen.Height,Screen.Width,Screen.Height,256)
term.setCursorPos(2,Screen.Height)
term.setTextColor(1)
Chat.Nickname=read():gsub("%W","")
update("")
Chat.Modem.transmit(CHAT_CHANNEL,CHAT_CHANNEL,"&8"..Chat.Nickname.." has joined")
while Chat.Running do
	parallel.waitForAny(receive,send)
end