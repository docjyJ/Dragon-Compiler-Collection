----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/08/2024 11:19:20 AM
-- Design Name:
-- Module Name: TestCounter - Behavioral
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

entity TestCounter is
end TestCounter;

architecture Behavioral of TestCounter is
    component Counter is
        Port ( CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            LOAD : in STD_LOGIC;
            SENS : in STD_LOGIC;
            EN : in STD_LOGIC;
            DI : in STD_LOGIC_VECTOR (7 downto 0);
            DO : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    signal sCLK : STD_LOGIC;
    signal sRST : STD_LOGIC;
    signal sLOAD : STD_LOGIC;
    signal sSENS : STD_LOGIC;
    signal sEN : STD_LOGIC;
    signal sDI : STD_LOGIC_VECTOR (7 downto 0);
    signal sDO : STD_LOGIC_VECTOR (7 downto 0);
begin
    uut: Counter port map (
        CLK => sCLK,
        RST => sRST,
        LOAD => sLOAD,
        SENS => sSENS,
        EN => sEN,
        DI => sDI,
        DO => sDO
    );

    pCLK: process
    begin
        sCLK <= '1';
        wait for 5 ns;
        sCLK <= '0';
        wait for 5 ns;
    end process pCLK;

    pTest: process
    begin
        -- Initialisation
        sRST <= '0';
        sLOAD <= '0';
        sSENS <= '0';
        sEN <= '0';
        sEN <= '0';
        sDI <= "00000000";
        wait for 2 ns;
        assert(sDO = "00000000") report "Initialisation failed" severity error;
        wait for 10 ns;

        -- Démarage du compteur
        sRST <= '1';
        sEN <= '1';
        wait for 22 ns;
        assert(sDO = "00000010") report "Démarage failed 1" severity error;
        wait for 84 ns;
        assert(sDO = "00001010") report "Démarage failed 2" severity error;

        -- changement de sens
        sSENS <= '1';
        wait for 90 ns;
        assert(sDO = "00000001") report "Sens failed" severity error;

        -- Overflow
        wait for 30 ns;
        assert(sDO = "11111110") report "Overflow failed" severity error;

        -- stop
        sEN <= '0';
        wait for 20 ns;
        assert(sDO = "11111110") report "Stop failed" severity error;

        -- reset
        sRST <= '0';
        wait for 20 ns;
        assert(sDO = "00000000") report "Reset failed 1" severity error;
        sEN <= '1';
        wait for 20 ns;
        assert(sDO = "00000000") report "Reset failed 2" severity error;

        -- load
        sLOAD <= '1';
        sDI <= "10101010";
        wait for 20 ns;
        assert(sDO = "00000000") report "Load failed 1" severity error;
        sRST <= '1';
        wait for 20 ns;
        assert(sDO = "10101010") report "Load failed 2" severity error;
        sLOAD <= '0';
        wait for 20 ns;
        assert(sDO = "10101000") report "Load failed 3" severity error;

        wait for 2 ns;

    end process pTest;

end Behavioral;

