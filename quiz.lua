-- Help from : https://stackoverflow.com/questions/12069109/getting-input-from-the-user-in-lua, https://stackoverflow.com/questions/57343624/can-i-use-os-date-to-convert-seconds-to-time-format
-- Tested on Lua 5.4.2

local pSettings = io.open("./settings.lua", "r")
local pUtils = io.open("./utils.lua", "r")

if pSettings == nil or pUtils == nil then
    print("Required module / settings file not found, exiting...")
    os.exit(true)
end

io.close(pSettings)
io.close(pUtils)

local utils = require("utils")
local settings = require("settings")
local letters = {
    ["A"] = 1,
    ["B"] = 2,
    ["C"] = 3,
    ["D"] = 4,
    ["E"] = 5,
    ["F"] = 6,
    ["G"] = 7,
    ["H"] = 8,
    ["I"] = 9,
    ["J"] = 10,
    ["K"] = 11,
    ["L"] = 12,
    ["M"] = 13,
    ["N"] = 14,
    ["O"] = 15,
    ["P"] = 16,
    ["Q"] = 17,
    ["R"] = 18,
    ["S"] = 19,
    ["T"] = 20,
    ["U"] = 21,
    ["V"] = 22,
    ["W"] = 23,
    ["X"] = 24,
    ["Y"] = 25,
    ["Z"] = 26
}
local lasttime = utils.GetApproxTick()
local dt = nil
local gTimer = nil
local qNum = 1
local answeredIndex = {}
local answeredChoice = {} -- lazy hack number aaaa
local correctAnswer = {} -- another lazy hack aaaaaa
local questionIndex = {} -- i can't be bothered

if settings.EnableGlobalTimer then
    gTimer = settings.GlobalTimer
else
    gTimer = math.huge -- lazy hack
end

--[[local function devShowEndText()
    local answer = nil
    while true do
        print("Continue ? (type y for yes or n for no)")
        answer = io.read("*l")
        if string.lower(answer) == "y" then
            break
        elseif string.lower(answer) == "n" then
            os.exit(true)
        else
            print("Unrecognised input, please try again.")
        end
    end
end]]

local function formatTimer(sec)
    local hours = math.floor((sec % 86400) / 3600)
    local minutes = math.floor((sec % 3600) / 60)
    local seconds = math.floor(sec % 60)
    return tostring(string.format("%02d:%02d:%02d", hours, minutes, seconds))
end

