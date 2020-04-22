----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2020 11:23:07 AM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (23 downto 0);
           B : in STD_LOGIC_VECTOR (23 downto 0);
           OP : in STD_LOGIC_VECTOR (4 downto 0);
           R : out STD_LOGIC_VECTOR (23 downto 0));
end ALU;

architecture Behavioral of ALU is

begin
    with op select R <= 
        X"000000"           when "00100", -- CLR 
        A + 1               when "00101", -- INC 
        A - 1               when "00110", -- DEC
        (not A) + 1         when "00111", -- NEG
        --SHIFT_LEFT(A, B)    when "01000", -- SLL
        --SHIFT_RIGHT(A, B)   when "01001", -- SLL
        A + B               when "10000", -- ADD
        A - B               when "10001", -- SUB
        -- mult             when "10010", -- mul
        -- divide           when "10011", -- DIV
        A and B             when "10100", -- AND
        A or B              when "10101", -- OR
        A xor B             when "10110", -- XOR
        A + B               when "10111", -- ADDI
        A - B               when "11000", -- SUBI
        X"000000"           when others;        

end Behavioral;


































--
