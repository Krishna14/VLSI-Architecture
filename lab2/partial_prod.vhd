library IEEE;
use IEEE.std_logic_1164.all;

entity partial_prod is
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
end partial_prod;

architecture RTL of partial_prod is
  type partial_prods is array(7 downto 0, 7 downto 0) of std_logic;
  signal partial_prod : partial_prods := (others => (others => '0'));
  
begin  -- RTL

  gen_partial_prod: for i in 0 to 7 generate
    gen_par_prod: for j in 0 to 7 generate
      partial_prod(i,j) <= B(i) and A(7-j);
    end generate;
  end generate;

  PP1 <= (partial_prod(0,0) & partial_prod(0,1) & partial_prod(0,2) & partial_prod(0,3) & partial_prod(0,4) & partial_prod(0,5) & partial_prod(0,6) & partial_prod(0,7));
  PP2 <= (partial_prod(1,0) & partial_prod(1,1) & partial_prod(1,2) & partial_prod(1,3) & partial_prod(1,4) & partial_prod(1,5) & partial_prod(1,6) & partial_prod(1,7));
  PP3 <= (partial_prod(2,0) & partial_prod(2,1) & partial_prod(2,2) & partial_prod(2,3) & partial_prod(2,4) & partial_prod(2,5) & partial_prod(2,6) & partial_prod(2,7));
  PP4 <= (partial_prod(3,0) & partial_prod(3,1) & partial_prod(3,2) & partial_prod(3,3) & partial_prod(3,4) & partial_prod(3,5) & partial_prod(3,6) & partial_prod(3,7));
  PP5 <= (partial_prod(4,0) & partial_prod(4,1) & partial_prod(4,2) & partial_prod(4,3) & partial_prod(4,4) & partial_prod(4,5) & partial_prod(4,6) & partial_prod(4,7));
  PP6 <= (partial_prod(5,0) & partial_prod(5,1) & partial_prod(5,2) & partial_prod(5,3) & partial_prod(5,4) & partial_prod(5,5) & partial_prod(5,6) & partial_prod(5,7));
  PP7 <= (partial_prod(6,0) & partial_prod(6,1) & partial_prod(6,2) & partial_prod(6,3) & partial_prod(6,4) & partial_prod(6,5) & partial_prod(6,6) & partial_prod(6,7));
  PP8 <= (partial_prod(7,0) & partial_prod(7,1) & partial_prod(7,2) & partial_prod(7,3) & partial_prod(7,4) & partial_prod(7,5) & partial_prod(7,6) & partial_prod(7,7));
  
end RTL;
