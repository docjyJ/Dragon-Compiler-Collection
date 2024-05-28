LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.DRAGON.ALL;

ENTITY ALU IS PORT (
    cmd        : IN std_logic_vector (3 DOWNTO 0);
    a, b       : IN std_logic_vector (7 DOWNTO 0);
    s          : OUT std_logic_vector (7 DOWNTO 0);
    z, c, o, n : OUT std_logic);
END ENTITY;

ARCHITECTURE Behavioral OF ALU IS
    CONSTANT MAX_INT  : integer := 127;
    CONSTANT MIN_INT  : integer := - 128;
    SIGNAL sA, sB, sS : signed (15 DOWNTO 0);
BEGIN
    sA <= resize(signed(A), 16);

    sB <= resize(signed(B), 16);

    WITH CMD SELECT sS <=
        sA OR sB WHEN alu_or,
        sA AND sB WHEN alu_and,
        sA XOR sB WHEN alu_xor,
        sA XNOR sB WHEN alu_eq,
        sA + sB WHEN alu_add,
        sA - sB WHEN alu_sub,
        signed(A) * signed(B) WHEN alu_mul,
        sA / sB WHEN alu_div,
        sA MOD sB WHEN alu_mod,
        sA WHEN OTHERS;

    Z <= '1' WHEN sS = 0 ELSE
        '0';

    N <= '1' WHEN sS < 0 ELSE
        '0';

    C <= '1' WHEN (CMD = alu_add OR CMD = alu_sub) AND (sS < MIN_INT OR sS > MAX_INT) ELSE
        '0';

    O <= '1' WHEN CMD = alu_mul AND (sS < MIN_INT OR sS > MAX_INT) ELSE
        '0';

    S <= std_logic_vector(resize(sS, 8));

END ARCHITECTURE;