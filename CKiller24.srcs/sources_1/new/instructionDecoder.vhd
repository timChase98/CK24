----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2020 11:34:32 AM
-- Design Name: 
-- Module Name: instructionDecoder - Behavioral
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

entity instructionDecoder is
    Port ( instruction : in STD_LOGIC_VECTOR (23 downto 0);
           numOPs : out STD_LOGIC_VECTOR (1 downto 0);
           OPCode : out STD_LOGIC_VECTOR (4 downto 0);
           OP1Val : out STD_LOGIC_VECTOR (2 downto 0);
           OP1AM : out STD_LOGIC_VECTOR (1 downto 0);
           OP2Val : out STD_LOGIC_VECTOR (2 downto 0);
           OP2AM : out STD_LOGIC_VECTOR (1 downto 0);
           IMM9 : out std_logic_vector(8 downto 0);
           IMM14 : out std_logic_vector(8 downto 0);
           Mask : out std_logic_vector(3 downto 0)
           );
           
end instructionDecoder;

architecture Behavioral of instructionDecoder is

begin
    OPCode <= instruction(23 downto 19);
    OP1AM <= instruction(18 downto 17);
    OP1VAL <= instruction(16 downto 14);
    OP2AM <= instruction(13 downto 13);
    OP2VAL <= instruction(11 downto 9);
    IMM9 <= instruction(8 downto 0);
    IMM14 <= instruction(13 downto 0);
    Mask <= instruction(18 downto 15);
    
    with instruction(23 downto 19) select numOps <= 
        "00" when "00000", -- halt
        "00" when "00001", -- wait
        "00" when "00010", -- reset
        "00" when "00011", -- blmr
        "01" when "00100", -- clr
        "01" when "00101", -- inc
        "01" when "00110", -- dec
        "01" when "00111", -- neg
        "01" when "01000", -- sll
        "01" when "01001", -- srl
        "10" when "01010", -- mvs
        "00" when "01011", -- mvmi
        "01" when "01100", -- msm
        "01" when "01101", -- mms
        "00" when "01110", -- blrm
        "00" when "01111", -- blmr
        "10" when "10000", -- add
        "10" when "10001", -- sub
        "10" when "10010", -- mul
        "10" when "10011", -- div
        "10" when "10100", -- and
        "10" when "10101", -- or
        "10" when "10110", -- xor
        "01" when "10111", -- addi
        "01" when "11000", -- subi
        "11" when "11001", -- jmpi
        "11" when "11010", -- jsr
        "00" when "11011", -- rsr
        "11" when "11100", -- br
        "00" when "11101", -- inttgl
        "00" when "11110", -- rti
        "00" when "11111"; -- clrs
    

end Behavioral;
