library ieee ;
use ieee.std_logic_1164.All;
use IEEE.numeric_std.all;


entity Dflipflop is
    port (D      :in  std_logic;
          clk    :in  std_logic;

          Q      :out std_logic:='0'
    );
end Dflipflop;


architecture Behavioral of Dflipflop is

    begin
        process (clk)
        begin
            if (clk'event and clk='1') then
                Q <= D;
            end if;
        end process;
end Behavioral;

library ieee;
use ieee.std_logic_1164.All;
use IEEE.numeric_std.all;

entity tb_Dflipflop is end;

architecture tb_Dflipflop_arch of tb_Dflipflop is
    signal D     :std_logic := '0';
    signal clk   :std_logic := '0';

    signal Q     :std_logic;

begin
    Dflipflop_entity: entity work.Dflipflop
    port map (D, clk, Q);
    
    clk <= not clk after 10ps;

    D <= not D after 20ps;

end tb_Dflipflop_arch;
