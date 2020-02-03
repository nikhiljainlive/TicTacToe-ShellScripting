#!/usr/local/bin/bash -x

#This file contains Tic-Tac-Toe Game logic

ROWS=3
COLUMNS=3
INITIAL_SYMBOL="-"
declare -A board

initBoard() {
	for (( row=0; row < ROWS; row++ )) do
		for (( column=0; column < COLUMNS; column++ )) do
			board[$row, $col]=$INITIAL_SYMBOL
		done
	done	
}

initBoard
