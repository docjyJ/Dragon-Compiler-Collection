LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.conv_integer;

ENTITY InstructionMemory IS PORT (
    addr : IN std_logic_vector(7 DOWNTO 0);
    data : OUT std_logic_vector(31 DOWNTO 0));
END ENTITY;

ARCHITECTURE Behavioral OF InstructionMemory IS
    TYPE mem_t IS ARRAY (0 TO 255) OF std_logic_vector(31 DOWNTO 0);

    CONSTANT switch_chanel : mem_t := (
    x"14010000", --read r1 1
    x"14020100", --read r2 2 
    x"0C000101", --print r1 2
    x"0C000002", --print r2 1
    x"07000000", --jump 0
    OTHERS => (OTHERS => '0'));

    CONSTANT papa_noel : mem_t := (
    x"06020200", -- 00# afc r2 2
    x"06010100", -- 01# afc r1 1
    x"06000100", -- 02# afc r0 1
    x"08020000", -- 03# jmf 2 r0 
    x"06057F00", -- 04# afc r5 7F
    x"06047F00", -- 05# afc r4 7F
    x"06037F00", -- 06# afc r3 7F
    x"03030301", -- 07# sub r3 r3 r1
    x"080A0300", -- 08# jmf A r3
    x"07070000", -- 09# jmp 7
    x"03040401", -- 0A# sub r4 r4 r1
    x"080D0400", -- 0B# jmf D r4
    x"07060000", -- 0C# jmp 6
    x"03050501", -- 0D# sub r5 r5 r1
    x"08100500", -- 0E# jmf 10 r5
    x"07050000", -- 0F# jmp 5
    x"0C000000", -- 10# print r0 1
    x"0C000100", -- 11# print r0 2
    x"02000002", -- 12# mul r0 r0 r2
    x"07030000", -- 13# jmp 3
    OTHERS => (OTHERS => '0'));
    
    CONSTANT program : mem_t := (
    x"06010200",
    x"01000001",
    x"07000400",
    x"00000000",
    x"06010100",
    x"06020000",
    x"01020200",
    x"11000102",
    x"06010000",
    x"01010100",
    x"10010001",
    x"08001D01",
    x"14010100",
    x"06020000",
    x"01020200",
    x"11000102",
    x"06010000",
    x"01010100",
    x"10010001",
    x"0C000001",
    x"14010000",
    x"06020000",
    x"01020200",
    x"11000102",
    x"06010000",
    x"01010100",
    x"10010001",
    x"0C000101",
    x"07000400",
        OTHERS => (OTHERS => '0'));


    CONSTANT mem : mem_t := switch_chanel;
BEGIN
    data <= mem(conv_integer(addr));
END ARCHITECTURE;