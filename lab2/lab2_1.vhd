--This module defines a 4 bit Carry Lookahead adder using Dataflow style of modeling
--Author - RR Sreekrishna
--Assignment 1 for the course of VLSI Architecture
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CLA_4bit is
  port(
    A : in std_logic_vector(3 downto 0);
    B : in std_logic_vector(3 downto 0);
    Cin : in std_logic;
    Group_propagate : out std_logic;
    Group_generate  : out std_logic;
    Sum : out std_logic_vector(3 downto 0)
    );
end entity;

architecture dataflow of CLA_4bit is

  signal G : std_logic_vector(3 downto 0);
  signal P : std_logic_vector(3 downto 0);
  signal Carry_internal : std_logic_vector(3 downto 0);
begin
  Carry_internal(0) <= Cin;
  G <= A and B; --Generate signals
  P <= A xor B;  --Propagate signals
  Group_generate  <= (G(3) or (G(2) and P(3)) or (G(1) and P(2) and P(3)) or (G(0) and P(3) and P(2) and P(1)));
  Group_propagate <= (P(3) and P(2) and P(1) and P(0));

  Carry_internal(1) <= G(0) or (P(0) and Carry_internal(0));
  Carry_internal(2) <= G(1) or (P(1) and Carry_internal(1));
  Carry_internal(3) <= G(2) or (P(2) and Carry_internal(2));

  Sum(0) <= A(0) xor B(0) xor Carry_internal(0);
  Sum(1) <= A(1) xor B(1) xor Carry_internal(1);
  Sum(2) <= A(2) xor B(2) xor Carry_internal(2);
  Sum(3) <= A(3) xor B(3) xor Carry_internal(3);
end architecture;

