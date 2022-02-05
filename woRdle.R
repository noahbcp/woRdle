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
## Limit guess count
max_guess <- if ('unlimit' %in% args) {99999} else {6}
guess_count <- 1
while (guess_count == 1 & guess_count <= max_guess & guess_count + 1 ) {
    guess <- readline(noquote(paste('Enter a 5 character word ','(guess ', guess_count, ' / ', max_guess, '): ', sep = "")))
    guess <- tolower(guess)
    is_acceptable <- guess %in% acceptable$wordlist
    ##Check that guesses are valid
    if (nchar(guess) != 5) {
        guess <- readline(noquote(paste('You must enter a 5 character word ', '(guess ', guess_count, ' / ', max_guess, '): ', sep = "")))
    }
    ## Reject guesses that are not real words
    is_acceptable <- guess %in% acceptable$wordlist
    if (is_acceptable != TRUE) {
        guess <- readline(noquote(paste('That word is not in the dictionary. Please guess again ', '(guess ', guess_count, ' / ', max_guess, '): ', sep = "")))
        is_acceptable <- guess %in% acceptable$wordlist
        if (nchar(guess) != 5) {
            guess <- readline(noquote(paste('You must enter a 5 character word: ', '(guess ', guess_count, ' / ', max_guess, '): ', sep = "")))
        }
    }
}
}
