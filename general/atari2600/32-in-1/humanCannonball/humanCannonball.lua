--[[
Functions to be used in Human Cannonball.
]]

dofile("general\\atari2600\\32-in-1\\32-in-1.lua")

--[[
Flying man y position.
It is 211 when he is on the ground.
The higher the man is, the lower this value.
]]
function posyMan(...)
  assert(#{...} == 0)
  return memory.readbyte(0x0d + 0x80)
end

--[[
Man's speed at launch.
Equal to value on screen.
]]
function currentSpeed(...)
  assert(#{...} == 0)
  return memory.readbyte(0x19 + 0x80)
end

--[[
Show current player
0-> Player 1
1-> Player 2
]]
function currentPlayer(...)
  assert(#{...} == 0)
  return memory.readbyte(0x35 + 0x80)
end

--[[
Show the number on Left
Used in Success verify
]]
function numberOnScreenLeft(...)
  assert(#{...} == 0)
  return memory.readbyte(0x36 + 0x80)
end

--[[
Show the number on Right
Used in Success verify
]]
function numberOnScreenRight(...)
  assert(#{...} == 0)
  return memory.readbyte(0x37 + 0x80)
end

--[[
Current Angle in hexa
Ex.: 96 is 60 because   96 = 0x60
]]
function currentAngleHex(...)
  assert(#{...} == 0)
  return memory.readbyte(0x39 + 0x80)
end

--[[
Cannon angle
Equal to value on screen.
]]
function currentAngle(...)
  assert(#{...} == 0)
  return memory.readbyte(0x42 + 0x80)
end

--[[
Number of players
]]
function numberOfPlayers(...)
  assert(#{...} == 0)
  return memory.readbyte(0x43 + 0x80)
end

--[[
Flying man x position.
]]
function posxCannon(...)
  assert(#{...} == 0)
  return memory.readbyte(0x44 + 0x80)
end

--[[
Current dificulty level.
]]
function currentDiffculty(...)
  assert(#{...} == 0)
  return memory.readbyte(0x4e + 0x80)
end

--[[
Jogo selecionado
]]
function numberOfGame(...)
  assert(#{...} == 0)
  return memory.readbyte(0x51 + 0x80)
end

--[[
Posição x do homem em voo
]]
function posxMan(...)
  assert(#{...} == 0)
  return memory.readbyte(0x52 + 0x80)
end

--[[
Begin Human Cannonball (1978)
There are 8 subgames:
1->Control angle
2->Control angle, Far
3->Controls angle, Controls speed
4->Control distance
5->Control angle, Wall
6->Controls angle, Far, Wall
7->Control angle, Control speed, Wall
8-> Remote Control, Wall
1 or 2 players
two levels of difficulty
]]
function selectHumanCannonball(game, players, difficulty,...)
  assert(#{...} == 0)
  assert(type(game) == "number")
  assert(game == math.floor(game))
  assert(game >= 1 and game <= 8)
  assert(players == 1 or players == 2)
  assert(difficulty == 1 or difficulty == 2)
  selectGame(1)
  if difficulty == 2 then
    jInput("LD")
  end
  for i = 1, 2 * game + players - 3 do
    fr(2)
    jInput("SL")
  end
  fr(1)
  jInput("RS")
end

--[[
Change Cannon angle
It recognize current player
If it's already at final place, this function does not do anything
]]
function changeAngle(finalAngle,...)
  assert(#{...} == 0)
  assert(type(finalAngle) == "number")
  assert(finalAngle == math.floor(finalAngle))
  assert(finalAngle >= 20 and finalAngle <= 80)
  local player = currentPlayer() + 1
  while currentAngle() > finalAngle + 1 do
    if emu.framecount() % 16 == 1 then
      jInput("D"..tostring(player))
      fr(1)
    else
      fr(1)
    end
  end
  while currentAngle() < finalAngle - 1 do
    if emu.framecount() % 16 == 1 then
      jInput("U"..tostring(player))
      fr(1)
    else
      fr(1)
    end
  end
  while emu.framecount() % 16 ~= 1 and currentAngle() ~= finalAngle do
    fr(1)
  end
  if currentAngle() > finalAngle then
    jInput("D"..tostring(player))
  elseif currentAngle() < finalAngle then
    jInput("U"..tostring(player))
  end
end

--[[
Wait until variation at numbers on screen.
]]
function waitUntilPoint(...)
  assert(#{...} == 0)
  local a = numberOnScreenLeft() + numberOnScreenRight()
  while numberOnScreenLeft() + numberOnScreenRight() == a do
    fr(1)
  end
end

--[[
Used in middle game.
It recognize current player
If it's already at final place, this function only shoot.
]]
function fireAtAngle(finalAngle,...)
  assert(#{...} == 0)
  assert(type(finalAngle) == "number")
  assert(finalAngle == math.floor(finalAngle))
  assert(finalAngle >= 20 and finalAngle <= 80)
  local player = currentPlayer() + 1
  if currentAngle() ~= finalAngle then
    changeAngle(finalAngle)
    fr(1)
    jInput("B"..tostring(player))
  else
    jInput("B"..tostring(player))
  end
end
