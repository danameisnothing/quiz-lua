local utils = {}

local start = os.time() + 1

-- Returns true if the number is positive, and false if it's not
function utils.IsPositive(num)
	if num then
        if type(num) ~= "number" then
            error("Argument received is not the type 'number'")
        end

        if num < 0 then
            return false
        elseif num > 0 then
            return true
        else
            warn("Neutral")
        end
    else
        error("Argument passed is invalid")
    end
end

-- Returns the biggest number in a table
function utils.Biggest(table)
    local biggestNum = nil
    if type(table) ~= "table" then
        error("Argument received is not the type 'table'")
    end

    for _k, _v in pairs(table) do
        if type(_v) == "number" then
            if not biggestNum and _k == 1 then
                biggestNum = _v
                -- no continue statement :(
            end
            if biggestNum < _v then
                biggestNum = _v
            end
        else
            return nil
        end
    end
    return biggestNum
end

-- Returns the smallest number in a table
function utils.Smallest(table)
    local smallestNum = nil
    if type(table) ~= "table" then
        error("Argument received is not the type 'table'")
    end

    for _k, _v in pairs(table) do
        if type(_v) == "number" then
            if not smallestNum and _k == 1 then
                smallestNum = _v
                -- no continue statement :(
            end
            if smallestNum > _v then
                smallestNum = _v
            end
        else
            return nil
        end
    end
    return smallestNum
end

-- Rounds the number to the nearest whole number
function utils.Round(num)
    if type(num) ~= "number" then
        error("Argument received is not the type 'number'")
    end

    if utils.IsPositive(num) then
        if num - math.floor(num) < 0.5 then
            return math.floor(num)
        else
            return math.ceil(num)
        end
    elseif not utils.IsPositive(num) then
        if (num * -1) + math.ceil(num) > 0.5 then
            return math.floor(num)
        else
            return math.ceil(num)
        end
    else
        error("The function 'utils:positive()' returns values other than true or false")
    end
end

-- Returns the number in positive form
function utils.ToPositive(num)
    if type(num) ~= "number" then
        error("Argument received is not the type 'number'")
    end

    if not utils.IsPositive(num) then
        return num * -1
    end
    return num
end

-- Returns the approximate amount of time in seconds since the unix epoch according to this device's start time and the cpu time used by the program
function utils.GetApproxTick()
    return start + os.clock()
end

-- Yields the current thread until the specified amount of time in seconds have elapsed
function utils.Wait(second)
    if second ~= nil and second > 0 then
        if type(second) ~= "number" then
            error("Argument received is not the type 'number'")
        end
    
        local target = utils:GetApproxTick() + second
        while utils:GetApproxTick() < target do
            -- do nothing
        end 
    else
        local target = utils:GetApproxTick() + 0.01
        while utils:GetApproxTick() < target do
            -- do nothing
        end
    end
end

-- Prints the contents of a table
function utils.DebugPrintTable(table)
    if type(table) ~= "table" then
        error("Argument received is not the type 'table'")
    end

    for _k, _v in pairs(table) do
        print("Index " .. tostring(_k) .. " : " .. tostring(_v))
    end
    return true
end

-- Truncates the string into a table, Help from : https://stackoverflow.com/questions/41463421/lua-split-string-by-semicolon
function utils.TruncateSpace(str)
    if type(str) ~= "string" then
        error("Argument received is not the type 'string'")
    end

    local parsed = {}
    for token in string.gmatch(str, "[^ ]+") do
        table.insert(parsed, token)
    end
	return parsed
end

return utils