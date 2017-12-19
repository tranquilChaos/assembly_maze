TITLE MASM Template						(main.asm)

; Description:
; 
; Revision date:

INCLUDE Irvine32.inc

;==========================================================
;MACRO definitions
;==========================================================

;----------------------------------------------------------
DrawOptionsMenu MACRO
;----------------------------------------------------------
LOCAL MENUEnterName
.data
MENUEnterName		BYTE "Enter your name --> ",0dh,0ah,0

.code
	MOV EDX,OFFSET MENUEnterName
	CALL WriteString
	

ENDM

;----------------------------------------------------------
DrawEnterNameMenu MACRO
;----------------------------------------------------------
LOCAL MENUEnterName
.data
MENUEnterName		BYTE "Enter your name --> ",0dh,0ah,0

.code
	MOV EDX,OFFSET MENUEnterName
	CALL WriteString
	

ENDM

;----------------------------------------------------------
DrawHelpMenu MACRO
;----------------------------------------------------------
LOCAL MENUHelpTitle
LOCAL MENUHelpLineA
LOCAL MENUHelpLineB
LOCAL MENUHelpLineC
LOCAL MENUHelpLineD
LOCAL MENUHelpLineE
.data
MENUHelpTitle		BYTE 0dh,0ah,0"Help",0dh,0ah,0
MENUHelpLineA		BYTE "Try to get through the maze with the best score possible.",0dh,0ah,0
MENUHelpLineB		BYTE "Red tiles are worth 10 points, blue tiles are worth 20 points.",0dh,0ah,0
MENUHelpLineC		BYTE "Lose 1 point every 5 seconds until reaching the end.",0dh,0ah,0
MENUHelpLineD		BYTE "Use WASD keys to navigate the maze.",0dh,0ah,0
MENUHelpLineE		BYTE "Press any key to continue...",0dh,0ah,0

.code
	MOV EDX,OFFSET MENUHelpTitle
	CALL WriteString
	
	MOV EDX,OFFSET MENUHelpLineA
	CALL WriteString

	MOV EDX,OFFSET MENUHelpLineB
	CALL WriteString
	
	MOV EDX,OFFSET MENUHelpLineC
	CALL WriteString
	
	MOV EDX,OFFSET MENUHelpLineD
	CALL WriteString
	
	MOV EDX,OFFSET MENUHelpLineE
	CALL WriteString
	
	CALL ReadChar

ENDM

;----------------------------------------------------------
DrawMainMenu MACRO
;----------------------------------------------------------
LOCAL MENUBreakLine
LOCAL MENUMenuHeader
LOCAL MENUInputName
LOCAL MENUOptions
LOCAL MENUHelp
LOCAL MENUPlay
LOCAL MENUExit

.data
MENUBreakLine		BYTE "*****************************************************************",0dh,0ah,0
MENUMenuHeader		BYTE "*                 Super Happy Fun Time Maze Game                *",0dh,0ah,0
MENUInputName		BYTE "1> Input your name",0dh,0ah,0
MENUOptions			BYTE "2> Options",0dh,0ah,0
MENUHelp			BYTE "3> Help",0dh,0ah,0
MENUPlay			BYTE "4> Play",0dh,0ah,0
MENUExit			BYTE "5> Exit",0dh,0ah,0

.code
	CALL Clrscr

	MOV EDX,OFFSET MENUBreakLine
	CALL WriteString
	
	MOV EDX,OFFSET MENUMenuHeader
	CALL WriteString
	
	MOV EDX,OFFSET MENUBreakLine
	CALL WriteString
	
	MOV EDX,OFFSET MENUInputName
	CALL WriteString
	
	MOV EDX,OFFSET MENUOptions
	CALL WriteString
	
	MOV EDX,OFFSET MENUHelp
	CALL WriteString
	
	MOV EDX,OFFSET MENUPlay
	CALL WriteString
	
	MOV EDX,OFFSET MENUExit
	CALL WriteString

ENDM

;----------------------------------------------------------
DrawMaze MACRO mzdata:REQ
;----------------------------------------------------------
LOCAL xrep
LOCAL yrep

.data
	xrep	BYTE 20
	yrep	BYTE 20

