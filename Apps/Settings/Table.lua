{
  {
    Name = "General",
    Type = "group",
    Action = function() Settings.Objects=Parse.render(Settings.Objects[Settings.y-1].children,Settings.env) end,
    Children = {
      {Name = "General", Type = "header", Value = function() return "< Back" end, Action = function() Settings.Objects=nil Settings.Objects=Parse.render(Settings.Table,Settings.env) end,},
      {Name = "Modem", Type = "bool", Value = function() return Core.getData('Modem') end, Action = function() Core.setData('Modem',not Core.getData('Modem')) end,},
      {Name = "24h time format", Type = "bool",Value = function() return Core.getData('H24') end, Action = function() Core.setData('H24',not Core.getData('H24')) end,},
      {Name = "Color mode", Type = "bool",Value = function() return Core.getData('ColorMode') end, Action = function() Core.setData('ColorMode',not Core.getData('ColorMode')) Core.Window.updateColors() Core.Status.updateColors() end,},
      {Type = "space",},
      {Name = "Info", Type = "list", Value = { 
        {Name = "ID", Value = function() return os.getComputerID() end,}, 
        {Name = "Label", Value = function() return os.getComputerLabel() or 'Not set' end,}, 
        {Name = "Version", Value = function() return Core.getData('Version') or 'Unknown' end,}, 
        {Name = "HTTP", Value = function() return http and 'Enabled' or 'Disabled' end,},},
      },
    },
  },
  {
    Name = "Usage",
    Type = "group",
    Action = function() Settings.Objects=Parse.render(Settings.Objects[Settings.y-1].children,Settings.env) end,
    Children = {
      {Name = "Usage", Type = "header", Value = function() return "< Back" end, Action = function() Settings.Objects=nil Settings.Objects=Parse.render(Settings.Table,Settings.env) end},
      {Name = "Free space", Type = "static", Value = function() return parseSize(fs.getFreeSpace('/')) end,},
      {Name = "Used space", Type = "static", Value = function() return parseSize(fs.getSizeFolder('/')) end,},
      {Type = "space",},
      {Name = "Apps", Type = "static", Value = function() return parseSize(fs.getSizeFolder('Apps')) end,},
      {Name = "System", Type = "static", Value = function() return parseSize(fs.getSizeFolder('System')-fs.getSizeFolder('System/API/')) end,},
      {Name = "APIs", Type = "static", Value = function() return parseSize(fs.getSizeFolder('System/API/')) end,},
    },
  },
  {
    Name = "Private", 
    Type = "group",
    Action = function() Settings.Objects=Parse.render(Settings.Objects[Settings.y-1].children,Settings.env) end,
    Children = {
     {Name = "Private", Type = "header", Value = function() return "< Back" end, Action = function() Settings.Objects=nil Settings.Objects=Parse.render(Settings.Table,Settings.env) end,},
      {Name = "Label", Type = "string", Value = function() return os.getComputerLabel() or 'Not set' end, Action = function() term.setCursorPos(3,Settings.y) term.write(string.rep(" ",Screen.Width-4),1,128) term.setCursorPos(3,Settings.y) local l=read() os.setComputerLabel(#l>0 and l or nil) end,},
      {Type = "space",},
      {Type = "space",},
    },
  },
}