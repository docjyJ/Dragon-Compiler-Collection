LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TestCounter IS
END TestCounter;

ARCHITECTURE Behavioral OF TestCounter IS
    COMPONENT Counter IS
        PORT (
            clk : IN STD_LOGIC;
            en : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            dir : IN STD_LOGIC;
            lod : IN STD_LOGIC;
            a : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            s : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
    END COMPONENT;

    SIGNAL sclk : STD_LOGIC;
    SIGNAL srst : STD_LOGIC;
    SIGNAL ssens : STD_LOGIC;
    SIGNAL sload : STD_LOGIC;
    SIGNAL sDin : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sDout : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sEN : STD_LOGIC;
BEGIN
    uut : Counter PORT MAP(
        clk => sclk,
        en => sEN,
        rst => srst,
        dir => ssens,
        lod => sload,
        a => sDin,
        s => sDout);

    pCLK : PROCESS
    BEGIN
        sCLK <= '0';
        WAIT FOR 5 ns;
        sCLK <= '1';
        WAIT FOR 5 ns;
    END PROCESS pCLK;
    sRST <= '0' AFTER 0 ns;
    sRST <= '1' AFTER 30 ns;

    pLOAD : PROCESS
    BEGIN
        sLOAD <= '0';
        WAIT FOR 500 ns;
        sLOAD <= '1';
        WAIT FOR 20 ns;
    END PROCESS pLOAD;

    pEN : PROCESS
    BEGIN
        sEN <= '1';
        WAIT FOR 600 ns;
        sEN <= '0';
        WAIT FOR 40 ns;
    END PROCESS pEN;

    pDI : PROCESS
    BEGIN
        sDin <= "00000000";
        WAIT FOR 500 ns;
        sDin <= "01111111";
        WAIT FOR 500 ns;
    END PROCESS pDI;

    pSens : PROCESS
    BEGIN
        ssens <= '1';
        WAIT FOR 600 ns;
        ssens <= '0';
        WAIT FOR 500 ns;
    END PROCESS pSens;

END Behavioral;