library IEEE;
use IEEE.std_logic_1164.all;

entity MUX2_1 is
  generic(
    word_length : integer := 4
    );
  port(
    A : in std_logic_vector(word_length -1 downto 0);
    B : in std_logic_vector(word_length -1 downto 0);
    Sel : in std_logic;
    Y : out std_logic_vector(word_length -1 downto 0)
    );
end entity;

architecture behav of MUX2_1 is
begin
  process(A,B,Sel)
  begin
    case Sel is
      when '0' => Y <= A;
      when '1' => Y <= B;
      when others => Y <= (others => '0');
    end case;
  end process;
end architecture;

