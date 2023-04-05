# Assignment - Connect Four
# Remember to set Bitmap Display to 8x8 pixels, 512x512 display and use heap base memory
.data
ColorTable:
	.word 0x0000FF, 0xFF0000, 0xE5C420, 0xFFFFFF
	#	Blue	Red	  Yellow     White

CircleArray: 
	.word 2, 4, 1, 6, 0, 8, 0, 8, 0, 8, 0, 8, 1, 6, 2, 4

BoardArray: .byte 0:42

welcome_string: .asciiz "Welcome to Connect Four \n"
player1_turn_string: .asciiz "\nPlayer 1's turn: "
player2_turn_string: .asciiz "\nPlayer 2's turn: "
player1_win_string: .asciiz "Player 1 Wins! Congratulatios! \n"
player2_win_string: .asciiz "Player 2 Wins! Congratulatios! \n"
enter_number_string: .asciiz "Your number is out of range. Please re-enter a number between 1 and 7 \n"
column_full_string: .asciiz "This column is already full. Please choose a different column\n"
tie_string: .asciiz "Tie Game!\n"

.text

# Draw Gameboard
jal DrawGameBoard

# Welcome
la $a0, welcome_string	
addi $v0, $zero, 4
syscall

################################  Begin Main ################################  
main:

# Player 1 Input
playerOne:
la $a0, player1_turn_string
addi $v0, $zero, 4
syscall
addi $v0, $zero, 5
syscall
addi $a0, $zero, 1
jal SaveInputToArray
addi $a0, $zero, 1
jal DrawPlayerCircle
jal WinCheck

# Player 2 Input
playerTwo:
la $a0, player2_turn_string
addi $v0, $zero, 4
syscall
addi $v0, $zero, 5
syscall
addi $a0, $zero, 2
jal SaveInputToArray
addi $a0, $zero, 2
jal DrawPlayerCircle
jal WinCheck

j main	# Play until win or tie

################################  End Main ################################ 




################################  Begin All Drawing Procedures ################################ 
#Procedure: DrawDotDisplay
# $a0 = X
# $a1 = Y
# $a2 = color
DrawDotDisplay:
	addiu $sp, $sp, -8
	sw $ra, 4($sp)
	sw $a2, 0($sp)
	
	jal CalcAddressInHeap
	lw $a2, 0($sp)
	sw $v0, 0($sp)
	jal GetColor
	lw $v0, 0($sp)
	sw $v1, ($v0)
	lw $ra, 4($sp)
	
	addiu $sp, $sp, 8
	jr $ra


#############################################################################
#Procedure: CalcAddressInHeap
# $a0 = X
# $a1 = Y
# Output - $v0 = memory address to draw dot
CalcAddressInHeap:
	sll $t0, $a0, 2
	sll $t1, $a1, 8
	add $t2, $t0, $t1
	addi $v0, $t2, 0x10040000
	jr $ra

#############################################################################
# Procedure: GetColor
# $a2 = Color Value (0-3)
# $v1 = Hex color value
GetColor:
	la $t0, ColorTable
	sll $a2, $a2, 2
	add $a2, $a2, $t0
	lw $v1, ($a2)
	jr $ra

#############################################################################
# Procedure: DrawGameBoard
DrawGameBoard:
	addiu $sp, $sp, -4
	sw $ra, ($sp)
	
	#White Background
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 3
	addi $a3, $zero, 64
	jal DrawWhiteBoard
	
	#Horizontal Lines
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 0
	addi $a3, $zero, 64
	jal DrawHorizontalWithLength
	addi $a1, $a1, 9
	jal DrawHorizontalWithLength
	addi $a1, $a1, 9
	jal DrawHorizontalWithLength	
	addi $a1, $a1, 9
	jal DrawHorizontalWithLength	
	addi $a1, $a1, 9
	jal DrawHorizontalWithLength
	addi $a1, $a1, 9	
	jal DrawHorizontalWithLength
	addi $a1, $a1, 9	
	jal DrawHorizontalWithLength


	#Vertical Lines 
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 0
	addi $a3, $zero, 54
	jal DrawVerticalWithLength
	addi $a0, $a0, 9
	jal DrawVerticalWithLength
	addi $a0, $a0, 9
	jal DrawVerticalWithLength
	addi $a0, $a0, 9
	jal DrawVerticalWithLength
	addi $a0, $a0, 9
	jal DrawVerticalWithLength
	addi $a0, $a0, 9
	jal DrawVerticalWithLength
	addi $a0, $a0, 9
	jal DrawVerticalWithLength
	addi $a0, $a0, 9
	jal DrawVerticalWithLength
	
	jal DrawNumberInBoard

	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra
	
