{
## Dependencies
## Crayon required to facilitate coloured terminal output
crayon <- require(crayon)
if (crayon == FALSE) {install.packages('crayon')}
library(crayon)
## Clean environment; check for arguments. Use 'unlimit' for unlimited guesses.
## Sets up scoring system
rm(list = ls())
args <- commandArgs()
## Load English 5 letter words; selects goal word from 300 most common.
acceptable <- read.csv('fiveletterwords.csv', fileEncoding = "UTF-8-BOM")
wordlist <- read.csv('fiveletterwords.csv', fileEncoding = "UTF-8-BOM", nrows = 300)
actual <- sample(wordlist$wordlist, 1)
## Converts to raw to allow diffs to be calculated
actual_raw <- charToRaw(toupper(actual))
## Limit guess count; set up replay function
max_guess <- if ('unlimit' %in% args) {99999} else {6}
guess_count <- 1
## Remaining vector serves to store letters not yet correctly guessed
remaining <- actual_raw
## Loops provided guess_count is less than max (default = 6)
while (guess_count <= max_guess) {
    guess <- readline(noquote(paste('Enter a 5 character word ','(guess ', guess_count, ' / ', max_guess, '): ', sep = "")))
    guess <- tolower(guess)
    guess_raw <- charToRaw(toupper(guess))
    guess_count <- guess_count + 1
    ## Checks to see if guess is 5 characters and a real word
    is_acceptable <- guess %in% acceptable$wordlist
    if (is_acceptable != TRUE) {
        guess_count <- guess_count - 1
        readline(noquote(paste('Sorry, that word is not acceptable.')))
    } else {
    }
    ## i keeps track of the position in the word. i.e. for 'think', i[2] = 'h'
    i = 0
    while ((i < length(actual_raw)) && (is_acceptable == TRUE)) {
        i <- (i + 1)
        ## Checks whether the letter is in the correct position (i) then
        ## whether the letter is in the word at all. Prints yellow
        ## if letter is in word but wrong position otherwise prints red
        ## if neither statement satisfied prints green as letter must be in
        ## correct position
        if (actual_raw[i] != guess_raw[i]) {
            if (guess_raw[i] %in% remaining) {
                cat(bold(bgYellow(' ', rawToChar(guess_raw[i]), ' '), ' '))
                remaining <- remaining[-i]
            } else (cat(bold(bgRed(' ', rawToChar(guess_raw[i]), ' '), ' ')))
        } else (cat(bold(bgGreen(' ', rawToChar(guess_raw[i]), ' '), ' ')))
    }
    if (guess == actual) {readline("That's correct, Nice work!")
        ## Adjust guess_count to true number (caused by count starting at 1)
        guess_count <- guess_count - 1
        ## Add score to scores.csv; print out a histogram of scores
        write.table(guess_count, file = 'scores.csv', append = TRUE, row.names = FALSE, col.names = FALSE)
        score_history <- read.csv('scores.csv')
        hist(score_history$score, freq = TRUE, main = 'Scores', xlab = 'Score', ylab = 'Count')
        ## Silently exit program
        opt <- options(show.error.messages = FALSE)
        on.exit(options(opt))
        stop()
    }
}
readline('Oops! Better luck next time...')
}
