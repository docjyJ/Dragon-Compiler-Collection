LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.conv_integer;

ENTITY Registers IS PORT (
    rst            : IN std_logic;
    addr_a, addr_b : IN std_logic_vector (3 DOWNTO 0);
    val_a, val_b   : OUT std_logic_vector (7 DOWNTO 0);
    wr             : IN std_logic;
    addr_wr        : IN std_logic_vector (3 DOWNTO 0);
    val_wr         : IN std_logic_vector (7 DOWNTO 0));
END ENTITY;

ARCHITECTURE Behavioral OF Registers IS
    TYPE ttab IS ARRAY (0 TO 15) OF std_logic_vector (7 DOWNTO 0);
    SIGNAL reg    : ttab;
    SIGNAL in_tmp : std_logic_vector(7 DOWNTO 0);
BEGIN

    val_a  <= reg(conv_integer(addr_a));
    val_b  <= reg(conv_integer(addr_b));
    in_tmp <= val_wr;

    PROCESS (wr, rst) BEGIN
        IF rst = '1' THEN
            reg <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(wr) THEN
            reg(conv_integer(addr_wr)) <= in_tmp;
        END IF;
    END PROCESS;

END ARCHITECTURE;