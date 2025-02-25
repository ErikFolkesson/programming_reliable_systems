---------------------------------------------------
                  --MUX2TO1
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity mux2to1 is
    port(
        i0 : in std_logic;
        i1 : in std_logic;
        s0 : in std_logic;
        out0 : out std_logic
        );
end mux2to1;

architecture arch1 of mux2to1 is
    signal or1, or2: std_logic;
begin
    or1 <= i0 and (not s0);
    or2 <= i1 and s0;
    out0 <= or1 or or2;
end arch1;

---------------------------------------------------
                  --Dflipflop
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
entity Dflipflop is
    Port (
    Clk, D: in std_logic;
    Q: out std_logic
    );
end Dflipflop;

architecture Dff of Dflipflop is

begin
process (Clk)
    begin
        if rising_edge(Clk) then
            Q <= D;
        end if;
    end process;
end Dff;

---------------------------------------------------
                     --LFSR
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity LFSR is
    generic (n: natural := 11);
    port(
    seed_in, seed_en, Clk: in std_logic;
    data_out: out std_logic_vector(n - 1 downto 0)
    );
end LFSR;

architecture LFSR_arch of LFSR is
    component Dflipflop is
        Port (
        Clk, D: in std_logic;
        Q: out std_logic
        );
    end component;

    component mux2to1 is
        port(
            i0 : in std_logic;
            i1 : in std_logic;
            s0 : in std_logic;
            out0 : out std_logic
        );
    end component;

signal shift_reg : std_logic_vector(n - 1 downto 0) := (others => '0');
signal feedback: std_logic;
signal mux_out: std_logic;

begin

    feedback <= shift_reg(n-1) xor shift_reg(n-2);

    mux: mux2to1
        port map(i0 => feedback, i1 => seed_in, s0 => seed_en, out0 => mux_out);

    dff0: Dflipflop
        port map(Clk => Clk, D => mux_out, Q => shift_reg(0));

    dffn: for i in 1 to n-1 generate
        instance_i: Dflipflop port map (Clk => Clk, D => shift_reg(i-1), Q => shift_reg(i));
end generate;

data_out <= shift_reg;
end LFSR_arch;

---------------------------------------------------
                     --FLG
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity fault_location_generator is
  generic (
    fault_probability : real;
    seed : positive
  );
  port (
    clk : in std_logic;
    fault_location : out std_logic_vector(3 downto 0)
  );
end entity;

architecture arch of fault_location_generator is
begin
  process (clk)
    variable seed1, seed2 : positive;
    variable rand : real;
  begin
    if rising_edge(clk) then
      seed1 := seed1 + seed;
      seed2 := seed2 + 2 * seed + 1;
      uniform(seed1, seed2, rand);
      if (rand < fault_probability) then
        seed1 := seed1 + seed;
        seed2 := seed2 + 2 * seed + 1;
        uniform(seed1, seed2, rand);
        fault_location <= std_logic_vector(to_unsigned(integer(floor(rand * real(11))), 4));
      else
        fault_location <= "1111";
      end if;
    end if;
  end process;
end architecture;

---------------------------------------------------
                  --Mux4Bit8To1
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Max4Bit8To1 is
    Port (
    i0, i1, i2, i3, i4, i5, i6, i7 : in std_logic_vector(3 downto 0);
    sel : in std_logic_vector(2 downto 0);
    out0 : out std_logic_vector(3 downto 0)
     );
end Max4Bit8To1;

architecture Behavioral of Max4Bit8To1 is

begin
    process (i0, i1, i2, i3, i4, i5, i6, i7, sel) is
        begin
            case sel is
                when "000" => out0 <= i0;
                when "001" => out0 <= i1;
                when "010" => out0 <= i2;
                when "011" => out0 <= i3;
                when "100" => out0 <= i4;
                when "101" => out0 <= i5;
                when "110" => out0 <= i6;
                when "111" => out0 <= i7;
                when others => out0 <= "0000";
            end case;
        end process;
end Behavioral;

---------------------------------------------------
                  --Mux4Bit8To1
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity ArithLogic is
    Port (
    A, B: in std_logic_vector(3 downto 0);
    AplusB, AandB, AxorB, AnandB, APlusOne, Ao, Bo, AllZero: out std_logic_vector(3 downto 0)
    );
end ArithLogic;

architecture Behavioral of ArithLogic is

begin
    AplusB <= std_logic_vector(unsigned(A)+unsigned(B));
    AandB <= A and B;
    AxorB <= A xor B;
    AnandB <= not(A and B);
    APlusOne <= std_logic_vector(unsigned(A)+ 1);
    Ao <= A;
    Bo <= B;
    AllZero <= "0000";
