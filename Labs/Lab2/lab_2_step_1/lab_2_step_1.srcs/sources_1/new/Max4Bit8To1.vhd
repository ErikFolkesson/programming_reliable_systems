library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Max4Bit8To1 is
    --- Define port for inputs i0 to i7 using 4 bit std_logic_vector.
    port (
        i0     : in  std_logic_vector(3 downto 0);  -- Input 0 (LSB)
        i1     : in  std_logic_vector(3 downto 0);  -- Input 1
        i2     : in  std_logic_vector(3 downto 0);  -- Input 2
        i3     : in  std_logic_vector(3 downto 0);  -- Input 3
        i4     : in  std_logic_vector(3 downto 0);  -- Input 4
        i5     : in  std_logic_vector(3 downto 0);  -- Input 5
        i6     : in  std_logic_vector(3 downto 0);  -- Input 6
        i7     : in  std_logic_vector(3 downto 0);  -- Input 7 (MSB)

        s0     : in  std_logic_vector(2 downto 0);  -- Select

        out0   : out  std_logic_vector(3 downto 0)  -- Output
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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Max4Bit8To1 is end;

architecture tb_Max4Bit8To1_arch of tb_Max4Bit8To1 is
    signal i0, i1, i2, i3, i4, i5, i6, i7, out0: std_logic_vector(3 downto 0);
    signal s0: std_logic_vector(2 downto 0);

begin
    Max4Bit8To1_instance_1: entity work.Max4Bit8To1
        port map(i0, i1, i2, i3, i4, i5, i6, i7, s0, out0);

    process is
    begin
        -- Test pattern: (i7, i6, i5, i4, i3, i2, i1, i0) | s0
        -- Group 1: Select i0 (s0=000)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "000"; wait for 10 ps;  -- 0 from i0 (all 0)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0001"; s0 <= "000"; wait for 10 ps;  -- 1 from i0 (others 0)

        -- Group 2: Select i1 (s0=001)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "001"; wait for 10 ps;  -- 0 from i1 (others 0)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0001"; i0 <= "0000"; s0 <= "001"; wait for 10 ps;  -- 1 from i1 (others 0)

        -- Group 3: Select i2 (s0=010)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "010"; wait for 10 ps;  -- 0 from i2 (others 0)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0001"; i1 <= "0000"; i0 <= "0000"; s0 <= "010"; wait for 10 ps;  -- 1 from i2 (others 0)

        -- Group 4: Select i3 (s0=011)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "011"; wait for 10 ps;  -- 0 from i3 (others 0)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0001"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "011"; wait for 10 ps;  -- 1 from i3 (others 0)

        -- Group 5: Select i4 (s0=100)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "100"; wait for 10 ps;  -- 0 from i4 (others 0)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0001"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "100"; wait for 10 ps;  -- 1 from i4 (others 0)

        -- Group 6: Select i5 (s0=101)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "101"; wait for 10 ps;  -- 0 from i5 (others 0)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0001"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "101"; wait for 10 ps;  -- 1 from i5 (others 0)

        -- Group 7: Select i6 (s0=110)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "110"; wait for 10 ps;  -- 0 from i6 (others 0)
        i7 <= "0000"; i6 <= "0001"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "110"; wait for 10 ps;  -- 1 from i6 (others 0)

        -- Group 8: Select i7 (s0=111)
        i7 <= "0000"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "111"; wait for 10 ps;  -- 0 from i7 (others 0)
        i7 <= "0001"; i6 <= "0000"; i5 <= "0000"; i4 <= "0000"; i3 <= "0000"; i2 <= "0000"; i1 <= "0000"; i0 <= "0000"; s0 <= "111"; wait for 10 ps;  -- 1 from i7 (others 0)

        wait;
    end process;
end tb_Max4Bit8To1_arch;