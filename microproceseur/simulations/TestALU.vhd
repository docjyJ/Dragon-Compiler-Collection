library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity TestALU is
end TestALU;

architecture Behavioral of TestALU is
    component ALU is
        Port (
            CMD: in STD_LOGIC_VECTOR (3 downto 0);
            A: in STD_LOGIC_VECTOR (7 downto 0);
            B: in STD_LOGIC_VECTOR (7 downto 0);
            S: out STD_LOGIC_VECTOR (7 downto 0);
            Z: out STD_LOGIC;
            C: out STD_LOGIC;
            O: out STD_LOGIC;
            N: out STD_LOGIC
        );
    end component;

    constant length: integer := 8;

    signal sCMD: STD_LOGIC_VECTOR (3 downto 0);
    signal sS: STD_LOGIC_VECTOR (7 downto 0);
    signal sZCON: STD_LOGIC_VECTOR (3 downto 0);
    signal sA: STD_LOGIC_VECTOR (7 downto 0);
    signal sB: STD_LOGIC_VECTOR (7 downto 0);
    signal intA: integer range -128 to 255;
    signal intB: integer range -128 to 255;

    constant lOR: STD_LOGIC_VECTOR(3 downto 0) := "0000";
    constant lNOR: STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant lAND: STD_LOGIC_VECTOR(3 downto 0) := "0010";
    constant lNAND: STD_LOGIC_VECTOR(3 downto 0) := "0011";
    constant lXOR: STD_LOGIC_VECTOR(3 downto 0) := "0100";
    constant lEQ: STD_LOGIC_VECTOR(3 downto 0) := "0101";
    --constant UNUSE : STD_LOGIC_VECTOR(3 downto 0) := "0110";
    --constant UNUSE : STD_LOGIC_VECTOR(3 downto 0) := "0111";
    constant uADD: STD_LOGIC_VECTOR(3 downto 0) := "1000";
    constant uSUB: STD_LOGIC_VECTOR(3 downto 0) := "1001";
    constant uMUL: STD_LOGIC_VECTOR(3 downto 0) := "1010";
    --constant UNUSE : STD_LOGIC_VECTOR(3 downto 0) := "1011";
    constant sADD: STD_LOGIC_VECTOR(3 downto 0) := "1100";
    constant sSUB: STD_LOGIC_VECTOR(3 downto 0) := "1101";
    constant sMUL: STD_LOGIC_VECTOR(3 downto 0) := "1110";
    --constant UNUSE : STD_LOGIC_VECTOR(3 downto 0) := "1111";
