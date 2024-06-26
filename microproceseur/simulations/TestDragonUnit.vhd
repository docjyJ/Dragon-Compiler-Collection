LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

ENTITY TestDragonUnit IS
END ENTITY;

ARCHITECTURE Behavioral OF TestDragonUnit IS
    COMPONENT DragonUnit IS PORT (
        clk, btnL, btnR  : IN std_logic;
        btnU, btnD, btnC : IN std_logic;
        sw               : IN std_logic_vector(15 DOWNTO 0);
        led              : OUT std_logic_vector(15 DOWNTO 0);
        an               : OUT std_logic_vector(3 DOWNTO 0);
        seg              : OUT std_logic_vector(6 DOWNTO 0);
        dp               : OUT std_logic);
    END COMPONENT;

    SIGNAL clk, rst      : std_logic;
    SIGNAL input, output : std_logic_vector(15 DOWNTO 0);
BEGIN

    uut : DragonUnit PORT MAP(
        clk  => clk,
        btnL => '0',
        btnR => '0',
        btnU => rst,
        btnD => '0',
        btnC => '0',
        sw   => input,
        led  => output,
        an   => OPEN,
        seg  => OPEN,
        dp   => OPEN);

    pCLK : PROCESS
    BEGIN
        clk <= '1';
        WAIT FOR 5 ps;
        clk <= '0';
        WAIT FOR 5 ps;
    END PROCESS;

    pRST : PROCESS
    BEGIN
        rst <= '0';
        WAIT FOR 11 ns;
        rst <= '1';
        WAIT FOR 33 ns;
        rst <= '0';
        WAIT;
    END PROCESS;

    pROG : PROCESS
    BEGIN
        input <= x"0000";
        WAIT FOR 111 ns;
        ASSERT output = x"0000" REPORT "Test 1 failed" SEVERITY ERROR;

        input <= x"FFFF";
        WAIT FOR 111 ns;
        ASSERT output = x"FFFF" REPORT "Test 2 failed" SEVERITY ERROR;

        input <= x"ABCD";
        WAIT FOR 111 ns;
        ASSERT output = x"CDAB" REPORT "Test 3 failed" SEVERITY ERROR;

        input <= x"1234";
        WAIT FOR 111 ns;
        ASSERT output = x"3412" REPORT "Test 4 failed" SEVERITY ERROR;
    END PROCESS;

END ARCHITECTURE;