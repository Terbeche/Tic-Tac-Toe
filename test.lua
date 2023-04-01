function getAiMove()
    local bestScore = -math.huge
    local move

    for row, rowValues in ipairs(gridSymbols) do
        for col, symbol in ipairs(rowValues) do
            if symbol == "" then
                gridSymbols[row][col] = aiSymbol
                local score = minimax(gridSymbols, 0, false, -math.huge, math.huge)
                gridSymbols[row][col] = ""
                if score > bestScore then
                    bestScore = score
                    move = {row, col}
                end
            end
        end
    end

    return unpack(move)
end

function minimax(gridSymbols, depth, isMaximizingPlayer, alpha, beta)
    local score = evaluate(gridSymbols)

    if score == 10 then
        return score - depth
    elseif score == -10 then
        return score + depth
    elseif isBoardFull(gridSymbols) then
        return 0
    end

    if isMaximizingPlayer then
        local bestScore = -math.huge
        for row, rowValues in ipairs(gridSymbols) do
            for col, symbol in ipairs(rowValues) do
                if symbol == "" then
                    gridSymbols[row][col] = aiSymbol
                    bestScore = math.max(bestScore, minimax(gridSymbols, depth + 1, false, alpha, beta))
                    gridSymbols[row][col] = ""
                    alpha = math.max(alpha, bestScore)
                    if beta <= alpha then
                        break
                    end
                end
            end
        end
        return bestScore
    else
        local bestScore = math.huge
        for row, rowValues in ipairs(gridSymbols) do
            for col, symbol in ipairs(rowValues) do
                if symbol == "" then
                    gridSymbols[row][col] = playerSymbol
                    bestScore = math.min(bestScore, minimax(gridSymbols, depth + 1, true, alpha, beta))
                    gridSymbols[row][col] = ""
                    beta = math.min(beta, bestScore)
                    if beta <= alpha then
                        break
                    end
                end
            end
        end
        return bestScore
    end
end

function evaluate(gridSymbols)
    for row = 1, 3 do
        if gridSymbols[row][1] ~= "" and gridSymbols[row][1] == gridSymbols[row][2] and gridSymbols[row][2] ==
            gridSymbols[row][3] then
            if gridSymbols[row][1] == aiSymbol then
                return 10
            else
                return -10
            end
        end
    end

    for col = 1, 3 do
        if gridSymbols[1][col] ~= "" and gridSymbols[1][col] == gridSymbols[2][col] and gridSymbols[2][col] ==
            gridSymbols[3][col] then
            if gridSymbols[1][col] == aiSymbol then
                return 10
            else
                return -10
            end
        end
    end

    if gridSymbols[1][1] ~= "" and gridSymbols[1][1] == gridSymbols[2][2] and gridSymbols[2][2] == gridSymbols[3][3] then
        if gridSymbols[1][1] == aiSymbol then
            return 10
        else
            return -10
        end
    end

    if gridSymbols[1][3] ~= "" and gridSymbols[1][3] == gridSymbols[2][2] and gridSymbols[2][2] == gridSymbols[3][1] then
        if gridSymbols[1][3] == aiSymbol then
            return 10
        else
            return -10
        end
    end

    return 0 -- no winner
end
