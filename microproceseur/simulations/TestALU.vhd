LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;

! DEPRECATED

ENTITY TestALU IS
END TestALU;

ARCHITECTURE Behavioral OF TestALU IS
    COMPONENT ALU IS
        PORT (
            CMD : IN std_logic_vector (3 DOWNTO 0);
            A   : IN std_logic_vector (7 DOWNTO 0);
            B   : IN std_logic_vector (7 DOWNTO 0);
            S   : OUT std_logic_vector (7 DOWNTO 0);
            Z   : OUT std_logic;
            C   : OUT std_logic;
            O   : OUT std_logic;
            N   : OUT std_logic
        );
    END COMPONENT;

    CONSTANT length : integer := 8;

    SIGNAL sCMD  : std_logic_vector (3 DOWNTO 0);
    SIGNAL sS    : std_logic_vector (7 DOWNTO 0);
    SIGNAL sZCON : std_logic_vector (3 DOWNTO 0);
    SIGNAL sA    : std_logic_vector (7 DOWNTO 0);
    SIGNAL sB    : std_logic_vector (7 DOWNTO 0);
    SIGNAL intA  : integer RANGE -128 TO 255;
    SIGNAL intB  : integer RANGE -128 TO 255;

    CONSTANT lOR   : std_logic_vector(3 DOWNTO 0) := "0000";
    CONSTANT lNOR  : std_logic_vector(3 DOWNTO 0) := "0001";
    CONSTANT lAND  : std_logic_vector(3 DOWNTO 0) := "0010";
    CONSTANT lNAND : std_logic_vector(3 DOWNTO 0) := "0011";
    CONSTANT lXOR  : std_logic_vector(3 DOWNTO 0) := "0100";
    CONSTANT lEQ   : std_logic_vector(3 DOWNTO 0) := "0101";
    --constant UNUSE : STD_LOGIC_VECTOR(3 downto 0) := "0110";
    --constant UNUSE : STD_LOGIC_VECTOR(3 downto 0) := "0111";
    CONSTANT uADD : std_logic_vector(3 DOWNTO 0) := "1000";
    CONSTANT uSUB : std_logic_vector(3 DOWNTO 0) := "1001";
    CONSTANT uMUL : std_logic_vector(3 DOWNTO 0) := "1010";
    --constant UNUSE : STD_LOGIC_VECTOR(3 downto 0) := "1011";
    CONSTANT sADD : std_logic_vector(3 DOWNTO 0) := "1100";
    CONSTANT sSUB : std_logic_vector(3 DOWNTO 0) := "1101";
    CONSTANT sMUL : std_logic_vector(3 DOWNTO 0) := "1110";
    --constant UNUSE : STD_LOGIC_VECTOR(3 downto 0) := "1111";