.code
	MOV ESI,OFFSET mzdata	
	MOV xrep,1
	MOV yrep,1
	
	CALL Clrscr
	
	.REPEAT
		MOV xrep,1
		.REPEAT
			MOV DH,yrep
			MOV DL,xrep
			CALL Gotoxy
			MOV AL,[ESI]
			
			.IF AL == '0'
				MOV EAX,white + (lightBlue * 16)
				CALL SetTextColor
				MOV AL,' '
			.ENDIF
			
			.IF AL == '1'
				MOV EAX,white + (black * 16)
				CALL SetTextColor
				MOV AL,' '
			.ENDIF
			
			.IF AL == '2'
				MOV EAX,white + (blue * 16)
				CALL SetTextColor
				MOV AL,' '
			.ENDIF
			
			.IF AL == '3'
				MOV EAX,white + (red * 16)
				CALL SetTextColor
				MOV AL,' '
			.ENDIF
			
			.IF AL == '4'
				MOV EAX,white + (green * 16)
				CALL SetTextColor
				MOV AL,' '
			.ENDIF
			
			.IF AL == '5'
				MOV EAX,white + (black * 16)
				CALL SetTextColor
				MOV AL,' '
			.ENDIF
	
			.IF AL == '6'
				MOV EAX,white + (black * 16)
				CALL SetTextColor
				MOV AL,' '
			.ENDIF
			
			CALL WriteChar
			INC ESI
			INC xrep
		.UNTIL xrep == 21
		INC yrep
	.UNTIL yrep==21
	
	MOV EAX,white + (black * 16)
	CALL SetTextColor
	
	
ENDM

DrawPlayer MACRO x:REQ, y:REQ

.code
	MOV DH,y
	MOV DL,x
	CALL Gotoxy
	MOV AL,'*'
	CALL WriteChar
ENDM

.data
	selection		BYTE	?
	playerName		BYTE	"New Player",0
	mazeData		BYTE	400 DUP(?)
	selectionPrompt	BYTE	"Selection, ",0
	enterNamePrompt	BYTE	0dh,0ah,"Enter your name --> ",0
	filename		BYTE	"mazedata.txt",0
	filehandle		DWORD	?
	playerX			BYTE	1
	playerY			BYTE	20
	playerB			WORD	381
	testTile		WORD	?

	
.code

main PROC
	call Clrscr

DisplayMainMenu:
	DrawMainMenu
	
	MOV EDX,OFFSET selectionPrompt
	CALL WriteString
	
	MOV EDX,OFFSET playerName
	CALL WriteString
	
	CALL ReadChar

	MOV selection,AL
	
	CMP selection,"1"
	JE DisplayEnterName
	
	CMP selection,"3"
	JE DisplayHelpMenu
	
	CMP selection,"4"
	JE StartGame
	
	CMP selection,"5"
	JE ExitGame
	
	JMP DisplayMainMenu					;Invalid selection, go back to menu display

DisplayEnterName:
	MOV EDX,OFFSET enterNamePrompt
	CALL WriteString

	MOV EDX,OFFSET playerName
	MOV ECX,SIZEOF playerName
	CALL ReadString
	JMP DisplayMainMenu

DisplayHelpMenu:
	DrawOptionsMenu
	JMP DisplayMainMenu

StartGame:
	;start the main game loop
	
	;Load the mazedata - should only need to do this once
	MOV EDX,OFFSET filename
	CALL OpenInputFile
	
	MOV EDX,OFFSET mazeData
	MOV ECX,SIZEOF mazeData
	CALL ReadFromFile
	
GameLoop:
	DrawMaze mazeData
	DrawPlayer playerX, playerY
	CALL ReadChar
	MOV selection,AL
	
	.IF selection == 'q'
		JMP ExitGame
	.ENDIF
	
	.IF selection == 'd'
		;ADD playerX,1
		;ADD PlayerB,1
		;MOV testTile,playerB
		;ADD testTile,1
		MOV AX,playerB
		ADD AX,1
		MOV testTile,AX
		MOV ESI,OFFSET mazeData
		;MOV AX,[ESI + testTile]
		;MOV ESI,382
		;MOV AX,mazeData[ESI*2]
		ADD ESI,762
		MOV AX,[ESI]
		.IF AX == '1'
			ADD playerX,1
			ADD playerB,1
		.ENDIF
	.ENDIF
	
	JMP GameLoop
	
ExitGame:
	
	exit
main ENDP

END main