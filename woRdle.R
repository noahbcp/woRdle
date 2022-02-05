{
## Dependencies
crayon <- require(crayon)
if (crayon == FALSE) {install.packages('crayon')}
library(crayon)
## Clean environment; check for arguments. Use 'unlimit' for unlimited guesses.
rm(list=ls())
args <- commandArgs()
## Load English 5 letter words
acceptable <- read.csv('fiveletterwords.csv', fileEncoding = "UTF-8-BOM")
wordlist <- read.csv('wordlist.csv', fileEncoding = 'UTF-8-BOM')
## Find goal word
actual <- sample(wordlist$wordlist, 1)
actual_raw <- charToRaw(actual)
## Limit guess count
max_guess <- if ('unlimit' %in% args) {99999} else {6}
guess_count <- 1
## Create remaining set
remaining <- as.raw(c(1:5))
while (guess_count <= max_guess) {
    guess <- readline(noquote(paste('Enter a 5 character word ','(guess ', guess_count, ' / ', max_guess, '): ', sep = "")))
    guess <- tolower(guess)
    guess_raw <- charToRaw(guess)
    guess_count <- guess_count + 1
    is_acceptable <- guess %in% acceptable$wordlist
    if (is_acceptable != TRUE) {
        guess_count <- guess_count - 1
        readline(noquote(paste('Sorry, that word is not acceptable.')))
        guess <- readline(noquote(paste('Enter a 5 character word ','(guess ', guess_count, ' / ', max_guess, '): ', sep = "")))
    }
    if (actual == guess) {
        readline('You guessed right!')
        cat(bgGreen(guess))
        opt <- options(show.error.messages = FALSE)
        on.exit(options(opt))
        stop()
    }
    i = 0
    while (i < length(actual_raw)) {
        i <- (i + 1)
        if (actual_raw[i] != guess_raw[i]) {
            remaining[i] <- actual_raw[i]
        }
    }
    i = 0
    while (i <= length(actual_raw)) {
        i <- (i + 1)
        if (actual_raw[i] != guess_raw[i]) {
            if (guess_raw[i] %in% remaining) {
                cat(bgYellow(rawToChar(guess_raw[i])))
                remaining <- remaining[-i]
            } else (cat(bgRed(rawToChar(guess_raw[i]))))
        } else (cat(bgGreen(rawToChar(guess_raw[i]))))
    }
}
}