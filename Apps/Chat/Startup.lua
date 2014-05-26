term.setBackgroundColor(1)
term.setTextColor(2^15)
local chat=true
tData=getData()
if tData["modemOn"] and peripheral.isPresent("back") then
local nChat=65533
local function update(msg)
local ox=term.getCursorPos()
term.setBackgroundColor(1)
term.setTextColor(2^15)
for i=2,17 do
tChatHistory[i-1]=tChatHistory[i]
end
tChatHistory[17]=msg
for i=1,17 do
term.setCursorPos(2,i+1)
term.clearLine()
tChatHistory[i]:gsub("&0","&f")
cprint(tChatHistory[i])
end
term.setCursorPos(ox,h)
end
local function fRead( _sReplaceChar, _tHistory )
    term.setCursorBlink( true )
    local sLine = ""
    local nHistoryPos
    local nPos = 0
    if _sReplaceChar then
        _sReplaceChar = string.sub( _sReplaceChar, 1, 1 )
    end
    local w = term.getSize()
    local sx = term.getCursorPos()
    local function redraw( _sCustomReplaceChar )
        local nScroll = 0
        if sx + nPos >= w then
            nScroll = (sx + nPos) - w
        end
        local cx,cy = term.getCursorPos()
        term.setCursorPos( sx, cy )
        local sReplace = _sCustomReplaceChar or _sReplaceChar
        if sReplace then
            term.write( string.rep( sReplace, math.max( string.len(sLine) - nScroll, 0 ) ) )
        else
            term.write( string.sub( sLine, nScroll + 1 ) )
        end
        term.setCursorPos( sx + nPos - nScroll, cy )
    end
    while true do
        local sEvent, param, param2, param3, message = os.pullEventRaw()
        if sEvent == "char" then
            sLine = string.sub( sLine, 1, nPos ) .. param .. string.sub( sLine, nPos + 1 )
            nPos = nPos + 1
            redraw()
        elseif sEvent == "paste" then
            sLine = string.sub( sLine, 1, nPos ) .. param .. string.sub( sLine, nPos + 1 )
            nPos = nPos + string.len( param )
            redraw()
        elseif sEvent == "key" then
            if param == keys.enter then
                break
            elseif param == keys.left then
                if nPos > 0 then
                    nPos = nPos - 1
                    redraw()
                end
            elseif param == keys.right then              
                if nPos < string.len(sLine) then
                    redraw(" ")
                    nPos = nPos + 1
                    redraw()
                end            elseif param == keys.up or param == keys.down then
                if _tHistory then
                    redraw(" ")
                    if param == keys.up then
                        if nHistoryPos == nil then
                            if #_tHistory > 0 then
                                nHistoryPos = #_tHistory
                            end
                        elseif nHistoryPos > 1 then
                            nHistoryPos = nHistoryPos - 1
                        end
                    else
                        if nHistoryPos == #_tHistory then
                            nHistoryPos = nil
                        elseif nHistoryPos ~= nil then
                            nHistoryPos = nHistoryPos + 1
                        end                        
                    end
                    if nHistoryPos then
                        sLine = _tHistory[nHistoryPos]
                        nPos = string.len( sLine ) 
                    else
                        sLine = ""
                        nPos = 0
                    end
                    redraw()
                end
            elseif param == keys.backspace then
                if nPos > 0 then
                    redraw(" ")
                    sLine = string.sub( sLine, 1, nPos - 1 ) .. string.sub( sLine, nPos + 1 )
                    nPos = nPos - 1                    
                    redraw()
                end
            elseif param == keys.home then
                redraw(" ")
                nPos = 0
                redraw()        
            elseif param == keys.delete then
                if nPos < string.len(sLine) then
                    redraw(" ")
                    sLine = string.sub( sLine, 1, nPos ) .. string.sub( sLine, nPos + 2 )                
                    redraw()
                end
            elseif param == keys["end"] then
                redraw(" ")
                nPos = string.len(sLine)
                redraw()
            end
        elseif sEvent == "term_resize" then
            w = term.getSize()
            redraw()
		elseif sEvent=="timer" then
			oy,ox=term.getCursorPos()
			status(1,false)
			os.startTimer(60/72)
			term.setCursorPos(oy,ox)
			term.setBackgroundColor(256)
			term.setTextColor(1)
		elseif sEvent=="modem_message" then
			update("&f"..message)
        end
    end
    local cx, cy = term.getCursorPos()
    term.setCursorBlink( false )
    term.setCursorPos( w + 1, cy )
    print()
    return sLine
end
status(1,false)
paintutils.drawFilledBox(1,1,w,h,1)
if type(tChatHistory)~="table" or #tChatHistory==0 then
tChatHistory={}
for i=1,17 do
tChatHistory[i]=""
end
end
os.startTimer(60/72)
m=peripheral.wrap("back")
m.open(nChat)
if not user then
term.setCursorPos(1,h)
paintutils.drawLine(1,h+1,w,h+1,256)
term.setBackgroundColor(256)
term.setTextColor(1)
write("Nickname: ")
user = fRead()
end
m.transmit(nChat,nChat,"&8"..user.." is now online")
paintutils.drawFilledBox(1,1,w,h,1)
for i=1,17 do
term.setCursorPos(2,i+1)
term.clearLine()
cprint(tChatHistory[i])
end
while chat do
term.setCursorPos(1,h-1)
paintutils.drawFilledBox(1,h-1,w,h,1)
term.setCursorPos(1,h)
term.setBackgroundColor(1)
term.setTextColor(2^15)
term.setCursorPos(2,h-1)
print("/exit for exit")
paintutils.drawLine(1,h,w,h,256)
term.setCursorPos(1,h)
term.setTextColor(1)
write("> ")
msg = fRead()
if msg=="/exit" then chat=false m.transmit(nChat,nChat,"&8"..user.." is now offline") shell.run("System/Desktop.lua") end
if msg~="" or msg~=" " or msg~=nil then
m.transmit(nChat,nChat,user..": "..msg)
end
msg="&fYou: ".."&5"..msg
update(msg)
end
else
os.startTimer(60/72)
term.clear()
status(1,false)
term.setCursorPos((w-20)/2,h/2-1)
print("No rednet connection!")
term.setCursorPos((w-24)/2,h/2)
print("Chat needs rednet to run")
while chat do
local tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then chat=false shell.run("System/Desktop.lua")
elseif tEvent[1]=="timer" then status(1,false) os.startTimer(60/72) end
end
end