{
## Clear environment
rm(list=ls())
## Dependencies
library(crayon)
## Load english 5 letter words
acceptable <- read.csv('fiveletterwords.csv', fileEncoding="UTF-8-BOM")
## Convert 'fiveletterwords.csv' into a list object
wordlist <- read.csv('wordlist.csv', fileEncoding="UTF-8-BOM")
## Sample wordlist to select goal word. Split goal word.
## Unlist() is used to return a list of length = n letters
goal_word <- sample(wordlist$wordlist, 1)
goal_word <- strsplit(goal_word, split = "")
goal_word <- as.list(unlist(goal_word))
## Prompt user to guess
guess1 <- readline(prompt = 'First guess: ')
## Reject guesses longer than 5 characters
while (nchar(guess1) != 5) {
    guess1 <- readline(noquote('Please guess a 5 character word: '))
    }
## Reject guesses that are not real words
is_acceptable <- guess1 %in% acceptable$wordlist
while (is_acceptable != TRUE) {
    guess1 <- readline(noquote('That word is not in the dictionary. Please guess again: '))
    is_acceptable <- guess1 %in% acceptable$wordlist
    while (nchar(guess1) != 5) {
        guess1 <- readline(noquote('Please guess a 5 character word: '))
        }
    }
rm(is_acceptable)
## Split guess string.
## Unlist() is used to return a list of length = n letters
guess1 <- strsplit(guess1, split = "")
guess1 <- as.list(unlist(guess1))
## Check if guess is in goal. Convert to matrix.
guess1_results <- as.list(unlist(lapply(guess1, 'grepl', x = goal_word)))
guess1_results_matrix <- matrix(guess1_results, nrow = 5, ncol = 5)
correct_guesses <- which(guess1_results_matrix == TRUE, arr.ind = TRUE) ##row = matching letter in goal; col = letter in guess

}
