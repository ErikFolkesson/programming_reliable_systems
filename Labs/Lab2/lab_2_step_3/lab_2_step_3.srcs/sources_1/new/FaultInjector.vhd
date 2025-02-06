library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FaultInjector is
    port (
        a, b          : in  unsigned(3 downto 0);  -- Input A, B           (0000-1111)
        Operation     : in  unsigned(2 downto 0);  -- Input Operation      (000-111)
        FaultLocation : in  unsigned(3 downto 0);  -- Input Fault Location (0000-1010)

        FaultyA       : out  unsigned(3 downto 0); -- Output Faulty A      (0000-1111)
        FaultyB       : out  unsigned(3 downto 0);  -- Output Faulty B      (0000-1111)
        FaultyOp      : out  unsigned(2 downto 0)  -- Output Faulty Operation (000-111)
    );
end FaultInjector;

architecture Behavioral of FaultInjector is

    begin
        process(a, b, Operation, FaultLocation)
        begin
            FaultyA <= a;
            FaultyB <= b;
            FaultyOp <= Operation;

            case FaultLocation is
                when "0000" => FaultyA(0) <= not a(0);
                when "0001" => FaultyA(1) <= not a(1);
                when "0010" => FaultyA(2) <= not a(2);
                when "0011" => FaultyA(3) <= not a(3);

                when "0100" => FaultyB(0) <= not b(0);
                when "0101" => FaultyB(1) <= not b(1);
                when "0110" => FaultyB(2) <= not b(2);
                when "0111" => FaultyB(3) <= not b(3);

                when "1000" => FaultyOp(0) <= not Operation(0);
                when "1001" => FaultyOp(1) <= not Operation(1);
                when "1010" => FaultyOp(2) <= not Operation(2);

                when others => null;
            end case;
        end process;
    end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_FaultInjector is end;

architecture tb_FaultInjector_arch of tb_FaultInjector is
    signal a, b, FaultLocation, FaultyA, FaultyB: unsigned(3 downto 0);
    signal Operation, FaultyOp: unsigned(2 downto 0);

begin
    ArithLogic_instance_1: entity work.FaultInjector
        port map(a, b, Operation, FaultLocation, FaultyA, FaultyB, FaultyOp);

    process is
    begin
        a <= "0000"; b <= "0000"; Operation <= "000"; FaultLocation <= "0000";
        wait for 10 ps;

        a <= "0001"; b <= "0000"; Operation <= "000"; FaultLocation <= "0000";
        wait for 10 ps;

        a <= "0001"; b <= "0000"; Operation <= "000"; FaultLocation <= "0011";
        wait for 10 ps;

        a <= "0000"; b <= "0000"; Operation <= "000"; FaultLocation <= "0100";
        wait for 10 ps;

        a <= "0000"; b <= "0001"; Operation <= "000"; FaultLocation <= "0100";
        wait for 10 ps;

        a <= "0000"; b <= "0000"; Operation <= "000"; FaultLocation <= "0111";
        wait for 10 ps;

        a <= "0000"; b <= "0000"; Operation <= "000"; FaultLocation <= "1000";
        wait for 10 ps;

        a <= "0000"; b <= "0000"; Operation <= "001"; FaultLocation <= "1000";
        wait for 10 ps;

        a <= "1111"; b <= "1111"; Operation <= "111"; FaultLocation <= "1011";
        wait for 10 ps;

        a <= "0000"; b <= "0000"; Operation <= "000"; FaultLocation <= "1011";
        wait;

    end process;
end tb_FaultInjector_arch;