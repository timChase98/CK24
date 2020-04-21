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
		  sel: in STD_LOGIC;
		  AN : out STD_LOGIC_VECTOR (7 downto 0);
          CA : out STD_LOGIC_VECTOR (6 downto 0);
          exeState : out STD_LOGIC_VECTOR(1 downto 0)
	);
end CKiller24;

architecture Behavioral of CKiller24 is

    signal ir : std_logic_vector(23 downto 0);
    signal op : std_logic_vector(4 downto 0);
    
    signal display : std_logic_vector(31 downto 0);
    signal clkDiv : std_logic_vector(20 downto 0);
    
    signal sysBus : std_logic_vector(23 downto 0);
    
    signal regFileA : std_logic_vector(2 downto 0);
    signal regFileD : std_logic_vector(23 downto 0);
    signal regFileQ : std_logic_vector(23 downto 0);
    signal regFileC : std_logic; 
    
    signal aluA, aluB, aluR: std_logic_vector(23 downto 0);
    signal aluOp : std_logic_vector(4 downto 0);
  
begin
	rf: entity RegisterFile PORT MAP (clk => regFileC, addr => regFileA,
	d => regFileD, q => regFileQ);
	
	au: entity ALU PORT MAP(a => aluA, b => aluB, op => op, r=> aluR);

    cu: entity ControlUnit PORT MAP(clk => clk, rst => rst, 
        irOut => ir, exeout => exeState,
        regClk => regFileC,
        regAddr => regFileA,
        regDataD => regFileD,
        regDataQ => regFileQ,
        aluRegA => aluA,
        aluRegB => aluB,
        aluop => op,
        aluRegR => aluR
        );
        
    dp: entity SevenSegmentDigitController PORT MAP (pxlClk => clkDiv(17),
           data => display, latch => clkDiv(19), 
           AN => AN, CA => CA);
    
    display <= (X"00" & regFileD) when sel = '1' else (X"00" & IR); 
    
    process(clk100M)
    begin 
        if(rising_edge(clk100M)) then
            clkdiv <= clkDiv + 1;
        end if;
    end process;
    

end Behavioral;























--
