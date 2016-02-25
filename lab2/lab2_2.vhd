library IEEE;
use IEEE.std_logic_1164.all;

entity CSA_16bit is
  port(
    A : in std_logic_vector(15 downto 0);
    B : in std_logic_vector(15 downto 0);
    Cin : in std_logic;
    Sum : out std_logic_vector(15 downto 0);
    Cout : out std_logic
    );
end entity;

architecture RTL of CSA_16bit is
  --signal declarations
  signal Sum_internal1   : std_logic_vector(15 downto 0);
  signal Sum_internal2   : std_logic_vector(15 downto 0);
  signal Group_generate  : std_logic_vector(3 downto 0);
  signal Group_propagate : std_logic_vector(3 downto 0);
  signal Carry_internal  : std_logic_vector(2 downto 0);

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

  component MUX2_1
    port(
      A : in std_logic_vector(3 downto 0);
      B : in std_logic_vector(3 downto 0);
      Sel : in std_logic;
      Y : out std_logic_vector(3 downto 0)
      );
  end component;
  
 begin
 
  i_CLA01 : CLA_4bit
    port map(
      A => A(3 downto 0),
      B => B(3 downto 0),
      Cin => Cin,
      Group_generate => Group_generate(0),
      Group_propagate => Group_propagate(0),
      Sum => Sum(3 downto 0)
      );

  Carry_internal(0) <= (Group_propagate(0) and Cin ) or (Group_generate(0));

  i_CLA11 : CLA_4bit
    port map(
      A => A(7 downto 4),
      B => B(7 downto 4),
      Cin => '0',
      Group_generate => Group_generate(1),
      Group_propagate => Group_propagate(1),
      Sum => Sum_internal1(7 downto 4)
      );

  i_CLA12 : CLA_4bit
    port map(
      A => A(7 downto 4),
      B => B(7 downto 4),
      Cin => '1',
     -- Group_generate => open,
     -- Group_propagate => open,
      Sum => Sum_internal2(7 downto 4)
      );

  Carry_internal(1) <= (Group_propagate(1) and Carry_internal(0)) or (Group_generate(1));
  
  i_CLA21 : CLA_4bit
    port map(
      A => A(11 downto 8),
      B => B(11 downto 8),
      Cin => '0',
      Group_generate => Group_generate(2),
      Group_propagate => Group_propagate(2),
      Sum => Sum_internal1(11 downto 8)
      );
                                                         
  i_CLA22 : CLA_4bit
    port map(
      A => A(11 downto 8),
      B => B(11 downto 8),
      Cin => '1',
      --Group_generate => Group_generate(2),
      --Group_propagate => Group_propagate(2),
      Sum => Sum_internal2(11 downto 8)
      );

  Carry_internal(2) <= (Group_propagate(2) and Carry_internal(1)) or (Group_generate(2));
      
  i_CLA31 : CLA_4bit
    port map(
      A => A(15 downto 12),
      B => B(15 downto 12),
      Cin => '0',
      Group_generate => Group_generate(3),
      Group_propagate => Group_propagate(3),
      Sum => Sum_internal1(15 downto 12)
      );

  i_CLA32 : CLA_4bit
    port map(
      A => A(15 downto 12),
      B => B(15 downto 12),
      Cin => '1',
      --Group_generate => Group_generate(3),
      --Group_propagate => Group_propagate(3),
      Sum => Sum_internal2(15 downto 12)
      );

  Cout <= (Group_propagate(3) and Carry_internal(2)) or (Group_generate(3));
  
  i_Sum_select1 : MUX2_1
    port map(
      A => Sum_internal1(7 downto 4),
      B => Sum_internal2(7 downto 4),
      Sel => Carry_internal(0),
      Y => Sum(7 downto 4)
      );

  i_Sum_select2 : MUX2_1
    port map(
      A => Sum_internal1(11 downto 8),
      B => Sum_internal2(11 downto 8),
      Sel => Carry_internal(1),
      Y => Sum(11 downto 8)
      );

  i_Sum_select3 : MUX2_1
    port map(
      A => Sum_internal1(15 downto 12),
      B => Sum_internal2(15 downto 12),
      Sel => Carry_internal(2),
      Y => Sum(15 downto 12)
      );
 end architecture;
  
