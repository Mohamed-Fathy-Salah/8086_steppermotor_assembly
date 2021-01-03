
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


.STACK  100H                  ; Stack segment


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
    CALL DISPLAY 
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
    TEST HDIR , 2 ; 2 means ccw and 0 means cw
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
    MOV BL , 35
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

;---------------DISPLAY function------------------

DISPLAY PROC
    CALL GETRESULT
    
    PUSH AX
    PUSH BX
    PUSH DX
    
    MOV AX, RESULT
    MOV BX, 10

    DIV BX
    XCHG AX, DX
    OUT PORTCB, AL
    XCHG AX, DX
    MOV DX, 0H

    DIV BX
    XCHG AX, DX
    OUT PORTBB, AL
    XCHG AX, DX
    MOV DX, 0H

    DIV BX
    XCHG AX, DX
    OUT PORTAB, AL
    XCHG AX, DX
    MOV DX, 0H


    POP DX
    POP BX
    POP AX
    RET

DISPLAY ENDP

;---------------GETRESULT function------------------

GETRESULT PROC
    PUSH AX
    PUSH BX
    PUSH DX
    MOV AX,DELAY
    MOV BX, 0000H
    MOV BX,64H
    MUL BX
    MOV BX,185CH
    DIV BX
    MOV RESULT,0080H
    SUB RESULT,AX
    POP DX
    POP BX
    POP AX
    RET

GETRESULT ENDP

.EXIT

end
