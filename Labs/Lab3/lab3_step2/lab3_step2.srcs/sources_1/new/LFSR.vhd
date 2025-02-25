-- Dflipflop
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
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

-- End of Dflipflop --------------------------------------------------------

-- 2:1 Mux
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1 is
    port (
        i0     : in  std_logic;  -- Input 0 (LSB)
        i1     : in  std_logic;  -- Input 1 (MSB)
        s0     : in  std_logic;  -- Select bit
        out0   : out std_logic   -- Output
    );
end mux2to1;

architecture arch_mux2to1 of mux2to1 is
    signal input0_term, input1_term : std_logic;  -- Internal signals
begin
    input0_term <= i0 and (not s0);  -- Select i0 when s0 = 0
    input1_term <= i1 and s0;        -- Select i1 when s0 = 1

    out0 <= input0_term or input1_term;  -- Output based on select bit
end arch_mux2to1;

-- End of 2:1 Mux --------------------------------------------------------

-- n-bit LFSR
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity n_bit_LFSR is
    generic (n: natural := 4); -- Default size is 4.
    port (
        clk      :  in std_logic;
        seed_in  :  in std_logic;
        seed_en  :  in std_logic;
        data_out : out std_logic_vector(n-1 downto 0)
    );
end n_bit_LFSR;

architecture Behavioral of n_bit_LFSR is
    -- Internal signals
    signal mux_out, xor_out : std_logic;
    signal internal_data_out : std_logic_vector(n-1 downto 0);

    -- MUX component
    component mux2to1 is
        port (
            i0   : in  std_logic;
            i1   : in  std_logic;
            s0   : in  std_logic;
            out0 : out std_logic
        );
    end component;

    -- DFF component
    component Dflipflop is
        port (
            D   : in  std_logic;
            clk : in  std_logic;
            Q   : out std_logic
        );
    end component;
begin
    -- Instantiate MUX
    MUX: mux2to1 port map (
        i0 => xor_out,  -- XOR output
        i1 => seed_in,
        s0 => seed_en,
        out0 => mux_out
    );

    -- First DFF (bit n-1) connected to MUX output
    DFF_first: Dflipflop port map (
        D   => mux_out,
        clk => clk,
        Q   => internal_data_out(n-1)
    );

    -- Instantiate DFFs for remaining bits
    DFFs: for i in 0 to n-2 generate
        DFF: Dflipflop port map (
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
-----------------------------------------------------------------------------
                            ---FaultyALU
                            -----------------------------------------------
-- Testbench for n-bit LFSR
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity tb_n_bit_LFSR is end;

architecture tb_n_bit_LFSR_arch of tb_n_bit_LFSR is
    -- Constant for n
    constant set_n : natural := 8;

    -- Signals for testbench
    signal clk : std_logic := '0';
    signal seed_in, seed_en : std_logic;
    signal data_out : std_logic_vector(set_n-1 downto 0);

begin
    -- Instantiate Device Under Test (DUT)
    DUT: entity work.n_bit_LFSR
        generic map (n => set_n)
        port map (
            clk      => clk,
            seed_in  => seed_in,
            seed_en  => seed_en,
            data_out => data_out
        );

    -- Clock generation
    clk <= not clk after 10 ps;

    -- Test process
    process
    begin
        seed_en <= '1';
        seed_in <= '1';
        wait for 10 ps;

        for i in 0 to set_n-1 loop
            seed_in <= not seed_in;
            wait for 15 ps;
        end loop;

        seed_in <= '0';
        seed_en <= '0';
        wait;
    end process;
end tb_n_bit_LFSR_arch;