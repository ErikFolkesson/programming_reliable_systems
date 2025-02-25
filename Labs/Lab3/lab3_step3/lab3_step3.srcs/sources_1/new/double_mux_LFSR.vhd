-- constants_pkg
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

package constants_pkg is
    constant SET_N : natural := 6;
end package constants_pkg;

-- End of constants_pkg --------------------------------------------------------

-- Dflipflop
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity DFlipFlop is
    port (
        D   : in  std_logic;
        clk : in  std_logic;
        Q   : out std_logic := '0'
    );
end DFlipFlop;

architecture Behavioral of DFlipFlop is
begin
    process (clk)
    begin
        if rising_edge(clk) then
            Q <= D;
        end if;
    end process;
end Behavioral;

-- End of Dflipflop --------------------------------------------------------

-- 2:1 Mux
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux2to1 is
    port (
        i0   : in  std_logic;  -- Input 0 (LSB)
        i1   : in  std_logic;  -- Input 1 (MSB)
        s0   : in  std_logic;  -- Select bit
        out0 : out std_logic   -- Output
    );
end Mux2to1;

architecture Behavioral of Mux2to1 is
    signal input0_term, input1_term : std_logic;  -- Internal signals
begin
    input0_term <= i0 and (not s0);  -- Select i0 when s0 = 0
    input1_term <= i1 and s0;        -- Select i1 when s0 = 1

    out0 <= input0_term or input1_term;  -- Output based on select bit
end Behavioral;

-- End of 2:1 Mux --------------------------------------------------------

-- n-bit LFSR
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity NBitLFSR is
    generic (N: natural := 4); -- Default size is 4.
    port (
        clk      : in  std_logic;
        seed_in  : in  std_logic;
        seed_en  : in  std_logic;
        data_out : out std_logic_vector(N-1 downto 0)
    );
end NBitLFSR;

architecture Behavioral of NBitLFSR is
    -- Internal signals
    signal mux_out, xor_out : std_logic;
    signal internal_data_out : std_logic_vector(N-1 downto 0);

    -- MUX component
    component Mux2to1 is
        port (
            i0   : in  std_logic;
            i1   : in  std_logic;
            s0   : in  std_logic;
            out0 : out std_logic
        );
    end component;

    -- DFF component
    component DFlipFlop is
        port (
            D   : in  std_logic;
            clk : in  std_logic;
            Q   : out std_logic
        );
    end component;
begin
    -- Instantiate MUX
    MUX: Mux2to1 port map (
        i0 => xor_out,  -- XOR output
        i1 => seed_in,
        s0 => seed_en,
        out0 => mux_out
    );

    -- First DFF (bit N-1) connected to MUX output
    DFF_first: DFlipFlop port map (
        D   => mux_out,
        clk => clk,
        Q   => internal_data_out(N-1)
    );

    -- Instantiate DFFs for remaining bits
    DFFs: for i in 0 to N-2 generate
        DFF: DFlipFlop port map (
            D   => internal_data_out(i + 1),
            clk => clk,
            Q   => internal_data_out(i)
        );
    end generate DFFs;

    -- XOR gate for feedback
    xor_out <= internal_data_out(1) xor internal_data_out(0);

    -- Output assignment
    data_out <= internal_data_out;
end Behavioral;

-- End of n-bit LFSR --------------------------------------------------------

-- 4:1 Mux Exp
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.ALL;

entity Mux4to1Exp is
    port (
        i0   : in  std_logic;  -- Input 0 (LSB)
        i1   : in  std_logic;  -- Input 1
        i2   : in  std_logic;  -- Input 2
        i3   : in  std_logic;  -- Input 3 (MSB)
        s0   : in  std_logic;  -- Select bit 0 (LSB)
        s1   : in  std_logic;  -- Select bit 1 (MSB)
        out0 : out std_logic
    );
end Mux4to1Exp;

architecture Behavioral of Mux4to1Exp is
    signal input0_term,  -- i0 when s1=0, s0=0
           input1_term,  -- i1 when s1=0, s0=1
           input2_term,  -- i2 when s1=1, s0=0
           input3_term : std_logic;  -- i3 when s1=1, s0=1
begin
    input0_term <= i0 and (not s1) and (not s0);
    input1_term <= i1 and (not s1) and s0;
    input2_term <= i2 and s1 and (not s0);
    input3_term <= i3 and s1 and s0;

    out0 <= input0_term or input1_term or input2_term or input3_term;
