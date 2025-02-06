-- 8:1 Multiplexer
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Max4Bit8To1 is
    --- Define port for inputs i0 to i7 using 4 bit unsigned.
    port (
        i0     : in  unsigned(3 downto 0);  -- Input 0 (LSB)
        i1     : in  unsigned(3 downto 0);  -- Input 1
        i2     : in  unsigned(3 downto 0);  -- Input 2
        i3     : in  unsigned(3 downto 0);  -- Input 3
        i4     : in  unsigned(3 downto 0);  -- Input 4
        i5     : in  unsigned(3 downto 0);  -- Input 5
        i6     : in  unsigned(3 downto 0);  -- Input 6
        i7     : in  unsigned(3 downto 0);  -- Input 7 (MSB)

        s0     : in  unsigned(2 downto 0);  -- Select

        out0   : out  unsigned(3 downto 0)  -- Output
    );
end Max4Bit8To1;

architecture Behavioral of Max4Bit8To1 is

begin
    process(i0, i1, i2, i3, i4, i5, i6, i7, s0)
    begin
        if s0 = "000" then
            out0 <= i0;
        elsif s0 = "001" then
            out0 <= i1;
        elsif s0 = "010" then
            out0 <= i2;
        elsif s0 = "011" then
            out0 <= i3;
        elsif s0 = "100" then
            out0 <= i4;
        elsif s0 = "101" then
            out0 <= i5;
        elsif s0 = "110" then
            out0 <= i6;
        elsif s0 = "111" then
            out0 <= i7;
        else
            out0 <= (others => '0'); -- Default case
        end if;
    end process;
end Behavioral;

-- End of 8:1 Multiplexer

-- ArithLogic

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

-- End of ArithLogic

-- FaultInjector

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

-- End of FaultInjector

-- FaultyALU

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FaultyALU is
    port (
        A, B         : in  unsigned(3 downto 0);  -- Input A, B
        Operation    : in  unsigned(2 downto 0);  -- Input Operation
        FaultLocation: in  unsigned(3 downto 0);  -- Input Fault Location

        Result       : out unsigned(3 downto 0)   -- Output Result
    );
end FaultyALU;

architecture Behavioral of FaultyALU is
    signal FaultyA, FaultyB  : unsigned(3 downto 0);
    signal FaultyOp          : unsigned(2 downto 0);
    signal AplusB, AandB, AxorB, AnandB, APlusOne, Ao, Bo, AllZero: unsigned(3 downto 0);

begin
    FaultInjector_entity: entity work.FaultInjector
        port map (
            A            => A,
            B            => B,
            Operation    => Operation,
            FaultLocation=> FaultLocation,
            FaultyA      => FaultyA,
            FaultyB      => FaultyB,
            FaultyOp     => FaultyOp
        );

    ArithLogic_entity: entity work.ArithLogic
        port map (
            a       => FaultyA,
            b       => FaultyB,
            AplusB  => AplusB,
            AandB   => AandB,
            AxorB   => AxorB,
            AnandB  => AnandB,
            APlusOne=> APlusOne,
            Ao      => Ao,
            Bo      => Bo,
            AllZero => AllZero
        );

    Max4Bit8To1_entity: entity work.Max4Bit8To1
        port map (
            i0     => AplusB,
            i1     => AandB,
            i2     => AxorB,
            i3     => AnandB,
            i4     => APlusOne,
            i5     => Ao,
            i6     => Bo,
            i7     => AllZero,
            s0     => FaultyOp,
            out0   => Result
        );
end Behavioral;

-- End of FaultyALU

-- RedundantALU

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RedundantALU is
    port (
        A, B         : in  unsigned(3 downto 0);  -- Input A, B
        Operation    : in  unsigned(2 downto 0);  -- Input Operation
        FaultLocation: in  unsigned(3 downto 0);  -- Input Fault Location

        Result1       : out unsigned(3 downto 0);   -- Output Result 1
        Result2       : out unsigned(3 downto 0)   -- Output Result 2
    );
end RedundantALU;

architecture Behavioral of RedundantALU is

begin
    FaultyALU_entity1: entity work.FaultyALU
        port map (
            A            => A,
            B            => B,
            Operation    => Operation,
            FaultLocation=> FaultLocation,
            Result       => Result1
        );

    FaultyALU_entity2: entity work.FaultyALU
        port map (
            A            => A,
            B            => B,
            Operation    => Operation,
            FaultLocation=> "1111",
            Result       => Result2
        );
end Behavioral;

-- End of RedundantALU

-- Testbench for RedundantALU

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_RedundantALU is end;

