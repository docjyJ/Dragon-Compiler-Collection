LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.conv_integer;

ENTITY InstructionMemory IS PORT (
    addr : IN std_logic_vector(7 DOWNTO 0);
    data : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY;

ARCHITECTURE Behavioral OF InstructionMemory IS
    TYPE mem_t IS ARRAY (0 TO 255) OF std_logic_vector(31 DOWNTO 0);

    -- CONSTANT mem : mem_t := (
    -- x"14010000", --read r1 1
    -- x"14020100", --read r2 2
    -- x"00000000", --nop
    -- x"00000000", --nop
    -- x"0C010100", --print r1 2
    -- x"0C020000", --print r2 1
    -- x"00000000", --nop
    -- x"07000000", --jump 0
    -- OTHERS => (OTHERS => '0'));

    CONSTANT mem : mem_t := (
    x"06020200", --00# afc r2 2
    x"06010100", --01# afc r1 1
    x"06000100", --02# afc r0 1
    x"00000000", --03# nop
    x"00000000", --04# nop
    x"08010000", --05# jmf 1 r0
    x"00000000", --06# nop
    x"00000000", --07# nop
    x"0603FF00", --09# afc r3 FF
    x"00000000", --0A# nop
    x"00000000", --0B# nop
    x"03030301", --0C# sub r3 r3 r1
    x"00000000", --0D# nop
    x"00000000", --0E# nop
    x"08100300", --0F# jmf 10 r3
    x"070B0000", --10# jmp B
    x"0C000200", --11# print r0 1
    x"0C000100", --12# print r0 2
    x"02000002", --08# mul r0 r0 r2
    x"07000000", --13# jmp 4
    OTHERS => (OTHERS => '0'));
BEGIN
    data <= mem(conv_integer(addr));
END ARCHITECTURE;