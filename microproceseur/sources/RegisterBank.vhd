library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegisterBank is
    Port (
        read1: in STD_LOGIC_VECTOR (2 downto 0);
        read2: in STD_LOGIC_VECTOR (2 downto 0);
        write: in STD_LOGIC_VECTOR (2 downto 0);
        input: in STD_LOGIC_VECTOR (7 downto 0);
        output1: out STD_LOGIC_VECTOR (7 downto 0);
        output2: out STD_LOGIC_VECTOR (7 downto 0)
    );
end RegisterBank;

architecture Behavioral of RegisterBank is
    signal R1: STD_LOGIC_VECTOR (7 downto 0);
    signal R2: STD_LOGIC_VECTOR (7 downto 0);
    signal R3: STD_LOGIC_VECTOR (7 downto 0);
    signal R4: STD_LOGIC_VECTOR (7 downto 0);
    signal R5: STD_LOGIC_VECTOR (7 downto 0);
    signal R6: STD_LOGIC_VECTOR (7 downto 0);
    signal R7: STD_LOGIC_VECTOR (7 downto 0);
    signal R0: STD_LOGIC_VECTOR (7 downto 0);
begin
    with read1 select
        output1 <= R0 when "000",
                   R1 when "001",
                   R2 when "010",
                   R3 when "011",
                   R4 when "100",
                   R5 when "101",
                   R6 when "110",
                   R7 when others;
                   --R7 when "111",
                   --(others => '0') when others ;

    with read2 select
        output2 <= R0 when "000",
                   R1 when "001",
                   R2 when "010",
                   R3 when "011",
                   R4 when "100",
                   R5 when "101",
                   R6 when "110",
                   R7 when others;
                   --R7 when "111",
                   --(others => '0') when others ;

    process (write)
    begin
        case write is
            when "000" => R0 <= input;
            when "001" => R1 <= input;
            when "010" => R2 <= input;
            when "011" => R3 <= input;
            when "100" => R4 <= input;
            when "101" => R5 <= input;
            when "110" => R6 <= input;
            when others => R7 <= input;
        end case;
    end process;

end Behavioral;