architecture tb_RedundantALU_arch of tb_RedundantALU is
    signal A, B, FaultLocation, Result1, Result2: unsigned(3 downto 0);
    signal Operation: unsigned(2 downto 0);

begin
    RedundantALU_entity: entity work.RedundantALU
        port map (
            A            => A,
            B            => B,
            Operation    => Operation,
            FaultLocation=> FaultLocation,
            Result1      => Result1,
            Result2      => Result2
        );

    process is
        begin
            -- Group 1: Changes between Result1 and Result2

            -- Operation: A+B | FaultLocation: "0000" => A + 1
            A <= "0000"; B <= "0000"; Operation <= "000"; FaultLocation <= "0000";
            wait for 10 ps;

            -- Operation: A+B | FaultLocation: "0000" => A + 1
            A <= "0001"; B <= "0000"; Operation <= "000"; FaultLocation <= "0000";
            wait for 10 ps;

            -- Operation: A+B | FaultLocation: "0011" => A(3) + 1
            A <= "0001"; B <= "0000"; Operation <= "000"; FaultLocation <= "0011";
            wait for 10 ps;

            -- Operation: A+B | FaultLocation: "0100" => B + 1
            A <= "0000"; B <= "0000"; Operation <= "000"; FaultLocation <= "0100";
            wait for 10 ps;

            -- Operation: A+B | FaultLocation: "0100" => B + 1
            A <= "0000"; B <= "0001"; Operation <= "000"; FaultLocation <= "0100";
            wait for 10 ps;

            -- Operation: A+B | FaultLocation: "0111" => B(3) + 1
            A <= "0000"; B <= "0000"; Operation <= "000"; FaultLocation <= "0111";
            wait for 10 ps;

            -- Operation: A+B | FaultLocation: "1000" => Op + 1 | New Operation: A and B
            A <= "0000"; B <= "0000"; Operation <= "000"; FaultLocation <= "1000";
            wait for 10 ps;

            -- Operation: A and B | FaultLocation: "1000" => Op - 1 | New Operation: A plus B
            A <= "0000"; B <= "0000"; Operation <= "001"; FaultLocation <= "1000";
            wait for 10 ps;

            -- Operation: AllZero | FaultLocation: "1011" => Nothing
            A <= "1111"; B <= "1111"; Operation <= "111"; FaultLocation <= "1011";
            wait for 10 ps;

            -- Operation: A + B | FaultLocation: "1011" => Nothing
            A <= "0000"; B <= "0000"; Operation <= "000"; FaultLocation <= "1011";
            wait for 10 ps;

            -- Group 2: No changes between Result1 and Result2

            -- Operation AandB | FaultLocation: "1000" => Op - 1 | New Operation: A plus B
            A <= "0000"; B <= "0000"; Operation <= "001"; FaultLocation <= "1000";
            wait for 10 ps;

            -- Operation: Ao | FaultLocation: "0100" => B + 1
            A <= "0000"; B <= "0000"; Operation <= "101"; FaultLocation <= "0100";
            wait for 10 ps;

            -- Operation: Ao | FaultLocation: "0100" => B + 1
            A <= "1111"; B <= "0000"; Operation <= "101"; FaultLocation <= "0100";
            wait for 10 ps;

            -- Operation: Bo | FaultLocation: "0000" => A + 1
            A <= "0000"; B <= "0000"; Operation <= "110"; FaultLocation <= "0000";
            wait for 10 ps;

            -- Operation: Bo | FaultLocation: "0000" => A + 1
            A <= "1110"; B <= "1111"; Operation <= "110"; FaultLocation <= "0000";
            wait for 10 ps;

            -- Operation: AllZero | FaultLocation: "0100" => B + 1
            A <= "0000"; B <= "0000"; Operation <= "111"; FaultLocation <= "0100";
            wait for 10 ps;

            -- Operation: AllZero | FaultLocation: "0100" => B + 1
            A <= "1110"; B <= "1111"; Operation <= "111"; FaultLocation <= "0100";
            wait for 10 ps;

            -- Operation: AllZero |
            A <= "1110"; B <= "1111"; Operation <= "111"; FaultLocation <= "0000";
            wait for 10 ps;

            -- Operation: AllZero |
            A <= "0000"; B <= "1111"; Operation <= "111"; FaultLocation <= "0001";
            wait for 10 ps;

            -- Operation: AllZero |
            A <= "0000"; B <= "0000"; Operation <= "111"; FaultLocation <= "0010";
            wait;

    end process;
end tb_RedundantALU_arch;