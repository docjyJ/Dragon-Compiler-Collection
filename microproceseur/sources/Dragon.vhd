LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE Dragon IS
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
    CONSTANT op_negate       : std_logic_vector (7 DOWNTO 0) := x"30";
    CONSTANT op_modulo       : std_logic_vector (7 DOWNTO 0) := x"31";
    CONSTANT op_bitwise_and  : std_logic_vector (7 DOWNTO 0) := x"50";
    CONSTANT op_bitwise_or   : std_logic_vector (7 DOWNTO 0) := x"51";
    CONSTANT op_bitwise_not  : std_logic_vector (7 DOWNTO 0) := x"52";
    CONSTANT op_bitwise_xor  : std_logic_vector (7 DOWNTO 0) := x"53";

    CONSTANT alu_nop : std_logic_vector (3 DOWNTO 0) := "0001";
    CONSTANT log_or  : std_logic_vector (3 DOWNTO 0) := "0001";
    CONSTANT log_nor : std_logic_vector (3 DOWNTO 0) := "0010";
    CONSTANT log_and : std_logic_vector (3 DOWNTO 0) := "0011";
    CONSTANT log_xor : std_logic_vector (3 DOWNTO 0) := "0100";
    CONSTANT log_eq  : std_logic_vector (3 DOWNTO 0) := "0101";
    -- constant UNUSED: std_logic_vector (3 downto 0) := "0110";
    -- constant UNUSED: std_logic_vector (3 downto 0) := "0111";
    CONSTANT u_add : std_logic_vector (3 DOWNTO 0) := "1000";
    CONSTANT u_sub : std_logic_vector (3 DOWNTO 0) := "1001";
    CONSTANT u_mul : std_logic_vector (3 DOWNTO 0) := "1010";
    -- constant UNUSED: std_logic_vector (3 downto 0) := "1011";
    CONSTANT s_add : std_logic_vector (3 DOWNTO 0) := "1100";
    CONSTANT s_sub : std_logic_vector (3 DOWNTO 0) := "1101";
    CONSTANT s_mul : std_logic_vector (3 DOWNTO 0) := "1110";
    CONSTANT s_div : std_logic_vector (3 DOWNTO 0) := "1111";

    FUNCTION op_to_alu_code (code : IN std_logic_vector(7 DOWNTO 0)) RETURN std_logic_vector;
END Dragon;

PACKAGE BODY Dragon IS
    FUNCTION op_to_alu_code (code : IN std_logic_vector(7 DOWNTO 0)) RETURN std_logic_vector IS
    BEGIN
        CASE code IS
            WHEN op_add          => RETURN u_add;
            WHEN op_multiply     => RETURN u_mul;
            WHEN op_subtract     => RETURN u_sub;
            WHEN op_divide       => RETURN s_div;
            WHEN op_copy         => RETURN u_add;
            WHEN op_define       => RETURN u_add;
            WHEN op_jump         => RETURN u_add;
            WHEN op_branch       => RETURN u_add;
            WHEN op_lower_than   => RETURN u_add;
            WHEN op_greater_than => RETURN u_add;
            WHEN op_equal_to     => RETURN u_add;
            WHEN op_display      => RETURN u_add;
            WHEN op_load         => RETURN u_add;
            WHEN op_store        => RETURN u_add;
            WHEN op_negate       => RETURN u_add;
            WHEN op_modulo       => RETURN u_add;
            WHEN op_bitwise_and  => RETURN u_add;
            WHEN op_bitwise_or   => RETURN u_add;
            WHEN op_bitwise_not  => RETURN u_add;
            WHEN op_bitwise_xor  => RETURN u_add;
            WHEN OTHERS          => RETURN u_add;
        END CASE;
    END op_to_alu_code;
END Dragon;
