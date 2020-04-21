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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ControlUnit is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           regDataQ : in STD_LOGIC_VECTOR(23 downto 0);
           aluRegR : in STD_LOGIC_VECTOR(23 downto 0);
           irOut : out STD_LOGIC_VECTOR(23 downto 0);
           exeOut : out std_logic_vector(1 downto 0);
           regClk : out std_logic;
           regAddr : out STD_LOGIC_VECTOR(2 downto 0);
           regDataD : out STD_LOGIC_VECTOR(23 downto 0);
           aluRegA : out STD_LOGIC_VECTOR(23 downto 0);
           aluRegB : out STD_LOGIC_VECTOR(23 downto 0);
           aluOp : out STD_LOGIC_VECTOR(4 downto 0)
           );
end ControlUnit;

architecture Behavioral of ControlUnit is

    component progmem is
        PORT (
            clka : IN STD_LOGIC;
            rsta : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
            rsta_busy : OUT STD_LOGIC
      );
    end component; 

    TYPE instructionState IS (FETCH, OP1, OP2, EXE);
    TYPE fetchState IS (setAddr, addrValid, dataValid, pcInc);
    TYPE operandState IS (setRegA, getRegD, dummy1, dummy2);
    TYPE executionState IS (opALU, aluRst, store);
    signal iState : instructionState;
    signal fState : fetchState;
    signal opState : operandState;
    signal eState : executionState; 
    
    TYPE opTypes IS (NONE, OP_NONE, OP_OP, BR, JMP);
            
    signal PC : std_logic_vector(15 downto 0);
    signal IR : std_logic_vector(23 downto 0);
    
    signal progmemAddr : std_logic_vector(15 downto 0);
    signal progmemData : std_logic_vector(23 downto 0);
    
    signal optype : opTypes;
    signal numOPs : STD_LOGIC_VECTOR (1 downto 0);
    signal OPCode : STD_LOGIC_VECTOR (4 downto 0);
    signal OP1Val : STD_LOGIC_VECTOR (2 downto 0);
    signal OP1AM :STD_LOGIC_VECTOR (1 downto 0);
    signal OP2Val : STD_LOGIC_VECTOR (2 downto 0);
    -- imm 9 is not used for any instruction
    signal OP2AM : STD_LOGIC_VECTOR (1 downto 0);
    signal IMM14 : std_logic_vector(13 downto 0);
    signal IMM15 : std_logic_vector(14 downto 0);
    signal Mask : std_logic_vector(3 downto 0);
    
    signal opA : std_logic_vector(23 downto 0);
    signal opB : std_logic_vector(23 downto 0);
    signal result : std_logic_vector(23 downto 0);

