library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lab2_2_tb is
end entity;

architecture RTL of lab2_2_tb is
  signal A : std_logic_vector(15 downto 0) := (others => '0');
  signal B : std_logic_vector(15 downto 0) := (others => '0');
  signal Cin : std_logic := '0';
  signal Sum : std_logic_vector(15 downto 0);
  signal Cout : std_logic;
  
  component CSA_16bit
    port(
      A : in std_logic_vector(15 downto 0);
      B : in std_logic_vector(15 downto 0);
      Cin : in std_logic;
      Sum : out std_logic_vector(15 downto 0);
      Cout : out std_logic
      );
  end component;
  
begin
  process
  begin
    A <= (others => '0'); wait for 10 ns;
    B <= (others => '1'); wait for 10 ns;
    Cin <= '0'; wait for 10 ns;
    A <= std_logic_vector(to_unsigned(32677,A'length)); wait for 10 ns;
    B <= std_logic_vector(to_unsigned(21222,A'length)); wait for 20 ns;
    Cin <= '1'; wait for 40 ns;
    A <= std_logic_vector(to_unsigned(65535,A'length)); wait for 60 ns;
    B <= std_logic_vector(to_unsigned(65535,B'length)); wait for 80 ns;
    A <= (others => '1');
    B <= std_logic_vector(to_unsigned(32768,B'length));
    Cin <= '0'; wait for 100 ns;
  end process;

  i_CSA_16_bit : CSA_16bit
    port map(
      A => A,
      B => B,
      Cin => Cin,
      Sum => Sum,
      Cout => Cout
      );
end architecture;

      
    
