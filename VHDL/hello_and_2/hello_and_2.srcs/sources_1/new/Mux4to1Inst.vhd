library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux4to1Inst is
    port (
        i0, i1, i2, i3  : in  std_logic;  -- 4 input lines
        s0, s1          : in  std_logic;  -- 2 select lines
        out0            : out std_logic   -- Output
    );
end Mux4to1Inst;

architecture arch_mux4to1Inst of Mux4to1Inst is
    signal mux0_out, mux1_out : std_logic;  -- Intermediate signals
begin
    -- First-level muxes (select between pairs using s0)
    mux0: entity work.mux2to1  -- Instance 1: i0 vs i1 (s0)
        port map (
            i0   => i0,
            i1   => i1,
            s0   => s0,
            out0 => mux0_out
        );
    
    mux1: entity work.mux2to1  -- Instance 2: i2 vs i3 (s0)
        port map (
            i0   => i2,
            i1   => i3,
            s0   => s0,
            out0 => mux1_out
        );
    
    -- Second-level mux (select between mux0 and mux1 using s1)
    mux2: entity work.mux2to1  -- Instance 3: mux0_out vs mux1_out (s1)
        port map (
            i0   => mux0_out,
            i1   => mux1_out,
            s0   => s1,
            out0 => out0
        );
end arch_mux4to1Inst;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mux4to1Inst is end;

architecture tb_mux4to1Inst_arch of tb_mux4to1Inst is
    signal i0, i1, i2, i3, s0, s1, out0: std_logic;
begin
    mux4to1_instance_1: entity work.Mux4to1Inst
        port map(i0, i1, i2, i3, s0, s1, out0);
    
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
end tb_mux4to1Inst_arch;
