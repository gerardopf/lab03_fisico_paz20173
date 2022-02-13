/*	
    Archivo:		lab03_fisico_progra.s
    Dispositivo:	PIC16F887
    Autor:		Gerardo Paz 20173
    Compilador:		pic-as (v2.30), MPLABX V6.00

    Programa:		Contador 
    Hardware:		7 segmentos en el puerto C

    Creado:			09/02/22
    Última modificación:	12/02/22	
*/

PROCESSOR 16F887
#include <xc.inc>
 
; CONFIG1
CONFIG  FOSC = INTRC_NOCLKOUT ; Oscillator Selection bits (INTOSCIO oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled and can be enabled by SWDTEN bit of the WDTCON register)
CONFIG  PWRTE = ON            ; Power-up Timer Enable bit (PWRT enabled)
CONFIG  MCLRE = OFF           ; RE3/MCLR pin function select bit (RE3/MCLR pin function is digital input, MCLR internally tied to VDD)
CONFIG  CP = OFF              ; Code Protection bit (Program memory code protection is disabled)
CONFIG  CPD = OFF             ; Data Code Protection bit (Data memory code protection is disabled)
CONFIG  BOREN = OFF           ; Brown Out Reset Selection bits (BOR disabled)
CONFIG  IESO = OFF            ; Internal External Switchover bit (Internal/External Switchover mode is disabled)
CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enabled bit (Fail-Safe Clock Monitor is disabled)
CONFIG  LVP = ON              ; Low Voltage Programming Enable bit (RB3/PGM pin has PGM function, low voltage programming enabled)

; CONFIG2
CONFIG  BOR4V = BOR40V        ; Brown-out Reset Selection bit (Brown-out Reset set to 4.0V)
CONFIG  WRT = OFF             ; Flash Program Memory Self Write Enable bits (Write protection off)

   
PSECT resVect, class=CODE, abs, delta=2
// -------- Configuración del RESET --------
    
ORG 00h                       // posición 0000h para el reset
    
resVect:
    PAGESEL main
    GOTO    main
    
PSECT code, delta=2, abs
// -------- Configuración del microcontrolador --------
 
ORG 100h //Dirección 100% seguro de que ya pasó el reseteo
 
 main:
    CALL    setup_io
    BANKSEL PORTC
    
 // LOOP	  
 check_button:
    BTFSC   PORTB, 0	//Revisar RB0
    CALL    button_inc
    
    BTFSC   PORTB, 1	//Revisar RB1
    CALL    button_dec
    
    GOTO    check_button

 setup_io:
    BANKSEL ANSEL
    CLRF    ANSEL
    CLRF    ANSELH	    //Entradas y salidas digitales
    
    BANKSEL TRISC
    CLRF    TRISC	    //PORT C out
    CLRF    TRISA	    //Port A out
    
    BANKSEL TRISB
    BSF	    TRISB, 0	    //RB0 in
    BSF	    TRISB, 1	    //RB1 in
    
    BANKSEL PORTB
    CLRF    PORTC	    //Limpiar C
    CLRF    PORTB	    //Limpiar B
    CLRF    PORTA	    //Limpiar A
       
    RETURN
    
    
 button_inc:
    BTFSC   PORTB, 0	//Revisar button en RB0
    GOTO    $-1
    
    INCF    PORTA	//incrementar A
    MOVF    PORTA, W	//Mover el valor de A 
    CALL    tabla	//La tabla devuelve el valor de A convertido a 7 segmentos
    MOVWF   PORTC	//El valor convertido se va a C
    
    GOTO check_button
    
    
 button_dec:
    BTFSC   PORTB, 1	//Revisar button en RB0
    GOTO    $-1
    
    DECF    PORTA	//incrementar A
    MOVF    PORTA, W	//Mover el valor de A 
    CALL    tabla	//La tabla devuelve el valor de A convertido a 7 segmentos
    MOVWF   PORTC	//El valor convertido se va a C
    
    GOTO check_button
    
 ORG 200h   
 tabla:
    CLRF    PCLATH
    BSF	    PCLATH, 1	//LATH en posición 1
    
    ANDLW   0x0F	//No sobrepasar el tamaño de la tabla (<16)
    ADDWF   PCL		//PC = PCLATH + PCL 
    
    RETLW   00111111B	//0
    RETLW   00000110B	//1
    RETLW   01011011B	//2
    RETLW   01001111B	//3
    RETLW   01100110B	//4
    RETLW   01101101B	//5
    RETLW   01111101B	//6
    RETLW   00000111B	//7
    RETLW   01111111B	//8
    RETLW   01101111B	//9
    RETLW   01110111B	//A
    RETLW   01111100B	//B
    RETLW   00111001B	//C
    RETLW   01011110B	//D
    RETLW   01111001B	//E
    RETLW   01110001B	//F
    
 END
    

   


