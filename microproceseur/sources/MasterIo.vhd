LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MasterIO IS
    PORT (
        clk  : IN std_logic;
        btnL : IN std_logic;
        btnR : IN std_logic;
        btnU : IN std_logic;
        btnD : IN std_logic;
        btnC : IN std_logic;
        sw   : IN std_logic_vector(15 DOWNTO 0);
        led  : OUT std_logic_vector(15 DOWNTO 0);
        an   : OUT std_logic_vector(3 DOWNTO 0);
        seg  : OUT std_logic_vector(6 DOWNTO 0);
        dp   : OUT std_logic);
END MasterIO;

ARCHITECTURE Behavioral OF MasterIO IS
    COMPONENT Counter IS
        PORT (
            clk : IN std_logic;
            en  : IN std_logic;
            rst : IN std_logic;
            dir : IN std_logic;
            lod : IN std_logic;
            a   : IN std_logic_vector (7 DOWNTO 0);
            s   : OUT std_logic_vector (7 DOWNTO 0));
    END COMPONENT;

    SIGNAL clk1 : std_logic;
    SIGNAL clk2 : std_logic;
    SIGNAL en   : std_logic;
    SIGNAL rst  : std_logic;
    SIGNAL dir  : std_logic;
    SIGNAL d1   : std_logic_vector(7 DOWNTO 0);
    SIGNAL d2   : std_logic_vector(7 DOWNTO 0);
BEGIN
    an               <= "0000";
    dp               <= '0';
    seg              <= "0000000";
    rst              <= btnU;
    en               <= sw(0);
    dir              <= sw(1);
    clk1             <= clk;
    clk2             <= NOT d1(7);
    led(7 DOWNTO 0)  <= d1;
    led(15 DOWNTO 8) <= d2;

    counter0 : Counter PORT MAP(
        clk => clk1,
        en  => en,
        rst => rst,
        dir => dir,
        lod => '0',
        a   => "00000000",
        s   => d1);

    counter1 : Counter PORT MAP(
        clk => clk2,
        en  => en,
        rst => rst,
        dir => dir,
        lod => '0',
        a   => "00000000",
        s   => d2);

END Behavioral;