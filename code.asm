
;Componants' place :

    ; Device_A :
    ; ADC (potentiometer)       on port A
    ; Direction led             on port B 0
    ; Write bit of ADC (BLINK)  on port B 1
    ; Stepper motor (driver)    on port C 0-3
    ; Half/full cycle Switch    on port C 4
    ; Rotate Switch             on port C 5

    ; Device_B :
    ; led 7-segment 1           on port A 0-3
    ; led 7-segment 2           on port B 0-3
    ; led 7-segment 3           on port C 0-3

.MODEL SMALL

.DATA                         ; ---------------------------------------Data segment------------------------------------------------------

    ; Device_A ports
    PORTAA EQU 10H            ; Address of port A of device A
    PORTAB EQU 12H            ; Address of port B of device A
    PORTAC EQU 14H            ; Address of port C of device A
    CTRLWORDA EQU 16H         ; Addresse of port Control Word of device A
    
    ; Device_B ports
    PORTBA EQU 08H            ; Address of port A of device B
    PORTBB EQU 0AH            ; Address of port B of device B
    PORTBC EQU 0CH            ; Address of port C of device B
    CTRLWORDB EQU 0EH         ; Addresse of port Control Word of device B

    ; Variables
    DELAY   DW 0H             ; DELAY Value that will control the stepper motor speed
    HDIR    DB 00H            ; Direction of Stepper Motor (0/1) and (step / half ) step
    RHS     DB 30H            ; Address of Rotate and half/full step mode switches at port B
    DSPLYD  DW 0H             ; Value that will displayed on the display

    STEPS  DB 00000011B,      ; Full Step Mode Array
              00000110B, 
              00001100B, 
              00001001B,
			  00000011B,      
              00000110B, 
              00001100B, 
              00001001B   

    HSTEPS DB 00000001B,      ; Half step Mode Array
              00000011B, 
	      00000010B, 
	      00000110B, 
	      00000100B, 
  	      00001100B, 
	      00001000B,
	      00001001B
	II DW 0 				  ;index for stepping


.STACK  10H                   ; ---------------------------------------Stack segment------------------------------------------------------


.CODE                         ; ----------------------------------------Code segment------------------------------------------------------

.STARTUP

;----------Configration of PORTS----------

    ; Device_A
    MOV AL ,10010000B         
    OUT CTRLWORDA , AL        ; Set Control Word

    ; port_A --> input 
    ; port_B --> output 
    ; port_C --> (input-output)

    ; Device_B
    MOV AL ,10000000B         
    OUT CTRLWORDB , AL        ; Set Control Word

    ; port_A --> output 
    ; port_B --> output 
    ; port_C --> output
    

;---------------MAIN LOOP-----------------

MAIN PROC

    CALL GETPRESSED
    CALL GETSPEED
    CALL RUN
    CALL GETDSPLYD
    CALL DISPLAY 
	CALL SLEEP
    JMP MAIN

    RET
    
MAIN ENDP

;-----------RUN function--------------

RUN PROC            ; 1- Check the direction button (DIC) to determine the step diection (cw/ccw)
                    ; 2- Check the Step Mode button (HS) to determine step mode (half / full) step
                    ; 3- Run in the determined direction and in determined mode

    TEST HDIR , 1                 ; Check on HS switch 
    JNZ a                         ; If one then it Half step mode and jump to a
    LEA SI , STEPS                ; SI = offset of Full steps array
    JMP b   
    a: 
    LEA SI , HSTEPS               ; SI = offset of Half steps array
    b:
    TEST HDIR , 2                 ; Check the rotate direction 0--> clockwise and 1--> anticlock wise
    JNZ  CCW                      ; Jump to CCW if 1

    CW:                           ; Clock wise Direction
		
		ADD SI,II			  ; mov to the inde
        MOV  AL     ,[SI]
        OUT  PORTAC , AL      ; Write on the motor the current step
		CMP II , 7			  ; (ii == 7 ) ? ii =0 : ii++
		JZ n
		INC II
		RET
		n:
        MOV II , 0
        RET
 
    CCW:                          ; Anti clock wise direction
        ADD SI , II               ; SI += CX - 1 , which is the last element in the array (step/hstep)
        MOV  AL , [SI]
        OUT  PORTAC , AL          ; Write on the motor the current step
		CMP II,0				  ; (ii == 0 ) ? ii = 7 : ii--
		JZ m
		DEC II
		RET
		m:
		MOV II,7
    RET
    
