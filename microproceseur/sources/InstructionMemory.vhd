LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.std_logic_arith.ALL;
USE IEEE.std_logic_unsigned.ALL;
USE work.Constants.ALL;

ENTITY InstructionMemory IS
    PORT (
        cnt        : IN STD_LOGIC_VECTOR (7 TO 0);
        reg_a      : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        reg_b      : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        alu_code   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
        data_wr    : OUT STD_LOGIC;
        data_rd    : OUT STD_LOGIC;
        data_addr  : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        jump       : OUT STD_LOGIC;
        branch     : OUT STD_LOGIC;
        number     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        write_back : OUT STD_LOGIC;
        reg_s      : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));

END InstructionMemory;

ARCHITECTURE Behavioral OF InstructionMemory IS
    TYPE ttab IS ARRAY (255 DOWNTO 0) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
    CONSTANT mem_inst : ttab := (
        x"00000000",
        x"01020304",
        x"07060304",
        x"090A0309",
        x"50010105",
        OTHERS => (OTHERS => '0'));

    SIGNAL inst : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL op_code : STD_LOGIC_VECTOR (7 DOWNTO 0);
BEGIN
    inst <= mem_inst(conv_integer(cnt));
    op_code <= inst(31 DOWNTO 24);

    WITH op_code SELECT alu_code <=
        s_add WHEN op_add,
        s_mul WHEN op_multiply,
        s_sub WHEN op_subtract,
        s_div WHEN op_divide,
        log_eq WHEN op_equal_to,
        s_sub WHEN op_negate,
        log_and WHEN op_bitwise_and,
        log_or WHEN op_bitwise_or,
        log_nor WHEN op_bitwise_not,
        log_xor WHEN op_bitwise_xor,
        (OTHERS => '0') WHEN OTHERS;

    data_addr <= inst(23 DOWNTO 16);
    data_wr <= '1' WHEN op_code = op_store ELSE
        '0';
    data_rd <= '1' WHEN op_code = op_load ELSE
        '0';

    WITH op_code SELECT
        write_back <= '1' WHEN op_add | op_multiply | op_subtract | op_divide |
        op_copy | op_define | op_negate | op_modulo |
        op_bitwise_and | op_bitwise_or | op_bitwise_not | op_bitwise_xor,
        '0' WHEN OTHERS;

    reg_a <= inst(19 DOWNTO 16) WHEN op_code = op_display ELSE
        inst(11 DOWNTO 8);

    reg_b <= inst(3 DOWNTO 0);

    reg_s <= inst(19 DOWNTO 16);

    WITH op_code SELECT
        number <= inst(23 DOWNTO 16) WHEN op_jump | op_branch,
        inst(15 DOWNTO 8) WHEN op_define,
        (OTHERS => '1') WHEN OTHERS;

    jump <= '1' WHEN op_code = op_jump ELSE
        '0';

    branch <= '1' WHEN op_code = op_branch ELSE
        '0';

END Behavioral;