end Behavioral;

---------------------------------------------------
                --Fault Injector
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity FaultInjector is
    Port (
    A, B, FaultLocation: in std_logic_vector(3 downto 0);
    Operation: in std_logic_vector(2 downto 0);
    FaultyA, FaultyB: out std_logic_vector(3 downto 0);
    FaultyOp: out std_logic_vector(2 downto 0)
    );
end FaultInjector;

architecture Behavioral of FaultInjector is
    signal tempA, TempB: std_logic_vector(3 downto 0);
    signal tempOp: std_logic_vector(2 downto 0);
begin
    process (A, B, FaultLocation, Operation) is
        begin
            tempA <= A;
            tempB <= B;
            tempOp <= Operation;

            case FaultLocation is
                when "0000" => tempA(0) <= not A(0);
                when "0001" => tempA(1) <= not A(1);
                when "0010" => tempA(2) <= not A(2);
                when "0011" => tempA(3) <= not A(3);

                when "0100" => tempB(0) <= not B(0);
                when "0101" => tempB(1) <= not B(1);
                when "0110" => tempB(2) <= not B(2);
                when "0111" => tempB(3) <= not B(3);

                when "1000" => tempOp(0) <= not Operation(0);
                when "1001" => tempOp(1) <= not Operation(1);
                when "1010" => tempOp(2) <= not Operation(2);

                when others =>
                    tempA <= A;
                    tempB <= B;
                    tempOp <= Operation;
            end case;
        end process;

    FaultyA <= tempA;
    FaultyB <= tempB;
    FaultyOp <= tempOp;

end Behavioral;

---------------------------------------------------
                  --FaultyALU
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity FaultyALU is
    Port (
    A, B, FaultLocation: in std_logic_vector(3 downto 0);
    Operation: in std_logic_vector(2 downto 0);
    Result: out std_logic_vector(3 downto 0)
     );
end FaultyALU;

architecture Behavioral of FaultyALU is
    component Max4Bit8To1 is
    Port (
    i0, i1, i2, i3, i4, i5, i6, i7 : in std_logic_vector(3 downto 0);
    sel : in std_logic_vector(2 downto 0);
    out0 : out std_logic_vector(3 downto 0)
     );
    end component;

    component ArithLogic is
    Port (
    A, B: in std_logic_vector(3 downto 0);
    AplusB, AandB, AxorB, AnandB, APlusOne, Ao, Bo, AllZero: out std_logic_vector(3 downto 0)
    );
    end component;

    component FaultInjector is
    Port (
    A, B, FaultLocation: in std_logic_vector(3 downto 0);
    Operation: in std_logic_vector(2 downto 0);
    FaultyA, FaultyB: out std_logic_vector(3 downto 0);
    FaultyOp: out std_logic_vector(2 downto 0)
    );
    end component;

    signal FaultyA, FaultyB, AplusB, AandB, AxorB, AnandB, APlusOne, Ao, Bo, AllZero: std_logic_vector(3 downto 0);
    signal FaultyOp: std_logic_vector(2 downto 0);

begin
    FaultInjector_instance: FaultInjector
        port map(A => A, B => B , Operation => Operation, FaultLocation => FaultLocation, FaultyA => FaultyA, FaultyB => FaultyB, FaultyOp => FaultyOp);

    ArithLogic_instance: ArithLogic
        port map(A => FaultyA, B => FaultyB, AplusB => AplusB, AandB => AandB, AxorB => AxorB, AnandB => AnandB, APlusOne => APlusOne, Ao => Ao, Bo => Bo, AllZero => AllZero);

    MUX_instance: Max4Bit8To1
        port map(i0 => AplusB, i1 => AandB, i2 => AxorB, i3 => AnandB, i4 => APlusOne, i5 => Ao, i6 => Bo, i7 => AllZero, sel => FaultyOp, out0 => Result);

end Behavioral;

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
               --Inequality Counter
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InequalityCounter is
    generic (n: natural := 4);
    port (
        in1, in2      :  in std_logic_vector(n-1 downto 0);
        clk  :  in std_logic;
        reset  :  in std_logic;
        ineq_counter_out : out integer
    );
end InequalityCounter;