BEGIN
    sA <= conv_std_logic_vector (intA, length);
    sB <= conv_std_logic_vector (intB, length);

    uut : ALU PORT MAP(
        CMD => sCMD,
        A   => sA,
        B   => sB,
        S   => sS,
        Z   => sZCON(3),
        C   => sZCON(2),
        O   => sZCON(1),
        N   => sZCON(0)
    );

    pTest : PROCESS
    BEGIN
        intA <= 16#AA#;
        intB <= 16#F0#;

        -- OR
        sCMD <= lOR;
        WAIT FOR 5 ns;
        ASSERT (sS = 16#FA#) REPORT "OR failed: bad output" SEVERITY error;
        ASSERT (sZCON = 0) REPORT "OR failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- NOR
        sCMD <= lNOR;
        WAIT FOR 5 ns;
        ASSERT (sS = 16#05#) REPORT "NOR failed: bad output" SEVERITY error;
        ASSERT (sZCON = 0) REPORT "NOR failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- AND
        sCMD <= lAND;
        WAIT FOR 5 ns;
        ASSERT (sS = 16#A0#) REPORT "AND failed: bad output" SEVERITY error;
        ASSERT (sZCON = 0) REPORT "AND failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- NAND
        sCMD <= lNAND;
        WAIT FOR 5 ns;
        ASSERT (sS = 16#5F#) REPORT "NAND failed: bad output" SEVERITY error;
        ASSERT (sZCON = 0) REPORT "NAND failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- XOR
        sCMD <= lXOR;
        WAIT FOR 5 ns;
        ASSERT (sS = 16#5A#) REPORT "XOR failed: bad output" SEVERITY error;
        ASSERT (sZCON = 0) REPORT "XOR failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- EQ
        sCMD <= lEQ;
        WAIT FOR 5 ns;
        ASSERT (sS = 16#A5#) REPORT "EQ failed: bad output" SEVERITY error;
        ASSERT (sZCON = 0) REPORT "EQ failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- Logical Z flag
        intA <= 16#0F#;
        WAIT FOR 5 ns;
        ASSERT (sS = 0) REPORT "Logical Z flag failed: bad output" SEVERITY error;
        ASSERT (sZCON = "1000") REPORT "Logical Z flag failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- uADD (simple)
        sCMD <= uADD;
        intA <= 78;
        intB <= 96;
        WAIT FOR 5 ns;
        ASSERT (sS = 174) REPORT "uADD failed: bad output" SEVERITY error;
        ASSERT (sZCON = 0) REPORT "uADD failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- uADD (carry)
        intA <= 96;
        intB <= 174;
        WAIT FOR 5 ns;
        ASSERT (sS = 14) REPORT "uADD C failed: bad output" SEVERITY error;
        ASSERT (sZCON = "0100") REPORT "uADD C failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- uSUB (simple)
        sCMD <= uSUB;
        intA <= 174;
        intB <= 96;
        WAIT FOR 5 ns;
        ASSERT (sS = 78) REPORT "uSUB failed: bad output" SEVERITY error;
        ASSERT (sZCON = 0) REPORT "uSUB failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- uSUB (carry)
        intA <= 14;
        intB <= 96;
        WAIT FOR 5 ns;
        ASSERT (sS = 174) REPORT "uSUB C failed: bad output" SEVERITY error;
        ASSERT (sZCON = "0101") REPORT "uSUB C failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- TODO uMUL

        -- ADD (simple)
        sCMD <= sADD;
        intA <= 96;
        intB <= - 14;
        WAIT FOR 5 ns;
        ASSERT (sS = 82) REPORT "ADD failed: bad output" SEVERITY error;
        ASSERT (sZCON = 0) REPORT "ADD failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- ADD (carry up)
        intA <= 78;
        intB <= 96;
        WAIT FOR 5 ns;
        ASSERT (sS = conv_std_logic_vector (-82,
        length)) REPORT "ADD Cup failed: bad output" SEVERITY error;
        ASSERT (sZCON = "0100") REPORT "ADD Cup failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- ADD (carry down)
        intA <= - 96;
        intB <= - 78;
        WAIT FOR 5 ns;
        ASSERT (sS = 82) REPORT "ADD Cdown failed: bad output" SEVERITY error;
        ASSERT (sZCON = "0101") REPORT "ADD Cdown failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- SUB (simple)
        sCMD <= sSUB;
        intA <= - 14;
        intB <= 82;
        WAIT FOR 5 ns;
        ASSERT (sS = conv_std_logic_vector (-96,
        length)) REPORT "SUB failed: bad output" SEVERITY error;
        ASSERT (sZCON = "0001") REPORT "SUB failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- SUB (carry up)
        intA <= 96;
        intB <= - 78;
        WAIT FOR 5 ns;
        ASSERT (sS = conv_std_logic_vector (-82,
        length)) REPORT "SUB Cup failed: bad output" SEVERITY error;
        ASSERT (sZCON = "0100") REPORT "SUB Cup failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- SUB (carry down)
        intA <= - 96;
        intB <= 78;
        WAIT FOR 5 ns;
        ASSERT (sS = 82) REPORT "SUB Cdown failed: bad output" SEVERITY error;
        ASSERT (sZCON = "0101") REPORT "SUB Cdown failed: bad flag" SEVERITY error;
        WAIT FOR 5 ns;

        -- TODO MUL

    END PROCESS;
END Behavioral;