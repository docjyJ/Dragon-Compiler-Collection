LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.DRAGON.ALL;

ENTITY ALU IS PORT (
    cmd        : IN std_logic_vector (3 DOWNTO 0);
    a, b       : IN std_logic_vector (7 DOWNTO 0);
    s          : OUT std_logic_vector (7 DOWNTO 0);
    z, c, o, n : OUT std_logic);
END ALU;

ARCHITECTURE Behavioral OF ALU IS
    CONSTANT MAX_UINT : integer                       := 255;
    CONSTANT MAX_INT  : integer                       := 127;
    CONSTANT MIN_INT  : integer                       := - 128;
    CONSTANT ZERROS   : std_logic_vector (9 DOWNTO 0) := (OTHERS => '0');
    CONSTANT ONES     : std_logic_vector (9 DOWNTO 0) := (OTHERS => '1');

    SIGNAL sA, sB, sS : std_logic_vector (17 DOWNTO 0);

BEGIN
    sA <= ONES & A WHEN A(7) = '1' AND (CMD = S_ADD OR CMD = S_SUB OR CMD = S_MUL) ELSE
        ZERROS & NOT(A) WHEN CMD = LOG_NOR OR CMD = LOG_EQ ELSE
        ZERROS & A;

    sB <= ONES & B WHEN B(7) = '1' AND (CMD = S_ADD OR CMD = S_SUB OR CMD = S_MUL) ELSE
        ZERROS & NOT(B) WHEN CMD = LOG_NOR ELSE
        ZERROS & B;

    WITH CMD SELECT sS <=
        sA OR sB WHEN LOG_OR,
        sA AND sB WHEN LOG_AND | LOG_NOR,
        sA XOR sB WHEN LOG_XOR | LOG_EQ,

        sA + sB WHEN U_ADD | S_ADD,
        sA - sB WHEN U_SUB | S_SUB,
        sA(8 DOWNTO 0) * sB(8 DOWNTO 0) WHEN U_MUL | S_MUL,

        sA WHEN OTHERS;

    Z <= '1' WHEN sS = 0 ELSE
        '0';

    N <= '1' WHEN sS < 0 ELSE
        '0';

    C <= '1' WHEN CMD = U_ADD AND sS > MAX_UINT ELSE
        '1' WHEN CMD = U_SUB AND sS < 0 ELSE
        '1' WHEN (CMD = S_ADD OR CMD = S_SUB) AND (sS < MIN_INT OR sS > MAX_INT) ELSE
        '0';

    O <= '1' WHEN CMD = U_MUL AND sS > MAX_UINT ELSE
        '1' WHEN CMD = S_MUL AND (sS < MIN_INT OR sS > MAX_INT) ELSE
        '0';

    S <= Ss(7 DOWNTO 0);

END Behavioral;