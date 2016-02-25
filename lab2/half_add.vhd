library IEEE;
use IEEE.std_logic_1164.all;

entity half_add is
  port(
    A : in std_logic;
    B : in std_logic;
    Sum : out std_logic;
    Cout : out std_logic
    );
end entity;

architecture RTL of half_add is
begin
  Sum <= A xor B;
  Cout <= A and B;
end architecture;

