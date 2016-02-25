library IEEE;
use IEEE.std_logic_1164.all;

entity multiplier is
  port(
    multiplicand : in std_logic_vector(7 downto 0);
    multiplier   : in std_logic_vector(7 downto 0);
    prod         : out std_logic_vector(15 downto 0)
    );
end multiplier;

architecture RTL of multiplier is
  --Signal declarations

  --Partial products
  signal PP1 : std_logic_vector(9 downto 0) := (others => '0');
  signal PP2 : std_logic_vector(9 downto 0) := (others => '0');
  signal PP3 : std_logic_vector(9 downto 0) := (others => '0');
  signal PP4 : std_logic_vector(10 downto 0) := (others => '0');
  signal PP5 : std_logic_vector(11 downto 0) := (others => '0');
  signal PP6 : std_logic_vector(12 downto 0) := (others => '0');
  signal PP7 : std_logic_vector(13 downto 0) := (others => '0');
  signal PP8 : std_logic_vector(14 downto 0) := (others => '0');
  
  --Carry select adder signals                                          
  signal CSA11 : std_logic_vector(10 downto 0) := (others => '0');
  signal CSA12 : std_logic_vector(10 downto 0) := (others => '0');
  signal CSA21 : std_logic_vector(11 downto 0) := (others => '0');
  signal CSA22 : std_logic_vector(11 downto 0) := (others => '0');
  signal CSA31 : std_logic_vector(12 downto 0) := (others => '0');
  signal CSA32 : std_logic_vector(12 downto 0) := (others => '0');
  signal CSA41 : std_logic_vector(13 downto 0) := (others => '0');
  signal CSA42 : std_logic_vector(13 downto 0) := (others => '0');
  signal CSA51 : std_logic_vector(14 downto 0) := (others => '0');
  signal CSA52 : std_logic_vector(14 downto 0) := (others => '0');
  signal CSA61 : std_logic_vector(15 downto 0) := (others => '0');
  signal CSA62 : std_logic_vector(15 downto 0) := (others => '0');
  signal CPA1  : std_logic_vector(15 downto 0) := (others => '0');
  
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

 component carry_save is
    generic(
      N : integer := 8
      );
    port(
      A    : in std_logic_vector(N - 1 downto 0);
      B    : in std_logic_vector(N - 1 downto 0);
      C    : in std_logic_vector(N - 1 downto 0);
      D    : out std_logic_vector(N - 1 downto 0);
      E    : out std_logic_vector(N - 1 downto 0)
      );
 end component;

 component carry_propagate
    port(
      A : in std_logic_vector(15 downto 0);
      B : in std_logic_vector(15 downto 0);
      Cin : in std_logic;
      Sum : out std_logic_vector(15 downto 0);
      Cout : out std_logic
      );
 end component; 
 
begin  -- RTL
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

  i_CSA1 : carry_save
    generic map(
      N => 10
      )
    port map(
      A => PP1,
      B => PP2,
      C => PP3,
      D => CSA11(9 downto 0),
      E => CSA12(9 downto 0)
      );
  
  i_CSA2 : carry_save
    generic map(
      N => 11
      )
    port map(
      A => CSA11,
      B => CSA12,
      C => PP4,
      D => CSA21(10 downto 0),
      E => CSA22(10 downto 0)
      );
  
  i_CSA3 : carry_save
    generic map(
      N => 12
      )
    port map(
      A => CSA21,
      B => CSA22,
      C => PP5,
      D => CSA31(11 downto 0),
      E => CSA32(11 downto 0)
      );

  i_CSA4 : carry_save
    generic map(
      N => 13
      )
    port map(
      A => CSA31,
      B => CSA32,
      C => PP6,
      D => CSA41(12 downto 0),
      E => CSA42(12 downto 0)
      );

  i_CSA5 : carry_save
    generic map(
      N => 14
      )
    port map(
      A => CSA41,
      B => CSA42,
      C => PP7,
      D => CSA51(13 downto 0),
      E => CSA52(13 downto 0)
      );

  i_CSA6 : carry_save
    generic map(
      N => 15
      )
    port map(
      A => CSA51,
      B => CSA52,
      C => PP8,
      D => CSA61(14 downto 0),
      E => CSA62(14 downto 0)
      );

  i_CPA1 : carry_propagate
    port map(
      A => CSA61,
      B => CSA62,
      Cin => '0',
      Sum => CPA1,
      Cout => open
      );

  prod <= CPA1;
      
