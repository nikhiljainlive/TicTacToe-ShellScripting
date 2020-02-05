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
	printf "\n\tBoard"
	printf "\t\t\t\tPosition\n"
	printf "\n-------------------"
	printf "\t\t-------------------------"
	for (( row = 0; row < ROWS; row++ )) do
		printf "\n|     |     |     |"
		printf "\t\t|       |       |       |\n"
		for (( column = 0; column < COLUMNS; column++ )) do 
			printf "|  ${board[$row,$column]}  "
		done

		printf "|"
		printf "\t\t"
		for (( column = 0; column < COLUMNS; column++ )) do
			printf "|  $row,$column  "
		done
	printf "|"
	printf "\n|     |     |     |"
	printf "\t\t|       |       |       |"
	printf "\n-------------------"
	printf "\t\t-------------------------"
	done

	printf "\n\n"
}

fillBoard() {
	row=$1
	column=$2
	mark=$3
	
	board[$row,$column]=$mark			
}

checkOccupiedPosition() {
	row=$1
	column=$2
	
	if [[ ${board[$row,$column]} == $INITIAL_SYMBOL ]]
	then
		return 0
	fi
	
	return 1
}

initBoard
printBoard

fillBoard 0 0 X
printBoard

checkOccupiedPosition 0 0
exitCode=$?
echo "The exit code for 0,0 position if occupied :  $exitCode"

checkOccupiedPosition 0 1
exitCode=$?
echo "The exit code for 0,1 position if occupied :  $exitCode"