architecture Behavioral of InequalityCounter is
    -- Internal signals
    signal internal_cmp_out : std_logic;

    -- Counter component
    component Counter is
        port(
            clk : in std_logic;
            reset : in std_logic;
            en : in std_logic;
            counter_out: out integer
        );
        end component;

        component Comparator is
        port (
            cmp_in1 : in std_logic_vector(n-1 downto 0);
            cmp_in2 : in std_logic_vector(n-1 downto 0);
            cmp_out : out std_logic
        );
        end component;
begin

    CMP: Comparator port map (
        cmp_in1 => in1,
        cmp_in2 => in2,
        cmp_out => internal_cmp_out
    );

    CNT: Counter port map (
        clk => clk,
        reset => reset,
        en => internal_cmp_out,
        counter_out => ineq_counter_out
    );

end Behavioral;

---------------------------------------------------
               --FaultyALUTester
---------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity FaultyALUTester is
    generic (
    n: natural := 11;
    fault_probability: real := 0.2;
    seed: positive
    );
    Port(
    seed_in, seed_en, Clk, reset: in std_logic;
    counter_out: out integer
    );
end FaultyALUTester;

architecture Behavioral of FaultyALUTester is
    component LFSR is
        generic (n: natural := 11);
        port(
        seed_in, seed_en, Clk: in std_logic;
        data_out: out std_logic_vector(n - 1 downto 0)
        );
    end component;

    component fault_location_generator is
        generic (
            fault_probability : real := 0.2;
            seed : positive
            );
        port (
            Clk : in std_logic;
            fault_location : out std_logic_vector(3 downto 0)
            );
      end component;

    component FaultyALU is
        Port (
            A, B, FaultLocation: in std_logic_vector(3 downto 0);
            Operation: in std_logic_vector(2 downto 0);
            Result: out std_logic_vector(3 downto 0)
             );
    end component;

    component InequalityCounter is
        generic (n: natural := 4);
        port (
            in1, in2      :  in std_logic_vector(n-1 downto 0);
            Clk  :  in std_logic;
            reset  :  in std_logic;
            ineq_counter_out : out integer
            );
    end component;

    signal data_out_signal: std_logic_vector(n-1 downto 0);
    signal fault_location_signal : std_logic_vector(3 downto 0);
    signal Result_signal, ResultFaulty_signal: std_logic_vector(3 downto 0);

begin
    instance_LFSR: LFSR
    port map(seed_in => seed_in, seed_en => seed_en, Clk => Clk, data_out => data_out_signal);

    instance_FLG: fault_location_generator
    generic map(fault_probability => fault_probability, seed => seed)
    port map(Clk => Clk, fault_location => fault_location_signal);

    instance_FaultyALU: FaultyALU
    port map(A => data_out_signal(3 downto 0), B => data_out_signal(7 downto 4), Operation => data_out_signal(10 downto 8), FaultLocation => fault_location_signal, Result => ResultFaulty_signal);

    instance_NonFaultyALU: FaultyALU
    port map(A => data_out_signal(3 downto 0), B => data_out_signal(7 downto 4), Operation => data_out_signal(10 downto 8), FaultLocation => "1111", Result => Result_signal);

    instance_InequalityCounter: InequalityCounter
    port map(in1 => ResultFaulty_signal, in2 => Result_signal, ineq_counter_out => counter_out, Clk => Clk, reset => reset);
end Behavioral;

---------------------------------------------------
               --Testbench
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_FaultyALUTester is end;

architecture tb_arch of tb_FaultyALUTester is
    component FaultyALUTester
        generic (
        n: natural := 11;
        fault_probability: real := 0.2;
        seed: positive := 2
        );
        Port(
        seed_in, seed_en, Clk, reset: in std_logic;
        counter_out: out integer
        );
    end component;

    signal Clk_tb: std_logic := '0';
    signal seed_in_tb, seed_en_tb: std_logic := '1';
    signal reset_tb: std_logic := '0';
    signal counter_out_tb: integer;

    constant PERIOD : time := 10 ns;

begin
    FaultyALUTester_uut: FaultyALUTester
        generic map(
        n => 11,
        fault_probability => 0.2,
        seed => 1
        )
        port map(Clk => Clk_tb, seed_in => seed_in_tb, seed_en => seed_en_tb, reset => reset_tb, counter_out => counter_out_tb);
        Clk_tb <= not Clk_tb after 5000ps;

    process
    begin
        for i in 0 to 10 loop
                seed_in_tb <= not seed_in_tb;
                wait for 10000 ps;
            end loop;
            seed_en_tb <= '0';
            seed_in_tb <= '0';

        reset_tb <= '1';
        wait for 50 ns;
        reset_tb <= '0';

        wait for 100000 * PERIOD;

        wait;
    end process;

end tb_arch;
