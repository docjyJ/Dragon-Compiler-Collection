LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;
USE WORK.DRAGONSPY.ALL;

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
    -- synthesis translate_off
    SIGNAL jump, aller                : std_logic;
    SIGNAL pipe1, pipe2, pipe3, pipe4 : pipe_line;
    SIGNAL pc, jump_addr              : std_logic_vector(7 DOWNTO 0);
    SIGNAL registers                  : ttab;
    -- synthesis translate_on
BEGIN
    -- synthesis translate_off
    pipe1     <= spy_pipe1;
    pipe2     <= spy_pipe2;
    pipe3     <= spy_pipe3;
    pipe4     <= spy_pipe4;
    pc        <= spy_pc;
    jump      <= spy_jump;
    jump_addr <= spy_jump_addr;
    registers <= spy_registers;
    aller     <= spy_aller;
    -- synthesis translate_on

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