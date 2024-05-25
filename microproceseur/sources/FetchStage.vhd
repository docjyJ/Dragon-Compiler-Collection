LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

ENTITY FetchStage IS PORT (
    clk, rst, en, lod : IN std_logic;
    go_to             : IN std_logic_vector(7 DOWNTO 0);
    code, input_a     : OUT std_logic_vector(7 DOWNTO 0);
    output, input_b   : OUT std_logic_vector(3 DOWNTO 0));
END ENTITY FetchStage;

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
BEGIN
    program_counter : Counter PORT MAP(
        clk => clk,
        rst => rst,
        en  => en,
        dir => '1',
        lod => lod,
        a   => go_to,
        s   => pc);

    instruction_memory : InstructionMemory PORT MAP(
        addr => pc,
        data => data);

    code_tmp <= data(31 DOWNTO 24);

    code <= code_tmp;

    output <= data(19 DOWNTO 16);

    WITH code_tmp SELECT input_a <=
        data(23 DOWNTO 16) WHEN op_jump | op_branch | op_display | op_store | op_jump_r | op_branch_r,
        (OTHERS => '0') WHEN op_negate | op_bitwise_not,
        data(15 DOWNTO 8) WHEN OTHERS;

    WITH code_tmp SELECT input_b <=
        data(11 DOWNTO 8) WHEN op_branch | op_load | op_store | op_branch_r | op_negate | op_bitwise_not,
        data(3 DOWNTO 0) WHEN OTHERS;

END ARCHITECTURE behavioral;