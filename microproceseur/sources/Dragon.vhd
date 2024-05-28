LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE Dragon IS
    TYPE pipe_line IS RECORD
        code   : std_logic_vector(7 DOWNTO 0);
        first  : std_logic_vector(7 DOWNTO 0);
        second : std_logic_vector(7 DOWNTO 0);
        output : std_logic_vector(3 DOWNTO 0);
    END RECORD pipe_line;

    CONSTANT op_add          : std_logic_vector (7 DOWNTO 0) := x"01";
    CONSTANT op_multiply     : std_logic_vector (7 DOWNTO 0) := x"02";
    CONSTANT op_subtract     : std_logic_vector (7 DOWNTO 0) := x"03";
    CONSTANT op_divide       : std_logic_vector (7 DOWNTO 0) := x"04";
    CONSTANT op_copy         : std_logic_vector (7 DOWNTO 0) := x"05";
    CONSTANT op_define       : std_logic_vector (7 DOWNTO 0) := x"06";
    CONSTANT op_jump         : std_logic_vector (7 DOWNTO 0) := x"07";
    CONSTANT op_branch       : std_logic_vector (7 DOWNTO 0) := x"08";
    CONSTANT op_lower_than   : std_logic_vector (7 DOWNTO 0) := x"09";
    CONSTANT op_greater_than : std_logic_vector (7 DOWNTO 0) := x"0A";
    CONSTANT op_equal_to     : std_logic_vector (7 DOWNTO 0) := x"0B";
    CONSTANT op_display      : std_logic_vector (7 DOWNTO 0) := x"0C";
    CONSTANT op_load         : std_logic_vector (7 DOWNTO 0) := x"10";
    CONSTANT op_store        : std_logic_vector (7 DOWNTO 0) := x"11";
    CONSTANT op_jump_r       : std_logic_vector (7 DOWNTO 0) := x"12";
    CONSTANT op_branch_r     : std_logic_vector (7 DOWNTO 0) := x"13";
    CONSTANT op_read         : std_logic_vector (7 DOWNTO 0) := x"14";
    CONSTANT op_negate       : std_logic_vector (7 DOWNTO 0) := x"30";
    CONSTANT op_modulo       : std_logic_vector (7 DOWNTO 0) := x"31";
    CONSTANT op_bitwise_and  : std_logic_vector (7 DOWNTO 0) := x"50";
    CONSTANT op_bitwise_or   : std_logic_vector (7 DOWNTO 0) := x"51";
    CONSTANT op_bitwise_not  : std_logic_vector (7 DOWNTO 0) := x"52";
    CONSTANT op_bitwise_xor  : std_logic_vector (7 DOWNTO 0) := x"53";

    FUNCTION have_write_back (code : std_logic_vector(7 DOWNTO 0)) RETURN std_logic;
    FUNCTION code_to_alu (code     : std_logic_vector(7 DOWNTO 0)) RETURN std_logic_vector;

    CONSTANT alu_nop : std_logic_vector (3 DOWNTO 0) := "0000";
    CONSTANT alu_or  : std_logic_vector (3 DOWNTO 0) := "0001";
    CONSTANT alu_and : std_logic_vector (3 DOWNTO 0) := "0010";
    CONSTANT alu_xor : std_logic_vector (3 DOWNTO 0) := "0011";
    CONSTANT alu_eq  : std_logic_vector (3 DOWNTO 0) := "0100";
    -- constant UNUSED: std_logic_vector (3 downto 0) := "0110";
    -- constant UNUSED: std_logic_vector (3 downto 0) := "0111";
    -- CONSTANT u_add : std_logic_vector (3 DOWNTO 0) := "1000";
    -- CONSTANT u_sub : std_logic_vector (3 DOWNTO 0) := "1001";
    -- CONSTANT u_mul : std_logic_vector (3 DOWNTO 0) := "1010";
    -- constant UNUSED: std_logic_vector (3 downto 0) := "1011";
    CONSTANT alu_add : std_logic_vector (3 DOWNTO 0) := "1100";
    CONSTANT alu_sub : std_logic_vector (3 DOWNTO 0) := "1101";
    CONSTANT alu_mul : std_logic_vector (3 DOWNTO 0) := "1110";
    CONSTANT alu_div : std_logic_vector (3 DOWNTO 0) := "1111";
    CONSTANT alu_mod : std_logic_vector (3 DOWNTO 0) := "1011";

END PACKAGE;

PACKAGE BODY Dragon IS
    FUNCTION have_write_back (code : std_logic_vector(7 DOWNTO 0)) RETURN std_logic IS
    BEGIN
        CASE code IS
            WHEN op_add          => RETURN '1';
            WHEN op_multiply     => RETURN '1';
            WHEN op_subtract     => RETURN '1';
            WHEN op_divide       => RETURN '1';
            WHEN op_copy         => RETURN '1';
            WHEN op_define       => RETURN '1';
            WHEN op_jump         => RETURN '0';
            WHEN op_branch       => RETURN '0';
            WHEN op_lower_than   => RETURN '1';
            WHEN op_greater_than => RETURN '1';
            WHEN op_equal_to     => RETURN '1';
            WHEN op_display      => RETURN '0';
            WHEN op_load         => RETURN '1';
            WHEN op_store        => RETURN '0';
            WHEN op_jump_r       => RETURN '0';
            WHEN op_branch_r     => RETURN '0';
            WHEN op_read         => RETURN '1';
            WHEN op_negate       => RETURN '1';
            WHEN op_modulo       => RETURN '1';
            WHEN op_bitwise_and  => RETURN '1';
            WHEN op_bitwise_or   => RETURN '1';
            WHEN op_bitwise_not  => RETURN '1';
            WHEN op_bitwise_xor  => RETURN '1';
            WHEN OTHERS          => RETURN '0';
        END CASE;
    END FUNCTION;

    FUNCTION code_to_alu (code : std_logic_vector(7 DOWNTO 0)) RETURN std_logic_vector IS
    BEGIN
        CASE code IS
            WHEN op_add          => RETURN alu_add;
            WHEN op_multiply     => RETURN alu_mul;
            WHEN op_subtract     => RETURN alu_sub;
            WHEN op_divide       => RETURN alu_div;
            WHEN op_copy         => RETURN alu_nop;
            WHEN op_define       => RETURN alu_nop;
            WHEN op_jump         => RETURN alu_nop;
            WHEN op_branch       => RETURN alu_nop;
            WHEN op_lower_than   => RETURN alu_sub;
            WHEN op_greater_than => RETURN alu_sub;
            WHEN op_equal_to     => RETURN alu_eq;
            WHEN op_display      => RETURN alu_nop;
            WHEN op_load         => RETURN alu_nop;
            WHEN op_store        => RETURN alu_nop;
            WHEN op_jump_r       => RETURN alu_nop;
            WHEN op_branch_r     => RETURN alu_nop;
            WHEN op_read         => RETURN alu_nop;
            WHEN op_negate       => RETURN alu_sub;
            WHEN op_modulo       => RETURN alu_mod;
            WHEN op_bitwise_and  => RETURN alu_and;
            WHEN op_bitwise_or   => RETURN alu_or;
            WHEN op_bitwise_not  => RETURN alu_eq;
            WHEN op_bitwise_xor  => RETURN alu_xor;
            WHEN OTHERS          => RETURN alu_nop;
        END CASE;
    END FUNCTION;
END PACKAGE BODY;