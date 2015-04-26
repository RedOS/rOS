term.setBackgroundColor(1)
term.setTextColor(2^15)
local chat=true
Data=Core.getData()
if Data.bModem then modem=peripheral.find("modem") end
if modem then
local function update()
local ox=term.getCursorPos()
term.setBackgroundColor(1)
term.setTextColor(2^15)
for i=1,17 do
term.setCursorPos(2,i)
term.clearLine()
Draw.cprint(tChatHistory[i])
end
term.setCursorPos(ox,Screen.Height)
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
		elseif sEvent=="modem_message" and type(message)~="table" then
			update()
        end
    end
    local cx, cy = term.getCursorPos()
    term.setCursorBlink( false )
    term.setCursorPos( w + 1, cy )
    print()
    return sLine
end
Draw.setStatusColor(1)
Draw.isStatusVisible(true)
Draw.status()
paintutils.drawFilledBox(1,1,Screen.Width,Screen.Height,1)
if not modem.isOpen(CHAT_CHANNEL) then modem.open(CHAT_CHANNEL) end
if not user then
term.setCursorPos(1,Screen.Height)
paintutils.drawLine(1,Screen.Height+1,Screen.Width,Screen.Height+1,256)
term.setBackgroundColor(256)
term.setTextColor(1)
write("Nickname: ")
user = fRead()
end
modem.transmit(CHAT_CHANNEL,CHAT_CHANNEL,"&8"..user.." is now online")
paintutils.drawFilledBox(1,1,Screen.Width,Screen.Height,1)
for o=1,17 do
term.setTextColor(2^15)
term.setCursorPos(2,o-1)
term.clearLine()
Draw.cprint(tChatHistory[o])
end
while chat do
term.setCursorPos(1,Screen.Height-1)
paintutils.drawFilledBox(1,Screen.Height-1,Screen.Width,Screen.Height,1)
term.setCursorPos(1,Screen.Height)
term.setBackgroundColor(1)
term.setTextColor(2^15)
term.setCursorPos(2,Screen.Height-1)
print("/exit for exit")
paintutils.drawLine(1,Screen.Height,Screen.Width,Screen.Height,256)
term.setCursorPos(1,Screen.Height)
term.setTextColor(1)
write("> ")
msg=fRead()
if msg=="/exit" then chat=false modem.transmit(CHAT_CHANNEL,CHAT_CHANNEL,"&8"..user.." is now offline") shell.run("System/Desktop.lua") end
if msg~="" or msg~=" " or msg~=nil or msg~="/exit" then
modem.transmit(CHAT_CHANNEL,CHAT_CHANNEL,user..": "..msg)
msg="&fYou: ".."&5"..msg.."&f"
for i=2,17 do tChatHistory[i-1]=tChatHistory[i] end tChatHistory[17]=msg
local xpos,ypos=term.getCursorPos()
term.setCursorPos(2,Screen.Height-2)
update()
term.setCursorPos(xpos,ypos)
end
end
else
term.clear()
Draw.status()
term.setCursorPos((Screen.Width-20)/2,Screen.Height/2-1)
print("No rednet connection!")
term.setCursorPos((Screen.Width-24)/2,Screen.Height/2)
print("Chat needs rednet to run")
while chat do
local tEvent={os.pullEventRaw()}
if tEvent[1]=="mouse_click" then chat=false shell.run("System/Desktop.lua")
end
end
end