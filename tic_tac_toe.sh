#!/usr/local/bin/bash -x

#This file contains Tic-Tac-Toe Game logic

ROWS=3
COLUMNS=3
INITIAL_SYMBOL="-"
PLAYER_SYMBOL="X"
COMPUTER_SYMBOL="O"
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
	symbol=$3
	
	BOARD[$row,$column]=$symbol			
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
	symbol=$2
	column=0
 
	while [[ $column -lt $COLUMNS && ${BOARD[$row,$column]} == $symbol ]]
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
		checkVerticalColumnsFilled $row $PLAYER_SYMBOL
		playerResult=$?

		checkVerticalColumnsFilled $row $COMPUTER_SYMBOL
		computerResult=$?

		if [[ $playerResult -eq 1 ]]
		then
			return 1
		fi

		if [[ $computerResult -eq 1 ]]
		then
			return 2
		fi
		(( row++ ))
	done
   return 0
}

checkHorizontalRowsFilled() {
	column=$1
	symbol=$2
	row=0

	while [[ $row -lt $ROWS && ${BOARD[$row,$column]} == $symbol ]]
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
		checkHorizontalRowsFilled $column $PLAYER_SYMBOL
		playerResult=$?

		checkHorizontalRowsFilled $column $COMPUTER_SYMBOL
		computerResult=$?

		if [[ $playerResult -eq 1 ]]
		then
			return 1
		fi
      
		if [[ $computerResult -eq 1 ]]
		then
			return 2
		fi

		(( column++ ))
	done
	return 0
}

isLeftDiagonalFilled() {
	symbol=$1
	filledDiagonals=0

	if [[ $ROWS -eq $COLUMNS ]]
	then
		while [[ $filledDiagonals -lt $COLUMNS && ${BOARD[$filledDiagonals,$filledDiagonals]} == $symbol ]]
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
	isLeftDiagonalFilled $PLAYER_SYMBOL
	playerResult=$?

	isLeftDiagonalFilled $COMPUTER_SYMBOL
	computerResult=$?

	if [[ $playerResult -eq 1 ]]
	then
		return 1
	fi

	if [[ $computerResult -eq 1 ]]
	then
		return 2
	fi

	return 0
}

isRightDiagonalFilled() {
	symbol=$1
	row=0
	column=$(( $COLUMNS - 1 ))

	while [[ $column -ge 0 && ${BOARD[$row,$column]} == $symbol ]]
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
	isRightDiagonalFilled $PLAYER_SYMBOL
	playerResult=$?

	isRightDiagonalFilled $COMPUTER_SYMBOL
	computerResult=$?

	if [[ $playerResult -eq 1 ]]
	then
		return 1
	fi

	if [[ $computerResult -eq 1 ]]
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

takePlayerInput() {
	while :
	do
		read -p "Enter row position : " row
		read -p "Enter column position : " column
	
		checkOccupiedPosition $row $column
		
		if [ $? -eq 1 ]
		then
			echo Position is already occupied. Try another position!
			continue
		fi	

		fillBoard $row $column $PLAYER_SYMBOL
		break
	done
}

takeComputerInput() {
	while :
	do
		randomRow=$(( $RANDOM % 3 ))
		randomColumn=$(( $RANDOM % 3 ))
			
		checkOccupiedPosition $randomRow $randomColumn

		if [ $? -eq 1 ]
		then
			continue
		fi
		
		echo "Computer Row : $randomRow"
		echo "Computer Column : $randomColumn"
		fillBoard $randomRow $randomColumn $COMPUTER_SYMBOL
		break
	done
}

checkWinLossOrDraw() {
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
		return 1
	fi

	if [[ $verticallyFilledResult -eq 2 || $horizontallyFilledResult -eq 2 || $leftDiagonalFilledResult -eq 2 || $rightDiagonalFilledResult -eq 2 ]]
	then
		printf "\nComputer Won\n"
		return 1
	fi

	isBoardFull
	
	if [ $? -eq 1 ]
	then
		printf "\nGame Draw\n"
		return 1
	fi

	return 0
}

# main
initBoard
printBoard

while :
do	
	takePlayerInput
	printBoard
	checkWinLossOrDraw
 	
	if [ $? -eq 1 ]
	then
		break
	fi

	takeComputerInput
	printBoard
	checkWinLossOrDraw

	if [ $? -eq 1 ]
	then
		break
	fi	
done
