library IEEE;
use IEEE.std_logic_1164.all;

entity multiplier_optimized is
  port(
    multiplicand : in std_logic_vector(7 downto 0);
    multiplier   : in std_logic_vector(7 downto 0);
    prod         : out std_logic_vector(15 downto 0)
    );
end multiplier_optimized;

architecture accumulative of multiplier_optimized is
  --Signal declarations
  signal PP1 : std_logic_vector(7 downto 0) := (others => '0');
  signal PP2 : std_logic_vector(8 downto 1) := (others => '0');
  signal PP3 : std_logic_vector(9 downto 2) := (others => '0');
  signal PP4 : std_logic_vector(10 downto 3) := (others => '0');
  signal PP5 : std_logic_vector(11 downto 4) := (others => '0');
  signal PP6 : std_logic_vector(12 downto 5) := (others => '0');
  signal PP7 : std_logic_vector(13 downto 6) := (others => '0');
  signal PP8 : std_logic_vector(14 downto 7) := (others => '0');

  signal CSA11 : std_logic_vector(8 downto 1)  := (others => '0');
  signal CSA12 : std_logic_vector(9 downto 1)  := (others => '0');
  signal CSA21 : std_logic_vector(9 downto 2)  := (others => '0');
  signal CSA22 : std_logic_vector(10 downto 2) := (others => '0');
  signal CSA31 : std_logic_vector(10 downto 3) := (others => '0');
  signal CSA32 : std_logic_vector(11 downto 3) := (others => '0');
  signal CSA41 : std_logic_vector(12 downto 4) := (others => '0');
  signal CSA42 : std_logic_vector(13 downto 4) := (others => '0');
  signal CSA51 : std_logic_vector(13 downto 5) := (others => '0');
  signal CSA52 : std_logic_vector(14 downto 5) := (others => '0');
  signal CSA61 : std_logic_vector(14 downto 6) := (others => '0');
  signal CSA62 : std_logic_vector(15 downto 6) := (others => '0');

  signal interm1  : std_logic_vector(8 downto 1) := (others => '0');
  signal interm2  : std_logic_vector(8 downto 1) := (others => '0');
  signal interm3  : std_logic_vector(9 downto 2) := (others => '0');
  signal interm4  : std_logic_vector(9 downto 2) := (others => '0');
  signal interm5  : std_logic_vector(10 downto 3) := (others => '0');
  signal interm6  : std_logic_vector(10 downto 3) := (others => '0');
  signal interm7  : std_logic_vector(11 downto 4) := (others => '0');
  signal interm8  : std_logic_vector(11 downto 4) := (others => '0');
  signal interm9  : std_logic_vector(12 downto 5) := (others => '0');
  signal interm10 : std_logic_vector(12 downto 5) := (others => '0');
  signal interm11 : std_logic_vector(13 downto 6) := (others => '0');
  signal interm12 : std_logic_vector(13 downto 6) := (others => '0');
  signal interm13 : std_logic_vector(14 downto 7) := (others => '0');
  signal interm14 : std_logic_vector(14 downto 7) := (others => '0');

  --Component declarations
  component partial_prod is
    port(
      A : in std_logic_vector(7 downto 0);
      B : in std_logic_vector(7 downto 0);
      PP1 : out std_logic_vector(7 downto 0);
      PP2 : out std_logic_vector(7 downto 0);
      PP3 : out std_logic_vector(7 downto 0);
      PP4 : out std_logic_vector(7 downto 0);
      PP5 : out std_logic_vector(7 downto 0);
      PP6 : out std_logic_vector(7 downto 0);
      PP7 : out std_logic_vector(7 downto 0);
      PP8 : out std_logic_vector(7 downto 0)
      );
  end component;
  
  component carry_save1
    generic(
      N : integer := 8
      );
    port(
      A : in std_logic_vector(N-1 downto 0);
      B : in std_logic_vector(N-1 downto 0);
      C : in std_logic_vector(N-1 downto 0);
      D : out std_logic_vector(N-1 downto 0);
      E : out std_logic_vector(N downto 0)
      );
  end component;

  component carry_propagate8bit
    port(
      A : in std_logic_vector(7 downto 0);
      B : in std_logic_vector(7 downto 0);
      Cin : in std_logic;
      Sum : out std_logic_vector(7 downto 0);
      Cout : out std_logic
      );
  end component;

