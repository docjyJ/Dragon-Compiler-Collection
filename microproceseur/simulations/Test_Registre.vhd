----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/10/2024 02:39:02 PM
-- Design Name: 
-- Module Name: Test_Registre - Behavior al
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

entity Test_Registre is
--  Port ( );
end Test_Registre;

architecture Behavioral of Test_Registre is

    component Registre is
    Port ( read1 : in STD_LOGIC_VECTOR (3 downto 0);
           read2 : in STD_LOGIC_VECTOR (3 downto 0);
           write_add : in STD_LOGIC_VECTOR (3 downto 0);
           write : in STD_LOGIC;
           rst : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (7 downto 0);
           output1 : out STD_LOGIC_VECTOR (7 downto 0);
           output2 : out STD_LOGIC_VECTOR (7 downto 0));
    end component;


    signal  sread1  :    STD_LOGIC_VECTOR (3 downto 0);
    signal  sread2  :    STD_LOGIC_VECTOR (3 downto 0);
    signal  swrite_add  :    STD_LOGIC_VECTOR (3 downto 0);
        signal  swrite   :    std_logic;
        signal  srst   :    std_logic;

    signal  sinput   :    STD_LOGIC_VECTOR (7 downto 0);
    signal  soutput1 :    STD_LOGIC_VECTOR (7 downto 0);
    signal  soutput2 :    STD_LOGIC_VECTOR (7 downto 0);
    
begin
     uut : Registre port map(sread1, sread2, swrite_add, swrite,srst, sinput, soutput1, soutput2);
     
    pwrite : process
    begin
    srst <='0';
    wait for 5 ns;
    swrite <='1';
    wait for 5 ns;
    swrite <='0';
    wait for 15 ns;
    swrite <='1';
    wait for 5 ns;
    swrite <='0';
    wait for 50000 ns;
    end process pwrite ; 
     
    pwrite_add : process
    begin
    swrite_add <= "0000";
    sinput <= "00000001";
    wait for 5 ns;
    swrite_add <= "0001";
    sinput <= "00000011";
    wait for 5 ns;
    swrite_add <= "0011";
    sinput <= "00000111";
    wait for 5 ns;
    sinput <= "00111111";
    swrite_add <= "0010";
    sinput <= "00001111";
    wait for 50000 ns;
    end process pwrite_add ;
    
    
    pread1 : process
    begin
    wait for 5 ns;
    sread1 <= "0001";
    wait for 25 ns;
    sread1 <= "0001";
    wait for 5 ns;
    sread1 <= "0011";
    wait for 5 ns;
    sread1 <= "0010";
    end process pread1 ;
    
    pread2 : process
    begin
    wait for 5 ns;
    sread2 <= "0001";
    wait for 25 ns;
    sread2 <= "0001";
    wait for 5 ns;
    sread2 <= "0010";
    wait for 5 ns;
    sread2 <= "0011";
    end process pread2 ;

end Behavioral;
