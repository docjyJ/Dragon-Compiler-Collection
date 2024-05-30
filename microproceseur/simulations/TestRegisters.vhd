LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TestRegisters IS
END ENTITY;

ARCHITECTURE Behavioral OF TestRegisters IS

    COMPONENT Registers IS PORT (
        rst            : IN std_logic;
        addr_a, addr_b : IN std_logic_vector (3 DOWNTO 0);
        val_a, val_b   : OUT std_logic_vector (7 DOWNTO 0);
        wr             : IN std_logic;
        addr_wr        : IN std_logic_vector (3 DOWNTO 0);
        val_wr         : IN std_logic_vector (7 DOWNTO 0));
    END COMPONENT;
    SIGNAL sread1     : std_logic_vector (3 DOWNTO 0);
    SIGNAL sread2     : std_logic_vector (3 DOWNTO 0);
    SIGNAL swrite_add : std_logic_vector (3 DOWNTO 0);
    SIGNAL swrite     : std_logic;
    SIGNAL srst       : std_logic;
    SIGNAL sinput     : std_logic_vector (7 DOWNTO 0);
    SIGNAL soutput1   : std_logic_vector (7 DOWNTO 0);
    SIGNAL soutput2   : std_logic_vector (7 DOWNTO 0);

BEGIN
    uut : Registers PORT MAP(
        rst     => srst,
        wr      => swrite,
        addr_a  => sread1,
        addr_b  => sread2,
        addr_wr => swrite_add,
        val_wr  => sinput,
        val_a   => soutput1,
        val_b   => soutput2);

    pwrite : PROCESS
    BEGIN
        srst <= '0';
        WAIT FOR 5 ns;
        swrite <= '1';
        WAIT FOR 5 ns;
        swrite <= '0';
        WAIT FOR 15 ns;
        swrite <= '1';
        WAIT FOR 5 ns;
        swrite <= '0';
        WAIT FOR 50000 ns;
    END PROCESS pwrite;

    pwrite_add : PROCESS
    BEGIN
        swrite_add <= "0000";
        sinput     <= "00000001";
        WAIT FOR 5 ns;
        swrite_add <= "0001";
        sinput     <= "00000011";
        WAIT FOR 5 ns;
        swrite_add <= "0011";
        sinput     <= "00000111";
        WAIT FOR 5 ns;
        sinput     <= "00111111";
        swrite_add <= "0010";
        sinput     <= "00001111";
        WAIT FOR 50000 ns;
    END PROCESS pwrite_add;
    pread1 : PROCESS
    BEGIN
        WAIT FOR 5 ns;
        sread1 <= "0001";
        WAIT FOR 25 ns;
        sread1 <= "0001";
        WAIT FOR 5 ns;
        sread1 <= "0011";
        WAIT FOR 5 ns;
        sread1 <= "0010";
    END PROCESS pread1;

    pread2 : PROCESS
    BEGIN
        WAIT FOR 5 ns;
        sread2 <= "0001";
        WAIT FOR 25 ns;
        sread2 <= "0001";
        WAIT FOR 5 ns;
        sread2 <= "0010";
        WAIT FOR 5 ns;
        sread2 <= "0011";
    END PROCESS pread2;

END ARCHITECTURE;