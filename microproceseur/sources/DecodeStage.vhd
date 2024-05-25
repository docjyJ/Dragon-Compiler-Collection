LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

ENTITY DecodeStage IS PORT (
    rst    : IN std_logic;
    pipin  : IN pipe_line;
    pipout : OUT pipe_line;
    jump   : OUT std_logic);
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

    SIGNAL wr      : std_logic;
    SIGNAL addr_wr : std_logic_vector(3 DOWNTO 0);
    SIGNAL val_wr  : std_logic_vector(7 DOWNTO 0);

    SIGNAL code_tmp : std_logic_vector(7 DOWNTO 0);
    SIGNAL tmp_frst : std_logic_vector(7 DOWNTO 0);
    SIGNAL tmp_scnd : std_logic_vector(7 DOWNTO 0);
BEGIN
    datas : Registers PORT MAP(
        rst     => rst,
        addr_a  => pipin.first(3 DOWNTO 0),
        addr_b  => pipin.second(3 DOWNTO 0),
        val_a   => tmp_frst,
        val_b   => tmp_scnd,
        wr      => wr,
        addr_wr => addr_wr,
        val_wr  => val_wr
    );

    code_tmp <= pipin.code;

    WITH code_tmp SELECT jump <=
        NOR tmp_scnd WHEN op_branch | op_branch_r,
        '1' WHEN op_jump | op_jump_r,
        '0' WHEN OTHERS;

    pipout.code <= code_tmp;

    pipout.output <= pipin.output;

    WITH code_tmp SELECT pipout.first <=
        pipin.first WHEN op_define | op_jump | op_branch,
        tmp_frst WHEN OTHERS;

    pipout.second <= tmp_scnd;

    --TODO Aléa

END Behavioral;