LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

ENTITY DecodeStage IS PORT (
    clk, rst             : IN std_logic;
    instruction          : IN std_logic_vector(31 DOWNTO 0);
    alu_op               : OUT std_logic_vector(3 DOWNTO 0);
    alu_val_a, alu_val_b : OUT std_logic_vector(7 DOWNTO 0)
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
BEGIN
    op_code <= instruction(31 DOWNTO 28);
    datas : Registers PORT MAP(
        rst    => rst,
        addr_a => instruction(7 DOWNTO 4),
        addr_b => instruction(3 DOWNTO 0),
        val_a  => val_a,
        val_b  => val_b,
        wr     => '0',
        addr_wr => (OTHERS => '0'),
        val_wr => (OTHERS => '0')
    );

    alu_op <= op_to_alu_code(op_code);

    alu_val_a <= (OTHERS => '0') WHEN alu_op = alu_nop OR op_code = op_negate OR op_code = op_not ELSE
        val_a;
    val_a;

END Behavioral;
