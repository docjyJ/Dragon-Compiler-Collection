LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.conv_integer;

ENTITY IORegister IS PORT (
    rst, wr : IN std_logic;
    chanel  : IN integer RANGE 0 TO 1;
    input   : IN std_logic_vector(15 DOWNTO 0);
    output  : OUT std_logic_vector(15 DOWNTO 0);
    val_in  : IN std_logic_vector(7 DOWNTO 0);
    val_out : OUT std_logic_vector(7 DOWNTO 0));
END ENTITY;

ARCHITECTURE IORegister OF IORegister IS
    TYPE reg_type IS ARRAY (0 TO 1) OF std_logic_vector(7 DOWNTO 0);
    SIGNAL reg : reg_type;
BEGIN
    output <= reg(1) & reg(0);

    WITH chanel SELECT val_out <=
        input(7 DOWNTO 0) WHEN 0,
        input(15 DOWNTO 8) WHEN 1;

    PROCESS (rst, wr) BEGIN
        IF rst = '1' THEN
            reg <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(wr) THEN
            reg(chanel) <= val_in;
        END IF;
    END PROCESS;
END ARCHITECTURE;