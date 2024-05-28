LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY TestInstructionMemory IS
END TestInstructionMemory;

ARCHITECTURE Behavioral OF TestInstructionMemory IS
    COMPONENT InstructionMemory IS
        PORT (
            cnt           : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            Registre1     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            Registre2     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            ALU           : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            MemoryWrite   : OUT STD_LOGIC;
            MemoryRead    : OUT STD_LOGIC;
            MemoryAddress : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            LoadPC        : OUT STD_LOGIC;
            LoadComparePC : OUT STD_LOGIC;
            Constante     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            WriteBack     : OUT STD_LOGIC;
            WriteAddress  : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));

    END COMPONENT;

    SIGNAL scnt : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL sRegistre1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sRegistre2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sALU : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL sMemoryWrite : STD_LOGIC;
    SIGNAL sMemoryRead : STD_LOGIC;
    SIGNAL sMemoryAddress : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sLoadPC : STD_LOGIC;
    SIGNAL sLoadComparePC : STD_LOGIC;
    SIGNAL sConstante : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sWriteBack : STD_LOGIC;
    SIGNAL sWriteAddress : STD_LOGIC_VECTOR (7 DOWNTO 0);
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
