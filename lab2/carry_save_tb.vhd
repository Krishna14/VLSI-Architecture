library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity carry_save_tb is
  generic(
    width : integer := 9
    );
end entity;

architecture behav of carry_save_tb is

  signal A : std_logic_vector(width - 1 downto 0) := (others => '0');
  signal B : std_logic_vector(width - 1 downto 0) := (others => '0');
  signal C : std_logic_vector(width - 1 downto 0) := (others => '0');
  signal D : std_logic_vector(width - 1 downto 0) := (others => '0');
  signal E : std_logic_vector(width downto 0) := (others => '0');

begin
  process
  begin
    A <= (others => '0');
    B <= std_logic_vector(to_unsigned(128,B'length));
    C <= std_logic_vector(to_unsigned(127,C'length));
    wait for 10 ns;
    A <= (others => '1');
    B <= (others => '0');
    C <= std_logic_vector(to_unsigned(1,C'length));
    wait for 10 ns;
    A <= std_logic_vector(to_unsigned(23,A'length));
    B <= std_logic_vector(to_unsigned(46,B'length));
    C <= std_logic_vector(to_unsigned(92,C'length));
    wait for 10 ns;
    A <= std_logic_vector(to_unsigned(92,A'length));
    B <= std_logic_vector(to_unsigned(184,B'length));
    C <= std_logic_vector(to_unsigned(368,C'length));
    wait for 10 ns;
  end process;

  i_CSA : entity work.carry_save1
    generic map(
      N => width
      )
    port map(
      A => A,
      B => B,
      C => C,
      D => D,
      E => E
      );

end architecture;

  
        
