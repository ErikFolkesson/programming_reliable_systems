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
               --Testbench
---------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity tb_FLG is end;

architecture tb_arch of tb_FLG is
  component fault_location_generator is
    generic (
      fault_probability : real;
      seed : positive
    );
    port (
      clk : in std_logic;
      fault_location : out std_logic_vector(3 downto 0)
    );
  end component;

  signal clk : std_logic := '0';
  signal fault_location1 : std_logic_vector(3 downto 0);
  signal fault_location2 : std_logic_vector(3 downto 0);
  signal fault_location3 : std_logic_vector(3 downto 0);

begin
  clk <= not clk after 10 ps;

  inst1 : fault_location_generator 
    generic map (0.5, 1)
    port map (clk, fault_location1);

  inst2 : fault_location_generator 
    generic map (0.5, 2)
    port map (clk, fault_location2);

  inst3 : fault_location_generator 
    generic map (0.5, 3)  
    port map (clk, fault_location3);

end architecture;