LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.conv_integer;

ENTITY InstructionMemory IS PORT (
    addr : IN std_logic_vector(7 DOWNTO 0);
    data : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY;

ARCHITECTURE Behavioral OF InstructionMemory IS
    TYPE mem_t IS ARRAY (0 TO 255) OF std_logic_vector(31 DOWNTO 0);

    CONSTANT mem : mem_t := (
    x"14010000", --read r1 1
    x"14020100", --read r2 2
    x"00000000", --nop
    x"00000000", --nop
    x"0C010100", --print r1 2
    x"0C020000", --print r2 1
    x"00000000", --nop
    x"07000000", --jump 0
    x"FFFFFFFF", --nop
    OTHERS => (OTHERS => '0'));

BEGIN
    data <= mem(conv_integer(addr));
END ARCHITECTURE;