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
    signal input0_term,  -- i0 when s0=0
           input1_term : std_logic;  -- i1 when s0=1
begin
    input0_term <= i0 and (not s0);  -- Select i0 when s0=0
    input1_term <= i1 and s0;        -- Select i1 when s0=1

    out0 <= input0_term or input1_term;

end arch_mux2to1;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mux2to1 is end;

architecture tb_mux2to1_arch of tb_mux2to1 is
    signal i0, i1, s0, out0: std_logic;
begin
    mux2to1_instance_1: entity work.mux2to1
        port map(
            i0  => i0,
            i1  => i1,
            s0  => s0,
            out0 => out0
        );
    
    process is
    begin 
        i0 <= '0'; i1 <= '0'; s0 <= '0'; wait for 10 ps;
        i0 <= '1'; i1 <= '0'; s0 <= '0'; wait for 10 ps;
        i0 <= '0'; i1 <= '1'; s0 <= '0'; wait for 10 ps;
        i0 <= '1'; i1 <= '1'; s0 <= '0'; wait for 10 ps;
        i0 <= '0'; i1 <= '0'; s0 <= '1'; wait for 10 ps;
        i0 <= '1'; i1 <= '0'; s0 <= '1'; wait for 10 ps;
        i0 <= '0'; i1 <= '1'; s0 <= '1'; wait for 10 ps;
        i0 <= '1'; i1 <= '1'; s0 <= '1'; wait; 
    end process;
end tb_mux2to1_arch;