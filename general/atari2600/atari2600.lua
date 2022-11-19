--[[
Declare general functions that can be used by any atari 2600's game.
]]

dofile("general\\general.lua")

--[[
Check if table has a determinaded element.
The table cannot be empty and the element cannot be nil.
This function is local and is used only by jInput
]]
local function tableHasElement(myTable, myElement,...)
  assert(#{...} == 0)
  assert(type(myTable) == "table")
  assert(#myTable >= 1)
  assert(type(myElement) ~= nil)
  for i = 1, #myTable do
    if myElement == myTable[i] then
      return true
    end
  end
  return false
end

--[[
Check if table has duplicated elements.
The table cannot be empty.
This function is local and is used only by jInput
]]
local function tableHasDuplicatedElement(myTable,...)
  assert(#{...} == 0)
  assert(type(myTable) == "table")
  assert(#myTable >= 1)
  for i = 1, #myTable - 1 do
    for j = i + 1, #myTable do
      if myTable[i] == myTable[j] then
        return true
      end
    end
  end
  return false
end

--[[
The function jInput receive the initials of the buttons and active them.
This function have a great advantage, a standarizeded possibility for
active various buttons at same time.
The function recognize the last activaded buttons
(with the function emu.getimmediate).
This function does not allow duplicated inputs.
This functions does not allow u+d/l+r
]]
function jInput(...)
  assert(not tableHasDuplicatedElement({...}))
  local possibleInputs = {"B1", "D1", "L1", "R1", "U1", "B2", "D2", "L2",
    "R2", "U2", "PW", "RS", "SL", "LD", "RD"}
  local a = {...}
  for i = 1, #a do
    assert(tableHasElement(possibleInputs, a[i]))
  end
  local correlTable = {}
  correlTable["B1"] = "P1 Button"
  correlTable["D1"] = "P1 Down"
  correlTable["L1"] = "P1 Left"
  correlTable["R1"] = "P1 Right"
  correlTable["U1"] = "P1 Up"
  correlTable["B2"] = "P2 Button"
  correlTable["D2"] = "P2 Down"
  correlTable["L2"] = "P2 Left"
  correlTable["R2"] = "P2 Right"
  correlTable["U2"] = "P2 Up"
  correlTable["PW"] = "Power"
  correlTable["RS"] = "Reset"
  correlTable["SL"] = "Select"
  correlTable["LD"] = "Toggle Left Difficulty"
  correlTable["RD"] = "Toggle Right Difficulty"
  local b = {}
  for k, v in pairs(joypad.getimmediate()) do
    if v then
      b[k] = true
    end
  end
  for i = 1, #a do
    b[correlTable[a[i]]] = true
  end
  if b["P1 Up"] == true then
    assert(b["P1 Down"] ~= true)
  end
  if b["P1 Down"] == true then
    assert(b["P1 Up"] ~= true)
  end
  if b["P2 Up"] == true then
    assert(b["P2 Down"] ~= true)
  end
  if b["P2 Down"] == true then
    assert(b["P2 Up"] ~= true)
  end
  if b["P1 Left"] == true then
    assert(b["P1 Right"] ~= true)
  end
  if b["P1 Right"] == true then
    assert(b["P1 Left"] ~= true)
  end
  if b["P2 Left"] == true then
    assert(b["P2 Right"] ~= true)
  end
  if b["P2 Right"] == true then
    assert(b["P2 Left"] ~= true)
  end
  joypad.set(b)
end

--[[
Clear last inputs.
]]
function clearJInput(...)
  assert(#{...} == 0)
  local a = {}
  a["P1 Button"] = false
  a["P1 Down"] = false
  a["P1 Left"] = false
  a["P1 Right"] = false
  a["P1 Up"] = false
  a["P2 Button"] = false
  a["P2 Down"] = false
  a["P2 Left"] = false
  a["P2 Right"] = false
  a["P2 Up"] = false
  a["Power"] = false
  a["Reset"] = false
  a["Select"] = false
  a["Toggle Left Difficulty"] = false
  a["Toggle Right Difficulty"] = false
  joypad.set(a)
end

--[[
This function advance a determinated number of frames.
]]
function fr(time,...)
  assert(#{...} == 0)
  assert(type(time) == "number")
  assert(time == math.floor(time))
  assert(math.abs(time) ~= math.huge)
  assert(time >= 0)
  for i = 1, time do
    emu.frameadvance()
  end
  clearJInput()
end

--[[
Hold button over the frames.
]]
function holdJInput(buttons, time,...)
  assert(#{...} == 0)
  assert(type(time) == "number")
  assert(time == math.floor(time))
  assert(math.abs(time) ~= math.huge)
  assert(time >= 1)
  jInput(unpack(buttons))
  for i = 1, time - 1 do
    fr(1)
    jInput(unpack(buttons))
  end
end

--[[
Periodic press of JInput
]]
function pressJInput(buttons, period, times,...)
  assert(#{...} == 0)
  assert(type(times) == "number")
  assert(times == math.floor(times))
  assert(times >= 1)
  jInput(unpack(buttons))
  for i = 1, times - 1 do
    fr(period)
    jInput(unpack(buttons))
  end
end

--[[
Return value at atari 2600's ram (System Bus)
]]
function atari2600ram(address,...)
  assert(#{...} == 0)
  assert(type(address) == "number")
  assert(address == math.floor(address))
  assert(address >= 0x00 and address <= 0x7f)
  assert(memory.getcurrentmemorydomain() == "System Bus")
  return memory.read_u8(address + 0x80)
end

--[[
Show value at atari 2600's ram (System Bus)
Infinite loop
]]
function showDataFromAtari2600ram(address,...)
  assert(#{...} == 0)
  while true do
    gui.text(100, 200, atari2600ram(address))
    emu.frameadvance()
  end
end
