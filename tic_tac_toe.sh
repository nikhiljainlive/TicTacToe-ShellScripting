#!/usr/local/bin/bash -x

#This file contains Tic-Tac-Toe Game logic

ROWS=3
COLUMNS=3
INITIAL_SYMBOL="-"
declare -A board

initBoard() {
	for (( row = 0; row < ROWS; row++ )); do
		for (( column = 0; column < COLUMNS; column++ )); do
			board[$row,$column]=$INITIAL_SYMBOL
		done
	done
}

printBoard() {
	printf "\n-------------------"
	for (( row = 0; row < ROWS; row++ )) do
		printf "\n|     |     |     |\n"
		for (( column = 0; column < COLUMNS; column++ )) do 
			printf "|  ${board[$row,$column]}  "
		done
	printf "|"
	printf "\n|     |     |     |"
	printf "\n-------------------"
	done
	printf "\n\n"
}

initBoard
printBoard
