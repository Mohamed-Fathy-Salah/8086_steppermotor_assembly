.MODEL SMALL
.DATA
    PORTA EQU 00H
    PORTB EQU 02H
    PORTC EQU 04H
    CTRLWORD EQU 06H
    DELAY DW 0FFFFH
    STEPS DB 00000011B , 00000110B,00001100B,00001001B  ; full step
    DIR DB 00H;
;stop portc4
;rotate portc5
    
.CODE
.STARTUP
    MOV AL ,10010000B ; mode 0 port a input , b output , c output/input 
    OUT CTRLWORD , AL
;-----------------
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
;----------------- shahendah
STOP PROC
    ;stop the motor without exiting the program
STOP ENDP
;-----------------nashaat
GETSPEED PROC
    ;claculate delay and set delay
GETSPEED ENDP
;----------------- yasser
GETPRESSED PROC
  ; check if the stop or the rotate button is pressed 
GETPRESSED ENDP
;----------------- omar
SLEEP PROC
    ; delay for DELAY cycles
SLEEP ENDP
.EXIT
end
