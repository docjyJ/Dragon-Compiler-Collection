LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.conv_integer;

ENTITY DataMemory IS PORT (
    rst, wr      : IN std_logic;
    addr, val_in : IN std_logic_vector (7 DOWNTO 0);
    val_out      : OUT std_logic_vector (7 DOWNTO 0));
END ENTITY;

ARCHITECTURE Behavioral OF DataMemory IS
    TYPE ttab IS ARRAY (255 DOWNTO 0) OF std_logic_vector (7 DOWNTO 0);
    SIGNAL mem : ttab;
BEGIN
    val_out <= mem(conv_integer(addr));

    PROCESS (wr, rst) BEGIN
        IF rst = '1' THEN
            mem <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(wr) THEN
            mem(conv_integer(addr)) <= val_in;
        END IF;
    END PROCESS;

END ARCHITECTURE;