#############################################################################
#Procedure: DrawWhiteBoard
# $a0 = X 
# $a1 = Y
# $a2 = color
# $a3 = 64
DrawWhiteBoard:
	addiu $sp, $sp, -24
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $a0, 12($sp)
	sw $a2, 8($sp)
	
	add $s0, $zero, $a3
whileDrawWhiteHorizontal:
	sw $a1, 4($sp)
	sw $a3, 0($sp)
	jal DrawHorizontalWithLength
	
	lw $a3, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a0, 12($sp)
	addi $a1, $a1, 1
	addi $s0, $s0, -1
	bne $zero, $s0, whileDrawWhiteHorizontal
	
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	addiu $sp, $sp, 24
	jr $ra
	
#############################################################################
#Procedure: DrawHorizontalWithLength
# $a0 = X 
# $a1 = Y
# $a2 = color
# $a3 = 64
DrawHorizontalWithLength:
	addiu $sp, $sp, -28
	sw $ra, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a0, 20($sp)
	sw $a3, 24($sp)
	
WhileDrawHorizontal:
	sw $a0, 4($sp)
	sw $a3, 0($sp)
	jal DrawDotDisplay
	lw $a0, 4($sp)
	lw $a1, 12($sp)
	lw $a2, 8($sp)
	lw $a3, 0($sp)	
	addi $a3, $a3, -1
	addi $a0, $a0, 1
	bnez $a3, WhileDrawHorizontal
		
	lw $ra, 16($sp)
	lw $a0, 20($sp)
	lw $a3, 24($sp)
	addiu $sp, $sp, 28
	jr $ra

#############################################################################
#Procedure: DrawVerticalWithLength
# $a0 = X 
# $a1 = Y
# $a2 = color
# $a3 = 64
DrawVerticalWithLength:
	addiu $sp, $sp, -28
	sw $ra, 16($sp)
	sw $a1, 12($sp)
	sw $a2, 8($sp)
	sw $a0, 20($sp)
	sw $a3, 24($sp)
	
whileDrawVertical:
	sw $a1, 4($sp)
	sw $a3, 0($sp)
	jal DrawDotDisplay
	lw $a1, 4($sp)
	lw $a0, 20($sp)
	lw $a2, 8($sp)
	lw $a3, 0($sp)	
	addi $a3, $a3, -1
	addi $a1, $a1, 1
	bnez $a3, whileDrawVertical
		
	lw $ra, 16($sp)
	lw $a1, 12($sp)
	lw $a3, 24($sp)
	addiu $sp, $sp, 28
	jr $ra

#############################################################################
#Procedure: DrawNumberInBoard
# $a0 = X 
# $a1 = Y
# $a2 = color
DrawNumberInBoard:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $a1, $zero, 59
	addi $a2, $zero, 0
	addi $a3, $zero, 5
	# Draw Number 1
	addi $a0, $zero, 4
	jal DrawVerticalWithLength
	# Draw Number 2
	addi $a0, $zero, 12
	jal DrawVerticalWithLength
	addi $a0, $zero, 14
	jal DrawVerticalWithLength
	# Draw Number 3
	addi $a0, $zero, 20
	jal DrawVerticalWithLength
	addi $a0, $zero, 22
	jal DrawVerticalWithLength
	addi $a0, $zero, 24
	jal DrawVerticalWithLength
	# Draw Number 4
	addi $a0, $zero, 30
	jal DrawVerticalWithLength
	addi $t9, $zero, 32
	jal DrawV
	# Draw Number 5
	addi $t9, $zero, 40
	jal DrawV
	#Draw Number 6
	addi $t9, $zero, 48
	jal DrawV
	addi $a0, $zero, 52
	jal DrawVerticalWithLength
	#Draw Number 7
	addi $t9, $zero, 56
	jal DrawV
	addi $a0, $zero, 60
	jal DrawVerticalWithLength
	addi $a0, $zero, 62
	jal DrawVerticalWithLength

	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra

#############################################################################
# Procedure: DrawNumberInBoard
DrawV:
	addiu $sp, $sp, -4
	sw $ra, 0($sp)

	addi $a3, $zero, 4
	addi $a0, $t9, 0
	jal DrawVerticalWithLength
	addi $a0, $t9, 2
	jal DrawVerticalWithLength
	
	addi $a1, $zero, 63
	addi $a3, $zero, 1
	
	addi $a0, $t9, 1
	jal DrawVerticalWithLength
	
	addi $a1, $zero, 59
	addi $a2, $zero, 0
	addi $a3, $zero, 5
	
	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra


