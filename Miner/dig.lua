local function getCurrentCoordinateX(x, d, orientation)
    if orientation == "E" then
        return x + d
    elseif orientation == "W" then
        return x - d
    end
    return x
end

local function getCurrentCoordinateZ(z, d, orientation)
    if orientation == "S" then
        return z + d
    elseif orientation == "N" then
        return z - d
    end
    return z
end

--parameter
local startX = -144
local startZ = -134
local facing = "E"
rednet.open("left")
--

local distance = 0


local run = true

while run do
    if distance % 16 == 0 then
        rednet.broadcast("forceload remove " ..
        tostring(
            getCurrentCoordinateX(startX, distance - 1, facing)
        ).. " " .. tostring(
            getCurrentCoordinateZ(startZ, distance - 1, facing)
        ))
        sleep(1)
        rednet.broadcast("forceload add " ..
        tostring(
            getCurrentCoordinateX(startX, distance, facing)
        ).. " " .. tostring(
            getCurrentCoordinateZ(startZ, distance, facing)
        ))
    end
    turtle.forward()
    distance = distance + 1
end
