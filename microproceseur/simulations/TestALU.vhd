----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 03/09/2024 12:06:39 PM
-- Design Name:
-- Module Name: TestALU - Behavioral
-- Project Name:
-- Target Devices:
-- Tool Versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TestALU is
--  Port ( );
end TestALU;

architecture Behavioral of TestALU is
    component ALU is
    Port ( CMD : in STD_LOGIC_VECTOR (3 downto 0);
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           S : out STD_LOGIC_VECTOR (7 downto 0);
           Z : out STD_LOGIC;
           C : out STD_LOGIC;
           O : out STD_LOGIC;
           N : out STD_LOGIC);
    end component;

    signal sCMD : STD_LOGIC_VECTOR (3 downto 0);
    signal sA : STD_LOGIC_VECTOR (7 downto 0);
    signal sB : STD_LOGIC_VECTOR (7 downto 0);
    signal sS : STD_LOGIC_VECTOR (7 downto 0);
    signal sZ : STD_LOGIC;
    signal sC : STD_LOGIC;
    signal sO : STD_LOGIC;
    signal sN : STD_LOGIC;

    constant log_or : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    constant log_nor : STD_LOGIC_VECTOR(3 downto 0) := "0001";
    constant log_and : STD_LOGIC_VECTOR(3 downto 0) := "0010";
    constant log_nand : STD_LOGIC_VECTOR(3 downto 0) := "0011";
    constant log_xor : STD_LOGIC_VECTOR(3 downto 0) := "0100";
    constant log_eq : STD_LOGIC_VECTOR(3 downto 0) := "0101";

    constant uns_add : STD_LOGIC_VECTOR(3 downto 0) := "1000";
    constant uns_sub : STD_LOGIC_VECTOR(3 downto 0) := "1001";
    constant uns_mul : STD_LOGIC_VECTOR(3 downto 0) := "1010";

    constant sin_add : STD_LOGIC_VECTOR(3 downto 0) := "1100";
    constant sin_sub : STD_LOGIC_VECTOR(3 downto 0) := "1101";
    constant sin_mul : STD_LOGIC_VECTOR(3 downto 0) := "1110";

    constant int_14 : STD_LOGIC_VECTOR(7 downto 0) := STD_LOGIC_VECTOR(to_unsigned(14, 8));
    constant int_78 : STD_LOGIC_VECTOR(7 downto 0) := STD_LOGIC_VECTOR(to_unsigned(78, 8));
    constant int_82 : STD_LOGIC_VECTOR(7 downto 0) := STD_LOGIC_VECTOR(to_unsigned(82, 8));
    constant int_96 : STD_LOGIC_VECTOR(7 downto 0) := STD_LOGIC_VECTOR(to_unsigned(96, 8));

    constant int_n14 : STD_LOGIC_VECTOR(7 downto 0) := STD_LOGIC_VECTOR(to_signed(-14, 8));
    constant int_n78 : STD_LOGIC_VECTOR(7 downto 0) := STD_LOGIC_VECTOR(to_signed(-78, 8));
    constant int_n82 : STD_LOGIC_VECTOR(7 downto 0) := STD_LOGIC_VECTOR(to_signed(-82, 8));
    constant int_n96 : STD_LOGIC_VECTOR(7 downto 0) := STD_LOGIC_VECTOR(to_signed(-96, 8));

    constant int_174 : STD_LOGIC_VECTOR(7 downto 0) := int_n82;
