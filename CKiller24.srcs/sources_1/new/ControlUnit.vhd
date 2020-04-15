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
           irValid : out std_logic;
           irOut : out STD_LOGIC_VECTOR(23 downto 0)
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

    TYPE fetchState IS (setAddr, addrValid, dataValid, pcInc); 
    TYPE executionState IS (FETCH, OP1, OP2, EXE);
    signal fstate : fetchState;
    signal estate : executionState;
            
    signal PC : std_logic_vector(15 downto 0);
    signal IR : std_logic_vector(23 downto 0);
    
    signal progmemAddr : std_logic_vector(15 downto 0);
    signal progmemData : std_logic_vector(23 downto 0);
    
    
begin

    process(clk, rst)
    begin 
        if(rst = '1') then 
            estate <= FETCH;
            -- set the program counter to 0
            PC <= PC xor PC;
        elsif (rising_edge(clk)) then
           case estate is 
                when FETCH => 
                    case fstate is 
                        when setAddr => 
                            progmemAddr <= PC; 
                            fstate <= addrValid;
                            irValid <= '0'; 
                        when addrValid => 
                            -- one clock propegation from addresss valid 
                            --      to data valid 
                            fstate <= dataValid;
                        when dataValid => 
                            IR <= progmemData; 
                            fstate <= pcInc;
                        when pcInc => 
                            PC <= PC + 1;
                            irValid <= '1';
                            fstate <= setAddr;            
                            estate <= FETCH;
                    end case;
                when OP1 =>
                    estate <= OP2;
                when OP2 => 
                    estate <= EXE;
                when EXE =>
                    estate <= FETCH;
                when others => 
                    estate <= FETCH;  
            end case;
        end if;
    end process;
    
    pm :  progmem PORT MAP (addra => progmemAddr, clka => clk, dina => X"000000",
    douta => progmemData, ena => '1', rsta => rst, Wea => "0");
    irOut <= IR; 

end Behavioral;




















--