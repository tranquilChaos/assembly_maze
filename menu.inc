; Include file for rendering the maze				(maze.inc)

.NOLIST
COMMENT !

;OPTION CASEMAP:NONE		; optional: make identifiers case-sensitive

;INCLUDE Irvine32.inc


; Last update: 7/29/05


DrawMainMenu MACRO

LOCAL MENUBreakLine
LOCAL MENUMenuHeader
LOCAL MENUInputName
LOCAL MENUOptions
LOCAL MENUHelp
LOCAL MENUPlay
LOCAL MENUExit

.data
MENUBreakLine		BYTE "*****************************************************************",0dh,0ah,0
MENUMenuHeader		BYTE "*            Super Happy Fun Time Maze Game                     *",0dh,0ah,0
MENUInputName		BYTE "1> Input your name",0dh,0ah,0
MENUOptions			BYTE "2> Options",0dh,0ah,0
MENUHelp			BYTE "3> Help",0dh,0ah,0
MENUPlay			BYTE "4> Play",0dh,0ah,0
MENUExit			BYTE "5> Exit",0dh,0ah,0

.code
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


.LIST
