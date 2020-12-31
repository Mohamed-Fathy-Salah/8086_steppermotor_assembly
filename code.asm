
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
    stpBtn  DB 10H         ; stop value That will stop the motor
    ROTAT DB 20H         ; rotate value that will make the motor to rotate
    CTRLWORD EQU 06H     ; Addresse of port Control Word
    DELAY DW 0FFFFH      ; Delay Value that will control the motor speed
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
    TEST DIR , 1 ; 1 means ccw
    MOV CX , 4
    JNZ CCW
    ; led on/off 
    CW: ; clock wise 
		MOV AL  , 1
        OUT PORTB, AL; led on 
        LEA SI , STEPS
        c1: 
			MOV AL , [SI]
			CALL SLEEP
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
			MOV AL , [SI]
			CALL SLEEP
            OUT PORTC , AL
            DEC SI
            LOOP c2
    RET
RUN ENDP 

;----------------- shahenda
STOP PROC
    ;stop the motor without exiting the program
    RET
STOP ENDP

;----------------------------
GETSPEED PROC       ;Get input from potentiometer to claculate and set Delay
   
    MOV AL , 00H
    IN AL , PORTA                   ; Take input from potentiometer

    MOV AH , AL                     
    MOV AL , OB
    SHL AX , 1
    inc AX

    MOV DELAY , OFFH
    ADD DELAY , AX

    MOV AL , DIR            
    and AL , 00000011B
    OUT PORTB , AL                  ; set write bit in ADC

    MOV CX , 00FFH                  ; Delay
    convert: Loop convert

    and AL , 00000001B              
    OUT PORTB , AL                  ; Reset write bit in ADC

    RET

GETSPEED ENDP

;----------------- AhmadYasser
GETPRESSED PROC

  ; check if the stop or the rotate button is pressed 
<<<<<<< HEAD
    MOV DX, PORTC    
    IN AL, DX   ; read the content of port c
    TEST AL, stpBtn    ; compare port c with stop value 
    JZ TEST2            ; go to second test 
    CALL STOP
    TEST2:
        TEST AL,ROTAT   ; compare port c with rotate value
        JZ ENP          ; exit 
        XOR DIR,01H           ; xoring dir with 1 to invert the dir


ENP:


=======
  RET
>>>>>>> 134d156adfba744d25de619882810fe6ecd0fb1c
GETPRESSED ENDP

;----------------- omar
SLEEP PROC
    ; delay for DELAY cycles
    MOV CX, DELAY
    delayloop:loop delayloop
    RET	
SLEEP ENDP

.EXIT

end
