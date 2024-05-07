----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2024 11:01:25 AM
-- Design Name: 
-- Module Name: conteur8bit - Behavioral
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
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity conteur8bit is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sens : in STD_LOGIC;
           load : in STD_LOGIC;
           Din : in STD_LOGIC_VECTOR (7 downto 0);
           Dout : out STD_LOGIC_VECTOR (7 downto 0);
           EN : in STD_LOGIC);
end conteur8bit;

architecture Behavioral of conteur8bit is
    signal Mem : STD_LOGIC_VECTOR (7 downto 0);
begin
    process (clk) is
    begin
    --wait until clk'event and clk = '1'
        if (rising_edge (clk)) then 
        if EN ='1' then
            if (rst='1') then
                Mem <= x"00";
            elsif (load ='1') then
                Mem <= Din;
            elsif (sens='0') then
                Mem <=   Mem -1;
            else 
               Mem <=   Mem +1;
            end if;
            end if;
            
        end if;
    end process; 
    
    --process(clk)
    --begin
    Dout <= Mem;
    --end process ;
    
end Behavioral;
