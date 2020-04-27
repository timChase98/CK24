; init stack
CLR R7
ADDI R7, 0xFF
; code
CLR R1
ADDI R1, 0xA0
loop:
	MVS (R2), R1
	JSR foo
	JMPI loop
foo:
	inc R1
	RSR
