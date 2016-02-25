library IEEE;
use IEEE.std_logic_1164.all;

entity carry_propagate is
  port(
    A : in std_logic_vector(15 downto 0);
    B : in std_logic_vector(15 downto 0);
    Cin : in std_logic;
    Sum : out std_logic_vector(15 downto 0);
    Cout : out std_logic
    );
end entity;

architecture RTL of carry_propagate is

  --Signal declarations
  signal Carry_internal  : std_logic_vector(3 downto 0);
  signal Group_propagate : std_logic_vector(3 downto 0);
  signal Group_generate  : std_logic_vector(3 downto 0);

  --Component declarations
  component CLA_4bit
    port(
      A : in std_logic_vector(3 downto 0);
      B : in std_logic_vector(3 downto 0);
      Cin : in std_logic;
      Group_propagate : out std_logic;
      Group_generate  : out std_logic;
      Sum : out std_logic_vector(3 downto 0)
      );
  end component;
begin

  i_CLA1 : CLA_4bit
    port map(
      A => A(3 downto 0),
      B => B(3 downto 0),
      Cin => Cin,
      Group_propagate => Group_propagate(0),
      Group_generate  => Group_generate(0),
      Sum => Sum(3 downto 0)
      );

  Carry_internal(0) <= (Group_generate(0) or (Group_propagate(0) and Cin));
  
  i_CLA2 : CLA_4bit
    port map(
      A => A(7 downto 4),
      B => B(7 downto 4),
      Cin => Carry_internal(0),
      Group_propagate => Group_propagate(1),
      Group_generate  => Group_generate(1),
      Sum => Sum(7 downto 4)
      );

  Carry_internal(1) <= (Group_generate(1) or (Group_propagate(1) and Carry_internal(0)));

  i_CLA3 : CLA_4bit
    port map(
      A => A(11 downto 8),
      B => B(11 downto 8),
      Cin => Carry_internal(1),
      Group_propagate => Group_propagate(2),
      Group_generate  => Group_generate(2),
      Sum => Sum(11 downto 8)
      );

  Carry_internal(2) <= (Group_generate(2) or (Group_propagate(2) and Carry_internal(1)));

  i_CLA4 : CLA_4bit
    port map(
      A => A(15 downto 12),
      B => B(15 downto 12),
      Cin => Carry_internal(2),
      Group_propagate => Group_propagate(3),
      Group_generate  => Group_generate(3),
      Sum => Sum(15 downto 12)
      );

  Carry_internal(3) <= (Group_generate(3) or (Group_propagate(3) and Carry_internal(2)));

  Cout <= Carry_internal(3);
  
end architecture;