#############################################################################
# Procedure: DrawPlayerCircle
# $a0 = player 1 or 2
# $v0 = BoardArray index
DrawPlayerCircle:
	addiu $sp, $sp, -12
	sw $ra, ($sp)
	sw $a0, 4($sp)
	sw $v0, 8($sp)
	
	add $a2, $zero, $a0
	
	#Calculate Address
	addi $t0, $zero, 7
	div $v0, $t0
	mflo $t0
	mfhi $t1

	# Y-Address = 63-[(Y+1)*9+8] = 46-9Y
	addi $t2, $zero, 46
	mul $t0, $t0, 9
	mflo $t0
	sub $t0, $t2, $t0
	
	# X-Address = X*9 + 1
	mul $t1, $t1, 9
	addi $t1, $t1, 1
	
	add $a0, $zero, $t1
	add $a1, $zero, $t0
	
	jal DrawCircle
	
	lw $v0, 8($sp)
	lw $a0, 4($sp)
	lw $ra, ($sp)
	addiu $sp, $sp, 4
	jr $ra

#############################################################################
#Procedure: DrawCircle
# $a0 = X 
# $a1 = Y
# $a2 = color
DrawCircle:
	addiu $sp, $sp, -28
	sw $ra, 20($sp)
	sw $s0, 16($sp)
	sw $a0, 12($sp)
	sw $a2, 8($sp)
	addi $s2, $zero, 0
	
whileDrawCircle:
	la $t1, CircleArray
	addi $t2, $s2, 0
	mul $t2, $t2, 8
	add $t2, $t1, $t2
	lw $t3, ($t2)
	add $a0, $a0, $t3
	
	addi $t2, $t2, 4
	lw $a3, ($t2)
	sw $a1, 4($sp)
	sw $a3, 0($sp)
	sw $s2, 24($sp)
	jal DrawHorizontalWithLength
	
	lw $a3, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a0, 12($sp)
	lw $s2, 24($sp)
	addi $a1, $a1, 1
	addi $s2, $s2, 1
	bne $s2, 8, whileDrawCircle
	
	lw $ra, 20($sp)
	lw $s0, 16($sp)
	addiu $sp, $sp, 28
	jr $ra

################################  End All Drawing Procedures ################################ 


#############################################################################
# Procedure: SaveInputToArray
# $v0 = entered value
# $a0 = player 1 or 2
SaveInputToArray:
	addi $v0, $v0, -1
	blt $v0, 0, OutOfRange
	bgt $v0, 6, OutOfRange
	
whileCheckFullColumn:
	bgt $v0, 41, FullColumn
	lb $t1, BoardArray($v0)
	addiu $v0, $v0, 7
	bnez $t1, whileCheckFullColumn
	
	addiu $v0, $v0, -7
	sb $a0, BoardArray($v0)
	
	jr $ra
	
	# If Out of Range
	OutOfRange:
	add $t0, $zero, $a0
	la $a0, enter_number_string
	addi $v0, $zero, 4
	syscall
	add $a0, $zero, $t0
	j returnToPlayer
	
	# If Column is already full
	FullColumn:
	add $t0, $zero, $a0
	la $a0, column_full_string
	addi $v0, $zero, 4
	syscall
	add $a0, $zero, $t0
	
	returnToPlayer:
	beq $a0, 1, playerOne
	beq $a0, 2, playerTwo
	
################################  Begin WinCheck ################################ 
#Procedure: WinCheck
# $a0 = player 1 or 2
# $v0 = Last index of BoardArray placed
WinCheck:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal checkVertical
	jal checkHorizontal
	jal checkRightSlash
	jal checkLeftSlash
	jal checkTie
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
#############################################################################
# $a0 = player 1 or 2
# $v0 = Last index of BoardArray placed
checkHorizontal:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $t0, $zero, 0
	
	add $t3, $zero, $v0
	addi $t7, $zero, 7
	div $t3, $t7
     	mfhi $t1
     	sub $t1, $v0, $t1
     	add $t2, $zero, $t1
     	addi $t1, $t1, 6 
     	
	add $a1, $zero, $v0

whileGoLeft:
	bgt $a1, $t1, endGoLeft
	lb $t5, BoardArray($a1)
	bne $t5, $a0, endGoLeft
	addi $a1, $a1, 1
	j whileGoLeft
endGoLeft:
	addi $a1, $a1, -1
whileGoRight:
	blt $a1, $zero, endGoRight
	lb $t5, BoardArray($a1)
	bne $t5, $a0, endGoRight
	addi $t0, $t0, 1
	addi $a1, $a1, -1
	j whileGoRight
