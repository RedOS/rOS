{
  {
    Name = "General",
	Items = {
	  {Name = "Modem", Type = "bool", Value = "return Core.getData().bModem", Action = "Core.invertData('bModem')",},
	  {Name = "24h time format", Type = "bool",Value = "return Core.getData().H24", Action = "Core.invertData('H24')",},
	  {Type = "space",},
	  {Name = "Info", Type = "list", Value = { 
	    {Name = "ID", Code = "return os.getComputerID()"}, 
		{Name = "Label", Code = "return os.getComputerLabel() or 'Not set'"}, 
		{Name = "Version", Code = "return Core.getData().Version or 'Unknown'"}, 
		{Name = "HTTP", Code = "return http and 'Enabled' or 'Disabled'"}, 
	    }, 
	  },
    },
  },
  {
    Name = "Notifications",
  },
  {
    Name = "Usage",
	Items = {
	  {Name = "Free space", Type = "static", Value = "local u={' B',' kB',' MB',' GB',' TB',' PB'} for i=1,6 do if fs.getFreeSpace('/')/1024^(i-1)<1024 then return tostring(math.floor(fs.getFreeSpace('/')/1024^(i-1)))..u[i] end end",},
	  {Name = "Used space", Type = "static", Value = "local u={' B',' kB',' MB',' GB',' TB',' PB'} for i=1,6 do if fs.getSizeFolder('Apps')/1024^(i-1)<1024 then return tostring(math.floor(fs.getSizeFolder('/')/1024^(i-1)))..u[i] end end",},
	},
  },
  {
    Name = "Private",
	Items = {
	  {Name = "Label", Type = "string", Value = "k,v=term.getCursorPos(); return (os.getComputerLabel() and os.getComputerLabel() or '')", Action = "paintutils.drawLine(Screen.Width>29 and 20 or 2,v+1,Screen.Width-2,v+1,256) term.setCursorPos(Screen.Width>29 and 21 or 3,v+1) term.setBackgroundColor(256) term.setTextColor(1) os.setComputerLabel(read())",},
	  {Type = "space",},
	  {Type = "space",},
	},
  },
}
