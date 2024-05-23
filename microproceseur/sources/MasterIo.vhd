LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MasterIO IS
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
END MasterIO;

ARCHITECTURE Behavioral OF MasterIO IS
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

    SIGNAL clk1 : STD_LOGIC;
    SIGNAL clk2 : STD_LOGIC;
    SIGNAL en : STD_LOGIC;
    SIGNAL rst : STD_LOGIC;
    SIGNAL dir : STD_LOGIC;
    SIGNAL d1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL d2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    rst <= BTNU;
    en <= SW(0);
    dir <= SW(1);
    clk1 <= CLK;
    clk2 <= NOT d1(7);
    LD(7 DOWNTO 0) <= d1;
    LD(15 DOWNTO 8) <= d2;

    counter0 : Counter PORT MAP(
        clk => clk1,
        en => en,
        rst => rst,
        dir => dir,
        lod => '0',
        a => "00000000",
        s => d1);

    counter1 : Counter PORT MAP(
        clk => clk2,
        en => en,
        rst => rst,
        dir => dir,
        lod => '0',
        a => "00000000",
        s => d2);

END Behavioral;