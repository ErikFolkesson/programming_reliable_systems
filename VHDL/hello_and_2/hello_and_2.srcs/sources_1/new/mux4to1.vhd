library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.all;

entity mux4to1Exp is
    port (
        i0     : in  std_logic;  -- Input 0 (LSB)
        i1     : in  std_logic;  -- Input 1
        i2     : in  std_logic;  -- Input 2
        i3     : in  std_logic;  -- Input 3 (MSB)
        s0     : in  std_logic;  -- Select bit 0 (LSB)
        s1     : in  std_logic;  -- Select bit 1 (MSB)
        out0   : out std_logic
    );
end mux4to1Exp;

architecture arch_mux4to1 of mux4to1Exp is
    signal input0_term,  -- i0 when s1=0, s0=0
           input1_term,  -- i1 when s1=0, s0=1
           input2_term,  -- i2 when s1=1, s0=0
           input3_term : std_logic;  -- i3 when s1=1, s0=1
begin
    input0_term <= i0 and (not s1) and (not s0);
    input1_term <= i1 and (not s1) and      s0;
    input2_term <= i2 and      s1  and (not s0);
    input3_term <= i3 and      s1  and      s0;

    out0 <= input0_term or input1_term or input2_term or input3_term;

end arch_mux4to1;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mux4to1 is end;

architecture tb_mux4to1_arch of tb_mux4to1 is
    signal i0, i1, i2, i3, s0, s1, out0: std_logic;
begin
    mux4to1_instance_1: entity work.mux4to1Exp
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
end tb_mux4to1_arch;