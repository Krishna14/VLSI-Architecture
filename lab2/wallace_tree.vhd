library IEEE;
use IEEE.std_logic_1164.all;

entity wallace_tree is
  port(
    multiplier : in std_logic_vector(7 downto 0);
    multiplicand : in  std_logic_vector(7 downto 0);
    prod : out std_logic_vector(15 downto 0)
    );
end entity;

architecture RTL of wallace_tree is

  --Carry select adder signals
  signal CSA11 : std_logic_vector(8  downto 1) := (others => '0');
  signal CSA12 : std_logic_vector(9  downto 1) := (others => '0');
  signal CSA21 : std_logic_vector(10 downto 3) := (others => '0');
  signal CSA22 : std_logic_vector(11 downto 3) := (others => '0');
  signal CSA31 : std_logic_vector(9  downto 2) := (others => '0');
  signal CSA32 : std_logic_vector(10 downto 2) := (others => '0');
  signal CSA41 : std_logic_vector(11 downto 3) := (others => '0');
  signal CSA42 : std_logic_vector(12 downto 3) := (others => '0');
  signal CSA51 : std_logic_vector(12 downto 4) := (others => '0');
  signal CSA52 : std_logic_vector(13 downto 4) := (others => '0');
  signal CSA61 : std_logic_vector(14 downto 5) := (others => '0');
  signal CSA62 : std_logic_vector(15 downto 5) := (others => '0');
  
  --Partial Products
  signal PP1   : std_logic_vector(7 downto 0)  := (others => '0');
  signal PP2   : std_logic_vector(8 downto 1)  := (others => '0');
  signal PP3   : std_logic_vector(9 downto 2)  := (others => '0');
  signal PP4   : std_logic_vector(10 downto 3)  := (others => '0');
  signal PP5   : std_logic_vector(11 downto 4)  := (others => '0');
  signal PP6   : std_logic_vector(12 downto 5)  := (others => '0');
  signal PP7   : std_logic_vector(13 downto 6)  := (others => '0');
  signal PP8   : std_logic_vector(14 downto 7)  := (others => '0');

  signal interm1  : std_logic_vector(8  downto 1) := (others => '0');
  signal interm2  : std_logic_vector(8  downto 1) := (others => '0');
  signal interm3  : std_logic_vector(10 downto 3) := (others => '0');
  signal interm4  : std_logic_vector(10 downto 3) := (others => '0');
  signal interm5  : std_logic_vector(9  downto 2) := (others => '0');
  signal interm6  : std_logic_vector(9  downto 2) := (others => '0');
  signal interm7  : std_logic_vector(11 downto 3) := (others => '0');
  signal interm8  : std_logic_vector(11 downto 3) := (others => '0');
  signal interm9  : std_logic_vector(11 downto 3) := (others => '0');
  signal interm10 : std_logic_vector(12 downto 4) := (others => '0');
  signal interm11 : std_logic_vector(12 downto 4) := (others => '0');
  signal interm12 : std_logic_vector(14 downto 5) := (others => '0');
  signal interm13 : std_logic_vector(14 downto 5) := (others => '0');
  signal interm14 : std_logic_vector(14 downto 5) := (others => '0');
  signal interm15 : std_logic_vector(15 downto 6) := (others => '0');
  
 -- signal CPA   : std_logic_vector(15 downto 0) := (others => '0');

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

  component carry_save1 is
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
  end component;

  
  component carry_propagate10bit is
   port(
        A    : in std_logic_vector(9 downto 0);
        B    : in std_logic_vector(9 downto 0);
        Cin  : in std_logic;
        Sum  : out std_logic_vector(9 downto 0);
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

  prod(0) <= PP1(0);    --Product(0)

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

  prod(1) <= CSA11(1);  --Product(1)

  interm3 <= PP5(10 downto 4) & "0";
  interm4 <= PP6(10 downto 5) & "00";
  
  i_CSA2 : carry_save1
    generic map(
      N  => 8
      )
    port map(
      A  => PP4(10 downto 3),
      B  => interm3,
      C  => interm4,
      D  => CSA21(10 downto 3),
      E  => CSA22(11 downto 3)
      );

  interm5 <= PP3(9) & CSA11(8 downto 2);
  interm6 <= CSA21(9 downto 3) & "0";
  
  i_CSA3 : carry_save1
    generic map(
      N  => 8
      )
    port map(
      A  => interm5,
      B  => CSA12(9 downto 2),
      C  => interm6,
      D  => CSA31(9 downto 2),
      E  => CSA32(10 downto 2)
      );

  prod(2) <= CSA31(2);
  
  interm7 <= PP5(11) & CSA21(10)  & CSA31(9 downto 3);  --11 downto 3
  interm8 <= PP6(11) & CSA32(10 downto 3);
  interm9 <= CSA22(11 downto 4) & "0";
  
  i_CSA4 : carry_save1
    generic map(
      N  => 9
      )
    port map(
      A  => interm7,
      B  => interm8,
      C  => interm9,
      D  => CSA41(11 downto 3),                 
      E  => CSA42(12 downto 3)
      );

  prod(3) <= CSA41(3);

  interm10 <= PP6(12) & CSA41(11 downto 4);     --12 downto 4
  --interm11 <= CSA42(12 downto 4);
  interm11 <= PP7(12 downto 6) & "00";
  
  i_CSA5 : carry_save1
    generic map(
      N  => 9
      )
    port map(
      A  => interm10,
      B  => CSA42(12 downto 4),
      C  => interm11,
      D  => CSA51(12 downto 4),
      E  => CSA52(13 downto 4)
      );

  prod(4) <= CSA51(4);

  interm12 <= "0" & PP7(13) & CSA51(12 downto 5);        --14 downto 5
  interm13 <= "0" & CSA52(13 downto 5);
  interm14 <= PP8(14 downto 7) & "00";
  
  i_CSA6 : carry_save1
    generic map(
      N  => 10
      )
    port map(
      A  => interm12,
      B  => interm13,
      C  => interm14,
      D  => CSA61(14 downto 5),
      E  => CSA62(15 downto 5)
      );

  prod(5) <= CSA61(5);

  interm15 <= "0" & CSA61(14 downto 6);
  
  i_CPA : carry_propagate10bit
    port map(
      A  => interm15,
      B  => CSA62(15 downto 6),
      Cin => '0',
      Sum => prod(15 downto 6),
      Cout => open
      );
    
end architecture;

          
  
