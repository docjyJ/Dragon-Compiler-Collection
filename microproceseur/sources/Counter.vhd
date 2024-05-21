LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY Counter IS
    PORT (
        clk : IN STD_LOGIC;
        en : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        dir : IN STD_LOGIC;
        lod : IN STD_LOGIC;
        a : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        s : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END Counter;

ARCHITECTURE Behavioral OF Counter IS
    SIGNAL mem : STD_LOGIC_VECTOR (7 DOWNTO 0);
BEGIN
    s <= mem;

    PROCESS (clk) IS
    BEGIN
        IF clk = '1' AND en = '1' THEN
            IF (rst = '1') THEN
                mem <= x"00";
            ELSIF (lod = '1') THEN
                mem <= a;
            ELSIF (dir = '1') THEN
                mem <= mem + 1;
            ELSE
                mem <= mem - 1;
            END IF;
        END IF;
    END PROCESS;
END Behavioral;