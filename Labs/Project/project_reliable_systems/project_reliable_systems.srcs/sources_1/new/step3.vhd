---------------------------------------------------
               --InequalityCounter
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InequalityCounter is
    generic (n: natural := 4); -- Default size is 4.
    port (
        in1, in2      :  in std_logic_vector(n-1 downto 0);
        clk  :  in std_logic;
        reset  :  in std_logic;
        ineq_counter_out : out integer
    );
end InequalityCounter;

architecture Behavioral of InequalityCounter is
    signal internal_cmp_out : std_logic;
    
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
               --Testbench
---------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_InequalityCounter is end;

architecture tb_InequalityCounter_arch of tb_InequalityCounter is
    component InequalityCounter
        generic (n: natural := 4);
        port (
            in1, in2      :  in std_logic_vector(n-1 downto 0);
            clk  :  in std_logic;
            reset  :  in std_logic;
            ineq_counter_out : out integer
        );
    end component;
    
    signal in1_tb : std_logic_vector(3 downto 0) := "0000";
    signal in2_tb : std_logic_vector(3 downto 0) := "0000";
    signal clk_tb : std_logic := '0';
    signal reset_tb : std_logic := '0';
    signal ineq_counter_out_tb : integer;

begin
    InequalityCounter_uut: InequalityCounter
        generic map (n => 4)
        port map (
            in1 => in1_tb,
            in2 => in2_tb,
            clk => clk_tb,
            reset => reset_tb,
            ineq_counter_out => ineq_counter_out_tb
        );

    clk_tb <= not clk_tb after 2 ps;

    process
    begin
        in1_tb <= "0000";
        in2_tb <= "0000";
        reset_tb <= '1';
        wait for 10 ps;

        reset_tb <= '0';
        wait for 10 ps;

        in1_tb <= "0000";
        in2_tb <= "0001";
        wait for 10 ps;

        in1_tb <= "0001";
        in2_tb <= "0000";
        wait for 10 ps;

        in1_tb <= "0001";
        in2_tb <= "0001";
        wait for 10 ps;

        in1_tb <= "0010";
        in2_tb <= "0001";
        wait for 10 ps;

        in1_tb <= "0010";
        in2_tb <= "0010";
        wait for 10 ps;

        in1_tb <= "0011";
        in2_tb <= "0010";
        wait for 10 ps;

        in1_tb <= "0011";
        in2_tb <= "0011";
        wait for 10 ps;

        in1_tb <= "0100";
        in2_tb <= "0011";
        wait for 10 ps;

        in1_tb <= "0100";
        in2_tb <= "0100";
        wait for 10 ps;

        in1_tb <= "0101";
        in2_tb <= "0100";
        wait for 10 ps;

        in1_tb <= "0101";
        in2_tb <= "0101";
        wait for 10 ps;

        in1_tb <= "0110";
        in2_tb <= "0101";
        wait for 10 ps;

        in1_tb <= "0110";
        in2_tb <= "0110";
        wait for 10 ps;

        in1_tb <= "0111";
        in2_tb <= "0110";
        wait for 10 ps;

        in1_tb <= "0111";
        in2_tb <= "0111";
        wait for 10 ps;

        in1_tb <= "1000";
        in2_tb <= "0111";
        wait;
    end process;
end tb_InequalityCounter_arch;