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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RegisterFile is
    Port ( addr : in STD_LOGIC_VECTOR (2 downto 0);
           clk : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR (23 downto 0);
           q : out STD_LOGIC_VECTOR (23 downto 0));
end RegisterFile;

architecture Behavioral of RegisterFile is
    type registerFile is array(0 to 7) of std_logic_vector(23 downto 0);
    signal registers : registerFile;
    signal addressDecoder : std_logic_vector(7 downto 0);
begin
    ad : entity DEC8_1 PORT MAP (a => addr, en => '1', d => addressDecoder);    

    r0 : entity Reg PORT MAP(d => d, q => registers(0), en => addressDecoder(0), clk => clk);
    r1 : entity Reg PORT MAP(d => d, q => registers(1), en => addressDecoder(1), clk => clk);
    r2 : entity Reg PORT MAP(d => d, q => registers(2), en => addressDecoder(2), clk => clk);
    r3 : entity Reg PORT MAP(d => d, q => registers(3), en => addressDecoder(3), clk => clk);
    r4 : entity Reg PORT MAP(d => d, q => registers(4), en => addressDecoder(4), clk => clk);
    r5 : entity Reg PORT MAP(d => d, q => registers(5), en => addressDecoder(5), clk => clk);
    r6 : entity Reg PORT MAP(d => d, q => registers(6), en => addressDecoder(6), clk => clk);
    sp : entity Reg PORT MAP(d => d, q => registers(7), en => addressDecoder(7), clk => clk);

    q <= registers(to_integer(unsigned(addr)));

end Behavioral;























--