#!/usr/local/bin/bash

#This file contains Tic-Tac-Toe Game logic

ROWS=3
COLUMNS=3
INITIAL_SYMBOL="-"
PLAYER1_SYMBOL="X"
PLAYER2_SYMBOL="O"
declare -A BOARD

initBoard() {
	for (( row = 0; row < ROWS; row++ )); do
		for (( column = 0; column < COLUMNS; column++ )); do
			BOARD[$row,$column]=$INITIAL_SYMBOL
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
			printf "|  ${BOARD[$row,$column]}  "
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
	
	BOARD[$row,$column]=$mark			
}

checkOccupiedPosition() {
	row=$1
	column=$2
	
	if [[ ${BOARD[$row,$column]} == $INITIAL_SYMBOL ]]
	then
		return 0
	fi
	
	return 1
}

initBoard
printBoard

while :
do
	read -p "Enter row position : " row
	read -p "Enter column position : " column
	
	checkOccupiedPosition $row $column
	
	if [ $? -eq 1 ]
	then
		echo Position is already occupied. Try another position!	
	else
		fillBoard $row $column $PLAYER1_SYMBOL
 		
		while :
      do
         computerRow=$(( $RANDOM % 3 ))
         computerColumn=$(( $RANDOM % 3 ))
			
			checkOccupiedPosition $computerRow $computerColumn

			if [ $? -eq 0 ]
         then
            fillBoard $computerRow $computerColumn $PLAYER2_SYMBOL
            break
         fi
      done
	fi
	
	printBoard	
done
