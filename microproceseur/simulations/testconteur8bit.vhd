----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2024 11:20:13 AM
-- Design Name: 
-- Module Name: testconteur8bit - Behavioral
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

entity testconteur8bit is
--  Port ( );
end testconteur8bit;

architecture Behavioral of testconteur8bit is

    component conteur8bit is Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sens : in STD_LOGIC;
           load : in STD_LOGIC;
           Din : in STD_LOGIC_VECTOR (7 downto 0);
           Dout : out STD_LOGIC_VECTOR (7 downto 0);
           EN : in STD_LOGIC);
    end component;


     signal      sclk :  STD_LOGIC;
     signal      srst :  STD_LOGIC;
     signal      ssens :  STD_LOGIC;
     signal      sload :  STD_LOGIC;
     signal      sDin :  STD_LOGIC_VECTOR (7 downto 0);
     signal      sDout :  STD_LOGIC_VECTOR (7 downto 0);
     signal      sEN :  STD_LOGIC;

    
begin
    uut : conteur8bit port Map  (sclk,srst,ssens,sload,sDin,sDout,sEn);

    pCLK: process
    begin
        sCLK <= '0';
        wait for 5 ns;
        sCLK <= '1';
        wait for 5 ns;
    end process pCLK;


    sRST <= '0' after 0 ns;
    sRST <= '1' after 30 ns;

    pLOAD: process
    begin
        sLOAD <= '0';
        wait for 500 ns;
        sLOAD <= '1';
        wait for 20 ns;
    end process pLOAD;

    pEN: process
    begin
        sEN <= '1';
        wait for 600 ns;
        sEN <= '0';
        wait for 40 ns;
    end process pEN;

    pDI: process
    begin
        sDin <= "00000000";
        wait for 500 ns;
        sDin <= "01111111";
        wait for 500 ns;
    end process pDI;
    
    pSens: process
    begin
        ssens <= '1';
        wait for 600 ns;
        ssens <= '0';
        wait for 500 ns;
    end process pSens;

end Behavioral;
