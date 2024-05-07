----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/02/2024 08:32:23 AM
-- Design Name: 
-- Module Name: Test_Memoire - Behavioral
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

entity Test_Memoire is
--  Port ( );
end Test_Memoire;

architecture Behavioral of Test_Memoire is

    component Memoire is
    Port ( rst : in STD_LOGIC;
           write : in STD_LOGIC;
           read : in STD_LOGIC;
           add : in STD_LOGIC_VECTOR (7 downto 0);
           input : in STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (7 downto 0));
    end component;


    signal  srst   :    std_logic;
    signal  swrite   :    std_logic;
    signal  sread    :    std_logic;
    signal  sadd     :    STD_LOGIC_VECTOR (7 downto 0);
    signal  sinput   :    STD_LOGIC_VECTOR (7 downto 0);
    signal  soutput  :    STD_LOGIC_VECTOR (7 downto 0);
    
begin
     uut : Memoire port map(srst, swrite, sread, sadd, sinput, soutput);
     
   prst : process 
   begin
   srst<='0';
   wait for 100 ns; 
   sread<='1';
   wait for 5 ns; 
   end process prst;
   
   pread : process 
   begin
   sread<='0';
   wait for 50 ns; 
   sread<='1';
   wait for 50 ns; 
   end process pread;
   
   pwrite : process 
   begin
   swrite<='1';
   wait for 51 ns; 
   swrite<='0';
   wait for 49 ns; 
   end process pwrite;
   
   padd : process
   begin
   sadd<="00000000";
   wait for 10 ns; 
   sadd<="00000001";
   wait for 5 ns;
   sadd<="00000010";
   wait for 5 ns; 
   end process padd;
   
   pinput : process
   begin
   sinput<="00000100";
   wait for 5 ns; 
   sinput<="00000101";
   wait for 5 ns;
   sinput<="00000110";
   wait for 15 ns; 
   end process pinput;

end Behavioral;