local function showEndText(isTimeUp)
    local correctAnsIndex = 0
    if isTimeUp then
        print("Time is up!")
    else
        print("You have finished the quiz!")
    end
    utils.Wait(settings.WaitQuizFinished)
    for _aIndex, _answer in pairs(answeredChoice) do
        if type(correctAnswer[_aIndex]) == "string" and type(_answer) == "string" then
            if string.lower(correctAnswer[_aIndex]) == string.lower(_answer) then
                correctAnsIndex = correctAnsIndex + 1
            end
        else
            error("type(correctAnswer[_aIndex]) or type(_answer) doesn't return 'string'")
        end
    end
    print("Your grade is : " .. tostring(utils.Round(correctAnsIndex / #answeredChoice * 100)) .. "% (" .. tostring(correctAnsIndex) .. " / " .. #answeredChoice .. " question(s) answered right)")
    if settings.ReviewQuizOnFinished then
        print("Question reviews : \n")
        qNum = 1
        for _qIndex, _qTables in ipairs(settings.Questions) do
            for i = 1, #_qTables do
                local _opTables = _qTables[i] -- lazy code porting
                if type(_opTables) == "table" then
                    local optCount = 1
                    for _opIndex, _opName in ipairs(_opTables) do
                        if optCount <= 26 then
                            for _aAlphabet, _aIndex in pairs(letters) do
                                if _aIndex == _opIndex then
                                    print(tostring(_aAlphabet) .. ". " .. _opName) -- Prints options
                                    break
                                end
                            end
                            optCount = optCount + 1
                        else
                            warn("Warning : Too many options on question number " .. tostring(_qIndex) .. ", discarding options more than 26")
                            break
                        end
                    end
                    for _aIndex, _answer in pairs(answeredChoice) do
                        if type(correctAnswer[_aIndex]) == "string" and type(_answer) == "string" then
                            for _k = 1, #questionIndex do
                                local _qNum = questionIndex[_k]
                                if _aIndex == _qNum and _qIndex == _qNum then
                                    print("Your answer : " .. string.upper(answeredChoice[_k]) .. ", correct answer : " .. string.upper(correctAnswer[_k]) .. "\n") -- not necessary
                                    break
                                end
                            end
                        else
                            error("type(correctAnswer[_aIndex]) or type(_answer) doesn't return 'string'")
                        end
                    end
                    qNum = qNum + 1
                elseif type(_opTables) == "string" then
                    print(tostring(qNum) .. ". " .. tostring(_opTables)) -- Prints question name
                end
            end
        end
    end
    os.exit(true)
end

local function showQuestionIndex(_i)
    for _qIndex, _qTables in ipairs(settings.Questions) do
        for i = 1, #_qTables do
            local _opTables = _qTables[i] -- lazy code porting
            if _qIndex == _i then
                if type(_opTables) == "table" then
                    local optCount = 1
                    for _opIndex, _opName in ipairs(_opTables) do
                        if optCount <= 26 then
                            for _aAlphabet, _aIndex in pairs(letters) do
                                if _aIndex == _opIndex then
                                    print(tostring(_aAlphabet) .. ". " .. _opName) -- Prints options
                                    break
                                end
                            end
                            optCount = optCount + 1
                        else
                            warn("Warning : Too many options on question number " .. tostring(_qIndex) .. ", discarding options more than 26")
                            break
                        end
                    end
                elseif type(_opTables) == "string" then
                    print(tostring(qNum) .. ". " .. tostring(_opTables)) -- Prints question name
                else
                    local input = nil
                    while true do
                        io.write("Your answer : ")
                        input = io.read("*l")
                        -- does this even work properly?
                        if input ~= nil then
                            local canBreak = false
                            for j = 1, #_qTables do
                                local _opTablesAns = _qTables[j] -- lazy code porting again
                                if type(_opTablesAns) == "table" then
                                    for _opIndex in ipairs(_opTablesAns) do
                                        for _aAlphabet, _aIndex in pairs(letters) do
                                            if _aIndex == _opIndex then
                                                if settings.PrintLog then
                                                    print("Log : Input received : " .. input .. ", choices index : " .. _opIndex .. ", choice at current index : " .. _aAlphabet)
                                                end
                                                if string.lower(input) == string.lower(_aAlphabet) then
                                                    if settings.PrintLog then
                                                        print("Log : Input matched one of the _aAlphabet at index " .. _opIndex)
                                                    end
                                                    canBreak = true
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if canBreak then
                                break
                            end
                            print("Invalid choice, please try again.")
                        else
                            print("Don't input key combinations like Ctrl+Z or Ctrl+A")
                        end
                    end
                    for _pAlphabet, _pAlphabetIndex in pairs(letters) do
                        -- maybe it's fixed now
                        if string.lower(input) == string.lower(_pAlphabet) and settings.Questions[_qIndex][3] == _pAlphabetIndex then
                            table.insert(correctAnswer, _pAlphabet) -- bruh
                            if settings.ShowAnswerOnSubmit then
                                print("Correct answer!")
                            else
                                print("Answer submitted")
                            end
                            break
                        else
                            if settings.Questions[_qIndex][3] == _pAlphabetIndex then
                                table.insert(correctAnswer, _pAlphabet) -- bruh
                                if settings.ShowAnswerOnSubmit then
                                    print("Incorrect answer, the right answer is : " .. tostring(_pAlphabet) .. ". " .. settings.Questions[_qIndex][2][settings.Questions[_qIndex][3]] .. "\n") -- lmao
                                else
                                    print("Answer submitted\n")
                                end
                                break
                            end
                        end
                    end
                    table.insert(answeredChoice, string.lower(input))
                    table.insert(answeredIndex, _qIndex)
                    table.insert(questionIndex, _i)
                end
            end
        end
    end
    return true
end

while true do
    if gTimer > 0 then
        dt = utils.GetApproxTick() - lasttime
        lasttime = utils.GetApproxTick()
        math.randomseed(utils.Round(utils.GetApproxTick()))
        if settings.RandomizeQuestionOrder then
            local qRandomIndex = utils.Round(math.random(1, #settings.Questions))
            local repeatGen = true
            if #answeredIndex >= #settings.Questions then
                repeatGen = false
                showEndText(false)
            else
                if settings.EnableGlobalTimer then
                    gTimer = gTimer - dt
                    print("Time left : " .. tostring(formatTimer(gTimer)))
                end
            end
            while repeatGen do
                repeatGen = false
                for _i = 1, #answeredIndex do
                    if qRandomIndex == answeredIndex[_i] then
                        -- Is there a deadly bug in here?, because this is only printing at the end of the questions
                        if settings.PrintLog then
                            print("Log : Regenerating qRandomIndex, the value was " .. tostring(qRandomIndex))
                        end
                        qRandomIndex = utils.Round(math.random(1, #settings.Questions))
                        repeatGen = true
                        break
                    end
                end
            end
            local status = showQuestionIndex(qRandomIndex)
            if not status then
                error("showQuestionIndex returns something other than true")
            end
        else
            local status = showQuestionIndex(qNum)
            if not status then
                error("showQuestionIndex returns something other than true")
            end
        end
        qNum = qNum + 1
        --devShowEndText() for debugging
    else
        showEndText(true)
    end
end