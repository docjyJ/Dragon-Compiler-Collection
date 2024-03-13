----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/08/2024 11:01:08 AM
-- Design Name:
-- Module Name: Counter - Behavioral
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

entity Counter is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           LOAD : in STD_LOGIC;
           SENS : in STD_LOGIC;
           EN : in STD_LOGIC;
           DI : in STD_LOGIC_VECTOR (7 downto 0);
           DO : out STD_LOGIC_VECTOR (7 downto 0));
end Counter;


-- 50 cells
-- 75 Nets

architecture Behavioral of Counter is
    signal count : unsigned(7 downto 0);
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '0' then
                count <= (others=> '0');
            elsif LOAD = '1' then
                count <= unsigned(DI);
            elsif EN = '1' then
                if SENS = '0' then
                    count <= count + 1;
                else
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;
    DO <= STD_LOGIC_VECTOR(count);
end Behavioral;

