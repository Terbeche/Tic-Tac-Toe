local grid = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}
local gridSymbols = {{"", "", ""}, {"", "", ""}, {"", "", ""}}

local currentPlayer = 0
local playerSymbol = ""
local playerTurn = false
local screenWidth = love.graphics.getWidth()
local screenHeight = love.graphics.getHeight()
local button = {

    width = 180,
    height = 100,
    x = (screenWidth - 3 * 180) / 2,
    y = (screenHeight - 3 * 100) / 2,
    text = ""
}

function isInsideButton(x, y, button)
    for row, rowValues in ipairs(grid) do
        for col, value in ipairs(rowValues) do
            local cellX = button.x + (col - 1) * button.width
            local cellY = button.y + (row - 1) * button.height

            if x > cellX and x < cellX + button.width and y > cellY and y < cellY + button.height then

                return true, row, col
            end
        end
    end

    return false
end

function checkEnd()
    for row = 1, 3 do
        if gridSymbols[row][1] ~= "" and gridSymbols[row][1] == gridSymbols[row][2] and gridSymbols[row][2] ==
            gridSymbols[row][3] then
            print("Game ended. Winner: " .. gridSymbols[row][1])
            return true
        end
    end

    for col = 1, 3 do
        if gridSymbols[1][col] ~= "" and gridSymbols[1][col] == gridSymbols[2][col] and gridSymbols[2][col] ==
            gridSymbols[3][col] then
            print("Game ended. Winner: " .. gridSymbols[1][col])
            return true
        end
    end

    if gridSymbols[1][1] ~= "" and gridSymbols[1][1] == gridSymbols[2][2] and gridSymbols[2][2] == gridSymbols[3][3] then
        print("Game ended. Winner: " .. gridSymbols[1][1])
        return true
    end

    if gridSymbols[1][3] ~= "" and gridSymbols[1][3] == gridSymbols[2][2] and gridSymbols[2][2] == gridSymbols[3][1] then
        print("Game ended. Winner: " .. gridSymbols[1][3])
        return true
    end

    -- Check for tie
    local tie = true
    for row, rowValues in ipairs(gridSymbols) do
        for col, symbol in ipairs(rowValues) do
            if symbol == "" then
                tie = false
                break
            end
        end
    end
    if tie then
        print("Game ended in a tie.")
        return true
    end

    return false
end

function aiPlay(aiSymbol)

    local row, col = getAiMove()
    gridSymbols[row][col] = aiSymbol
    playerTurn = true
    print("AI played " .. aiSymbol .. " at " .. row .. ", " .. col)
    endGame = checkEnd()
    if endGame then
        return
    end
end

function getAiMove()
    local availableCells = {}
    for row, rowValues in ipairs(gridSymbols) do
        for col, symbol in ipairs(rowValues) do
            if symbol == "" then
                table.insert(availableCells, {row, col})
            end
        end
    end
    local index = math.random(#availableCells)
    return unpack(availableCells[index])
end

function love.mousepressed(x, y, buttonPressed)
    if endGame then
        return
    end
    if not playerTurn then
        return
    end

    if buttonPressed == 1 then
        local insideButton, row, col = isInsideButton(x, y, button)

        if insideButton then
            if gridSymbols[row][col] == "" then
                gridSymbols[row][col] = playerSymbol
                print("Player 1 played " .. playerSymbol .. " at " .. row .. ", " .. col)
                endGame = checkEnd()
                if endGame then
                    return
                end
                aiPlay(aiSymbol)
                playerTurn = true
            end
        end
    end

end

function love.load()
    currentPlayer = math.random(2)

    currentPlayer = 1
    if math.random(2) == 1 then
        playerSymbol = "X"
        aiSymbol = "O"
    else
        playerSymbol = "O"
        aiSymbol = "X"
    end

    if currentPlayer == 1 then
        playerTurn = true
    else
        playerTurn = false
        aiPlay(aiSymbol)
    end

end

function love.update(dt)
end

function love.draw()

    for row, rowValues in ipairs(grid) do
        for col, value in ipairs(rowValues) do
            local cellX = button.x + (col - 1) * button.width
            local cellY = button.y + (row - 1) * button.height

            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", cellX, cellY, button.width, button.height)

            if gridSymbols[row][col] ~= "" then
                love.graphics.setColor(1, 0, 0)
                love.graphics.print(gridSymbols[row][col], cellX + button.width / 2, cellY + button.height / 2)
            end
        end
    end
end

