library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity double_mux is
    port (
        i0, i1, i2, i3  : in  std_logic;  -- 4 input lines
        s0, s1          : in  std_logic;  -- 2 select lines
        out0            : out std_logic;  -- Output 1
        out1            : out std_logic   -- Output 2
    );
end double_mux;

architecture arch_double_mux of double_mux is

begin
    -- First-level muxes (select between pairs using s0)
    mux0: entity work.Mux4to1Inst  -- Instance 1: i0 vs i1 (s0)
        port map (
            i0   => i0,
            i1   => i1,
            i2   => i3,
            i3   => i3,
            s0   => s0,
            s1   => s1,
            out0 => out0
        );

    mux1: entity work.mux4to1Exp  -- Instance 1: i0 vs i1 (s0)
        port map (
            i0   => i0,
            i1   => i1,
            i2   => i3,
            i3   => i3,
            s0   => s0,
            s1   => s1,
            out0 => out1
        );
end arch_double_mux;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_double_mux is end;

architecture tb_double_mux_arch of tb_double_mux is
    signal i0, i1, i2, i3, s0, s1, out0, out1: std_logic;
begin
    double_mux_instance_1: entity work.double_mux
        port map(i0, i1, i2, i3, s0, s1, out0, out1);

    process is
    begin
        -- Test pattern: (i3, i2, i1, i0) | s1 | s0
        -- Group 1: Select i0 (s1=0, s0=0)
        i3 <= '0'; i2 <= '0'; i1 <= '0'; i0 <= '0'; s1 <= '0'; s0 <= '0'; wait for 10 ps;  -- 0 from i0 (all 0)
        i3 <= '0'; i2 <= '0'; i1 <= '0'; i0 <= '1'; s1 <= '0'; s0 <= '0'; wait for 10 ps;  -- 1 from i0 (others 0)
        i3 <= '1'; i2 <= '1'; i1 <= '1'; i0 <= '0'; s1 <= '0'; s0 <= '0'; wait for 10 ps;  -- 0 from i0 (others 1)
        i3 <= '1'; i2 <= '1'; i1 <= '1'; i0 <= '1'; s1 <= '0'; s0 <= '0'; wait for 10 ps;  -- 1 from i0 (others 1)

        -- Group 2: Select i1 (s1=0, s0=1)
        i3 <= '0'; i2 <= '0'; i1 <= '0'; i0 <= '0'; s1 <= '0'; s0 <= '1'; wait for 10 ps;  -- 0 from i1 (others 0)
        i3 <= '0'; i2 <= '0'; i1 <= '1'; i0 <= '0'; s1 <= '0'; s0 <= '1'; wait for 10 ps;  -- 1 from i1 (others 0)
        i3 <= '1'; i2 <= '1'; i1 <= '0'; i0 <= '1'; s1 <= '0'; s0 <= '1'; wait for 10 ps;  -- 0 from i1 (others 1)
        i3 <= '1'; i2 <= '1'; i1 <= '1'; i0 <= '1'; s1 <= '0'; s0 <= '1'; wait for 10 ps;  -- 1 from i1 (others 1)

        -- Group 3: Select i2 (s1=1, s0=0)
        i3 <= '0'; i2 <= '0'; i1 <= '0'; i0 <= '0'; s1 <= '1'; s0 <= '0'; wait for 10 ps;  -- 0 from i2 (others 0)
        i3 <= '0'; i2 <= '1'; i1 <= '0'; i0 <= '0'; s1 <= '1'; s0 <= '0'; wait for 10 ps;  -- 1 from i2 (others 0)
        i3 <= '1'; i2 <= '0'; i1 <= '1'; i0 <= '1'; s1 <= '1'; s0 <= '0'; wait for 10 ps;  -- 0 from i2 (others 1)
        i3 <= '1'; i2 <= '1'; i1 <= '1'; i0 <= '1'; s1 <= '1'; s0 <= '0'; wait for 10 ps;  -- 1 from i2 (others 1)

        -- Group 4: Select i3 (s1=1, s0=1)
        i3 <= '0'; i2 <= '0'; i1 <= '0'; i0 <= '0'; s1 <= '1'; s0 <= '1'; wait for 10 ps;  -- 0 from i3 (others 0)
        i3 <= '1'; i2 <= '0'; i1 <= '0'; i0 <= '0'; s1 <= '1'; s0 <= '1'; wait for 10 ps;  -- 1 from i3 (others 0)
        i3 <= '0'; i2 <= '1'; i1 <= '1'; i0 <= '1'; s1 <= '1'; s0 <= '1'; wait for 10 ps;  -- 0 from i3 (others 1)
        i3 <= '1'; i2 <= '1'; i1 <= '1'; i0 <= '1'; s1 <= '1'; s0 <= '1'; wait for 10 ps;  -- 1 from i3 (others 1)

        wait;
    end process;
end tb_double_mux_arch;
