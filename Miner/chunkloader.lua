rednet.open("left")
while true do
    local id, msg = rednet.receive()
    print(msg)
    commands.exec(msg)
end