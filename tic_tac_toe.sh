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

checkVerticalColumnsFilled() {
   row=$1
   playerSymbol=$2
   column=0
   filledColumns=0
   if [[ ${BOARD[$row,$column]} == $playerSymbol ]]
   then
      while [[ $column -lt $COLUMNS ]]
      do
         if [[ ${BOARD[$row,$column]} != $playerSymbol ]]
         then
            break
         fi
         (( column++ ))
         (( filledColumns++ ))
      done
   fi

   if [[ $filledColumns -eq $COLUMNS ]]
   then
      return 1
   fi
   return 0
}

checkBoardVerticallyFilled() {
   row=0
   player1Count=0
   player2Count=0

   while [[ $row -lt $ROWS ]]
   do
      if [[ ${BOARD[$row,$column]} == $INITIAL_SYMBOL ]]
      then
         (( row++ ))
         continue
      fi

      checkVerticalColumnsFilled $row $PLAYER1_SYMBOL
      player1Result=$?

      checkVerticalColumnsFilled $row $PLAYER2_SYMBOL
      player2Result=$?

      if [[ $player1Result -eq 1 ]]
      then
         return 1
      elif [[ $player2Result -eq 1 ]]
      then
         return 2
      fi

      (( row++ ))
   done
   return 0
}

# main
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
	checkBoardVerticallyFilled
	result=$?

	if [[ $result -eq 1 ]]
	then
		printf "\nPlayer won\n"
		echo
		break
	elif [[ $result -eq 2 ]]
	then
		printf "\nComputer Won\n"
		break
	fi
done
