LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TestMasterIO IS
END TestMasterIO;

ARCHITECTURE Behavioral OF TestMasterIO IS
    COMPONENT MasterIO IS
        PORT (
            CLK : IN STD_LOGIC;
            BTNL : IN STD_LOGIC;
            BTNR : IN STD_LOGIC;
            BTNU : IN STD_LOGIC;
            BTND : IN STD_LOGIC;
            SW : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            LD : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            AN : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            C : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            DP : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL clk : STD_LOGIC;
    SIGNAL rst : STD_LOGIC;
    SIGNAL en : STD_LOGIC;
    SIGNAL dir : STD_LOGIC;
    SIGNAL h : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL s : STD_LOGIC_VECTOR(11 DOWNTO 0);

    SIGNAL tmp_sw : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    tmp_sw <= (0 => en, 1 => dir, OTHERS => '0');
    uut : MasterIO PORT MAP(
        CLK => clk,
        BTNL => '0',
        BTNR => '0',
        BTNU => rst,
        BTND => '0',
        SW => tmp_sw,
        LD => h(15 DOWNTO 0),
        AN => s(3 DOWNTO 0),
        C => s(10 DOWNTO 4),
        DP => s(11));

    pCLK : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 5 ns;
        clk <= '1';
        WAIT FOR 5 ns;
    END PROCESS pCLK;

    en <= '1' AFTER 27 ns;
    dir <= '0' AFTER 16 ns;

    pRST : PROCESS
    BEGIN
        rst <= '1';
        WAIT FOR 43 ns;
        rst <= '0';
        WAIT;
    END PROCESS pRST;

END Behavioral;