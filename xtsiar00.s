; Vernamova sifra na architekture DLX
; Ivan Tsiareshkin, xtsiar00

        .data 0x04          ; zacatek data segmentu v pameti
login:  .asciiz "xtsiar00"  ; <-- nahradte vasim loginem
cipher: .space 9 ; sem ukladejte sifrovane znaky (za posledni nezapomente dat 0)

        .align 2            ; dale zarovnavej na ctverice (2^2) bajtu
laddr:  .word login         ; 4B adresa vstupniho textu (pro vypis)
caddr:  .word cipher        ; 4B adresa sifrovaneho retezce (pro vypis)

        .text 0x40          ; adresa zacatku programu v pameti
        .global main        ; 

main:   ; sem doplnte reseni Vernamovy sifry dle specifikace v zadani
	addi r3, r0, 0       ; index
	addi r5, r0, 97      ; check for number
	addi r7, r0, 0       ; reg for symb load
	addi r9, r0, 0       ; counter
	addi r29, r0, 0	     ; checker
loop:	
	addi r5, r0, 97      
	lb r7, login(r3)     ; load first symbol from login  
	sgt r29, r5, r7      ; check if r7 is number or valid symbol
	bnez r29, finish     ; if symbol = digit => go to finish and end
	nop
	nop
	beqz r9, plus        ; if counter = 0 => go to plus
	nop
	nop
	j minus              ; else => go to minus
	nop 
	nop

minus:
	subi r7, r7,  19    ; s => - 19
	addi r9, r0, 0      ; counter = 0
	sgt r29, r5, r7     ; if log symbol < 97
	bnez r29, underflow ; go to underflow 
	nop	
	nop
	sb cipher(r3), r7   ; store changed symbol in cipher
	addi r3, r3, 1      ; index++
	j loop
	nop
	nop

plus:
	addi r7, r7, 20     ; t => + 20
	addi r9, r0, 1      ; counter = 1
	addi r5, r0, 122
	sgt r29, r7, r5     ; if log symbol > 122
	bnez r29, overflow  ; go to overflow
	nop
	nop 
	sb cipher(r3), r7   ; store changed symbol in cipher
	addi r3, r3, 1      ; index++
	j loop
	nop
	nop

underflow:
	addi r7, r7, 26    ; fix underflow => +26
	sb cipher(r3), r7  ; store changed symbol in cipher
	addi r3, r3, 1     ; index++
	j loop
	nop
	nop

overflow:
	subi r7, r7, 26   ; fix overflow => -26
	sb cipher(r3), r7 ; store changed symbol in cipher
	addi r3, r3, 1    ; index++
	j loop
	nop
	nop

finish: 
	sb cipher(r3), r0 ; store r0 in last symbol of cipher
	j end 
	nop
	nop

end:   
	addi r14, r0, caddr; <-- pro vypis sifry nahradte laddr adresou caddr
        trap 5  ; vypis textoveho retezce (jeho adresa se ocekava v r14)
        trap 0  ; ukonceni simulace