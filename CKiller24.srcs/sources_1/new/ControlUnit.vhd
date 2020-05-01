----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/13/2020 03:12:07 PM
-- Design Name:
-- Module Name: ControlUnit - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY ControlUnit IS
	PORT (
		clk : IN STD_LOGIC;
		rst : IN STD_LOGIC;
		regDataQ : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		ramDataQ : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		ramDone : IN STD_LOGIC;
		aluRegR : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
		aluRegS : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		irOut : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		pcOut : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		exeOut : OUT std_logic_vector(1 DOWNTO 0);
		regEn : OUT std_logic;
		regAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		regDataD : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		regInc : OUT STD_LOGIC;
		regDec : OUT STD_LOGIC;
		ramRW : OUT STD_LOGIC;
		ramAddr : OUT STD_LOGIC_VECTOR(11 DOWNTO 0);
		ramDataD : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		aluSLatch : OUT STD_LOGIC;
		aluSRst : OUT STD_LOGIC;
		aluRegA : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		aluRegB : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
		aluOp : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		opaOut : out std_logic_vector(23 downto 0);
		opbOut : out std_logic_vector(23 downto 0)
	);
END ControlUnit;

ARCHITECTURE Behavioral OF ControlUnit IS

	COMPONENT progmem IS
		PORT (
			clka : IN STD_LOGIC;
			ena : IN STD_LOGIC;
			addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			douta : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
		);
	END COMPONENT;

	TYPE instructionState IS (RESET, FETCH, OP1, OP2, EXE);
	TYPE fetchState IS (setAddr, addrValid, dataValid, pcInc);
	TYPE operandState IS (setRegA, getRegD, ramAddrValid, ramDataCLk, ramDataValid);
	TYPE executionState IS (opALU, aluRst, addrValid, store);
	SIGNAL iState : instructionState;
	SIGNAL fState : fetchState;
	SIGNAL opState : operandState;
	SIGNAL eState : executionState;

	TYPE opTypes IS (NONE, OP_OP, BR, JMP, MV);

	SIGNAL PC : std_logic_vector(15 DOWNTO 0);
	SIGNAL IR : std_logic_vector(23 DOWNTO 0);

	SIGNAL progmemAddr : std_logic_vector(15 DOWNTO 0);
	SIGNAL progmemData : std_logic_vector(23 DOWNTO 0);

	SIGNAL optype : opTypes;
	SIGNAL numOPs : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL OPCode : STD_LOGIC_VECTOR (4 DOWNTO 0);
	SIGNAL OP1Val : STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL OP1AM : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL OP2Val : STD_LOGIC_VECTOR (2 DOWNTO 0);
	-- imm 9 is not used for any instruction
	SIGNAL OP2AM : STD_LOGIC_VECTOR (1 DOWNTO 0);
	SIGNAL IMM14 : std_logic_vector(13 DOWNTO 0);
	SIGNAL IMM15 : std_logic_vector(14 DOWNTO 0);
	SIGNAL Mask : std_logic_vector(3 DOWNTO 0);

	SIGNAL opA : std_logic_vector(23 DOWNTO 0);
	SIGNAL opB : std_logic_vector(23 DOWNTO 0);
	SIGNAL result : std_logic_vector(23 DOWNTO 0);

	SIGNAL allowPostInc : std_logic_vector(1 DOWNTO 0);
	
	signal blCnt : std_logic_vector(11 downto 0);
	signal blPtr : std_logic_vector(11 downto 0);

