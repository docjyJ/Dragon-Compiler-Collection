LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

ENTITY ExecuteStage IS PORT (
    rst                    : IN std_logic;
    code, input_a, input_b : IN std_logic_vector(7 DOWNTO 0);
    output_a, output_b     : OUT std_logic_vector(7 DOWNTO 0));
END ENTITY ExecuteStage;

ARCHITECTURE Behavioral OF ExecuteStage IS
    COMPONENT ALU IS PORT (
        cmd        : IN std_logic_vector (3 DOWNTO 0);
        a, b       : IN std_logic_vector (7 DOWNTO 0);
        s          : OUT std_logic_vector (7 DOWNTO 0);
        z, c, o, n : OUT std_logic);
    END COMPONENT;

    SIGNAL ALU_cmd : std_logic_vector(3 DOWNTO 0);

    SIGNAL s          : std_logic_vector(7 DOWNTO 0);
    SIGNAL z, c, o, n : std_logic;

BEGIN

    uALU : ALU PORT MAP(
        cmd => code,
        a   => input_a,
        b   => input_b,
        s   => s,
        z   => z,
        c   => c,
        o   => o,
        n   => n);

    WITH code SELECT alu_cmd <=
        s_add WHEN op_add,
        s_mul WHEN op_multiply,
        s_sub WHEN op_subtract,
        s_div WHEN op_divide,
        s_mod WHEN op_modulo,
        s_sub WHEN op_negate,
        s_sub WHEN op_lower_than,
        s_sub WHEN op_greater_than,
        log_eq WHEN op_equal_to,
        log_or WHEN op_bitwise_or,
        log_and WHEN op_bitwise_and,
        log_eq WHEN op_bitwise_not,
        log_xor WHEN op_bitwise_xor,
        alu_nop WHEN OTHERS;

    WITH code SELECT output_a <=
        (0 => n, OTHERS => '0') WHEN op_lower_than,
        (0 => NOT n, OTHERS => '0') WHEN op_greater_than,
        (0 => z, OTHERS => '0') WHEN op_equal_to,
        s WHEN OTHERS;

    output_b <= input_b;
END Behavioral;