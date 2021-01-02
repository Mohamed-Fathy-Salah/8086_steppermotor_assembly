
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
    CALL GETPRESSED
    CALL RUN 
    JMP MAIN

    RET
    
MAIN ENDP

;-----------RUN function--------------

RUN PROC 
    ;check on dir and jump to cw or ccw  
    TEST HDIR , 1
    JNZ a
    MOV CX , 4
    LEA SI , STEPS
    JMP b
    a: 
    LEA SI, HSTEPS
    MOV CX , 8
    b:
    TEST HDIR , 2 ; 1 means ccw
    JNZ CCW
    CW: ; clock wise 
        c1: 
            CALL SLEEP
            MOV AL , [SI]
            OUT PORTC , AL
            INC SI
            LOOP c1
        RET
 
    CCW: ; anti clock wise
        DEC CX
        ADD SI , CX
        INC CX
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

    MOV BL, HDIR
    SHR BL,1
    MOV AL , BL

    OR AL , 00000010B
    OUT PORTB , AL             ; reset the write bits of ADC
 
    MOV CX , 00FFH             ; delay
    convert: Loop convert
 
    AND AL , 00000001B         
    OUT PORTB , AL             ; set the write bits of ADC
 
    MOV AX , 0B                ; Clear Al and AH
 
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
