----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2020 07:44:02 PM
-- Design Name: 
-- Module Name: MMU - Behavioral
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

entity MMU is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           readWrite : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (11 downto 0);
           dataIn : in STD_LOGIC_VECTOR (23 downto 0);
           dataOut : out STD_LOGIC_VECTOR (23 downto 0));
end MMU;

architecture Behavioral of MMU is
    component dataRam is
        PORT (
            clka : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
      );
    end component; 
    
    signal wen : std_logic_vector(0 downto 0);
    
begin
    wen(0) <= readWrite; 
    dm : dataRam Port MAP (clka => clk, ena => '1', wea => wen, addra => addr, dina => dataIn, douta => dataOut);

end Behavioral;



















--