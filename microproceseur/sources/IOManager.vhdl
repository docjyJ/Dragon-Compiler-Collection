LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY IOManager IS PORT (
    clk, rst, test : IN std_logic;
    rd, wr         : IN std_logic_vector(15 DOWNTO 0);
    led            : OUT std_logic_vector(15 DOWNTO 0);
    an             : OUT std_logic_vector(3 DOWNTO 0);
    seg            : OUT std_logic_vector(6 DOWNTO 0);
    dp             : OUT std_logic);
END ENTITY;

ARCHITECTURE Behavioral OF IOManager IS
    COMPONENT Counter IS GENERIC
        (N : integer := 8);
        PORT (
            clk, rst     : IN std_logic;
            en, dir, lod : IN std_logic;
            a            : IN std_logic_vector (N - 1 DOWNTO 0);
            s            : OUT std_logic_vector (N - 1 DOWNTO 0));
    END COMPONENT;

    SIGNAL state : std_logic_vector(1 DOWNTO 0);
    SIGNAL mode  : std_logic;
    SIGNAL digit : std_logic_vector(3 DOWNTO 0);
    SIGNAL clkms : std_logic;
    SIGNAL nul   : std_logic_vector(16 DOWNTO 0);

BEGIN
    Counter0 : Counter GENERIC
    MAP (18)
    PORT MAP(
        clk            => clk,
        rst            => rst,
        en             => '1',
        dir            => '0',
        lod            => '0',
        a => (OTHERS => '0'),
        s(16 DOWNTO 0) => nul,
        s(17)          => clkms);

    PROCESS (clkms, rst)
    BEGIN
        IF rst = '1' THEN
            state <= "00";
        ELSIF rising_edge(clkms) THEN
            CASE state IS
                WHEN "00" => state <= "01";
                WHEN "01" => state <= "10";
                WHEN "10" => state <= "11";
                WHEN "11" => state <= "00";
            END CASE;
        END IF;
    END PROCESS;

    mode <= '1';

    led <= x"FFFF" WHEN test = '1' ELSE
        wr;

    WITH test & mode & state SELECT digit <=
    wr(3 DOWNTO 0) WHEN "0000",
    wr(7 DOWNTO 4) WHEN "0001",
    wr(11 DOWNTO 8) WHEN "0010",
    wr(15 DOWNTO 12) WHEN "0011",
    rd(3 DOWNTO 0) WHEN "0100",
    rd(7 DOWNTO 4) WHEN "0101",
    rd(11 DOWNTO 8) WHEN "0110",
    rd(15 DOWNTO 12) WHEN "0111",
    "1000" WHEN OTHERS;

    WITH state SELECT an <=
        "0111" WHEN "00",
        "1011" WHEN "01",
        "1101" WHEN "10",
        "1110" WHEN "11";

    WITH digit SELECT seg <=
        "0000001" WHEN "0000",
        "1001111" WHEN "0001",
        "0010010" WHEN "0010",
        "0000110" WHEN "0011",
        "1001100" WHEN "0100",
        "0100100" WHEN "0101",
        "0100000" WHEN "0110",
        "0001111" WHEN "0111",
        "0000000" WHEN "1000",
        "0000100" WHEN "1001",
        "0000010" WHEN "1010",
        "1100000" WHEN "1011",
        "0110001" WHEN "1100",
        "1000010" WHEN "1101",
        "0110000" WHEN "1110",
        "0111000" WHEN "1111";

    dp <= NOT (mode OR test);

END ARCHITECTURE;