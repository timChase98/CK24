----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/04/2020 12:34:10 PM
-- Design Name: 
-- Module Name: SevenSegmentDecoder - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SevenSegmentDecoder is
    Port ( digit : in STD_LOGIC_VECTOR (3 downto 0);
           clk, en : in STD_LOGIC;
           pattern : out STD_LOGIC_VECTOR (6 downto 0));
end SevenSegmentDecoder;

architecture Behavioral of SevenSegmentDecoder is

begin
process(clk, en)
begin
    if (clk'event and clk='1' and en='1') then 
        case digit is 
            when "0000" =>
            pattern <= "1000000"; -- 0
            when "0001" =>
            pattern <= "1111001"; -- 1
            when "0010" =>
            pattern <= "0100100"; -- 2
            when "0011" =>
            pattern <= "0110000"; -- 3
            when "0100" =>
            pattern <= "0011001"; -- 4
            when "0101" =>
            pattern <= "0010010"; -- 5
            when "0110" =>
            pattern <= "0000010"; -- 6
            when "0111" =>
            pattern <= "1111000"; -- 7
            when "1000" =>
            pattern <= "0000000"; -- 8
            when "1001" =>
            pattern <= "0010000"; -- 9
            when "1010" =>
            pattern <= "0001000"; -- A
            when "1011" =>
            pattern <= "0000011"; -- B
            when "1100" =>
            pattern <= "1000110"; -- C
            when "1101" =>
            pattern <= "0100001"; -- D
            when "1110" =>
            pattern <= "0000110"; -- E
            when "1111" =>
            pattern <= "0001110"; -- F
            when others =>
            pattern <= "1111111";
         end case;
    end if;

end process;


end Behavioral;


















--