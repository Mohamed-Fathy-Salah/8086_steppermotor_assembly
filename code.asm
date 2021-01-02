
;Componants' place :
    ; ADC (potentiometer)       on port A
    ; Direction led             on port B 0
    ; Write bit of ADC          on port B 1
    ; Rotate Switch             on port C 5
    ; Stepper motor (driver)    on port C 0-3

.MODEL SMALL

.DATA                        ; Data segment

    PORTA EQU 00H            ; Address of port A
    PORTB EQU 02H            ; Address of port B
    PORTC EQU 04H            ; Address of port C
    CTRLWORD EQU 06H         ; Addresse of port Control Word
    ROTATE DB 20H            ; Addresse of Rotate Switch that reverse stepper motor direction
    DELAY  DW 0H             ; DELAY Value that will control the stepper motor speed
    HDIR    DB 00H           ; Direction of Stepper Motor (0/1) and (step / half step)
    RHS DB 30H               ;
    STEPS  DB 00000011B,     ; Full Step Mode
              00000110B, 
              00001100B, 
              00001001B   
     


.STACK  10H                  ; Stack segment


.CODE                        ; Code segment

.STARTUP

;---------Configration of PORTS---------
    MOV AL ,10010000B         
    OUT CTRLWORD , AL        ; Set Control Word

    ; port_A --> input 
    ; port_B --> output 
    ; port_C --> (input-output)

;-------------MAIN LOOP----------------

MAIN PROC

    CALL GETSPEED
    CALL REVERSE
    CALL RUN 
    JMP  MAIN
    
    RET
MAIN ENDP

;-----------RUN function--------------

RUN PROC            ; 1- Check the direction button (DIC) to determine the step diection (cw/ccw) 
                    ; 2- Run in the determined direction

    MOV  CX  , 4                 ; Set counter by 4
    TEST DIR , 1                 ; IF Rotate Switch is pressed then step in reverse direction (DIR=1)
    JNZ  CCW                     
   
    CW:                          ; Clock wise direction
        LEA SI , STEPS           ; Set pointer to STEPS array
        c1:                      ; Step 
	CALL SLEEP
	MOV  AL    ,[SI]
        OUT  PORTC , AL
        INC  SI
        LOOP c1
        RET

    CCW:                         ; Anti clock wise direction
        LEA  SI  , STEPS         ; Set pointer to STEPS array
	ADD  SI  , 3             ; Make the pointer point to last of STEPS array
        c2:                      ; Step in reverse direction
	CALL SLEEP
	MOV  AL    ,[SI]
        OUT  PORTC , AL
        DEC  SI
        LOOP c2
    RET

RUN ENDP 

;---------------GET_SPEED function---------------

GETSPEED PROC       ; 1- Get input from potentiometer to calculate and set DELAY
                    ; 2- Set and Reset Write bit of ADC (to converts analog value to digital vale)
                    ; 3- Turn the LED on if the DIR = 1 (step in reverse direction (CCW))

    IN  AL , PORTA              ; Get input from potentiometer in AL
    MOV BL , 35                 
    MUL BL                      ; AX = AX * BL 
    ADD AX , 06FFH              ; Add AX to intial value of DELAY (initial value = the smallest value of DELAY) 
    MOV DELAY , AX              ; DELAY = AX + intial value

    MOV AL , DIR                ; Take value of DIR
    OR  AL , 00000010B          ; Check if DIR = 1 , then turn led on 
    OUT PORTB , AL              ; Reset the write bits of ADC

    MOV CX , 00FFH              ; delay
    convert: Loop convert

    AND AL , 00000001B         
    OUT PORTB , AL              ; Set the write bits of ADC

    MOV AX , 0B                 ; Clear Al and AH

    RET

GETSPEED ENDP

;---------------GETPRESSED function----------------- 

GETPRESSED PROC
    IN AL, PORTC            ; read the content of port c
    AND AL , RHS
    MOV BX ,16
    DIV BX
    MOV HDIR , AL
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

.EXIT

end
