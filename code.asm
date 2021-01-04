
;Componants' place :
    ; ADC (potentiometer)       on port A
    ; Direction led             on port B 0
    ; Write bit of ADC          on port B 1
    ; Rotate Switch             on port C 5
    ; Stepper motor (driver)    on port C 0-3

.MODEL SMALL

.DATA                        ; Data segment

    PORTA EQU 10H            ; Address of port A
    PORTB EQU 12H            ; Address of port B
    PORTC EQU 14H            ; Address of port C
    CTRLWORD EQU 16H         ; Addresse of port Control Word
    
                             ; Device B
    PORTAB EQU 08H           ; Address of port A
    PORTBB EQU 0AH           ; Address of port B
    PORTCB EQU 0CH           ; Address of port C
    BCTRLWORD EQU 0EH         ; Addresse of port Control Word

    DELAY  DW 0H             ; DELAY Value that will control the stepper motor speed
    HDIR    DB 00H           ; Direction of Stepper Motor (0/1) and (step / half step)
    RHS DB 30H               ; direction and half step switches at port B
    RESULT DW 0H             ; to hold the value for the 7-seg display

    STEPS  DB 00000011B,     ; Full Step Mode
              00000110B, 
              00001100B, 
              00001001B   

    HSTEPS DB 00000001B, ; half step
              00000011B, 
		      00000010B, 
			  00000110B, 
			  00000100B, 
			  00001100B, 
			  00001000B,
			  00001001B


.STACK  10H                  ; Stack segment


.CODE                        ; Code segment

.STARTUP

;---------Configration of PORTS---------
    ; Device A
    MOV AL ,10010000B         
    OUT CTRLWORD , AL        ; Set Control Word

    ; port_A --> input 
    ; port_B --> output 
    ; port_C --> (input-output)

    ; Device B
    MOV AL ,10000000B         
    OUT BCTRLWORD , AL        ; Set Control Word

    ; port_A --> output 
    ; port_B --> output 

;-------------MAIN LOOP----------------

MAIN PROC

    CALL GETSPEED
    CALL GETPRESSED
    CALL RUN
    CALL GETRESULT
    CALL DISPLAY 
    JMP MAIN

    RET
    
MAIN ENDP

;-----------RUN function--------------

RUN PROC            ; 1- Check the direction button (DIC) to determine the step diection (cw/ccw)
                    ; 2- Check the Step Mode button (HS) to determine the step diection (cw/ccw)
                    ; 3- Run in the determined direction and in determined mode

    TEST HDIR , 1                 ; Check on HS switch 
    JNZ a                         ; If one then it Half step mode and jump to a
    MOV CX , 4                    ; CX = length of Full steps array
    LEA SI , STEPS                ; SI = offset of Full steps array
    JMP b   

    a: 
    LEA SI , HSTEPS               ; SI = offset of Half steps array
    MOV CX , 8                    ; CX = length of Half steps array

    b:
    TEST HDIR , 2                 ; Check the rotate direction 0--> clockwise and 1--> anticlock wise
    JNZ  CCW                      ; Jump to CCW if 1

    CW:                           ; Clock wise Direction
        c1: 
            CALL SLEEP            ; Sleep for delay seconds to control the speed of rotation
            MOV  AL     ,[SI]
            OUT  PORTAC , AL      ; Write on the motor the current step
            INC  SI          
            LOOP c1               ; Do this for all elements in the array
        RET
 
    CCW:                          ; Anti clock wise direction
        DEC CX
        ADD SI , CX               ; SI += CX - 1 , which is the last element in the array (step/hstep)
        INC CX
        c2:
            CALL SLEEP            ; Sleep for delay seconds to control the speed of rotation
            MOV  AL , [SI]
            OUT  PORTAC , AL      ; Write on the motor the current step
            DEC  SI
            LOOP c2               ; Do this for all elements in the array

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

REVERSE PROC           ; Update HDIR (direction variable) by :
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

    PUSH CX                  ; Store old counter value in stack

    MOV CX, DELAY            ; Set new counter by DELAY value
    delayloop:               ; Loop for DELAY
    LOOP delayloop

    POP CX                   ; Destore old counter value from stack

    RET	

SLEEP ENDP

;---------------DISPLAY function------------------

DISPLAY PROC
    
    MOV AX, RESULT
    MOV BX, 10
	MOV DX ,0 
	
    DIV BX
    XCHG AL, DL
    OUT PORTCB, AL
    XCHG AL, DL
    MOV DL, 0

    DIV BX
    XCHG AL, DL
    OUT PORTBB, AL
    MOV AL, DL

    DIV BL
	MOV AL,AH
    OUT PORTAB, AL

    RET

DISPLAY ENDP

;---------------GETRESULT function------------------

GETRESULT PROC

    MOV AX,DELAY
    MOV BX,64H
    MUL BX
    MOV BX,185CH
    DIV BX
    MOV RESULT,80H
    SUB RESULT,AX
	
    RET

GETRESULT ENDP

.EXIT

end
