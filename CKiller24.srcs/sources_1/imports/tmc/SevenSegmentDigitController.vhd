----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/05/2020 08:37:04 AM
-- Design Name: 
-- Module Name: SevenSegmentDigitController - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SevenSegmentDigitController is
    Port ( pxlClk : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (31 downto 0);
           latch : in STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (7 downto 0);
           CA : out STD_LOGIC_VECTOR (6 downto 0));
end SevenSegmentDigitController;

architecture Behavioral of SevenSegmentDigitController is
   
    Component SevenSegmentDecoder is
        Port ( digit : in STD_LOGIC_VECTOR (3 downto 0);
               clk, en : in STD_LOGIC;
               pattern : out STD_LOGIC_VECTOR (6 downto 0));
    end Component;


   signal addressDecoder: std_logic_vector (7 downto 0);
   signal currentDigit : std_logic_vector (2 downto 0);
   signal currentDigitDecoder: std_logic_vector (7 downto 0);
   
   type registerFile is array(0 to 7) of std_logic_vector(6 downto 0);
   signal sevenSegRegisters : registerFile;
   type digitArray is array(0 to 7) of std_logic_vector(3 downto 0);
   signal digits : digitArray;
   
begin

    digits(0) <= data(3 downto 0);
    digits(1) <= data(7 downto 4);
    digits(2) <= data(11 downto 8);
    digits(3) <= data(15 downto 12);
    digits(4) <= data(19 downto 16);
    digits(5) <= data(23 downto 20);
    digits(6) <= data(27 downto 24);
    digits(7) <= data(31 downto 28);

-- create the decoders
    cdd : entity decoder3_8 PORT MAP (s=>currentDigit, o=>CurrentDigitDecoder);
    
    d0: SevenSegmentDecoder PORT MAP (digit=>digits(0), clk=>latch, en => '1', pattern=>sevenSegRegisters(0));
    d1: SevenSegmentDecoder PORT MAP (digit=>digits(1), clk=>latch, en => '1', pattern=>sevenSegRegisters(1));
    d2: SevenSegmentDecoder PORT MAP (digit=>digits(2), clk=>latch, en => '1', pattern=>sevenSegRegisters(2));
    d3: SevenSegmentDecoder PORT MAP (digit=>digits(3), clk=>latch, en => '1', pattern=>sevenSegRegisters(3));
    d4: SevenSegmentDecoder PORT MAP (digit=>digits(4), clk=>latch, en => '1', pattern=>sevenSegRegisters(4));
    d5: SevenSegmentDecoder PORT MAP (digit=>digits(5), clk=>latch, en => '1', pattern=>sevenSegRegisters(5));
    d6: SevenSegmentDecoder PORT MAP (digit=>digits(6), clk=>latch, en => '1', pattern=>sevenSegRegisters(6));
    d7: SevenSegmentDecoder PORT MAP (digit=>digits(7), clk=>latch, en => '1', pattern=>sevenSegRegisters(7));

-- process for muxing clock
process(pxlClk)
begin
    if(rising_edge(pxlclk)) then 
        -- select which digit to display 
        currentDigit <= currentDigit + 1;
        -- set the cathodes 
        CA <= sevenSegRegisters(to_integer(unsigned(currentDigit)));
        -- set the anode
        AN <= not currentDigitDecoder;
    end if;

end process; -- pxlClk


end Behavioral;


















--