begin

    process(clk, rst)
    begin 
        if(rst = '1') then 
            -- init states
            iState <= FETCH;
            fstate <= setAddr;
            opState <= setRegA;
             
            -- set the program counter to 0
            PC <= PC xor PC;
            
        elsif (rising_edge(clk)) then
            case iState is 
                when FETCH => 
                    exeOut <= "00";
                    case fstate is 
                        when setAddr => 
                            progmemAddr <= PC; 
                            fstate <= addrValid;
                        when addrValid => 
                            -- one clock propegation from addresss valid 
                            --      to data valid 
                            fstate <= dataValid;
                        when dataValid => 
                            IR <= progmemData; 
                            fstate <= pcInc;
                        when pcInc => 
                            PC <= PC + 1;
                            fstate <= setAddr;
                            opState <= setRegA; 
                            case numOps is 
                                when "00" => 
                                    iState <= EXE;
                                when "01" => 
                                    iState <= OP1;
                                when "10" => 
                                    iState <= OP1;
                                when others => 
                                    iState <= FETCH; 
                            end case;
                    end case;
                    -- end fetch 
                when OP1 =>
                    exeOut <= "01";
                    case opState is 
                        when setRegA => 
                            regAddr <= op1Val; 
                            opState <= getRegD;
                        when getRegD => 
                            opA <= regDataQ;
                            opState <= dummy1;
                        -- todo add addressing mode here
                        when dummy1 => 
                            opState <= dummy2;
                        when dummy2 => 
                            opState <= setRegA;
                            case numOps is 
                                when "01" => 
                                    iState <= EXE;
                                    -- opB get the sign extended immediate
                                    opB <= (others => imm14(13));
                                    opB(13 downto 0) <= imm14; 
                                when "10" => 
                                    iState <= OP2;
                                when others => 
                                    iState <= FETCH; 
                            end case;
                            eState <= opALU; 
                    end case;
                    -- end OP1
                when OP2 => 
                    exeOut <= "10";case opState is 
                        when setRegA => 
                            regAddr <= op1Val; 
                            opState <= getRegD;
                        when getRegD => 
                            opB <= regDataQ;
                            opState <= dummy1;
                        -- todo add addressing mode here
                        when dummy1 => 
                            opState <= dummy2;
                        when dummy2 => 
                            opState <= setRegA;
                            -- likely unnessiary 
                            case numOps is 
                                when "10" => 
                                    iState <= EXE;
                                when others => 
                                    iState <= FETCH;
                            end case;
                    end case;
                    -- end OP2
                when EXE =>
                    exeOut <= "11";
                    --case opType is 
                      --  when OP_OP => 
                            case eState is
                                when opALU => 
                                    aluOp <= opCode; 
                                    aluRegA <= opA;
                                    aluRegB <= opB;
                                    eState <= aluRst;
                                when aluRst => 
                                    regDataD <= aluRegR;
                                    regAddr <= OP1Val;
                                    regClk <= '0';
                                    eState <= store;
                                when store => 
                                    regClk <= '1';
                                    iState <= FETCH; 
                            end case;
                                
                    
                      --  when others => 
                        --    iState <= FETCH;
                    --end case;
                    
                    -- end EXE
                when others => 
                    iState <= FETCH;  
            end case;
        end if;
    end process;
    
    pm :  progmem PORT MAP (addra => progmemAddr, clka => clk, dina => X"000000",
    douta => progmemData, ena => '1', rsta => rst, Wea => "0");
    irOut <= IR; 
    
    
    OPCode <= IR(23 downto 19);
    OP1AM <= IR(18 downto 17);
    OP1VAL <= IR(16 downto 14);
    OP2AM <= IR(13 downto 12);
    OP2VAL <= IR(11 downto 9);
    IMM14 <= IR(13 downto 0);
    IMM15 <= IR(14 downto 0);
    Mask <= IR(18 downto 15);
    
    
    
    with opCode select numOps <= 
        "00" when "00000", -- halt
        "00" when "00001", -- wait
        "00" when "00010", -- reset
        "00" when "00011", -- blmr
        "01" when "00100", -- clr
        "01" when "00101", -- inc
        "01" when "00110", -- dec
        "01" when "00111", -- neg
        "01" when "01000", -- sll
        "01" when "01001", -- srl
        "10" when "01010", -- mvs
        "00" when "01011", -- mvmi
        "01" when "01100", -- msm
        "01" when "01101", -- mms
        "00" when "01110", -- blrm
        "00" when "01111", -- blmr
        "10" when "10000", -- add
        "10" when "10001", -- sub
        "10" when "10010", -- mul
        "10" when "10011", -- div
        "10" when "10100", -- and
        "10" when "10101", -- or
        "10" when "10110", -- xor
        "01" when "10111", -- addi
        "01" when "11000", -- subi
        "11" when "11001", -- jmpi
        "11" when "11010", -- jsr
        "00" when "11011", -- rsr
        "11" when "11100", -- br
        "00" when "11101", -- inttgl
        "00" when "11110", -- rti
        "00" when "11111"; -- clrs
        
    with opCode select opType <= 
        NONE when "00000", -- halt
        NONE when "00001", -- wait
        NONE when "00010", -- reset
        NONE when "00011", -- blmr
        OP_NONE when "00100", -- clr
        OP_NONE when "00101", -- inc
        OP_NONE when "00110", -- dec
        OP_NONE when "00111", -- neg
        OP_OP when "01000", -- sll
        OP_OP when "01001", -- srl
        OP_OP when "01010", -- mvs
        NONE when "01011", -- mvmi
        NONE when "01100", -- msm
        NONE when "01101", -- mms
        NONE when "01110", -- blrm
        NONE when "01111", -- blmr
        OP_OP when "10000", -- add
        OP_OP when "10001", -- sub
        OP_OP when "10010", -- mul
        OP_OP when "10011", -- div
        OP_OP when "10100", -- and
        OP_OP when "10101", -- or
        OP_OP when "10110", -- xor
        OP_OP when "10111", -- addi
        OP_OP when "11000", -- subi
        JMP when "11001", -- jmpi
        JMP when "11010", -- jsr
        JMP when "11011", -- rsr
        JMP when "11100", -- br
        NONE when "11101", -- inttgl
        NONE when "11110", -- rti
        NONE when "11111"; -- clrs

end Behavioral;




















--