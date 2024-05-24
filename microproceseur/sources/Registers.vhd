LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY Registers IS
    PORT (
        rst            : IN STD_LOGIC;
        addr_a, addr_b : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        val_a, val_b   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        wr             : IN STD_LOGIC;
        addr_wr        : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        val_wr         : IN STD_LOGIC_VECTOR (7 DOWNTO 0));
END Registers;

ARCHITECTURE Behavioral OF Registers IS
    TYPE ttab IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL reg : ttab;
BEGIN
    val_a <= reg(conv_integer(addr_a));
    val_b <= reg(conv_integer(addr_b));

    PROCESS (wr, rst)
    BEGIN
        IF rst = '1' THEN
            reg <= (OTHERS => (OTHERS => '0'));
        ELSIF wr = '1' THEN
            reg(conv_integer(addr_wr)) <= val_wr;
        END IF;
    END PROCESS;

END Behavioral;
