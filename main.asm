CLR R1
CLR R2
ADDI R2, 10
LOOP:
     add R1, R2
     dec R2
     BRZ DONE
     JMPI LOOP
DONE:
     HALT
