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

entity CKiller24 is
	Port (clk100M : in STD_LOGIC;  	
	      clk : in STD_LOGIC;
		  rst: in STD_LOGIC;
		  sel: in STD_LOGIC_VECTOR(1 downto 0);
		  AN : out STD_LOGIC_VECTOR (7 downto 0);
          CA : out STD_LOGIC_VECTOR (6 downto 0);
          exeState : out STD_LOGIC_VECTOR(1 downto 0);
          rfa : out STD_LOGIC_VECTOR(2 downto 0);
          as : out STD_LOGIC_VECTOR(3 downto 0);
          asn : out STD_LOGIC_VECTOR(3 downto 0);
          rfi : out STD_LOGIC
	);
end CKiller24;

architecture Behavioral of CKiller24 is

    signal ir : std_logic_vector(23 downto 0);
    signal op : std_logic_vector(4 downto 0);
    signal pc : std_logic_vector(15 downto 0);
    
    signal display : std_logic_vector(31 downto 0);
    signal clkDiv : std_logic_vector(20 downto 0);
    
    signal sysBus : std_logic_vector(23 downto 0);
    
    signal regFileA : std_logic_vector(2 downto 0);
    signal regFileD : std_logic_vector(23 downto 0);
    signal regFileQ : std_logic_vector(23 downto 0);
    signal regFileE : std_logic; 
    signal regFileI : std_logic; 
    signal regFileDec : std_logic;
    
    signal aluA, aluB, aluR: std_logic_vector(23 downto 0);
    signal aluOp : std_logic_vector(4 downto 0);
    signal aluS : std_logic_vector(3 downto 0);
    signal aluSR, aluSL : std_logic;
    
    signal ramA : std_logic_vector(11 downto 0);
    signal ramD : std_logic_vector(23 downto 0);
    signal ramQ : std_logic_vector(23 downto 0);
    signal ramRW : std_logic; 
    signal ramDn : std_logic;
  
begin
	rf: entity RegisterFile PORT MAP (clk => clk, addr => regFileA,
	d => regFileD, q => regFileQ, inc => regFileI, en => regFileE, dec => regFileDec);
	
	au: entity ALU PORT MAP(a => aluA, b => aluB, op => op, r=> aluR, s => aluS, sLatch => aluSL, sRst => aluSR);
    
    mu: entity MMU PORT MAP(clk => clk, rst => rst, addr => ramA, dataIn => ramD, dataOut => ramQ, readWrite => ramRW, done => ramDn);

    cu: entity ControlUnit PORT MAP(clk => clk, rst => rst, 
        irOut => ir, exeout => exeState,pcOut => PC, 
        regEn => regFileE,
        regAddr => regFileA,
        regDataD => regFileD,
        regDataQ => regFileQ,
        regInc => regFileI,
        regDec => regFileDec,
        ramAddr => ramA,
        ramDataD => ramD,
        ramDataQ => ramQ,
        ramRW => ramRW,
        ramDone => ramDn,
        aluRegA => aluA,
        aluRegB => aluB,
        aluop => op,
        aluRegR => aluR,
        aluRegS => aluS,
        aluSLatch => aluSL,
        aluSRst => aluSR
        );
        
    dp: entity SevenSegmentDigitController PORT MAP (pxlClk => clkDiv(17),
           data => display, latch => clkDiv(19), 
           AN => AN, CA => CA);
    
    with sel select display <= 
        X"00" & regFileQ when "01",
        ramA(7 downto 0) & ramQ when "10",
        PC(7 downto 0) & IR when others; 
    
    process(clk100M)
    begin 
        if(rising_edge(clk100M)) then
            clkdiv <= clkDiv + 1;
        end if;
    end process;
    
    rfa <= RegFileA;
    as <= aluS;
    asn <= not aluS;
    rfi <= regFileI; 
    

end Behavioral;























--
