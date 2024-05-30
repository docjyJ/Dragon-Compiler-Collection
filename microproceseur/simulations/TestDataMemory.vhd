LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TestDataMemory IS
END ENTITY;

ARCHITECTURE Behavioral OF TestDataMemory IS

    COMPONENT DataMemory IS PORT (
        rst, wr      : IN std_logic;
        addr, val_in : IN std_logic_vector (7 DOWNTO 0);
        val_out      : OUT std_logic_vector (7 DOWNTO 0));
    END COMPONENT;
    SIGNAL srst    : std_logic;
    SIGNAL swrite  : std_logic;
    SIGNAL sread   : std_logic;
    SIGNAL sadd    : std_logic_vector (7 DOWNTO 0);
    SIGNAL sinput  : std_logic_vector (7 DOWNTO 0);
    SIGNAL soutput : std_logic_vector (7 DOWNTO 0);

BEGIN
    uut : DataMemory PORT MAP(
        rst     => srst,
        wr      => swrite,
        addr    => sadd,
        val_in  => sinput,
        val_out => soutput);

    prst : PROCESS
    BEGIN
        srst <= '0';
        WAIT FOR 100 ns;
        sread <= '1';
        WAIT FOR 5 ns;
    END PROCESS prst;

    pread : PROCESS
    BEGIN
        sread <= '0';
        WAIT FOR 50 ns;
        sread <= '1';
        WAIT FOR 50 ns;
    END PROCESS pread;

    pwrite : PROCESS
    BEGIN
        swrite <= '1';
        WAIT FOR 51 ns;
        swrite <= '0';
        WAIT FOR 49 ns;
    END PROCESS pwrite;

    padd : PROCESS
    BEGIN
        sadd <= "00000000";
        WAIT FOR 10 ns;
        sadd <= "00000001";
        WAIT FOR 5 ns;
        sadd <= "00000010";
        WAIT FOR 5 ns;
    END PROCESS padd;

    pinput : PROCESS
    BEGIN
        sinput <= "00000100";
        WAIT FOR 5 ns;
        sinput <= "00000101";
        WAIT FOR 5 ns;
        sinput <= "00000110";
        WAIT FOR 15 ns;
    END PROCESS pinput;

END ARCHITECTURE;