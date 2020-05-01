; init stack
CLR R7
ADDI R7, 0xFFF

; code
CLR R1 ; load the value 0x06 into R1
ADDI R1, 0x06

CLR R2 ; load the value 0xAA into R2
ADDI R2, 0xAA

MVS (R2), R1+; mem[AA] = 6, r1 = 7

SUBI (R2), 0x02; mem[R2] = 3

MVS R3, R1; R3 = 7
MUL R3, (R2); R3 = 7 * 3 = 21

MSM R1, 0x55; mem[55] = 3
MMS (R3), 0x55; mem[23] = 3
DEC (R2)

loopAdd:
	ADD (R3), R1; add R1 to the running sum
	DEC (R2)
	BRZ endLoopAdd ; ir R2 is 0 we are done
	JMPI loopAdd ; else continue
endLoopAdd:

; check if ram[r3] = r3

SUB (r3), r3
BRZ equal
JMPI notEqual

equal:
	JSR foo
	JMPI endif
notEqual:
	JSR bar
endif:
HALT
; foo shifts right, bar shift left
; if the compare was equal then R2 would contain 0x55
; if not equal then R2 would contain 154



foo:
	SRL R2, 1
	RSR

bar:
	SLL R2, 1
	RSR