end RTL;

architecture Tree of multiplier is

  --Signal declarations
  signal PP1 : std_logic_vector(9 downto 0) := (others => '0');
  signal PP2 : std_logic_vector(9 downto 0) := (others => '0');
  signal PP3 : std_logic_vector(9 downto 0) := (others => '0');
  signal PP4 : std_logic_vector(12 downto 0) := (others => '0');
  signal PP5 : std_logic_vector(12 downto 0) := (others => '0');
  signal PP6 : std_logic_vector(12 downto 0) := (others => '0');
  signal PP7 : std_logic_vector(14 downto 0) := (others => '0');
  signal PP8 : std_logic_vector(14 downto 0) := (others => '0');

  signal CSA11 : std_logic_vector(12 downto 0) := (others => '0');
  signal CSA12 : std_logic_vector(12 downto 0) := (others => '0');
  signal CSA21 : std_logic_vector(12 downto 0) := (others => '0');
  signal CSA22 : std_logic_vector(14 downto 0) := (others => '0');
  signal CSA31 : std_logic_vector(14 downto 0) := (others => '0');
  signal CSA32 : std_logic_vector(14 downto 0) := (others => '0');
  signal CSA41 : std_logic_vector(14 downto 0) := (others => '0');
  signal CSA42 : std_logic_vector(14 downto 0) := (others => '0');
  signal CSA51 : std_logic_vector(14 downto 0) := (others => '0');
  signal CSA52 : std_logic_vector(14 downto 0) := (others => '0');
  signal CSA61 : std_logic_vector(15 downto 0) := (others => '0');
  signal CSA62 : std_logic_vector(15 downto 0) := (others => '0');
  signal CPA1  : std_logic_vector(15 downto 0) := (others => '0');
  
  --component declarations
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

 component carry_save is
    generic(
      N : integer := 8
      );
    port(
      A    : in std_logic_vector(N - 1 downto 0);
      B    : in std_logic_vector(N - 1 downto 0);
      C    : in std_logic_vector(N - 1 downto 0);
      D    : out std_logic_vector(N - 1 downto 0);
      E    : out std_logic_vector(N - 1 downto 0)
      );
 end component;

 component carry_propagate
    port(
      A : in std_logic_vector(15 downto 0);
      B : in std_logic_vector(15 downto 0);
      Cin : in std_logic;
      Sum : out std_logic_vector(15 downto 0);
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

  i_CSA1 : carry_save
    generic map(
      N => 10
      )
    port map(
      A => PP1,
      B => PP2,
      C => PP3,
      D => CSA11(9 downto 0),
      E => CSA12(9 downto 0)
      );

  i_CSA2 : carry_save
    generic map(
      N => 13
      )
    port map(
      A => PP4,
      B => PP5,
      C => PP6,
      D => CSA21(12 downto 0),
      E => CSA22(12 downto 0)
      );

  
  i_CSA3 : carry_save
    generic map(
      N => 13
      )
    port map(
      A => CSA11,
      B => CSA12,
      C => CSA21,
      D => CSA31(12 downto 0),
      E => CSA32(12 downto 0)
      );
    

  i_CSA4 : carry_save
    generic map(
      N => 15
      )
    port map(
      A => CSA22,
      B => PP7,
      C => PP8,
      D => CSA41,
      E => CSA42
      );

  i_CSA5 : carry_save
    generic map(
      N => 15
      )
    port map(
      A => CSA31,
      B => CSA32,
      C => CSA41,
      D => CSA51,
      E => CSA52
      );

  i_CSA6 : carry_save
    generic map(
      N => 15
      )
    port map(
      A => CSA42,
      B => CSA51,
      C => CSA52,
      D => CSA61(14 downto 0),
      E => CSA62(14 downto 0)
      );

  i_CPA : carry_propagate
    port map(
      A => CSA61,
      B => CSA62,
      Cin => '0',
      Sum => CPA1,
      Cout => open
      );

  prod <= CPA1;
  
  end architecture Tree;
