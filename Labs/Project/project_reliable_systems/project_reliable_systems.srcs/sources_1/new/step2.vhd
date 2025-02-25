---------------------------------------------------
               --Comparator
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Comparator is
    generic (n: natural := 4);
    port (
        cmp_in1 : in std_logic_vector(n-1 downto 0);
        cmp_in2 : in std_logic_vector(n-1 downto 0);
        cmp_out : out std_logic
    );
end Comparator;

architecture Behavioral of Comparator is

begin
    process (cmp_in1, cmp_in2)
    begin
        if (cmp_in1 = cmp_in2) then
            cmp_out <= '0';
        else
            cmp_out <= '1';
        end if;
    end process;

end Behavioral;

---------------------------------------------------
               --Testbench
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_Comparator is end;

architecture tb_Comparator_arch of tb_Comparator is
    component Comparator
        generic (n: natural := 4);
        port (
            cmp_in1 : in std_logic_vector(n-1 downto 0);
            cmp_in2 : in std_logic_vector(n-1 downto 0);
            cmp_out : out std_logic
        );
    end component;
    
    signal cmp_in1_tb : std_logic_vector(3 downto 0) := "0000";
    signal cmp_in2_tb : std_logic_vector(3 downto 0) := "0000";
    signal cmp_out_tb : std_logic;

begin
    Comparator_uut: Comparator
        generic map (n => 4)
        port map (
            cmp_in1 => cmp_in1_tb,
            cmp_in2 => cmp_in2_tb,
            cmp_out => cmp_out_tb
        );

    process
    begin
        cmp_in1_tb <= "0000";
        cmp_in2_tb <= "0000";
        wait for 10 ps;

        cmp_in1_tb <= "0001";
        cmp_in2_tb <= "0000";
        wait for 10 ps;

        cmp_in1_tb <= "0000";
        cmp_in2_tb <= "0001";
        wait for 10 ps;

        cmp_in1_tb <= "0001";
        cmp_in2_tb <= "0001";
        wait for 10 ps;

        cmp_in1_tb <= "1111";
        cmp_in2_tb <= "1111";
        wait for 10 ps;

        cmp_in1_tb <= "1111";
        cmp_in2_tb <= "0000";
        wait for 10 ps;

        cmp_in1_tb <= "0000";
        cmp_in2_tb <= "1111";
        wait for 10 ps;

        cmp_in1_tb <= "1111";
        cmp_in2_tb <= "1110";
        wait for 10 ps;

        cmp_in1_tb <= "1110";
        cmp_in2_tb <= "1111";
        wait for 10 ps;

        cmp_in1_tb <= "1110";
        cmp_in2_tb <= "1110";
        wait for 10 ps;

        wait;
    end process;
end tb_Comparator_arch;