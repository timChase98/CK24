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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.all;
library UNISIM;
use UNISIM.VComponents.all;

entity CKiller24 is
	Port ( 	clk : in STD_LOGIC;
		rst: in STD_LOGIC;
	    addr : in STD_LOGIC_VECTOR(3 downto 0);
		qout : out STD_LOGIC_VECTOR(7 downto 0)
	);
end CKiller24;

architecture Behavioral of CKiller24 is
    component progmem is
        PORT (
            clka : IN STD_LOGIC;
            rsta : IN STD_LOGIC;
            ena : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(23 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(23 DOWNTO 0);
            rsta_busy : OUT STD_LOGIC
      );
    end component; 
    
    TYPE fsmstate is (S0, S1, S2, S3);
    signal state : fsmstate;
   
    signal memD, memQ : std_logic_vector(23 downto 0);
    signal memRB : std_logic;
    signal memA : std_logic_vector(15 downto 0);
    signal latch : std_logic_vector(0 downto 0);
    signal q : std_logic_vector(7 downto 0);

begin
--	rf: entity RegisterFile PORT MAP (clk => clk, addr => registerAddr,
--	d => registerIn, q => registerOut, en => registerEn);
    process(clk, rst)
    begin 
        if (rst = '1') then 
            state <= S0;
            memA <= "0000000000000000";
        elsif(rising_edge(clk)) then 
            CASE state is 
                when S0 =>
                    memA <= "000000000000" & addr; 
                    state <= S1;
                when S1 =>
                    q <= memQ(7 downto 0); 
                    state <= S2;
                when S2 =>
                    q <= q + 1;
                    memD <= "0000000000000000" & q;
                    latch(0) <= '1';
                    state <= S3;
                when S3 => 
                    latch(0) <= '0';
                    --addr <= addr + 1;
                    state <= S0;
               end case;      
        end if;
    end process;
    pm :  progmem PORT MAP (addra => memA, clka => clk, dina => memD,
    douta => memQ, ena => '1', rsta => rst, Wea => latch);
    qout <= q;


end Behavioral;























--
