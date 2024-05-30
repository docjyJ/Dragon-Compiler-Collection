LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

! DEPRECATED

ENTITY TestMasterIO IS
END TestMasterIO;

ARCHITECTURE Behavioral OF TestMasterIO IS
    COMPONENT MasterIO IS
        PORT (
            CLK  : IN std_logic;
            BTNL : IN std_logic;
            BTNR : IN std_logic;
            BTNU : IN std_logic;
            BTND : IN std_logic;
            SW   : IN std_logic_vector(15 DOWNTO 0);
            LD   : OUT std_logic_vector(15 DOWNTO 0);
            AN   : OUT std_logic_vector(3 DOWNTO 0);
            C    : OUT std_logic_vector(6 DOWNTO 0);
            DP   : OUT std_logic);
    END COMPONENT;
    SIGNAL clk : std_logic;
    SIGNAL rst : std_logic;
    SIGNAL en  : std_logic;
    SIGNAL dir : std_logic;
    SIGNAL h   : std_logic_vector(15 DOWNTO 0);
    SIGNAL s   : std_logic_vector(11 DOWNTO 0);

    SIGNAL tmp_sw : std_logic_vector(15 DOWNTO 0);
BEGIN
    tmp_sw <= (0 => en, 1 => dir, OTHERS => '0');
    uut : MasterIO PORT MAP(
        CLK  => clk,
        BTNL => '0',
        BTNR => '0',
        BTNU => rst,
        BTND => '0',
        SW   => tmp_sw,
        LD   => h(15 DOWNTO 0),
        AN   => s(3 DOWNTO 0),
        C    => s(10 DOWNTO 4),
        DP   => s(11));

    pCLK : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 5 ns;
        clk <= '1';
        WAIT FOR 5 ns;
    END PROCESS pCLK;

    en  <= '1' AFTER 27 ns;
    dir <= '0' AFTER 16 ns;

    pRST : PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR 43 ns;
        rst <= '0';
        WAIT;
    END PROCESS pRST;

END Behavioral;