---------------------------------------------------
                    --TMR
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TMR is
    generic (n: natural);
    Port (
    tmr_in1, tmr_in2, tmr_in3: in std_logic_vector(n-1 downto 0);
    tmr_out: out std_logic_vector(n-1 downto 0)
    );
end TMR;

architecture Behavioral of TMR is

begin
process(tmr_in1, tmr_in2, tmr_in3)
    begin
        if (tmr_in2 = tmr_in3) then
            tmr_out <= tmr_in2;
        else
            tmr_out <= tmr_in1;
        end if;
    end process;
end Behavioral;

---------------------------------------------------
               --Testbench
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_TMR is end;

architecture tb_arch of tb_TMR is
    constant n : natural := 4;
    component TMR
        generic (n: natural);
        Port (
            tmr_in1, tmr_in2, tmr_in3: in std_logic_vector(n-1 downto 0);
            tmr_out: out std_logic_vector(n-1 downto 0)
        );
    end component;   
    
    signal tmr_in1, tmr_in2, tmr_in3, tmr_out : std_logic_vector(n-1 downto 0); 
begin
    TMR_uut: TMR
    generic map(n => n)
    port map(tmr_in1 => tmr_in1, tmr_in2 => tmr_in2, tmr_in3 => tmr_in3, tmr_out => tmr_out);
    
    process
    begin
        tmr_in1 <= "1010"; 
        tmr_in2 <= "1010";
        tmr_in3 <= "1010";
        wait for 10 ns;
        
        tmr_in1 <= "1100";
        tmr_in2 <= "0110";
        tmr_in3 <= "0110";
        wait for 10 ns;
        
        tmr_in1 <= "1001";
        tmr_in2 <= "1111";
        tmr_in3 <= "0000";
        wait for 10 ns;   
        
        tmr_in1 <= "0001";
        tmr_in2 <= "1010";
        tmr_in3 <= "1010";
        wait for 10 ns; 
        
        wait;
    end process;
end;