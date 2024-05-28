LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED."+";
USE IEEE.STD_LOGIC_UNSIGNED."-";

ENTITY Counter IS GENERIC
    (N : integer := 8);
PORT (
    clk, rst     : IN std_logic;
    en, dir, lod : IN std_logic;
    a            : IN std_logic_vector (N - 1 DOWNTO 0);
    s            : OUT std_logic_vector (N - 1 DOWNTO 0));
END ENTITY;

ARCHITECTURE Behavioral OF Counter IS
    SIGNAL mem : std_logic_vector (N - 1 DOWNTO 0);
BEGIN
    s <= mem;
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF rst = '1' THEN
                mem <= (OTHERS => '0');
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
END ARCHITECTURE;