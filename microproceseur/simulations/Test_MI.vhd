----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2024 08:20:35 AM
-- Design Name: 
-- Module Name: Test_MI - Behavioral
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

entity Test_MI is
--  Port ( );
end Test_MI;

architecture Behavioral of Test_MI is
    component  MI is
    Port ( cnt : in STD_LOGIC_VECTOR (31 downto 0);
           Registre1 : out STD_LOGIC_VECTOR (7 downto 0);
           Registre2 :out STD_LOGIC_VECTOR (7 downto 0); 
           ALU : out STD_LOGIC_VECTOR (3 downto 0);
           MemoryWrite : out STD_LOGIC;
           MemoryRead : out STD_LOGIC;
           MemoryAddress : out STD_LOGIC_VECTOR (7 downto 0);                      
           LoadPC : out STD_LOGIC;
           LoadComparePC : out STD_LOGIC;
           Constante : out STD_LOGIC_VECTOR (7 downto 0); 
           WriteBack : out STD_LOGIC;
           WriteAddress : out STD_LOGIC_VECTOR (7 downto 0));

    end component ;

signal scnt :  STD_LOGIC_VECTOR (31 downto 0);
signal sRegistre1 : STD_LOGIC_VECTOR (7 downto 0);
signal sRegistre2 : STD_LOGIC_VECTOR (7 downto 0); 
signal sALU :  STD_LOGIC_VECTOR (3 downto 0);
signal sMemoryWrite :  STD_LOGIC;
signal sMemoryRead :  STD_LOGIC;
signal sMemoryAddress :  STD_LOGIC_VECTOR (7 downto 0);                      
signal sLoadPC :  STD_LOGIC;
signal sLoadComparePC :  STD_LOGIC;
signal sConstante :  STD_LOGIC_VECTOR (7 downto 0); 
signal sWriteBack :  STD_LOGIC;
signal sWriteAddress :  STD_LOGIC_VECTOR (7 downto 0);


begin

 uut: Mi port map (
        cnt => scnt,
        Registre1 => sRegistre1,
        Registre2 => sRegistre2,
        ALU => sALU,
        MemoryWrite => sMemoryWrite,
        MemoryRead => sMemoryRead,
        MemoryAddress => sMemoryAddress,
        LoadPC => sLoadPC,
        LoadComparePC => sLoadComparePC,
        Constante => sConstante,
        WriteBack => sWriteBack,
        WriteAddress => sWriteAddress
    );

    test : process
    begin
        scnt <= x"01020302";
        wait for 5ns;
        
        scnt <= x"07050300";
        wait for 5ns;
        
        scnt <= x"0C050000";
        wait for 5ns;
        
        scnt <= x"10020300";
        wait for 5ns;
    end process;

end Behavioral;
