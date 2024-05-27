LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY DigitalIO IS PORT (
    clk, rst, test, mode : IN std_logic;
    rd, wr               : IN std_logic_vector(15 DOWNTO 0);
    led                  : OUT std_logic_vector(15 DOWNTO 0);
    an                   : OUT std_logic_vector(3 DOWNTO 0);
    seg                  : OUT std_logic_vector(6 DOWNTO 0);
    dp                   : OUT std_logic);
END ENTITY;

ARCHITECTURE Behavioral OF DigitalIO IS
    COMPONENT Counter IS GENERIC
        (N : integer := 8);
        PORT (
            clk, rst     : IN std_logic;
            en, dir, lod : IN std_logic;
            a            : IN std_logic_vector (N - 1 DOWNTO 0);
            s            : OUT std_logic_vector (N - 1 DOWNTO 0));
    END COMPONENT;

    SIGNAL state : std_logic_vector(1 DOWNTO 0);
    SIGNAL digit : std_logic_vector(3 DOWNTO 0);
    SIGNAL clkms : std_logic;
    SIGNAL nul   : std_logic_vector(16 DOWNTO 0);

BEGIN
    clkDiviser : Counter GENERIC
    MAP (18) -- 2**18 * 10 ns => 2.62144 ms
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

    led <= x"FFFF" WHEN test = '1' ELSE
        wr;

    WITH test & mode & state SELECT digit <=
    wr(15 DOWNTO 12) WHEN "0000",
    wr(11 DOWNTO 8) WHEN "0001",
    wr(7 DOWNTO 4) WHEN "0010",
    wr(3 DOWNTO 0) WHEN "0011",
    rd(15 DOWNTO 12) WHEN "0100",
    rd(11 DOWNTO 8) WHEN "0101",
    rd(7 DOWNTO 4) WHEN "0110",
    rd(3 DOWNTO 0) WHEN "0111",
    "1000" WHEN OTHERS;

    WITH rst & state SELECT an <=
    "0111" WHEN "000",
    "1011" WHEN "001",
    "1101" WHEN "010",
    "1110" WHEN "011",
    "1111" WHEN OTHERS;

    WITH digit SELECT seg <=
        "1000000" WHEN "0000", -- 0
        "1111001" WHEN "0001", -- 1
        "0100100" WHEN "0010", -- 2
        "0110000" WHEN "0011", -- 3
        "0011001" WHEN "0100", -- 4
        "0010010" WHEN "0101", -- 5
        "0000010" WHEN "0110", -- 6
        "1111000" WHEN "0111", -- 7
        "0000000" WHEN "1000", -- 8
        "0011000" WHEN "1001", -- 9
        "0001000" WHEN "1010", -- A
        "0000011" WHEN "1011", -- B
        "1000110" WHEN "1100", -- C
        "0100001" WHEN "1101", -- D
        "0000110" WHEN "1110", -- E
        "0001110" WHEN "1111"; -- F

    dp <= NOT (mode OR test);

END ARCHITECTURE;