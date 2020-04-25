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
    Port ( SRst : std_logic;
           SLatch : std_logic;
           A : in STD_LOGIC_VECTOR (23 downto 0);
           B : in STD_LOGIC_VECTOR (23 downto 0);
           OP : in STD_LOGIC_VECTOR (4 downto 0);
           R : out STD_LOGIC_VECTOR (23 downto 0);
           S : out STD_LOGIC_VECTOR(3 downto 0)
           );
end ALU;

architecture Behavioral of ALU is
    signal Ase, Bse : std_logic_vector(24 downto 0);
    signal result : std_logic_vector(24 downto 0);
begin
    -- sign extend A and B to 25 bits to preserve the carry bit
    Ase <= A(23) & A;
    bSe <= B(23) & B;
    with op select result <= 
        (others => '0')           when "00100", -- CLR 
        Ase + 1               when "00101", -- INC 
        Ase - 1               when "00110", -- DEC
        (not Ase) + 1         when "00111", -- NEG
        --SHIFT_LEFT(A, B)    when "01000", -- SLL
        --SHIFT_RIGHT(A, B)   when "01001", -- SLL
        Ase + Bse               when "10000", -- ADD
        Ase - Bse               when "10001", -- SUB
        -- mult             when "10010", -- mul
        -- divide           when "10011", -- DIV
        Ase and Bse             when "10100", -- AND
        Ase or Bse              when "10101", -- OR
        Ase xor Bse             when "10110", -- XOR
        Ase + Bse               when "10111", -- ADDI
        Ase - Bse               when "11000", -- SUBI
        (others => '0')            when others;        
    
    process(sLatch, sRst)
    begin 
        if (sRst = '1') then 
            s<= X"0";
        elsif(rising_edge(sLatch)) then 
            s(3) <= result(23); -- Negative
            s(2) <= result(24) XOR result(23); -- Overflow
            if (result = X"000000") then -- zero 
                s(1) <= '1';
            else
                s(1) <= '0';
            end if;
            s(0) <= result(24); -- Carry
        end if;
    
    end process;

    r <= result(23 downto 0);
    

end Behavioral;


































--
