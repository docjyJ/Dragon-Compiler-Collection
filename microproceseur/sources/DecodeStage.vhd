LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

ENTITY DecodeStage IS PORT (
    rst, wr  : IN std_logic;
    code     : IN std_logic_vector(7 DOWNTO 0);
    input_a  : IN std_logic_vector(7 DOWNTO 0);
    input_b  : IN std_logic_vector(3 DOWNTO 0);
    addr_wr  : IN std_logic_vector(3 DOWNTO 0);
    val_wr   : IN std_logic_vector(7 DOWNTO 0);
    output_a : OUT std_logic_vector(7 DOWNTO 0);
    output_b : OUT std_logic_vector(7 DOWNTO 0);
    jump     : OUT std_logic);
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
    SIGNAL tmp_a : std_logic_vector(7 DOWNTO 0);
    SIGNAL tmp_b : std_logic_vector(7 DOWNTO 0);
BEGIN
    datas : Registers PORT MAP(
        rst     => rst,
        addr_a  => input_a(3 DOWNTO 0),
        addr_b  => input_b,
        val_a   => tmp_a,
        val_b   => tmp_b,
        wr      => wr,
        addr_wr => code(7 DOWNTO 4),
        val_wr  => input_b
    );

    jump <= '1' WHEN (tmp_b = "00000000" AND (code = op_branch OR code = op_branch_r)) OR code = op_jump OR code = op_jump_r ELSE
        '0';

    output_a <= input_a WHEN code = op_define OR code = op_jump OR code = op_branch ELSE
        tmp_a;

    output_b <= tmp_b;

    --TODO Aléa

END Behavioral;