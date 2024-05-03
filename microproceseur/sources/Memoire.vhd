----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2024 08:11:10 AM
-- Design Name: 
-- Module Name: Memoire - Behavioral
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


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memoire is
    Port ( add : in STD_LOGIC_VECTOR (7 downto 0);
           write : in STD_LOGIC;
           read : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (7 downto 0));
end Memoire;

architecture Behavioral of Memoire is
    type ttab is array (255 downto 0) of std_logic_vector (7 downto 0);
    signal mem_var : ttab;
begin

    process (write,read,add)
    begin
        if (read='1') then
            output<= mem_var(to_integer(unsigned(add)));
        elsif (write='1') then
            mem_var(to_integer(unsigned(add))) <= input;
        end if;
    end process;

end Behavioral;
