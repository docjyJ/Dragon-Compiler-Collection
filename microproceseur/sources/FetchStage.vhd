LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;
USE WORK.DRAGONSPY.ALL;

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
    SIGNAL mode     : std_logic_vector(4 DOWNTO 0);
BEGIN
    program_counter : Counter PORT MAP(
        clk => clk,
        rst => rst,
        en  => en,
        dir => '0',
        lod => lod,
        a   => go_to,
        s   => pc);

    -- synthesis translate_off
    spy_pc <= pc;
    -- synthesis translate_on

    instruction_memory : InstructionMemory PORT MAP(
        addr => pc,
        data => data);

    code_tmp <= data(31 DOWNTO 24);

    mode <= code_mode(code_tmp);

    pipeline.code <= code_tmp;

    pipeline.output <= (OTHERS => '0') WHEN mode(0) = '0' ELSE
    data(19 DOWNTO 16);

    pipeline.first <=
    (OTHERS => '0') WHEN mode(1 DOWNTO 2) = "00" ELSE
    data(23 DOWNTO 16) WHEN code_tmp = op_jump OR code_tmp = op_branch OR code_tmp = op_store OR code_tmp = op_jump_r OR code_tmp = op_branch_r ELSE
    data(15 DOWNTO 8);

    pipeline.second <=
    (OTHERS => '0') WHEN mode(3) = '0' ELSE
    data(23 DOWNTO 16) WHEN code_tmp = op_display ELSE
    data(15 DOWNTO 8) WHEN code_tmp = op_branch OR code_tmp = op_load OR code_tmp = op_store OR code_tmp = op_branch_r OR code_tmp = op_negate OR code_tmp = op_bitwise_not ELSE
    data(7 DOWNTO 0);

END ARCHITECTURE;