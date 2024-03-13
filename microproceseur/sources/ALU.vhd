----------------------------------------------------------------------------------
-- Company:
-- Engineer:
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


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
    Port ( CMD : in STD_LOGIC_VECTOR (3 downto 0);
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           S : out STD_LOGIC_VECTOR (7 downto 0);
           Z : out STD_LOGIC;
           C : out STD_LOGIC;
           O : out STD_LOGIC;
           N : out STD_LOGIC);
end ALU;


-- 284 cells
-- 440 Nets

architecture Behavioral of ALU is

        constant MAX_UINT: integer := 255;
        constant MAX_INT: integer := 127;
        constant MIN_INT: integer := -128;
        constant ZERO: std_logic_vector(8 downto 0) := (others => '0');

        signal sS: signed(16 downto 0);


begin

    with CMD select
        sS <= signed(ZERO & (A or B)) when "0000",
              signed(ZERO & (A and B)) when "0010",
              signed(ZERO & (A xor B)) when "0100",
              signed(ZERO & (not(A or B))) when "0001",
              signed(ZERO & (not(A and B))) when "0011",
              signed(ZERO & (not(A xor B))) when "0101",

              signed(ZERO & A) + signed(ZERO & B) when "1000",
              signed(ZERO & A) - signed(ZERO & B) when "1001",
              signed((unsigned('0'&A)*unsigned(B))) when "1010",
              resize(signed(A),17) + resize(signed(B),17) when "1100",
              resize(signed(A),17) - resize(signed(B),17) when "1101",
              resize(signed(A),9) * signed(B) when "1110",
              (others => '0')            when others;

    Z <= '1' when sS = 0 else '0';

    N <= '1' when sS < 0 else '0';

    C <= '1' when CMD = "1000" and sS > MAX_UINT else
         '1' when CMD = "1001" and sS < 0 else
         '1' when CMD = "1100" and (sS < MIN_INT or sS > MAX_INT) else
         '1' when CMD = "1101" and (sS < MIN_INT or sS > MAX_INT) else
         '0';

    O <= '1' when CMD = "1010" and sS > MAX_UINT else
         '1' when CMD = "1110" and (sS < MIN_INT or sS > MAX_INT) else
         '0';

    S <= STD_LOGIC_VECTOR(Ss(7 downto 0));

end Behavioral;

