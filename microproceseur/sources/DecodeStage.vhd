LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

ENTITY DecodeStage IS PORT (
    clk, rst             : IN std_logic;
    instruction          : IN std_logic_vector(31 DOWNTO 0);
    alu_op               : OUT std_logic_vector(3 DOWNTO 0);
    alu_val_a, alu_val_b : OUT std_logic_vector(7 DOWNTO 0);
    jump_to              : OUT std_logic_vector(7 DOWNTO 0)
);
END DecodeStage;

ARCHITECTURE Behavioral OF DecodeStage IS
    COMPONENT Registers IS PORT (
        rst            : IN std_logic;
        addr_a, addr_b : IN std_logic_vector (3 DOWNTO 0);
        val_a, val_b   : OUT std_logic_vector (7 DOWNTO 0);
        wr             : IN std_logic;
        addr_wr        : IN std_logic_vector (3 DOWNTO 0);
        val_wr         : IN std_logic_vector (7 DOWNTO 0));
    END COMPONENT;
    SIGNAL op_code, val_a, val_b : std_logic_vector(7 DOWNTO 0);
    SIGNAL wr                    : std_logic;
    SIGNAL addr_wr               : std_logic_vector(3 DOWNTO 0);
    SIGNAL val_wr                : std_logic_vector(7 DOWNTO 0);
BEGIN
    datas : Registers PORT MAP(
        rst     => rst,
        addr_a  => instruction(11 DOWNTO 8),
        addr_b  => instruction(3 DOWNTO 0),
        val_a   => val_a,
        val_b   => val_b,
        wr      => wr,
        addr_wr => addr_wr,
        val_wr  => val_wr
    );

    --missing PRINT LOAD STORE JUMPr loadr

    op_code <= instruction(31 DOWNTO 28);

    wr <= '1' WHEN op_code = op_copy OR op_code = op_define ELSE
        '0';
    addr_wr <= instruction(19 DOWNTO 16);
    val_wr  <= instruction(15 DOWNTO 8) WHEN op_code = op_copy ELSE
        val_a;

    WITH op_code SELECT alu_op <=
        s_add WHEN op_add,
        s_mul WHEN op_multiply,
        s_sub WHEN op_subtract,
        s_div WHEN op_divide,
        s_sub WHEN op_lower_than,
        s_sub WHEN op_greater_than,
        s_sub WHEN op_equal_to,
        s_sub WHEN op_negate,
        s_mod WHEN op_modulo,
        log_and WHEN op_bitwise_and,
        log_or WHEN op_bitwise_or,
        log_eq WHEN op_bitwise_not,
        log_xor WHEN op_bitwise_xor,
        alu_nop WHEN OTHERS;

    WITH op_code SELECT alu_val_a <=
        val_a WHEN op_add | op_multiply | op_subtract | op_divide | op_modulo |
        op_lower_than | op_greater_than | op_equal_to |
        op_bitwise_and | op_bitwise_or | op_bitwise_xor,
        (OTHERS => '0') WHEN OTHERS;

    WITH op_code SELECT alu_val_b <=
        val_b WHEN op_add | op_multiply | op_subtract | op_divide | op_modulo |
        op_lower_than | op_greater_than | op_equal_to |
        op_bitwise_and | op_bitwise_or | op_bitwise_xor,
        val_a WHEN op_negate | op_bitwise_not,
        (OTHERS => '0') WHEN OTHERS;

    jump_to <= instruction(27 DOWNTO 20)
        WHEN op_code = op_jump OR (op_code = op_branch AND val_a = "0000") ELSE
        (OTHERS => '0');

END Behavioral;