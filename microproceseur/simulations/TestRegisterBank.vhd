LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TestRegisterBank IS
END TestRegisterBank;

! DEPRECATED

ARCHITECTURE Behavioral OF TestRegisterBank IS

    COMPONENT RegisterBank IS
        PORT (
            read1   : IN std_logic_vector (2 DOWNTO 0);
            read2   : IN std_logic_vector (2 DOWNTO 0);
            write   : IN std_logic_vector (2 DOWNTO 0);
            input   : IN std_logic_vector (7 DOWNTO 0);
            output1 : OUT std_logic_vector (7 DOWNTO 0);
            output2 : OUT std_logic_vector (7 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL sread1   : std_logic_vector (2 DOWNTO 0);
    SIGNAL sread2   : std_logic_vector (2 DOWNTO 0);
    SIGNAL swrite   : std_logic_vector (2 DOWNTO 0);
    SIGNAL sinput   : std_logic_vector (7 DOWNTO 0);
    SIGNAL soutput1 : std_logic_vector (7 DOWNTO 0);
    SIGNAL soutput2 : std_logic_vector (7 DOWNTO 0);

BEGIN
    uut : RegisterBank PORT MAP(sread1, sread2, swrite, sinput, soutput1, soutput2);

    pwrite : PROCESS
    BEGIN
        swrite <= "000";
        sinput <= "00000001";
        WAIT FOR 5 ns;
        swrite <= "001";
        sinput <= "00000011";
        WAIT FOR 5 ns;
        swrite <= "011";
        sinput <= "00000111";
        WAIT FOR 5 ns;
        sinput <= "00111111";
        swrite <= "010";
        sinput <= "00001111";
        WAIT FOR 50000 ns;
    END PROCESS pwrite;
    pread1 : PROCESS
    BEGIN
        WAIT FOR 5 ns;
        sread1 <= "001";
        WAIT FOR 25 ns;
        sread1 <= "001";
        WAIT FOR 5 ns;
        sread1 <= "011";
        WAIT FOR 5 ns;
        sread1 <= "010";
    END PROCESS pread1;

    pread2 : PROCESS
    BEGIN
        WAIT FOR 5 ns;
        sread2 <= "001";
        WAIT FOR 25 ns;
        sread2 <= "001";
        WAIT FOR 5 ns;
        sread2 <= "010";
        WAIT FOR 5 ns;
        sread2 <= "011";
    END PROCESS pread2;

END Behavioral;