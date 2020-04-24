library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity BP is
     PORT (
          clk : in std_logic;
          branchHistory : in std_logic;
          prediction : out  std_logic
     );
end BP;

architecture Behavioral of BP is
     type BranchState is (SN, WN, WT, ST);
     signal state is BranchState;
     function predict(s : BranchState) return std_logic
     begin
          case s is
               when SN =>
                    return '0';
               when WN =>
                    return '0';
               when WT =>
                    return '1';
               when ST =>
                    return '1';
          end case;
     end predict;

begin
     process(clk)
     begin
          if rising_edge(clk) then
               case state iswhen SN =>
                    return '0';
               when WN =>
                    return '0';
               when WT =>
                    return '1';
               when ST =>
                    return '1';
               end case;

          end if;
     end

end architecture;
