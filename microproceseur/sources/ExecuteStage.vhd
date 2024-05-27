LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

ENTITY ExecuteStage IS PORT (
    rst    : IN std_logic;
    pipin  : IN pipe_line;
    pipout : OUT pipe_line);
END ENTITY;

ARCHITECTURE Behavioral OF ExecuteStage IS
    COMPONENT ALU IS PORT (
        cmd        : IN std_logic_vector (3 DOWNTO 0);
        a, b       : IN std_logic_vector (7 DOWNTO 0);
        s          : OUT std_logic_vector (7 DOWNTO 0);
        z, c, o, n : OUT std_logic);
    END COMPONENT;

    SIGNAL ALU_cmd : std_logic_vector(3 DOWNTO 0);

    SIGNAL z, c, o, n : std_logic;

    SIGNAL tmp_code : std_logic_vector(7 DOWNTO 0);
    SIGNAL tmp_frst : std_logic_vector(7 DOWNTO 0);

BEGIN

    uALU : ALU PORT MAP(
        cmd => ALU_cmd,
        a   => pipin.first,
        b   => pipin.second,
        s   => tmp_frst,
        z   => z,
        c   => c,
        o   => o,
        n   => n);

    WITH tmp_code SELECT alu_cmd <=
        alu_add WHEN op_add,
        alu_mul WHEN op_multiply,
        alu_sub WHEN op_subtract,
        alu_div WHEN op_divide,
        alu_mod WHEN op_modulo,
        alu_sub WHEN op_negate,
        alu_sub WHEN op_lower_than,
        alu_sub WHEN op_greater_than,
        alu_eq WHEN op_equal_to,
        alu_or WHEN op_bitwise_or,
        alu_and WHEN op_bitwise_and,
        alu_eq WHEN op_bitwise_not,
        alu_xor WHEN op_bitwise_xor,
        alu_nop WHEN OTHERS;

    pipout.code <= tmp_code;

    pipout.output <= pipin.output;

    WITH tmp_code SELECT pipout.first <=
        (0 => n, OTHERS => '0') WHEN op_lower_than,
        (0 => NOT n, OTHERS => '0') WHEN op_greater_than,
        (0 => z, OTHERS => '0') WHEN op_equal_to,
        tmp_frst WHEN OTHERS;

    pipout.second <= pipin.second;

END ARCHITECTURE;