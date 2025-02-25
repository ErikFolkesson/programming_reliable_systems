---------------------------------------------------
               --Counter
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Counter is
    port(
        clk : in std_logic;
        reset : in std_logic; 
        en : in std_logic; 
        counter_out: out integer
    );
end Counter;

architecture Behavioral of Counter is
    signal counter_internal : integer;
begin
    process (clk)
    begin
        
        if (falling_edge(clk)) then
            if (reset = '1') then
                counter_internal <= 0;
            end if;
            if( en = '1') then
                counter_internal <= counter_internal + 1;
            end if;
        end if;
    end process;

    counter_out <= counter_internal;

end Behavioral;

---------------------------------------------------
               --Testbench
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_Counter is end;

architecture tb_Counter_arch of tb_Counter is
    component Counter
        port(
            clk : in std_logic;
            reset : in std_logic; 
            en : in std_logic; 
            counter_out: out integer
        );
    end component;
    
    signal clk_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal en_tb : std_logic := '0';
    signal counter_out_tb : integer;

begin
    Counter_uut: Counter
    port map (clk => clk_tb, reset => reset_tb, en => en_tb, counter_out => counter_out_tb);

    clk_tb <= not clk_tb after 10 ps;

    process
    begin
        reset_tb <= '1';
        en_tb <= '0';
        wait for 20 ps;

        reset_tb <= '0';
        en_tb <= '1';
        wait for 100 ps;

        en_tb <= '0';
        wait for 50 ps;

        reset_tb <= '1';
        wait;
    end process;

end tb_Counter_arch;