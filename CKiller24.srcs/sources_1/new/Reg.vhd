----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2020 09:25:57 AM
-- Design Name: 
-- Module Name: Reg - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Reg is
    Port ( d : in STD_LOGIC_VECTOR (23 downto 0);
           clk : in STD_LOGIC;
           en : in STD_LOGIC;
           inc : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (23 downto 0));
end Reg;

architecture Behavioral of Reg is
    signal qInternal : std_logic_vector(23 downto 0);
begin
    process(clk)
    begin 
        if(rising_edge(clk) and en='1') then 
            if(inc = '1') then
                qInternal <= qInternal + 1;
            else  
                qInternal <= d;
            end if;
        end if;
    end process;
    q <= qinternal;

end Behavioral;























--