
;Componants' place :
; ADC (potentiometer)       on port A
; Direction led             on port B 0
; Write bit of ADC          on port B 1
; Rotate Switch             on port C 5
; Stepper motor (driver)    on port C 0-3

.MODEL SMALL

.DATA                    ; Data segment

    PORTA EQU 00H        ; Address of port A
    PORTB EQU 02H        ; Address of port B
    PORTC EQU 04H        ; Address of port C
    ROTATE DB 20H        ; rotate value that will make the motor to rotate
    CTRLWORD EQU 06H     ; Addresse of port Control Word
    DELAY DW 01FFFH      ; Delay Value that will control the motor speed
    DIR DB 00H           ; Direction of Stepper Motor (0/1)
    STEPS DB 00000011B,  ; Full Step Mode
             00000110B, 
             00001100B, 
             00001001B   
     


.STACK  10H              ; Stack segment


.CODE                    ; Code segment
.STARTUP

;-------Configration of Ports---------
    MOV AL ,10010000B    ; mode 0 port a input , b output , c output/input 
    OUT CTRLWORD , AL

;-------Main Loop----------
MAIN PROC
    CALL GETSPEED
    CALL REVERSE
    CALL RUN 
    JMP MAIN
    RET
MAIN ENDP

;-----------------fathy
RUN PROC 
    ;check on dir and jump to cw or ccw  
    MOV CX , 4
    TEST DIR , 1 ; 1 means ccw
    JNZ CCW
    CW: ; clock wise 
        LEA SI , STEPS
        c1: 
			CALL SLEEP
			MOV AL , [SI]
            OUT PORTC , AL
            INC SI
            LOOP c1
        RET

    CCW: ; anti clock wise
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

;-----------------Get Speed---------------

GETSPEED PROC       ;Get input from potentiometer to claculate and set Delay

    IN AL , PORTA              ; Get input from potentiometer
	MOV BL , 20
	MUL BL
	ADD AX,06FFH
    MOV DELAY , AX           ; Make delay its intial value

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

    IN AL, PORTC            ; read the content of port c
	AND AL , ROTATE
	MOV BX ,32
	DIV BX
	MOV DIR , AL
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
