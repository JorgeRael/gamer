--[[
Declare general functions that can be used by any game
]]

--[[
Call saveslot 1, where should be at the begining of frames
]]
function startROM(...)
  assert(#{...} == 0)
  savestate.loadslot(1)
  assert(emu.framecount() == 0)
end


--[[
Show value on screen.
]]
function show(message,...)
  assert(#{...} == 0)
  gui.text(100, 200, message)
end

--[[
Show value on screen at an infinite loop.
]]
function showAndHold(message,...)
  assert(#{...} == 0)
  while true do
    gui.text(100, 200, message)
    emu.frameadvance()
  end
end

--[[
Show value on screen and pause.
]]
function showAndPause(message,...)
  assert(#{...} == 0)
  gui.text(100, 200, message)
  client.pause()
end

--[[
Show info about pressed buttons at console.
]]
function lastButtons(...)
  assert(#{...} == 0)
  console.log(joypad.getimmediate())
end