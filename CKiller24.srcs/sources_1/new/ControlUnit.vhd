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
           regAddr : out STD_LOGIC);
end ControlUnit;

architecture Behavioral of ControlUnit is
   
    TYPE phase IS (FETCH, OP1, OP2, EXE);
    signal state : phase;
    
    signal programCounter : std_logic_vector(31 downto 0);
	signal progmemOut : std_logic_vector(31 downto 0);
	signal instructionRegister : std_logic_vector(23 downto 0);
    
begin

    process(clk, rst)
    begin 
        if(rst = '1') then 
            state <= FETCH;
            -- set the program counter to 0
            programCounter <= programCounter xor programCounter;
        elsif (rising_edge(clk)) then
           case state is 
                when FETCH => 
                    state <= OP1;
                when OP1 =>
                    state <= OP2;
                when OP2 => 
                    state <= EXE;
                when EXE =>
                    state <= FETCH;
                when others => 
                    state <= FETCH;  
            end case;
        end if;
    
    end process;
    

end Behavioral;




















--