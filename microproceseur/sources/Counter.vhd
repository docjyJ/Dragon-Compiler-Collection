LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Counter IS PORT (
    clk, rst     : IN std_logic;
    en, dir, lod : IN std_logic;
    a            : IN std_logic_vector (7 DOWNTO 0);
    s            : OUT std_logic_vector (7 DOWNTO 0));
END Counter;

ARCHITECTURE Behavioral OF Counter IS
    SIGNAL mem : std_logic_vector (7 DOWNTO 0);
BEGIN
    s <= mem;
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF rst = '1' THEN
                mem <= x"00";
            ELSIF en = '1' THEN
                IF lod = '1' THEN
                    mem <= a;
                ELSIF dir = '1' THEN
                    mem <= mem - 1;
                ELSE
                    mem <= mem + 1;
                END IF;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;
