library IEEE;
use IEEE.std_logic_1164.all;

entity full_add is
  port(
    A : in std_logic;
    B : in std_logic;
    Cin : in std_logic;
    Sum : out std_logic;
    Cout : out std_logic
    );
end full_add;

architecture RTL of full_add is

begin  -- RTL

  Sum <= A xor B xor Cin;
  Cout <= (A and B) or (B and Cin) or (Cin and A);
  
end RTL;
