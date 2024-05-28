LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.conv_integer;
USE WORK.DRAGONSPY.ALL;

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
    -- synthesis translate_off
    spy_registers <= (
        0  => reg(0),
        1  => reg(1),
        2  => reg(2),
        3  => reg(3),
        4  => reg(4),
        5  => reg(5),
        6  => reg(6),
        7  => reg(7),
        8  => reg(8),
        9  => reg(9),
        10 => reg(10),
        11 => reg(11),
        12 => reg(12),
        13 => reg(13),
        14 => reg(14),
        15 => reg(15)
        );
    -- synthesis translate_on

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