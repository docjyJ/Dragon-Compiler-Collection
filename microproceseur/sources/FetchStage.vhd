LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

ENTITY FetchStage IS PORT (
    clk, rst, en, lod : IN std_logic;
    go_to             : IN std_logic_vector(7 DOWNTO 0);
    pipeline          : OUT pipe_line);
END ENTITY;

ARCHITECTURE behavioral OF FetchStage IS
    COMPONENT Counter IS PORT (
        clk, rst     : IN std_logic;
        en, dir, lod : IN std_logic;
        a            : IN std_logic_vector (7 DOWNTO 0);
        s            : OUT std_logic_vector (7 DOWNTO 0));
    END COMPONENT;

    COMPONENT InstructionMemory IS PORT (
        addr : IN std_logic_vector(7 DOWNTO 0);
        data : OUT std_logic_vector(31 DOWNTO 0));
    END COMPONENT;

    SIGNAL pc       : std_logic_vector(7 DOWNTO 0);
    SIGNAL data     : std_logic_vector(31 DOWNTO 0);
    SIGNAL code_tmp : std_logic_vector(7 DOWNTO 0);
    SIGNAL mode     : std_logic_vector(3 DOWNTO 0);
BEGIN
    program_counter : Counter PORT MAP(
        clk => clk,
        rst => rst,
        en  => en,
        dir => '0',
        lod => lod,
        a   => go_to,
        s   => pc);

    instruction_memory : InstructionMemory PORT MAP(
        addr => pc,
        data => data);

    code_tmp <= data(31 DOWNTO 24);

    pipeline.code <= code_tmp;

    WITH code_tmp SELECT mode <=
        "1101" WHEN op_add,
        "1101" WHEN op_multiply,
        "1101" WHEN op_subtract,
        "1101" WHEN op_divide,
        "0101" WHEN op_copy,
        "0011" WHEN op_define,
        "0010" WHEN op_jump,
        "1010" WHEN op_branch,
        "1101" WHEN op_lower_than,
        "1101" WHEN op_greater_than,
        "1101" WHEN op_equal_to,
        "1010" WHEN op_display,
        "1010" WHEN op_load,
        "1100" WHEN op_store,
        "0010" WHEN op_jump_r,
        "1010" WHEN op_branch_r,
        "0011" WHEN op_read,
        "1001" WHEN op_negate,
        "1101" WHEN op_modulo,
        "1101" WHEN op_bitwise_and,
        "1101" WHEN op_bitwise_or,
        "1001" WHEN op_bitwise_not,
        "1101" WHEN op_bitwise_xor,
        "0000" WHEN OTHERS;

    pipeline.info <= mode;

    pipeline.output <= (OTHERS => '0') WHEN mode(0) = '0' ELSE
    data(19 DOWNTO 16);

    pipeline.first <=
    (OTHERS => '0') WHEN mode(2 DOWNTO 1) = "00" ELSE
    data(23 DOWNTO 16) WHEN code_tmp = op_jump OR code_tmp = op_branch OR code_tmp = op_store OR code_tmp = op_jump_r OR code_tmp = op_branch_r ELSE
    data(15 DOWNTO 8);

    pipeline.second <=
    (OTHERS => '0') WHEN mode(3) = '0' ELSE
    data(23 DOWNTO 16) WHEN code_tmp = op_display ELSE
    data(15 DOWNTO 8) WHEN code_tmp = op_branch OR code_tmp = op_load OR code_tmp = op_store OR code_tmp = op_branch_r OR code_tmp = op_negate OR code_tmp = op_bitwise_not ELSE
    data(7 DOWNTO 0);

END ARCHITECTURE;