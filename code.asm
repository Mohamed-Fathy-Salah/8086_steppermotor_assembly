
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
    STOP  DB 10H         ; stop value That will stop the motor
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
   ; led on/off 
    CW: ; clock wise 

    CCW: ; anti clock wise
RUN ENDP 

;----------------- shahenda
STOP PROC
    ;stop the motor without exiting the program
STOP ENDP

;-----------------  Nashaat
GETSPEED PROC       ;Get input from potentiometer to claculate and set Delay


GETSPEED ENDP

;----------------- AhmadYasser
GETPRESSED PROC

  ; check if the stop or the rotate button is pressed 
    MOV DX, PORTC    
    IN AL, DX   ; read the content of port c
    TEST AL, STOP    ; compare port c with stop value 
    JNZ L1           ; Go to L1 if zero flag is 0


    L1:
        CALL STOP
       

  

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