end Behavioral;

-- End of 4:1 Mux Exp --------------------------------------------------------

-- 4:1 Mux Inst
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux4to1Inst is
    port (
        i0, i1, i2, i3 : in  std_logic;  -- 4 input lines
        s0, s1         : in  std_logic;  -- 2 select lines
        out0           : out std_logic   -- Output
    );
end Mux4to1Inst;

architecture Behavioral of Mux4to1Inst is
    signal mux0_out, mux1_out : std_logic;  -- Intermediate signals
begin
    -- First-level muxes (select between pairs using s0)
    mux0: entity work.Mux2to1  -- Instance 1: i0 vs i1 (s0)
        port map (
            i0   => i0,
            i1   => i1,
            s0   => s0,
            out0 => mux0_out
        );

    mux1: entity work.Mux2to1  -- Instance 2: i2 vs i3 (s0)
        port map (
            i0   => i2,
            i1   => i3,
            s0   => s0,
            out0 => mux1_out
        );

    -- Second-level mux (select between mux0 and mux1 using s1)
    mux2: entity work.Mux2to1  -- Instance 3: mux0_out vs mux1_out (s1)
        port map (
            i0   => mux0_out,
            i1   => mux1_out,
            s0   => s1,
            out0 => out0
        );
end Behavioral;

-- End of 4:1 Mux Inst --------------------------------------------------------

-- Double Mux
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DoubleMux is
    port (
        i0, i1, i2, i3 : in  std_logic;  -- 4 input lines
        s0, s1         : in  std_logic;  -- 2 select lines
        out0           : out std_logic;  -- Output 1
        out1           : out std_logic   -- Output 2
    );
end DoubleMux;

architecture Behavioral of DoubleMux is
begin
    -- First-level muxes (select between pairs using s0)
    mux0: entity work.Mux4to1Inst  -- Instance 1: i0 vs i1 (s0)
        port map (
            i0   => i0,
            i1   => i1,
            i2   => i2,
            i3   => i3,
            s0   => s0,
            s1   => s1,
            out0 => out0
        );

    mux1: entity work.Mux4to1Exp  -- Instance 1: i0 vs i1 (s0)
        port map (
            i0   => i0,
            i1   => i1,
            i2   => i2,
            i3   => i3,
            s0   => s0,
            s1   => s1,
            out0 => out1
        );
end Behavioral;

-- End of Double Mux --------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.constants_pkg.ALL;

entity DoubleMuxLFSR is
    port (
        clk      : in  std_logic;
        seed_in  : in  std_logic;
        seed_en  : in  std_logic;
        out0, out1 : out std_logic
    );
end DoubleMuxLFSR;

architecture Behavioral of DoubleMuxLFSR is
    signal internal_data_out : std_logic_vector(SET_N-1 downto 0);
begin
    n_bit_LFSR_inst: entity work.NBitLFSR
        generic map (N => SET_N)
        port map (
            clk      => clk,
            seed_in  => seed_in,
            seed_en  => seed_en,
            data_out => internal_data_out
        );

    double_mux_inst: entity work.DoubleMux
        port map (
            i0 => internal_data_out(0),
            i1 => internal_data_out(1),
            i2 => internal_data_out(2),
            i3 => internal_data_out(3),
            s0 => internal_data_out(4),
            s1 => internal_data_out(5),
            out0 => out0,
            out1 => out1
        );
end Behavioral;

-- End of DoubleMuxLFSR --------------------------------------------------------

-- Testbench for DoubleMuxLFSR
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use work.constants_pkg.ALL;

entity tb_DoubleMuxLFSR is end;

architecture Behavioral of tb_DoubleMuxLFSR is
    signal clk : std_logic := '0';
    signal seed_in, seed_en: std_logic;
    signal out0, out1: std_logic;

begin
    -- Instantiate Device Under Test (DUT)
    DUT: entity work.DoubleMuxLFSR
        port map (
            clk      => clk,
            seed_in  => seed_in,
            seed_en  => seed_en,
            out0     => out0,
            out1     => out1
        );

    -- Clock generation
    clk <= not clk after 10 ps;

    -- Test process
    process
    begin
        seed_en <= '1';
        seed_in <= '1';
        wait for 5 ps;

        for i in 0 to SET_N-1 loop
            seed_in <= not seed_in;
            wait for 15 ps;
        end loop;

        seed_in <= '0';
        seed_en <= '0';
        wait;
    end process;
end Behavioral;