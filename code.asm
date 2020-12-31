
;Componants' place :
; ADC (potentiometer)       on port A
; Direction led             on port B 0
; Write bit of ADC          on port B 1
; Stop Switch               on port C 4
; Rotate Switch             on port C 5
; Stepper motor (driver)    on port C 0-3

.MODEL SMALL

.DATA                    ; Data segment

    PORTA EQU 00H        ; Address of port A
    PORTB EQU 02H        ; Address of port B
    PORTC EQU 04H        ; Address of port C
    stpBtn DB 10H        ; stop value That will stop the motor
    ROTAT DB 20H         ; rotate value that will make the motor to rotate
    CTRLWORD EQU 06H     ; Addresse of port Control Word
    DELAY DW 000FFH      ; Delay Value that will control the motor speed
    DIR DB 00H           ; Direction of Stepper Motor (0/1)
    STEPS DB 00000011B,  ; Full Step Mode
             00000110B, 
             00001100B, 
             00001001B   
     


.STACK                   ; Stack segment
    DB 128D DUP(0B)



.CODE                    ; Code segment
.STARTUP

;-------Configration of Ports---------
    MOV AL ,10010000B    ; mode 0 port a input , b output , c output/input 
    OUT CTRLWORD , AL

;-------Main Loop----------
MAIN PROC
    CALL GETSPEED
    CALL GETPRESSED
    CALL RUN 
    JMP MAIN
MAIN ENDP

;-----------------fathy
RUN PROC 
    ;check on dir and jump to cw or ccw  
    MOV CX , 4
    TEST DIR , 1 ; 1 means ccw
    JNZ CCW
    ; led on/off 
    CW: ; clock wise 
		MOV AL  , 1
        OUT PORTB, AL; led on 
        LEA SI , STEPS
        c1: 
			CALL SLEEP
			MOV AL , [SI]
            OUT PORTC , AL
            INC SI
            LOOP c1
        RET

    CCW: ; anti clock wise
        ; not working yet 
		MOV AL  , 0
        OUT PORTB, AL; led off
        LEA SI , STEPS 
		ADD SI , 3
        c2:
			CALL SLEEP
			MOV AL , [SI]
            OUT PORTC , AL
            DEC SI
            LOOP c2
    RET
RUN ENDP 

;----------------- shahenda
STOP PROC
    ;stop the motor without exiting the program
     MOV DX , PORTC
     IN AL ,DX
     TEST AL , stpBtn   
     JNZ MAIN

    RET
STOP ENDP

;-----------------Get Speed---------------

GETSPEED PROC       ;Get input from potentiometer to claculate and set Delay

    MOV AX , 0B                ; Clear Al and AH
    IN AL , PORTA              ; Get input from potentiometer
    MOV AH , AL                ; Transfer input to higher AX 8-bits  
    MOV AL , 0B
    SHL AX , 1                 ; Shift left by one as the left most bit from input never set
    inc AH                     ; Set the shifted bit

    MOV DELAY , 09FFH          ; Make delay its intial value
    ADD DELAY , AX             ; compute the new DELAY

    MOV AL , DIR               
    OR AL , 00000010B
    OUT PORTB , AL             ; reset the write bits of ADC

    MOV CX , 00FFH             ; delay
    convert: Loop convert

    AND AL , 00000001B         
    OUT PORTB , AL             ; set the write bits of ADC

    MOV AX , 0B                ; Clear Al and AH

    RET

GETSPEED ENDP

;-----------------REVERSE----------------- 

REVERSE PROC     ; check if the stop or the rotate button is pressed 


    RET
REVERSE ENDP

;----------------- omar
SLEEP PROC
    ; delay for DELAY cycles
    PUSH CX
    MOV CX, DELAY
    delayloop:loop delayloop
    POP CX
    RET	
SLEEP ENDP

.EXIT

end