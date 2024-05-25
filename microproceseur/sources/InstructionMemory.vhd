LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY InstructionMemory IS PORT (
    addr : IN std_logic_vector(7 DOWNTO 0);
    data : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY;

ARCHITECTURE Behavioral OF InstructionMemory IS
    TYPE mem_t IS ARRAY (0 TO 255) OF std_logic_vector(31 DOWNTO 0);

    CONSTANT mem : mem_t := (
    x"00000000",
    x"01020304",
    x"07060304",
    x"090A0309",
    x"50010105",
    OTHERS => (OTHERS => '0'));

BEGIN
    data <= mem(conv_integer(addr));
END ARCHITECTURE;