RUN ENDP

;-----------------Get Speed---------------
 
GETSPEED PROC       ; 1- Get input from potentiometer to calculate and set DELAY
                    ; 2- Set and Reset Write bit of ADC (to converts analog value to digital vale)
                    ; 3- Turn the LED on if the HDIR = 10/11 (step in reverse direction (CCW))
 
    IN  AL , PORTAA             ; Get input from potentiometer in AL
    MOV BL , 35                 
    MUL BL                      ; AX = AX * BL 
    ADD AX , 06FFH              ; Add AX to intial value of DELAY (initial value = the smallest value of DELAY) 
    MOV DELAY , AX              ; DELAY = AX + intial value

    MOV BL , HDIR               ; Take value of HDIR
    SHR BL , 1                  ; Take value of only Rotate switch
    MOV AL , BL

    OR  AL     , 010B           ; Check if AL = 1 , then turn led on else turn led off
    OUT PORTAB , AL             ; reset the write bits of ADC
 
    MOV CX , 00FFH              ; delay
    convert: Loop convert
 
    AND AL     , 00000001B         
    OUT PORTAB , AL             ; set the write bits of ADC
 
    RET
 
GETSPEED ENDP

;---------------GETPRESSED function----------------- 

GETPRESSED PROC        ; Update HDIR (direction variable) by :
                       ; 11 if Rotate Switch is pressed  and HS switch is pressed
                       ; 10 if Rotate Switch is pressed  and HS switch is release
                       ; 01 if Rotate Switch is released and HS switch is pressed
                       ; 00 if Rotate Switch is released and HS switch is release    

    IN  AL , PORTAC            ; Read the content of port_C
    AND AL , RHS               ; Take value of Rotate Switch and HS switch
    MOV BX , 16         
    DIV BX                     ; Shift AX right by 4 bits 
    MOV HDIR , AL              ; Set HDIR by new value

    RET

GETPRESSED ENDP

;---------------SLEEP function------------------

SLEEP PROC            ; Delay for DELAY cycles 

    PUSH CX                   ; Store old counter value in stack

    MOV CX, DELAY             ; Set new counter by DELAY value
    delayloop:                ; Loop for DELAY
    LOOP delayloop

    POP CX                    ; Destore old counter value from stack

    RET	

SLEEP ENDP

;---------------DISPLAY function------------------

DISPLAY PROC          ; Seprate the DSPLYD value into 3 numbers and display them on corresponding 7-seg
    
    MOV AX , DSPLYD          ; Take the value of DSPLYD that will be dislpayed on screen
    MOV BX , 10
	MOV DX , 0 
	
    DIV  BX
    XCHG AL , DL
    OUT  PORTBC , AL         ; Display the most left number in DSPLYD on the third 7-seg 
    XCHG AL , DL
    MOV  DL , 0

    DIV  BX
    XCHG AL , DL
    OUT  PORTBB , AL         ; Display the middle number in DSPLYD on the second 7-seg
    MOV  AL , DL

    DIV  BL
	MOV  AL , AH
    OUT  PORTBA , AL         ; Display the most Right number in DSPLYD on the first 7-seg

    RET

DISPLAY ENDP

;---------------GETRESULT function------------------

GETDSPLYD PROC        ; Calculate the speed motor value to be diplayed on three 7-seg display

    MOV AX ,DELAY             ; Take the value of DELAY
    MOV BX ,64H               
    MUL BX                    ; DX,AX = AX * 100
    MOV BX ,185CH
    DIV BX                    ; AX = DX,AX / max value of delay
    MOV DSPLYD ,80H
    SUB DSPLYD ,AX            ; DSPLYD = 128 - AX  ----> the value that will be sdplayed on screen
	
    RET

GETDSPLYD ENDP

.EXIT

end