BEGIN
	PROCESS (clk, rst)
	BEGIN
		IF (rst = '1') THEN
			-- init states
			iState <= RESET;
			fstate <= setAddr;
			opState <= setRegA;
			eState <= opALU;
			ramRW <= '0';
			-- set the program counter and instruction register to 0
			PC <= (OTHERS => '0');
			IR <= (OTHERS => '0');

		ELSIF (rising_edge(clk)) THEN
			CASE iState IS
				WHEN RESET => 
					iState <= FETCH;
					fState <= setAddr;
				WHEN FETCH => 
					-- also handles post increment for register file addressing mode
					exeOut <= "00";
					opState <= setRegA;
					aluSRst <= '0';
					CASE fstate IS
						WHEN setAddr => 
							fstate <= addrValid;
							IF (OP1AM(1) = '1' AND allowPostInc(0) = '1') THEN
								regAddr <= OP1VAL;
								regInc <= '1';
								regEn <= '1';
							END IF;
						WHEN addrValid => 
							-- one clock propegation from addresss valid
							-- to data valid
							fstate <= dataValid;

							IF (OP2AM(1) = '1' AND allowPostInc(1) = '1') THEN
								regAddr <= OP2VAL;
								regInc <= '1';
								regEn <= '1';
							ELSE
								regInc <= '0';
								regEn <= '0';
							END IF;
						WHEN dataValid => 
							IR <= progmemData;
							fstate <= pcInc;
							regInc <= '0';
							regEn <= '0';
						WHEN pcInc => 
						
							IF (IR(23 DOWNTO 20) = X"0") THEN -- halt and wait
								fState <= dataValid;
							ELSIF (IR(23 downto 19) = "00010") then 
    							iState <= RESET;
							ELSE
								
							PC <= PC + 1;
							END IF;
						
							fstate <= setAddr;
							CASE numOps IS
								WHEN "00" => 
									iState <= EXE;
								WHEN "01" => 
									iState <= OP1;
								WHEN "10" => 
									iState <= OP1;
								WHEN "11" => 
									iState <= EXE;
								WHEN OTHERS => 
									iState <= FETCH;
                            END CASE;
                    END CASE;
				-- end fetch
				WHEN OP1 => 
					exeOut <= "01";
					eState <= opAlu;
					CASE opState IS
						WHEN setRegA => 
							regAddr <= op1Val;
							opState <= getRegD;
							-- get the immediate
							-- this will be overwriten if there are two ops
							opB <= (OTHERS => imm14(13));
							opB(13 DOWNTO 0) <= imm14;

						WHEN getRegD => 
							IF (op1AM(0) = '1') THEN -- register indirect
								ramAddr <= regDataQ(11 DOWNTO 0);
								opState <= ramAddrValid;
							ELSE -- register direct
								opA <= regDataQ;
								CASE numOps IS
									WHEN "01" => 
										iState <= EXE;
									WHEN "10" => 
										iState <= OP2;
										opState <= setRegA;
									WHEN OTHERS => 
										iState <= FETCH;
								END CASE;
							END IF;
						WHEN ramAddrValid => 
							opState <= ramDataclk;
						WHEN ramDataClk => 
							opState <= ramDataValid;
						WHEN ramDataValid => 
							opState <= setRegA;
							opA <= ramDataQ;
							CASE numOps IS
								WHEN "01" => 
									iState <= EXE;
								WHEN "10" => 
									iState <= OP2;
								WHEN OTHERS => 
									iState <= FETCH;
						END CASE;
				END CASE;
				-- end OP1
				WHEN OP2 => 
					exeOut <= "10";
					CASE opState IS
						WHEN setRegA => 
							regAddr <= op2Val;
							opState <= getRegD;
						WHEN getRegD => 
							IF (op2AM(0) = '1') THEN -- register indirect
								ramAddr <= regDataQ(11 DOWNTO 0);
								opState <= ramAddrValid;
							ELSE -- register direct
								opB <= regDataQ;
								iState <= EXE;
							END IF;
						WHEN ramAddrValid => 
							opState <= ramDataclk;
						WHEN ramDataClk => 
							opState <= ramDataValid;
						WHEN ramDataValid => 
							opState <= setRegA;
							opB <= ramDataQ;
							iState <= EXE;
				END CASE;
				-- end OP2
				WHEN EXE => 
					exeOut <= "11";
					fState <= setAddr;
					CASE opType IS
						WHEN OP_OP => 
							CASE eState IS
								WHEN opALU => 
									regAddr <= OP1Val;
									aluOp <= opCode;
									aluRegA <= opA;
									aluRegB <= opB;
									eState <= aluRst;
								WHEN aluRst => 
									aluSLatch <= '1';
									IF (op1AM(0) = '1') THEN -- register indirect
										ramAddr <= regDataQ(11 DOWNTO 0);
										ramDataD <= aluRegR;
									ELSE
										regDataD <= aluRegR;
										regEn <= '0';
									END IF;
									eState <= addrValid;
								WHEN addrValid => 
									aluSLatch <= '0';
									IF (op1AM(0) = '1') THEN -- register indirect
										ramRW <= '1';
									ELSE
										regEn <= '1';
									END IF;
									eState <= store;
								WHEN store => 
									ramRW <= '0';
									regEn <= '0';
									iState <= FETCH;
									eState <= opALU;
						END CASE;

						WHEN BR => 
							IF ((aluRegS AND mask) = mask) THEN
								pc <= '0' & IMM15;
							END IF;
							iState <= FETCH;
						WHEN JMP => 
							CASE OPCODE IS
								WHEN "11001" => -- JMPI
									PC <= '0' & IMM15;
									iState <= FETCH;
								WHEN "11010" => -- JSR
									-- push PC
									CASE eState IS
										WHEN opAlu => 
											regAddr <= "111"; -- reg7 is the stack pointer
											eState <= aluRst;
										WHEN aluRst => 
											ramAddr <= regDataQ(11 DOWNTO 0);
											ramDataD <= X"00" & PC;
											ramRW <= '1';
											regDec <= '1';
											regEn <= '1';
											eState <= addrValid;
										WHEN addrValid => 
											PC <= '0' & IMM15;
											ramRW <= '0';
											regDec <= '0';
											regEn <= '0';
											iState <= FETCH;
										WHEN OTHERS => 
											iState <= FETCH;
								END CASE;
								WHEN "11011" => -- RSR
									-- POP into PC
									CASE eState IS
										WHEN opAlu => 
											regAddr <= "111"; -- reg7 is the stack pointer
											eState <= aluRst;
										WHEN aluRst => 
											ramAddr <= regDataQ(11 DOWNTO 0);
											regInc <= '1';
											regEn <= '1';
											eState <= addrValid;
										WHEN addrValid => 
											regInc <= '0';
											regEn <= '0';
											eState <= store;
										WHEN store => 
											PC <= ramDataQ(15 DOWNTO 0);
											iState <= FETCH;
										WHEN OTHERS => 
											iState <= FETCH;
								END CASE;
								WHEN OTHERS => 
									iState <= FETCH;
						END CASE;
						WHEN MV => 
							CASE OPCODE IS
								WHEN "01010" => -- MVS
									CASE eState IS
										WHEN opALU => 
											regAddr <= OP1Val;
											eState <= aluRst;
										WHEN aluRst => 
											IF (op1AM(0) = '1') THEN -- register indirect
												ramAddr <= regDataQ(11 DOWNTO 0);
												ramDataD <= OPB;
											ELSE
												regDataD <= OPB;
												regEn <= '0';
											END IF;
											eState <= addrValid;
										WHEN addrValid =>
											IF (op1AM(0) = '1') THEN -- register indirect
												ramRW <= '1';
											ELSE
												regEn <= '1';
											END IF;
											eState <= store;
										WHEN store => 
											ramRW <= '0';
											regEn <= '0';
											iState <= FETCH;
											eState <= opALU;
								END CASE;
								WHEN "01011" => -- MVMI
									iState <= FETCH;
								WHEN "01101" => -- MMS
									CASE eState IS
										WHEN opALU => 
											-- read mem
											ramAddr <= IMM14(11 DOWNTO 0);
											regAddr <= OP1VAL;
											eState <= aluRst;
										WHEN aluRst => 
											eState <= addrValid;
										WHEN addrValid => 
											IF (OP1AM(0) = '1') THEN
												ramAddr <= regDataQ(11 DOWNTO 0);
												ramDataD <= ramDataQ;
												ramRW <= '1';
											ELSE
												regDataD <= ramDataQ;
												regEn <= '1';
											END IF;
											eState <= store;
										WHEN store => 
											ramRW <= '0';
											regEn <= '0';
											iState <= FETCH;
											eState <= opALU;
										WHEN OTHERS => 
											iState <= FETCH;
								END CASE;
								WHEN "01100" => -- MSM
									CASE eState IS
										WHEN opALU => 
											ramAddr <= IMM14(11 DOWNTO 0);
											ramDataD <= OPA;
											ramRW <= '1';
											eState <= aluRst;
										WHEN aluRst => 
											ramRW <= '0';
											iState <= FETCH;
											eState <= opALU;
										WHEN OTHERS => 
											iState <= FETCH;
											eState <= opALU;
								END CASE;
								WHEN "01110" => -- BLRM
								    case eState is
								        when opAlu => 
								            blcnt <= O"0000";
								            eState <= aluRst;
								        when aluRst => 
								            regAddr <= blCnt(2 downto 0);
								            blPtr <= IMM15(11 downto 0) + blCnt;
								            
								        
								        when others => 
								            iState <= FETCH;
								    end case;
								            

								WHEN OTHERS => 
									iState <= FETCH;
						  END CASE;
						WHEN NONE => -- special handling for control instrutcions 
						    CASE opcode is 
						        when "11111" => 
                                    aluSRst <= '0';
                                    iState <= FETCH;
                                when others =>
                                    iState <= FETCH;
						    end case;
						WHEN OTHERS => 
							iState <= FETCH;
				END CASE;

				-- end EXE
				WHEN OTHERS => 
					iState <= FETCH;
			END CASE;
		END IF;
	END PROCESS;

	pm : progmem
	PORT MAP(
		addra => progmemAddr, clka => clk, 
		douta => progmemData, ena => '1');
		irOut <= IR;
		pcOut <= PC;
		progmemAddr <= PC;
		OPCode <= IR(23 DOWNTO 19);
		OP1AM <= IR(18 DOWNTO 17);
		OP1VAL <= IR(16 DOWNTO 14);
		OP2AM <= IR(13 DOWNTO 12);
		OP2VAL <= IR(11 DOWNTO 9);
		IMM14 <= IR(13 DOWNTO 0);
		IMM15 <= IR(14 DOWNTO 0);
		Mask <= IR(18 DOWNTO 15);

        opaOut <= opa;
        opbOut <= opb;

		WITH opCode SELECT numOps <= 
			"00" WHEN "00000", -- halt
			"00" WHEN "00001", -- wait
			"00" WHEN "00010", -- reset
			"00" WHEN "00011", -- blmr
			"01" WHEN "00100", -- clr
			"01" WHEN "00101", -- inc
			"01" WHEN "00110", -- dec
			"01" WHEN "00111", -- neg
			"01" WHEN "01000", -- sll
			"01" WHEN "01001", -- srl
			"10" WHEN "01010", -- mvs
			"00" WHEN "01011", -- mvmi
			"01" WHEN "01100", -- msm
			"00" WHEN "01101", -- mms
			"00" WHEN "01110", -- blrm
			"00" WHEN "01111", -- blmr
			"10" WHEN "10000", -- add
			"10" WHEN "10001", -- sub
			"10" WHEN "10010", -- mul
			"10" WHEN "10011", -- div
			"10" WHEN "10100", -- and
			"10" WHEN "10101", -- or
			"10" WHEN "10110", -- xor
			"01" WHEN "10111", -- addi
			"01" WHEN "11000", -- subi
			"11" WHEN "11001", -- jmpi
			"11" WHEN "11010", -- jsr
			"11" WHEN "11011", -- rsr
			"11" WHEN "11100", -- br
			"00" WHEN "11101", -- inttgl
			"00" WHEN "11110", -- rti
			"00" WHEN "11111"; -- clrs

        WITH opCode SELECT allowPostInc <= 
            "00" WHEN "00000", -- halt
            "00" WHEN "00001", -- wait
            "00" WHEN "00010", -- reset
            "00" WHEN "00011", -- blmr
            "01" WHEN "00100", -- clr
            "01" WHEN "00101", -- inc
            "01" WHEN "00110", -- dec
            "01" WHEN "00111", -- neg
            "01" WHEN "01000", -- sll
            "01" WHEN "01001", -- srl
            "11" WHEN "01010", -- mvs
            "00" WHEN "01011", -- mvmi
            "01" WHEN "01100", -- msm
            "01" WHEN "01101", -- mms
            "00" WHEN "01110", -- blrm
            "00" WHEN "01111", -- blmr
            "11" WHEN "10000", -- add
            "11" WHEN "10001", -- sub
            "11" WHEN "10010", -- mul
            "11" WHEN "10011", -- div
            "11" WHEN "10100", -- and
            "11" WHEN "10101", -- or
            "11" WHEN "10110", -- xor
            "01" WHEN "10111", -- addi
            "01" WHEN "11000", -- subi
            "00" WHEN "11001", -- jmpi
            "00" WHEN "11010", -- jsr
            "00" WHEN "11011", -- rsr
            "00" WHEN "11100", -- br
            "00" WHEN "11101", -- inttgl
            "00" WHEN "11110", -- rti
            "00" WHEN "11111"; -- clrs

            WITH opCode SELECT opType <= 
                NONE WHEN "00000", -- halt
                NONE WHEN "00001", -- wait
                NONE WHEN "00010", -- reset
                NONE WHEN "00011", -- blmr
                OP_OP WHEN "00100", -- clr
                OP_OP WHEN "00101", -- inc
                OP_OP WHEN "00110", -- dec
                OP_OP WHEN "00111", -- neg
                OP_OP WHEN "01000", -- sll
                OP_OP WHEN "01001", -- srl
                MV WHEN "01010", -- mvs
                NONE WHEN "01011", -- mvmi
                MV WHEN "01100", -- msm
                MV WHEN "01101", -- mms
                MV WHEN "01110", -- blrm
                MV WHEN "01111", -- blmr
                OP_OP WHEN "10000", -- add
                OP_OP WHEN "10001", -- sub
                OP_OP WHEN "10010", -- mul
                OP_OP WHEN "10011", -- div
                OP_OP WHEN "10100", -- and
                OP_OP WHEN "10101", -- or
                OP_OP WHEN "10110", -- xor
                OP_OP WHEN "10111", -- addi
                OP_OP WHEN "11000", -- subi
                JMP WHEN "11001", -- jmpi
                JMP WHEN "11010", -- jsr
                JMP WHEN "11011", -- rsr
                BR WHEN "11100", -- br
                NONE WHEN "11101", -- inttgl
                NONE WHEN "11110", -- rti
                NONE WHEN "11111"; -- clrs

END Behavioral;
--
