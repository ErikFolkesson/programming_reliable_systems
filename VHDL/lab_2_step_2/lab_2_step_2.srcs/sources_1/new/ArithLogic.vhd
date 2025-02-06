library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ArithLogic is
    port (
        a, b    : in  unsigned(3 downto 0);  -- Input

        -- AplusB, AandB, AxorB, AnandB, APlusOne, Ao, Bo, AllZero (3 downto 0).
        AplusB  : out  unsigned(3 downto 0);  -- A + B
        AandB   : out  unsigned(3 downto 0);  -- A AND B
        AxorB   : out  unsigned(3 downto 0);  -- A XOR B
        AnandB  : out  unsigned(3 downto 0);  -- A NAND B
        APlusOne: out  unsigned(3 downto 0);  -- A + 1
        Ao      : out  unsigned(3 downto 0);  -- A
        Bo      : out  unsigned(3 downto 0);  -- B
        AllZero : out  unsigned(3 downto 0)   -- All zero
    );
end ArithLogic;

architecture Behavioral of ArithLogic is

begin
    process(a, b)
    begin
        AplusB  <= a + b;
        AandB   <= a and b;
        AxorB   <= a xor b;
        AnandB  <= not (a and b);
        APlusOne<= a + "0001";
        Ao      <= a;
        Bo      <= b;
        AllZero <= (others => '0');
    end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ArithLogic is end;

architecture tb_ArithLogic_arch of tb_ArithLogic is
    signal a, b, AplusB, AandB, AxorB, AnandB, APlusOne, Ao, Bo, AllZero: unsigned(3 downto 0);

begin
    ArithLogic_instance_1: entity work.ArithLogic
        port map(a, b, AplusB, AandB, AxorB, AnandB, APlusOne, Ao, Bo, AllZero);

    process is
    begin
        a <= "0000"; b <= "0000";
        wait for 10 ps;

        a <= "0000"; b <= "0001";
        wait for 10 ps;

        a <= "0001"; b <= "0000";
        wait for 10 ps;

        a <= "0001"; b <= "0001";
        wait for 10 ps;

        a <= "1111"; b <= "0000";
        wait for 10 ps;

        a <= "0000"; b <= "1111";
        wait for 10 ps;

        a <= "1111"; b <= "0001";
        wait for 10 ps;

        a <= "1111"; b <= "1111";
        wait;

    end process;
end tb_ArithLogic_arch;
