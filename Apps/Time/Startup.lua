if not fs.exists("Apps/Time/Table.lua") then
file=fs.open("Apps/Time/Table.lua","w")
file.write(textutils.serialize({["Alarms"]={["Times"]={},["Active"]={}},["Stopwatch"]=0,["Timer"]=0,["Menu"]={"Alarm","Stopwatch","Timer"},["TimerStart"]=0,["Selected"]=1,}))
file.close()
end
file=fs.open("Apps/Time/Table.lua","r")