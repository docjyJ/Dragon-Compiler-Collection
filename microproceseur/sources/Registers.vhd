LIBRARY ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY Registers IS PORT (
    rst            : IN std_logic;
    addr_a, addr_b : IN std_logic_vector (3 DOWNTO 0);
    val_a, val_b   : OUT std_logic_vector (7 DOWNTO 0);
    wr             : IN std_logic;
    addr_wr        : IN std_logic_vector (3 DOWNTO 0);
    val_wr         : IN std_logic_vector (7 DOWNTO 0));
END Registers;

ARCHITECTURE Behavioral OF Registers IS
    TYPE ttab IS ARRAY (0 TO 15) OF std_logic_vector (7 DOWNTO 0);
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