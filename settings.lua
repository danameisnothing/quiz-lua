local settings = {}

settings.EnableGlobalTimer = true -- If this is false, there is unlimited time
settings.GlobalTimer = 2147483647 -- In seconds, don't set this if you disable the EnableGlobalTimer, and set this to be larger than 5 seconds
settings.RandomizeQuestionOrder = true
settings.RandomizeOptionOrder = true -- Currently non-functional
settings.WaitQuizFinished = 1 -- In seconds, sets the wait time after the quiz has been finished
settings.ShowAnswerOnSubmit = true -- Shows the correct answer upon entering a response
settings.PrintLog = true -- Prints the debug message that were used to debug possible problems
settings.ReviewQuizOnFinished = true -- Shows all of the questions and answers to each questions at the end of the quiz

-- Remember, lua tables starts at index 1, and please don't try and break it :(, question have to be a string
settings.Questions = {
    {"what's 1+1", {
        "0",
        "1",
        "2",
        "2147483647"
    }, 3},

    {"what's 10+9", {
        "19",
        "21"
    }, 1},

    {"what's 3+9", {
        "13",
        "12"
    }, 2},

    {"who is mark zuckerberg?", {
        "the facebook",
        "ceo of book",
        "ceo of the nothing company",
        "ceo of facebook (maybe)"
    }, 4}
}

return settings