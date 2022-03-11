# Wordle
This is my interpretation of the word guessing game Wordle/Lingo, written in PowerShell.
The game supports an English word list (default), which is the same as the one Wordle uses. Optionally, you can play in Dutch (word list only, not the interface). This list is not so strong, but it's playable.

## Rules
The game needs you to find a five letter word. You have six guesses, after which you will lose if it is not correct.
After each guess, your guess will be shown with the following hints:
- Letters that are in the word, but in the incorrect place, will be colored yellow.
- Letters that are on the correct place, will be colored green.

## To do:
- Indicate the correct amount of letters when multiple are guessed (when you guess HELLO now and the word is LABOR, it will show two yellow L's)
- Show list of letters with their indication (unused / not in word / in word / correct place), like in Wordle

