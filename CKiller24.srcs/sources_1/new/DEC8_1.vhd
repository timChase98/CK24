----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2020 09:55:55 AM
-- Design Name: 
-- Module Name: DEC8_1 - Behavioral
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

entity DEC8_1 is
    Port ( A : in STD_LOGIC_VECTOR (2 downto 0);
           EN : in STD_LOGIC;
           D : out STD_LOGIC_VECTOR (7 downto 0));
end DEC8_1;

architecture Behavioral of DEC8_1 is
    signal decoded : std_logic_vector(7 downto 0);
begin
    with a select decoded <= 
        "00000001" when "000",
        "00000010" when "001",
        "00000100" when "010",
        "00001000" when "011",
        "00010000" when "100",
        "00100000" when "101",
        "01000000" when "110",
        "10000000" when "111";
    D <= decoded when en='1' else "00000000";


end Behavioral;
























---
