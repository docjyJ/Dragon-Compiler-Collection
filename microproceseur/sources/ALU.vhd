-- 
-- Create Date: 03/04/2024 08:38:17 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;


entity ALU is
    Port ( CMD : in std_logic_vector (3 downto 0);
           A : in std_logic_vector (7 downto 0);
           B : in std_logic_vector (7 downto 0);
           S : out std_logic_vector (7 downto 0);
           Z : out STD_LOGIC;
           C : out STD_LOGIC;
           O : out STD_LOGIC;
           N : out STD_LOGIC);
end ALU;


-- 284 cells
-- 440 Nets

architecture Behavioral of ALU is
    constant LOG_OR: std_logic_vector (3 downto 0) := "0000";
    constant LOG_NOR: std_logic_vector (3 downto 0) := "0001";
    constant LOG_AND: std_logic_vector (3 downto 0) := "0010";
    constant LOG_NAND: std_logic_vector (3 downto 0) := "0011";
    constant LOG_XOR: std_logic_vector (3 downto 0) := "0100";
    constant LOG_EQ: std_logic_vector (3 downto 0) := "0101";
    -- constant UNUSED: std_logic_vector (3 downto 0) := "0110";
    -- constant UNUSED: std_logic_vector (3 downto 0) := "0111";
    constant U_ADD: std_logic_vector (3 downto 0) := "1000";
    constant U_SUB: std_logic_vector (3 downto 0) := "1001";
    constant U_MUL: std_logic_vector (3 downto 0) := "1010";
    -- constant UNUSED: std_logic_vector (3 downto 0) := "1011";
    constant S_ADD: std_logic_vector (3 downto 0) := "1100";
    constant S_SUB: std_logic_vector (3 downto 0) := "1101";
    constant S_MUL: std_logic_vector (3 downto 0) := "1110";
    -- constant UNUSED: std_logic_vector (3 downto 0) := "1111";

    constant MAX_UINT: integer := 255;
    constant MAX_INT: integer := 127;
    constant MIN_INT: integer := -128;
    constant ZERROS: std_logic_vector (9 downto 0) := (others => '0');
    constant ONES: std_logic_vector (9 downto 0) := (others => '1');

    signal sA: std_logic_vector (17 downto 0);
    signal sB: std_logic_vector (17 downto 0);
    signal sS: std_logic_vector (17 downto 0);

begin
    sB <= ONES & A when A(7) = '1' and (CMD = S_ADD or CMD = S_SUB or CMD = S_MUL) else
          ZERROS & not(A) when CMD = LOG_NAND or CMD = LOG_NOR or CMD = LOG_EQ else
          ZERROS & A;
    
    sB <= ONES & B when B(7) = '1' and (CMD = S_ADD or CMD = S_SUB or CMD = S_MUL) else
          ZERROS & not(B) when CMD = LOG_NAND or CMD = LOG_NOR else
          ZERROS & B;
    
    with CMD select
        sS <= sA or sB when LOG_OR | LOG_NAND,
              sA and sB when LOG_AND | LOG_NOR,
              sA xor sB when LOG_XOR | LOG_EQ,

              sA + sB when U_ADD | S_ADD,
              sA - sB when U_SUB | S_SUB,
              sA(8 downto 0) * sB(8 downto 0) when U_MUL | S_MUL,
              
              A when others;
    
    Z <= '1' when sS = 0 else '0';
    
    N <= '1' when sS < 0 else '0';
    
    C <= '1' when CMD = U_ADD and sS > MAX_UINT else
         '1' when CMD = U_SUB and sS < 0 else
         '1' when (CMD = S_ADD or CMD = S_SUB) and (sS < MIN_INT or sS > MAX_INT) else
         '0';
    
    O <= '1' when CMD = U_MUL and sS > MAX_UINT else
         '1' when CMD = S_MUL and (sS < MIN_INT or sS > MAX_INT) else
         '0';
     
    S <= Ss(7 downto 0);

end Behavioral;

