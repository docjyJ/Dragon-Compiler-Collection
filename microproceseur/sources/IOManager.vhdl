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
    SIGNAL state : std_logic_vector(1 DOWNTO 0);
    SIGNAL mode  : std_logic;
    SIGNAL clear : std_logic;
    SIGNAL digit : std_logic_vector(3 DOWNTO 0);

BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            state <= "00";
            clear <= '1';
        ELSIF rising_edge(clk) THEN
            IF clear = '1' THEN
                clear <= '0';
            ELSE
                CASE state IS
                    WHEN "00" => state <= "01";
                    WHEN "01" => state <= "10";
                    WHEN "10" => state <= "11";
                    WHEN "11" => state <= "00";
                END CASE;
                clear <= '1';
            END IF;
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

    WITH clear & state SELECT an <=
    "0111" WHEN "000",
    "1111" WHEN "001",
    "1101" WHEN "010",
    "1111" WHEN "011",
    "0000" WHEN OTHERS;

    WITH clear & digit SELECT seg <=
    "0000001" WHEN "00000",
    "1001111" WHEN "00001",
    "0010010" WHEN "00010",
    "0000110" WHEN "00011",
    "1001100" WHEN "00100",
    "0100100" WHEN "00101",
    "0100000" WHEN "00110",
    "0001111" WHEN "00111",
    "0000000" WHEN "01000",
    "0000100" WHEN "01001",
    "0000010" WHEN "01010",
    "1100000" WHEN "01011",
    "0110001" WHEN "01100",
    "1000010" WHEN "01101",
    "0110000" WHEN "01110",
    "0111000" WHEN "01111",
    "1111111" WHEN OTHERS;

    dp <= NOT (mode OR test);

END ARCHITECTURE;