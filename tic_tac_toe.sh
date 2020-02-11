#!/usr/local/bin/bash -x

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
 
	while [[ $column -lt $COLUMNS && ${BOARD[$row,$column]} == $playerSymbol ]]
	do
		(( column++ ))
	done

   if [[ $column -eq $COLUMNS ]]
   then
      return 1
   fi
   return 0
}

checkBoardVerticallyFilled() {
   row=0

	while [[ $row -lt $ROWS ]]
	do
		checkVerticalColumnsFilled $row $PLAYER1_SYMBOL
		player1Result=$?

		checkVerticalColumnsFilled $row $PLAYER2_SYMBOL
		player2Result=$?

		if [[ $player1Result -eq 1 ]]
		then
			return 1
		fi

		if [[ $player2Result -eq 1 ]]
		then
			return 2
		fi
      (( row++ ))
   done
   return 0
}

checkHorizontalRowsFilled() {
   column=$1
   playerSymbol=$2
   row=0

	while [[ $row -lt $ROWS && ${BOARD[$row,$column]} == $playerSymbol ]]
	do
		(( row++ ))
	done

   if [[ $row -eq $ROWS ]]
   then
      return 1
   fi
   return 0
}

checkBoardHorizontallyFilled() {
   column=0

   while [[ $column -lt $COLUMNS ]]
   do
      checkHorizontalRowsFilled $column $PLAYER1_SYMBOL
      player1Result=$?

      checkHorizontalRowsFilled $column $PLAYER2_SYMBOL
      player2Result=$?

      if [[ $player1Result -eq 1 ]]
      then
         return 1
      elif [[ $player2Result -eq 1 ]]
      then
         return 2
      fi

      (( column++ ))
   done
   return 0
}

isLeftDiagonalFilled() {
   playerSymbol=$1
   filledDiagonals=0

   if [[ $ROWS -eq $COLUMNS ]]
   then
      while [[ $filledDiagonals -lt $COLUMNS && ${BOARD[$filledDiagonals,$filledDiagonals]} == $playerSymbol ]]
      do
         (( filledDiagonals++ ))
      done

      if [[ $filledDiagonals -eq 3 ]]
      then
         return 1
      fi
      return 0
   fi

   return 0
}

checkBoardLeftDiagonalFilled() {
   isLeftDiagonalFilled $PLAYER1_SYMBOL
   player1Result=$?

   isLeftDiagonalFilled $PLAYER2_SYMBOL
   player2Result=$?

   if [[ $player1Result -eq 1 ]]
   then
      return 1
   fi

   if [[ $player2Result -eq 1 ]]
   then
      return 2
   fi

   return 0
}

isRightDiagonalFilled() {
   playerSymbol=$1
   row=0
   column=$(( $COLUMNS - 1 ))

   while [[ $column -ge 0 && ${BOARD[$row,$column]} == $playerSymbol ]]
   do
      (( row++ ))
      (( column-- ))
   done

   if [[ $row -eq $ROWS ]]
   then
      return 1
   fi
   return 0
}

checkBoardRightDiagonalFilled() {
   isRightDiagonalFilled $PLAYER1_SYMBOL
   player1Result=$?

   isRightDiagonalFilled $PLAYER2_SYMBOL
   player2Result=$?

   if [[ $player1Result -eq 1 ]]
   then
      return 1
   fi

   if [[ $player2Result -eq 1 ]]
   then
      return 2
   fi

   return 0
}

isBoardFull() {
	for (( row = 0; row < ROWS; row++ ))
	do
		for (( column = 0; column < COLUMNS; column++ ))
		do 
			checkOccupiedPosition $row $column
			
			if [ $? -eq 0 ]
			then
				return 0
			fi
		done
	done
	return 1
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
			isBoardFull
			if [ $? -eq 1 ]
			then
				break
			fi

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
	verticallyFilledResult=$?

	checkBoardHorizontallyFilled
	horizontallyFilledResult=$?

	checkBoardLeftDiagonalFilled
	leftDiagonalFilledResult=$?

	checkBoardRightDiagonalFilled
	rightDiagonalFilledResult=$?	

	if [[ $verticallyFilledResult -eq 1 || $horizontallyFilledResult -eq 1 || $leftDiagonalFilledResult -eq 1 || $rightDiagonalFilledResult -eq 1 ]]
	then
		printf "\nPlayer won\n"
		echo
		break
	fi

	if [[ $verticallyFilledResult -eq 2 || $horizontallyFilledResult -eq 2 || $leftDiagonalFilledResult -eq 2 || $rightDiagonalFilledResult -eq 2 ]]
	then
		printf "\nComputer Won\n"
		break
	fi

	isBoardFull
	
	if [ $? -eq 1 ]
	then
		printf "\nGame Draw\n"
		break
	fi
done
