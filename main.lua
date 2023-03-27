local grid = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}}
local gridSymbols = {{"", "", ""}, {"", "", ""}, {"", "", ""}}

local currentPlayer = 0
local playerSymbol = ""

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

function love.mousepressed(x, y, buttonPressed)
    if not playerTurn then
        return
    end

    if buttonPressed == 1 then
        local insideButton, row, col = isInsideButton(x, y, button)

        if insideButton then
            if gridSymbols[row][col] == "" then
                if currentPlayer == 1 then
                    gridSymbols[row][col] = playerSymbol
                    print("Player 1 played " .. playerSymbol .. " at " .. row .. ", " .. col)

                else
                    -- aiPlay(aiSymbol)
                end

                playerTurn = not playerTurn
            end
        end
    end
end

function love.load()
    -- currentPlayer = math.random(2)
    currentPlayer = 1
    playerTurn = false
    if math.random(2) == 1 then
        playerSymbol = "X"
        aiSymbol = "O"
    else
        playerSymbol = "O"
        aiSymbol = "X"
    end

    if currentPlayer == 1 then
        playerTurn = true
        -- playerPlay(playerSymbol)
    else
        playerTurn = false
        print("AI's turn")
        print('Ai playing  with ' .. aiSymbol)
        aiPlay(aiSymbol, button.x + button.width, button.y + button.height)
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
        end
    end

    for row, rowValues in ipairs(gridSymbols) do
        for col, symbol in ipairs(rowValues) do
            local cellX = button.x + (col - 1) * button.width
            local cellY = button.y + (row - 1) * button.height
            if symbol ~= "" then

                love.graphics.setColor(1, 0, 0)
                love.graphics.print(symbol, cellX + button.width / 2, cellY + button.height / 2)
            end
        end
    end
end
