----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2020 09:25:57 AM
-- Design Name: 
-- Module Name: CKillerCISC24 - Behavioral
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

entity CKillerCISC24 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           addr : out STD_LOGIC_VECTOR (15 downto 0);
           rw : out STD_LOGIC; 
           data : inout STD_LOGIC_VECTOR (23 downto 0));
end CKillerCISC24;

architecture Behavioral of CKillerCISC24 is

begin


end Behavioral;
