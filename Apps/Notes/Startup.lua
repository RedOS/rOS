if not fs.exists("Apps/Notes/Table.lua") then local Notes={} Notes.List={} Notes.List[1]="" f=fs.open("Apps/Notes/Table.lua","w") f.write(textutils.serialize(Notes.List)) f.close() end
Notes={}
Notes.List=textutils.unserialize(fs.open("Apps/Notes/Table.lua","r").readAll())
Notes.Running=true
Notes.Draw=function()
Notes.Removed=0
Draw.clear(1)
Draw.setStatusColor(1)
Draw.status()
if Notes.List[1]=="" then
	term.setCursorPos(Screen.Width/2-6/2,2)
	term.setTextColor(256)
	term.setBackgroundColor(1)
	term.write("Empty")
end
for lines=1,Screen.Height-2 do
	if Notes.List[lines] then
		term.setTextColor(32768)
		term.setBackgroundColor(1)
		term.setCursorPos(2,1+lines-Notes.Removed)
		if Notes.List[lines]=="" then Notes.Removed=Notes.Removed+1
		else
		term.write(Notes.List[lines])
		end
	end
end
term.setCursorPos(Screen.Width/2-3,Screen.Height)
term.setTextColor(1)
term.setBackgroundColor(16384)
term.write(" Exit ")
end
Notes.Draw()
while Notes.Running do
	Event={os.pullEvent()}
	if Event[1]=="mouse_click" then
		term.setCursorPos(1,1)
		term.write(Event[3])
		Notes.x,Notes.y=Event[3],Event[4]
		if Notes.y==Screen.Height then
			Notes.Running=false
			f=fs.open("Apps/Notes/Table.lua","w")
			f.write(textutils.serialize(Notes.List))
			f.close()
		else
			term.setCursorPos(5,Notes.List[Notes.y-1+Notes.Removed] and Notes.y or #Notes.List+2-Notes.Removed)
			term.setTextColor(32768)
			term.setBackgroundColor(1)
			Notes.List[Notes.List[Notes.y-1+Notes.Removed] and Notes.y-1+Notes.Removed or #Notes.List+2-Notes.Removed]=read()
			Notes.Draw()
		end
	end
end