endGoRight:
	bgt $t0, 3, PlayerWon
	lw $ra, ($sp)
	addiu $sp, $sp, 4	
	jr $ra
	
#############################################################################
# $a0 = player 1 or 2
# $v0 = Last index of BoardArray placed
checkVertical:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $t0, $zero, 0
	
     	addi $t1, $zero, 41
     	addi $t2, $zero, 0 
     	
	add $a1, $zero, $v0

whileGoUp:
	bgt $a1, $t1, endGoUp
	lb $t5, BoardArray($a1)
	bne $t5, $a0, endGoUp
	addi $a1, $a1, 7
	j whileGoUp
endGoUp:
	addi $a1, $a1, -7
whileGoDown:
	blt $a1, $zero, endGoDown
	lb $t5, BoardArray($a1)
	bne $t5, $a0, endGoDown
	addi $t0, $t0, 1
	addi $a1, $a1, -7
	j whileGoDown
endGoDown:
	bgt $t0, 3, PlayerWon
	lw $ra, ($sp)
	addiu $sp, $sp, 4	
	jr $ra
	
	
#############################################################################
# $a0 = player 1 or 2
# $v0 = Last index of BoardArray placed
checkRightSlash:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $t0, $zero, 0
	
	add $a1, $zero, $v0
	addi $t7, $zero, 7
	
whileGoUpRight:
	bgt $a1, 34, checkTemp
	div $a1, $t7
	mfhi $t3
	beq $t3, 6, checkTemp

	lb $t5, BoardArray($a1)
     	bne $t5, $a0, endGoUpRight
     	
     	addi $a1, $a1, 8
	
     	j whileGoUpRight
     	
checkTemp:
	lb $t5, BoardArray($a1)
	beq $t5, $a0, whileGoDownLeft
endGoUpRight:
	addi $a1, $a1, -8
	
whileGoDownLeft:
	lb $t5, BoardArray($a1)
	bne $t5, $a0, endGoDownLeft
	addi $t0, $t0, 1
	
	blt $a1, 7, endGoDownLeft
	div $a1, $t8
	mfhi $t3
	beq $t3, 0, endGoDownLeft
	
	addi $a1, $a1, -8
	
	j whileGoDownLeft
endGoDownLeft:
	bgt $t0, 3, PlayerWon
	lw $ra, ($sp)
	addiu $sp, $sp, 4	
	jr $ra


#############################################################################
# $a0 = player 1 or 2
# $v0 = Last index of BoardArray placed
checkLeftSlash:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $t0, $zero, 0
	
	add $a1, $zero, $v0
	addi $t7, $zero, 7
	
whileGoUpLeft:
	bgt $a1, 34, checktemp
	div $a1, $t7
	mfhi $t3
	beq $t3, 0, checktemp

	lb $t5, BoardArray($a1)
     	bne $t5, $a0, endGoUpLeft
     	
     	addi $a1, $a1, 6
	
     	j whileGoUpLeft
     	
checktemp:
	lb $t5, BoardArray($a1)
	beq $t5, $a0, whileGoDownRight
endGoUpLeft:
	addi $a1, $a1, -6
	
whileGoDownRight:
	lb $t5, BoardArray($a1)
	bne $t5, $a0, endGoDownRight
	addi $t0, $t0, 1
	
	blt $a1, 7, endGoDownRight
	div $a1, $t8
	mfhi $t3
	beq $t3, 6, endGoDownRight
	
	addi $a1, $a1, -6
	
	j whileGoDownRight
endGoDownRight:
	bgt $t0, 3, PlayerWon
	lw $ra, ($sp)
	addiu $sp, $sp, 4	
	jr $ra


################################  End WinCheck ################################ 

#Procedure checkTie
checkTie:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	addi $t9, $zero, 35
whileCheckTop:
	beq $t9, 42, GameTie
	lb $t5, BoardArray($t9)
    	beqz $t5, endCheckTop
    	addi $t9, $t9, 1
    	j whileCheckTop	
    
endCheckTop:
    	lw $ra, ($sp)
	addiu $sp, $sp, 4	
	jr $ra

GameTie:
	la $a0, tie_string
	addi $v0, $zero, 4
	syscall
	addi $v0, $zero, 10
	syscall

#############################################################################
# Procedure: PlayerWon
# $a0 = Player Number
PlayerWon:
	beq $a0, 2 player2Win
	
	#Player 1 Won
	la $a0, player1_win_string
	addi $v0, $zero, 4
	syscall
	addi $v0, $zero, 10
	syscall
	
	#Player 2 Won
	player2Win:
	la $a0, player2_win_string
	addi $v0, $zero, 4
	syscall
	addi $v0, $zero, 10
	syscall









