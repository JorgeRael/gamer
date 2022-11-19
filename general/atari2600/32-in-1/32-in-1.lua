--[[
General functions used in 32-in-1 cartridge
]]

dofile("general\\atari2600\\atari2600.lua")

--[[
This function select a game at 32-in-1 cartridge
There are 32 games.
1-> Human Cannonball (1978)
2-> Basic Math (1977)
3-> 3-D Tic-Tac-Toe (1980)
4-> Flag Capture (1978)
5-> Othello (1980)
6-> Golf (1980)
7-> Surround (1977)
8-> Checkers (1980)
9-> Blackjack (1977)
10-> Freeway Rabbit (19??)
11-> Miniature Golf (1977)
12-> Football (1978)
13-> Slot Racers(1978)
14-> Fishing (19??)
15-> Space War (1978)
16-> Boxing (1980)
17-> Air-Sea Battle (1977)
18-> Freeway (1981)
19-> Tennis (1981)
20-> Combat (1977)
21-> Slot Machine (1979)
22-> Skiing (1980)
23-> Stampede (1981)
24-> Outlaw (1978)
25-> Fishing Derby (1980)
26-> Skydiver (1978)
27-> Laser Blast (1981)
28-> Basketball (1978)
29-> Cosmic Swarm (1982)
30-> Bowling (1978)
31-> Home Run (1978)
32-> Space Jockey (1982)
]]
function selectGame(game,...)
  assert(#{...} == 0)
  assert(type(game) == "number")
  assert(game == math.floor(game))
  assert(game >= 1 and game <= 32)
  clearJInput()
  startROM()
  if game == 2 then
    jInput("PW")
  elseif game >= 3 then
    jInput("PW")
    for i = 1, game - 2 do
      fr(1)
      jInput("PW")
    end
  end
end
