----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/10/2024 02:39:02 PM
-- Design Name:
-- Module Name: Test_Registre - Behavioral
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

entity TestRegisterBank is
--  Port ( );
end TestRegisterBank;

architecture Behavioral of TestRegisterBank is

    component RegisterBank is
    Port ( read1 : in STD_LOGIC_VECTOR (2 downto 0);
           read2 : in STD_LOGIC_VECTOR (2 downto 0);
           write : in STD_LOGIC_VECTOR (2 downto 0);
           input : in STD_LOGIC_VECTOR (7 downto 0);
           output1 : out STD_LOGIC_VECTOR (7 downto 0);
           output2 : out STD_LOGIC_VECTOR (7 downto 0));
    end component;


    signal  sread1  :    STD_LOGIC_VECTOR (2 downto 0);
    signal  sread2  :    STD_LOGIC_VECTOR (2 downto 0);
    signal  swrite  :    STD_LOGIC_VECTOR (2 downto 0);
    signal  sinput   :    STD_LOGIC_VECTOR (7 downto 0);
    signal  soutput1 :    STD_LOGIC_VECTOR (7 downto 0);
    signal  soutput2 :    STD_LOGIC_VECTOR (7 downto 0);

begin
     uut : RegisterBank port map(sread1, sread2, swrite, sinput, soutput1, soutput2);

    pwrite : process
    begin
    swrite <= "000";
    sinput <= "00000001";
    wait for 5 ns;
    swrite <= "001";
    sinput <= "00000011";
    wait for 5 ns;
    swrite <= "011";
    sinput <= "00000111";
    wait for 5 ns;
    sinput <= "00111111";
    swrite <= "010";
    sinput <= "00001111";
    wait for 50000 ns;
    end process pwrite ;


    pread1 : process
    begin
    wait for 5 ns;
    sread1 <= "001";
    wait for 25 ns;
    sread1 <= "001";
    wait for 5 ns;
    sread1 <= "011";
    wait for 5 ns;
    sread1 <= "010";
    end process pread1 ;

    pread2 : process
    begin
    wait for 5 ns;
    sread2 <= "001";
    wait for 25 ns;
    sread2 <= "001";
    wait for 5 ns;
    sread2 <= "010";
    wait for 5 ns;
    sread2 <= "011";
    end process pread2 ;

end Behavioral;

