LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

! DEPRECATED

ENTITY TestInstructionMemory IS
END TestInstructionMemory;

ARCHITECTURE Behavioral OF TestInstructionMemory IS
    COMPONENT InstructionMemory IS
        PORT (
            cnt           : IN std_logic_vector (31 DOWNTO 0);
            Registre1     : OUT std_logic_vector (7 DOWNTO 0);
            Registre2     : OUT std_logic_vector (7 DOWNTO 0);
            ALU           : OUT std_logic_vector (3 DOWNTO 0);
            MemoryWrite   : OUT std_logic;
            MemoryRead    : OUT std_logic;
            MemoryAddress : OUT std_logic_vector (7 DOWNTO 0);
            LoadPC        : OUT std_logic;
            LoadComparePC : OUT std_logic;
            Constante     : OUT std_logic_vector (7 DOWNTO 0);
            WriteBack     : OUT std_logic;
            WriteAddress  : OUT std_logic_vector (7 DOWNTO 0));

    END COMPONENT;

    SIGNAL scnt           : std_logic_vector (31 DOWNTO 0);
    SIGNAL sRegistre1     : std_logic_vector (7 DOWNTO 0);
    SIGNAL sRegistre2     : std_logic_vector (7 DOWNTO 0);
    SIGNAL sALU           : std_logic_vector (3 DOWNTO 0);
    SIGNAL sMemoryWrite   : std_logic;
    SIGNAL sMemoryRead    : std_logic;
    SIGNAL sMemoryAddress : std_logic_vector (7 DOWNTO 0);
    SIGNAL sLoadPC        : std_logic;
    SIGNAL sLoadComparePC : std_logic;
    SIGNAL sConstante     : std_logic_vector (7 DOWNTO 0);
    SIGNAL sWriteBack     : std_logic;
    SIGNAL sWriteAddress  : std_logic_vector (7 DOWNTO 0);
BEGIN

    uut : InstructionMemory PORT MAP(
        cnt           => scnt,
        Registre1     => sRegistre1,
        Registre2     => sRegistre2,
        ALU           => sALU,
        MemoryWrite   => sMemoryWrite,
        MemoryRead    => sMemoryRead,
        MemoryAddress => sMemoryAddress,
        LoadPC        => sLoadPC,
        LoadComparePC => sLoadComparePC,
        Constante     => sConstante,
        WriteBack     => sWriteBack,
        WriteAddress  => sWriteAddress
    );

    test : PROCESS
    BEGIN
        scnt <= x"01020302";
        WAIT FOR 5ns;

        scnt <= x"07050300";
        WAIT FOR 5ns;

        scnt <= x"0C050000";
        WAIT FOR 5ns;

        scnt <= x"10020300";
        WAIT FOR 5ns;
    END PROCESS;

END Behavioral;