begin

  i_PP_generator : partial_prod
    port map(
      A => multiplicand,
      B => multiplier,
      PP1 => PP1(7 downto 0),
      PP2 => PP2(8 downto 1),
      PP3 => PP3(9 downto 2),
      PP4 => PP4(10 downto 3),
      PP5 => PP5(11 downto 4),
      PP6 => PP6(12 downto 5),
      PP7 => PP7(13 downto 6),
      PP8 => PP8(14 downto 7)
      );
  
  prod(0) <= PP1(0);

  interm1 <= "0" & PP1(7 downto 1);
  interm2 <= PP3(8 downto 2) & "0";
  
  i_CSA1 : carry_save1
    generic map(
      N  => 8
      )
    port map(
      A  => interm1,
      B  => PP2(8 downto 1),
      C  => interm2,
      D  => CSA11(8 downto 1),
      E  => CSA12(9 downto 1)
      );

  prod(1) <= CSA11(1);

  interm3 <= PP3(9) & CSA11(8 downto 2);
  interm4 <= PP4(9 downto 3) & "0";

  i_CSA2 : carry_save1
    generic map(
      N  => 8
      )
    port map(
      A  => interm3,
      B  => CSA12(9 downto 2),
      C  => interm4,
      D  => CSA21(9 downto 2),
      E  => CSA22(10 downto 2)
      );

  prod(2) <= CSA21(2);

  interm5 <= PP4(10) & CSA21(9 downto 3);
  interm6 <= PP5(10 downto 4) & "0";

  i_CSA3 : carry_save1
    generic map(
      N  => 8
      )
    port map(
      A  => interm5,
      B  => CSA22(10 downto 3),
      C  => interm6,
      D  => CSA31(10 downto 3),
      E  => CSA32(11 downto 3)
      );

  prod(3) <= CSA31(3);

  interm7 <= PP5(11) & CSA31(10 downto 4);
  interm8 <= PP6(11 downto 5) & "0";
  
  i_CSA4 : carry_save1
    generic map(
      N  => 8
      )
    port map(
      A  => interm7,
      B  => CSA32(11 downto 4),
      C  => interm8,
      D  => CSA41(11 downto 4),
      E  => CSA42(12 downto 4)
      );

  prod(4) <= CSA41(4);

  interm9 <= PP6(12) & CSA41(11 downto 5);
  interm10 <= PP7(12 downto 6) & "0";

  i_CSA5 : carry_save1
    generic map(
      N => 8
      )
    port map(
      A  => interm9,
      B  => CSA42(12 downto 5),
      C  => interm10,
      D  => CSA51(12 downto 5),
      E  => CSA52(13 downto 5)
      );

  prod(5) <= CSA51(5);

  interm11 <= PP7(13) & CSA51(12 downto 6);
  interm12 <= PP8(13 downto 7) & "0";

  i_CSA6 : carry_save1
    generic map(
      N  => 8
      )
    port map(
      A  => interm11,
      B  => CSA52(13 downto 6),
      C  => interm12,
      D  => CSA61(13 downto 6),
      E  => CSA62(14 downto 6)
      );

  prod(6) <= CSA61(6);

  interm13 <= PP8(14) & CSA61(13 downto 7);
  interm14 <= CSA62(14 downto 7);

  i_CPA : carry_propagate8bit
    port map(
      A  => interm13,
      B  => interm14,
      Cin => '0',
      Sum => prod(14 downto 7),
      Cout => prod(15)
      );
end architecture accumulative;

