local function isIn(t, s)
    -- Return if s is in t
    for _, v in pairs(t) do
        if v == s then
            return true
        end
    end
    return false
end

local function initRessourceList()
    -- Return a table with all minecraft ressources
    local t = {"minecraft:diamond_ore", "minecraft:deepslate_diamond_ore", "minecraft:coal_ore",
               "minecraft:deepslate_coal_ore", "minecraft:iron_ore", "minecraft:deepslate_iron_ore",
               "minecraft:copper_ore", "minecraft:deepslate_copper_ore", "minecraft:gold_ore",
               "minecraft:deepslate_gold_ore", "minecraft:redstone_ore", "minecraft:deepslate_redstone_ore",
               "minecraft:emerald_ore", "minecraft:deepslate_emerald_ore", "minecraft:lapis_ore",
               "minecraft:deepslate_lapis_ore", "minecraft:ancient_debris", "minecraft:nether_quartz_ore",
               "minecraft:nether_gold_ore"}
    return t
end

local function getCurrentCoordinateX(x, d, orientation)
    -- return current x of the turtle with distance apply or not to x
    if orientation == "E" then
        return x + d
    elseif orientation == "W" then
        return x - d
    end
    return x
end

local function getCurrentCoordinateZ(z, d, orientation)
    -- return current z of the turtle with distance apply or not to z
    if orientation == "S" then
        return z + d
    elseif orientation == "N" then
        return z - d
    end
    return z
end

local function getRednetMessage(s, sx, sz, dist, facing)
    -- s for remove or add
    -- return forceload s sx sz with distance applied by f
    local str = "forceload " .. s
    str = str .. tostring(getCurrentCoordinateX(sx, dist - 1, facing)) .. " " ..
              tostring(getCurrentCoordinateZ(sz, dist - 1, facing))
    return str
end

local function __checkBlock(t, c, s, d)
    -- check if d is in t if is in then dig else do nothing.
    if s then
        if isIn(t, d.name) then
            c()
        end
    end
end

local function digRessources(t)
    -- dig ressource next to the turtle
    __checkBlock(t, turtle.digUp, turtle.inspectUp())
    __checkBlock(t, turtle.digDown, turtle.inspectDown())
    turtle.turnLeft()
    __checkBlock(t, turtle.dig, turtle.inspect())
    turtle.turnRight()
    turtle.turnRight()
    __checkBlock(t, turtle.dig, turtle.inspect())
    turtle.turnLeft()
end

local function printf(s, clear)
    -- better print for s
    if clear then
        term.clear()
        term.setCursorPos(1, 1)
    end
    term.setCursorBlink(true)
    textutils.slowWrite(s)
end

local function backward(dist)
    -- Turtle back to the start.
    while dist ~= 0 do
        turtle.back()
        dist = dist - 1
    end
end

local function refuel()
    for i = 1, 16, 1 do
        turtle.select(i)
        turtle.refuel()
    end
    turtle.select(1)
end

local function canDig(fuelLevel, distance)
    -- Return if a turtle can keep going mining.
    if fuelLevel > distance then
        return true
    end
    refuel()
    return turtle.getFuelLevel() > distance
end

local function digStep(rl)
    turtle.dig()
    turtle.forward()
    digRessources(rl)
end

-- constent
local ressourceList = initRessourceList()

-- parameter
-- printf("Enter x location of the turtle :", true)
local startX = 0 -- tonumber(read(), 10)

-- printf("Enter z location of the turtle :", false)
local startZ = 0 -- tonumber(read(), 10)

-- printf("Enter facin of the turtle (N, E, S, W) :", false)
local facing = "E" -- read()

-- printf("Enter location of the modem (left or right) :", false)
rednet.open("left") -- read()

printf("", true)

-- turtle property
local maxDistance = 0
local distance = 0

refuel()
local fuelLevel = turtle.getFuelLevel()

local run = true

while run do
    if distance % 16 == 0 then
        rednet.broadcast(getRednetMessage("remove ", startX, startZ, distance - 1, facing))
        sleep(1)
        rednet.broadcast(getRednetMessage("add ", startX, startZ, distance, facing))
    end
    distance = distance + 1
    if canDig(fuelLevel, distance) then
        if (distance - 1) < maxDistance then
            turtle.forward()
        else
            digStep(ressourceList)
        end
        
    else
        if distance - 1 > maxDistance then
            maxDistance = distance - 1
        end
        backward(distance - 1)
        distance = 0
    end

    fuelLevel = turtle.getFuelLevel()
end