begin
    sA <= conv_std_logic_vector (intA, length);
    sB <= conv_std_logic_vector (intB, length);

    uut: ALU port map (
        CMD => sCMD,
        A => sA,
        B => sB,
        S => sS,
        Z => sZCON(3),
        C => sZCON(2),
        O => sZCON(1),
        N => sZCON(0)
    );

    pTest: process
    begin
        intA <= 16#AA#;
        intB <= 16#F0#;

        -- OR
        sCMD <= lOR;
        wait for 5 ns;
        assert (sS = 16#FA#) report "OR failed: bad output" severity error;
        assert (sZCON = 0) report "OR failed: bad flag" severity error;
        wait for 5 ns;

        -- NOR
        sCMD <= lNOR;
        wait for 5 ns;
        assert (sS = 16#05#) report "NOR failed: bad output" severity error;
        assert (sZCON = 0) report "NOR failed: bad flag" severity error;
        wait for 5 ns;

        -- AND
        sCMD <= lAND;
        wait for 5 ns;
        assert (sS = 16#A0#) report "AND failed: bad output" severity error;
        assert (sZCON = 0) report "AND failed: bad flag" severity error;
        wait for 5 ns;

        -- NAND
        sCMD <= lNAND;
        wait for 5 ns;
        assert (sS = 16#5F#) report "NAND failed: bad output" severity error;
        assert (sZCON = 0) report "NAND failed: bad flag" severity error;
        wait for 5 ns;

        -- XOR
        sCMD <= lXOR;
        wait for 5 ns;
        assert (sS = 16#5A#) report "XOR failed: bad output" severity error;
        assert (sZCON = 0) report "XOR failed: bad flag" severity error;
        wait for 5 ns;

        -- EQ
        sCMD <= lEQ;
        wait for 5 ns;
        assert (sS = 16#A5#) report "EQ failed: bad output" severity error;
        assert (sZCON = 0) report "EQ failed: bad flag" severity error;
        wait for 5 ns;

        -- Logical Z flag
        intA <= 16#0F#;
        wait for 5 ns;
        assert (sS = 0) report "Logical Z flag failed: bad output" severity error;
        assert (sZCON = "1000") report "Logical Z flag failed: bad flag" severity error;
        wait for 5 ns;

        -- uADD (simple)
        sCMD <= uADD;
        intA <= 78;
        intB <= 96;
        wait for 5 ns;
        assert (sS = 174) report "uADD failed: bad output" severity error;
        assert (sZCON = 0) report "uADD failed: bad flag" severity error;
        wait for 5 ns;

        -- uADD (carry)
        intA <= 96;
        intB <= 174;
        wait for 5 ns;
        assert (sS = 14) report "uADD C failed: bad output" severity error;
        assert (sZCON = "0100") report "uADD C failed: bad flag" severity error;
        wait for 5 ns;

        -- uSUB (simple)
        sCMD <= uSUB;
        intA <= 174;
        intB <= 96;
        wait for 5 ns;
        assert (sS = 78) report "uSUB failed: bad output" severity error;
        assert (sZCON = 0) report "uSUB failed: bad flag" severity error;
        wait for 5 ns;

        -- uSUB (carry)
        intA <= 14;
        intB <= 96;
        wait for 5 ns;
        assert (sS = 174) report "uSUB C failed: bad output" severity error;
        assert (sZCON = "0101") report "uSUB C failed: bad flag" severity error;
        wait for 5 ns;

        -- TODO uMUL

        -- ADD (simple)
        sCMD <= sADD;
        intA <= 96;
        intB <= -14;
        wait for 5 ns;
        assert (sS = 82) report "ADD failed: bad output" severity error;
        assert (sZCON = 0) report "ADD failed: bad flag" severity error;
        wait for 5 ns;

        -- ADD (carry up)
        intA <= 78;
        intB <= 96;
        wait for 5 ns;
        assert (sS = conv_std_logic_vector (-82,
            length)) report "ADD Cup failed: bad output" severity error;
        assert (sZCON = "0100") report "ADD Cup failed: bad flag" severity error;
        wait for 5 ns;

        -- ADD (carry down)
        intA <= -96;
        intB <= -78;
        wait for 5 ns;
        assert (sS = 82) report "ADD Cdown failed: bad output" severity error;
        assert (sZCON = "0101") report "ADD Cdown failed: bad flag" severity error;
        wait for 5 ns;

        -- SUB (simple)
        sCMD <= sSUB;
        intA <= -14;
        intB <= 82;
        wait for 5 ns;
        assert (sS = conv_std_logic_vector (-96,
            length)) report "SUB failed: bad output" severity error;
        assert (sZCON = "0001") report "SUB failed: bad flag" severity error;
        wait for 5 ns;

        -- SUB (carry up)
        intA <= 96;
        intB <= -78;
        wait for 5 ns;
        assert (sS = conv_std_logic_vector (-82,
            length)) report "SUB Cup failed: bad output" severity error;
        assert (sZCON = "0100") report "SUB Cup failed: bad flag" severity error;
        wait for 5 ns;

        -- SUB (carry down)
        intA <= -96;
        intB <= 78;
        wait for 5 ns;
        assert (sS = 82) report "SUB Cdown failed: bad output" severity error;
        assert (sZCON = "0101") report "SUB Cdown failed: bad flag" severity error;
        wait for 5 ns;

        -- TODO MUL

    end process;
end Behavioral;
