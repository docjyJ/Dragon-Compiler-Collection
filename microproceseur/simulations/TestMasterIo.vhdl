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
            AN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            C : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
            DP : OUT STD_LOGIC);
    END COMPONENT;
    SIGNAL clk : STD_LOGIC;
    SIGNAL rst : STD_LOGIC;
    SIGNAL en : STD_LOGIC;
    SIGNAL dir : STD_LOGIC;
    SIGNAL s : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL tmp_sw : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    tmp_sw <= (0 => en, 1 => dir, OTHERS => '0');
    uut : MasterIO PORT MAP(
        CLK => clk,
        BTNL => '0',
        BTNR => '0',
        BTNU => '0',
        BTND => '0',
        SW => tmp_sw,
        LD => s(15 DOWNTO 0),
        AN => s(19 DOWNTO 16),
        C => s(26 DOWNTO 20),
        DP => s(27));

    pCLK : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR 5 ns;
        clk <= '1';
        WAIT FOR 5 ns;
    END PROCESS pCLK;

    en <= '1' AFTER 27 ns;
    rst <= '1' AFTER 33 ns;
    dir <= '0' AFTER 16 ns;

END Behavioral;