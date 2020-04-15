----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/04/2020 09:25:57 AM
-- Design Name:
-- Module Name: RegisterFile - Behavioral
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
use work.all;

entity CKiller24 is
	Port (clk100M : in STD_LOGIC;  	
	      clk : in STD_LOGIC;
		  rst: in STD_LOGIC;
		  AN : out STD_LOGIC_VECTOR (7 downto 0);
          CA : out STD_LOGIC_VECTOR (6 downto 0)
	);
end CKiller24;

architecture Behavioral of CKiller24 is

    signal ir : std_logic_vector(23 downto 0);
    signal irValid : std_logic;
    
    signal display : std_logic_vector(31 downto 0);
    signal clkDiv : std_logic_vector(17 downto 0);
  
begin
--	rf: entity RegisterFile PORT MAP (clk => clk, addr => registerAddr,
--	d => registerIn, q => registerOut, en => registerEn);

    cu: entity ControlUnit PORT MAP(clk => clk, rst => rst, 
        irOut => ir, irValid => irValid);
    dp: entity SevenSegmentDigitController PORT MAP (pxlClk => clkDiv(17),
           data => display,  
           latch => irValid, 
           AN => AN, 
           CA => CA);
    
    display <= X"00" & ir; 
    
    process(clk100M)
    begin 
        if(rising_edge(clk100M)) then
            clkdiv <= clkDiv + 1;
        end if;
    end process;
    

end Behavioral;























--
