----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2024 10:35:21 AM
-- Design Name: 
-- Module Name: MuxCompteur - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MuxCompteur is
    Port ( jmpCondIN : in STD_LOGIC;
           jmpIn : in STD_LOGIC;
           cond : in STD_LOGIC_VECTOR (7 downto 0);
           jmpOut : out STD_LOGIC);
end MuxCompteur;

architecture Behavioral of MuxCompteur is

begin

    jmpOut <= '1' when jmpIn='1' or (jmpCondIN='1' and cond = x"00");

end Behavioral;