begin
    uut: ALU port map (
        CMD => sCMD,
        A => sA,
        B => sB,
        S => sS,
        Z => sZ,
        C => sC,
        O => sO,
        N => sN
    );

    pTest: process
    begin
        sA <= "10101010";
        sB <= "11110000";

        -- OR
        sCMD <= log_or;
        wait for 5 ns;
        assert (sS = "11111010") report "OR failed: bad S" severity error;
        assert (sZ = '0') report "OR failed: Z = 1" severity error;
        assert (sC = '0') report "OR failed: C = 1" severity error;
        assert (sO = '0') report "OR failed: O = 1" severity error;
        assert (sN = '0') report "OR failed: N = 1" severity error;
        wait for 5 ns;

        -- NOR
        sCMD <= log_nor;
        wait for 5 ns;
        assert (sS = "00000101") report "NOR failed: bad S" severity error;
        assert (sZ = '0') report "NOR failed: Z = 1" severity error;
        assert (sC = '0') report "NOR failed: C = 1" severity error;
        assert (sO = '0') report "NOR failed: O = 1" severity error;
        assert (sN = '0') report "NOR failed: N = 1" severity error;
        wait for 5 ns;

        -- AND
        sCMD <= log_and;
        wait for 5 ns;
        assert (sS = "10100000") report "AND failed: bad S" severity error;
        assert (sZ = '0') report "AND failed: Z = 1" severity error;
        assert (sC = '0') report "AND failed: C = 1" severity error;
        assert (sO = '0') report "AND failed: O = 1" severity error;
        assert (sN = '0') report "AND failed: N = 1" severity error;
        wait for 5 ns;

        -- NAND
        sCMD <= log_nand;
        wait for 5 ns;
        assert (sS = "01011111") report "NAND failed: bad S" severity error;
        assert (sZ = '0') report "NAND failed: Z = 1" severity error;
        assert (sC = '0') report "NAND failed: C = 1" severity error;
        assert (sO = '0') report "NAND failed: O = 1" severity error;
        assert (sN = '0') report "NAND failed: N = 1" severity error;
        wait for 5 ns;

        -- XOR
        sCMD <= log_xor;
        wait for 5 ns;
        assert (sS = "01011010") report "XOR failed: bad S" severity error;
        assert (sZ = '0') report "XOR failed: Z = 1" severity error;
        assert (sC = '0') report "XOR failed: C = 1" severity error;
        assert (sO = '0') report "XOR failed: O = 1" severity error;
        assert (sN = '0') report "XOR failed: N = 1" severity error;
        wait for 5 ns;

        -- EQ
        sCMD <= log_eq;
        wait for 5 ns;
        assert (sS = "10100101") report "EQ failed: bad S" severity error;
        assert (sZ = '0') report "EQ failed: Z = 1" severity error;
        assert (sC = '0') report "EQ failed: C = 1" severity error;
        assert (sO = '0') report "EQ failed: O = 1" severity error;
        assert (sN = '0') report "EQ failed: N = 1" severity error;
        wait for 5 ns;

        -- Logical Z flag
        sA <= "00001111";
        wait for 5 ns;
        assert (sS = "00000000") report "Logical Z flag failed: bad S" severity error;
        assert (sZ = '1') report "Logical Z flag failed: Z = 0" severity error;
        assert (sC = '0') report "Logical Z flag failed: C = 1" severity error;
        assert (sO = '0') report "Logical Z flag failed: O = 1" severity error;
        assert (sN = '0') report "Logical Z flag failed: N = 1" severity error;
        wait for 5 ns;


        sCMD <= "0000";
        sA <= "00000000";
        sB <= "00000000";
        wait for 10 ns;

        -- uADD (simple)
        sCMD <= uns_add;
        sA <= int_78;
        sB <= int_96;
        wait for 5 ns;
        assert (sS = int_174) report "uADD failed: bad S" severity error;
        assert (sZ = '0') report "uADD failed: Z = 1" severity error;
        assert (sC = '0') report "uADD failed: C = 1" severity error;
        assert (sO = '0') report "uADD failed: O = 1" severity error;
        assert (sN = '0') report "uADD failed: N = 1" severity error;
        wait for 5 ns;

        -- uADD (carry)
        sA <= int_96;
        sB <= int_174;
        wait for 5 ns;
        assert (sS = int_14) report "uADDc failed: bad S" severity error;
        assert (sZ = '0') report "uADDc failed: Z = 1" severity error;
        assert (sC = '1') report "uADDc failed: C = 0" severity error;
        assert (sO = '0') report "uADDc failed: O = 1" severity error;
        assert (sN = '0') report "uADDc failed: N = 1" severity error;
        wait for 5 ns;

        -- uSUB (simple)
        sCMD <= uns_sub;
        sA <= int_174;
        sB <= int_96;
        wait for 5 ns;
        assert (sS = int_78) report "uSUB failed: bad S" severity error;
        assert (sZ = '0') report "uSUB failed: Z = 1" severity error;
        assert (sC = '0') report "uSUB failed: C = 1" severity error;
        assert (sO = '0') report "uSUB failed: O = 1" severity error;
        assert (sN = '0') report "uSUB failed: N = 1" severity error;
        wait for 5 ns;

        -- uSUB (carry)
        sA <= int_14;
        sB <= int_96;
        wait for 5 ns;
        assert (sS = int_174) report "uSUBc failed: bad S" severity error;
        assert (sZ = '0') report "uSUBc failed: Z = 1" severity error;
        assert (sC = '1') report "uSUBc failed: C = 0" severity error;
        assert (sO = '0') report "uSUBc failed: O = 1" severity error;
        assert (sN = '1') report "uSUBc failed: N = 0" severity error;
        wait for 5 ns;


        -- TODO uMUL


        sCMD <= "0000";
        sA <= "00000000";
        sB <= "00000000";
        wait for 10 ns;

        -- ADD (simple)
        sCMD <= "1100";
        sA <= int_96;
        sB <= int_n14;
        wait for 5 ns;
        assert (sS = int_82) report "ADD failed: bad S" severity error;
        assert (sZ = '0') report "ADD failed: Z = 1" severity error;
        assert (sC = '0') report "ADD failed: C = 1" severity error;
        assert (sO = '0') report "ADD failed: O = 1" severity error;
        assert (sN = '0') report "ADD failed: N = 1" severity error;
        wait for 5 ns;

        -- ADD (carry up)
        sA <= int_78;
        sB <= int_96;
        wait for 5 ns;
        assert (sS = int_n82) report "ADDcu failed: bad S" severity error;
        assert (sZ = '0') report "ADDcu failed: Z = 1" severity error;
        assert (sC = '1') report "ADDcu failed: C = 0" severity error;
        assert (sO = '0') report "ADDcu failed: O = 1" severity error;
        assert (sN = '0') report "ADDcu failed: N = 1" severity error;
        wait for 5 ns;

        -- ADD (carry down)
        sA <= int_n96;
        sB <= int_n78;
        wait for 5 ns;
        assert (sS = int_82) report "ADDcd failed: bad S" severity error;
        assert (sZ = '0') report "ADDcd failed: Z = 1" severity error;
        assert (sC = '1') report "ADDcd failed: C = 0" severity error;
        assert (sO = '0') report "ADDcd failed: O = 1" severity error;
        assert (sN = '1') report "ADDcd failed: N = 0" severity error;
        wait for 5 ns;

        -- SUB (simple)
        sCMD <= "1101";
        sA <= int_n14;
        sB <= int_82;
        wait for 5 ns;
        assert (sS = int_n96) report "SUB failed: bad S" severity error;
        assert (sZ = '0') report "SUB failed: Z = 1" severity error;
        assert (sC = '0') report "SUB failed: C = 1" severity error;
        assert (sO = '0') report "SUB failed: O = 1" severity error;
        assert (sN = '1') report "SUB failed: N = 0" severity error;
        wait for 5 ns;

        -- SUB (carry up)
        sA <= int_96;
        sB <= int_n78;
        wait for 5 ns;
        assert (sS = int_n82) report "SUBcu failed: bad S" severity error;
        assert (sZ = '0') report "SUBcu failed: Z = 1" severity error;
        assert (sC = '1') report "SUBcu failed: C = 0" severity error;
        assert (sO = '0') report "SUBcu failed: O = 1" severity error;
        assert (sN = '0') report "SUBcu failed: N = 1" severity error;
        wait for 5 ns;

        -- SUB (carry down)
        sA <= int_n96;
        sB <= int_78;
        wait for 5 ns;
        assert (sS = int_82) report "SUBcd failed: bad S" severity error;
        assert (sZ = '0') report "SUBcd failed: Z = 1" severity error;
        assert (sC = '1') report "SUBcd failed: C = 0" severity error;
        assert (sO = '0') report "SUBcd failed: O = 1" severity error;
        assert (sN = '1') report "SUBcd failed: N = 0" severity error;
        wait for 5 ns;



        -- TODO MUL

    end process;
end Behavioral;

