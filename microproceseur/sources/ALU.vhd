LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_signed.ALL;
USE work.Constants.ALL;

ENTITY ALU IS
    PORT (
        CMD : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        A   : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        B   : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        S   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        Z   : OUT STD_LOGIC;
        C   : OUT STD_LOGIC;
        O   : OUT STD_LOGIC;
        N   : OUT STD_LOGIC);
END ALU;

ARCHITECTURE Behavioral OF ALU IS
    CONSTANT MAX_UINT : INTEGER := 255;
    CONSTANT MAX_INT : INTEGER := 127;
    CONSTANT MIN_INT : INTEGER := - 128;
    CONSTANT ZERROS : STD_LOGIC_VECTOR (9 DOWNTO 0) := (OTHERS => '0');
    CONSTANT ONES : STD_LOGIC_VECTOR (9 DOWNTO 0) := (OTHERS => '1');

    SIGNAL sA : STD_LOGIC_VECTOR (17 DOWNTO 0);
    SIGNAL sB : STD_LOGIC_VECTOR (17 DOWNTO 0);
    SIGNAL sS : STD_LOGIC_VECTOR (17 DOWNTO 0);

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
