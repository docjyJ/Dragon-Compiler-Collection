library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_signed.all;

entity ALU is
    Port (
        CMD: in std_logic_vector (3 downto 0);
        A: in std_logic_vector (7 downto 0);
        B: in std_logic_vector (7 downto 0);
        S: out std_logic_vector (7 downto 0);
        Z: out STD_LOGIC;
        C: out STD_LOGIC;
        O: out STD_LOGIC;
        N: out STD_LOGIC
    );
end ALU;

architecture Behavioral of ALU is
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

    constant MAX_UINT: integer := 255;
    constant MAX_INT: integer := 127;
    constant MIN_INT: integer := -128;
    constant ZERROS: std_logic_vector (9 downto 0) := (others => '0');
    constant ONES: std_logic_vector (9 downto 0) := (others => '1');

    signal sA: std_logic_vector (17 downto 0);
    signal sB: std_logic_vector (17 downto 0);
    signal sS: std_logic_vector (17 downto 0);

begin
    sA <= ONES & A when A(7) = '1' and (CMD = sADD or CMD = sSUB or CMD = sMUL) else
        ZERROS & not(A) when CMD = lNAND or CMD = lNOR or CMD = lEQ else
        ZERROS & A;

    sB <= ONES & B when B(7) = '1' and (CMD = sADD or CMD = sSUB or CMD = sMUL) else
        ZERROS & not(B) when CMD = lNAND or CMD = lNOR else
        ZERROS & B;

    with CMD select
        sS <= sA or sB when lOR | lNAND,
              sA and sB when LOG_AND | lNOR,
              sA xor sB when lXOR | lEQ,
              sA + sB when uADD | sADD,
              sA - sB when uSUB | sSUB,
              sA(8 downto 0) * sB(8 downto 0) when uMUL | sMUL,
              (others => '0') when others;

    Z <= '1' when sS = 0 else '0';

    N <= '1' when sS < 0 else '0';

    C <= '1' when CMD = uADD and sS > MAX_UINT else
         '1' when CMD = uSUB and sS < 0 else
         '1' when (CMD = sADD or CMD = sSUB) and (sS < MIN_INT or sS > MAX_INT) else
         '0';

    O <= '1' when CMD = uMUL and sS > MAX_UINT else
         '1' when CMD = sMUL and (sS < MIN_INT or sS > MAX_INT) else
         '0';

    S <= Ss(7 downto 0);

end Behavioral;
