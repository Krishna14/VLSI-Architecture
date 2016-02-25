library IEEE;
use IEEE.std_logic_1164.all;

entity carry_save1 is
  generic(
    N : integer := 8
    );
  port(
    A    : in std_logic_vector(N - 1 downto 0);
    B    : in std_logic_vector(N - 1 downto 0);
    C    : in std_logic_vector(N - 1 downto 0);
    D    : out std_logic_vector(N - 1 downto 0);
    E    : out std_logic_vector(N  downto 0)
    );
end entity;

architecture RTL of carry_save1 is

  component full_add
    port (
      A : in std_logic;
      B : in std_logic;
      Cin : in std_logic;
      Sum : out std_logic;
      Cout : out std_logic
      );
  end component;
  
begin  -- RTL
  E(0) <= '0';
  mult_generate: for i in 0 to N-1  generate
    bit_add : full_add
      port map(
        A => A(i),
        B => B(i),
        Cin => C(i),
        Sum => D(i),
        Cout => E(i+1)
        );
  end generate mult_generate;
end architecture;
