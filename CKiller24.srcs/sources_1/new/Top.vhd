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
use work.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity CKiller24 is
	Port ( clk : in STD_LOGIC;
		reset : in STD_LOGIC
	);
end CKiller24;

architecture Behavioral of CKiller24 is
	signal registerEn : STD_LOGIC;
	signal registerAddr : STD_LOGIC_VECTOR(2 downto 0);
	signal registerIn : STD_LOGIC_VECTOR(23 downto 0);
	signal registerOut : STD_LOGIC_VECTOR(23 downto 0);
begin
	rf: RegisterFile PORT MAP (clk => clk, adr => registerAddr,
	d => registerIn, q => registerOut, en => registeEn);


end Behavioral;























--
