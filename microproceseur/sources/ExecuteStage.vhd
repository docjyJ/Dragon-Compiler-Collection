LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.conv_integer;
USE WORK.DRAGON.ALL;

ENTITY ExecuteStage IS PORT (
    clk, rst  : IN std_logic;
    io_input  : IN std_logic_vector(15 DOWNTO 0);
    io_output : OUT std_logic_vector(15 DOWNTO 0);
    pipin     : IN pipe_line;
    pipout    : OUT pipe_line);
END ENTITY;

ARCHITECTURE Behavioral OF ExecuteStage IS
    COMPONENT ALU IS PORT (
        cmd        : IN std_logic_vector (3 DOWNTO 0);
        a, b       : IN std_logic_vector (7 DOWNTO 0);
        s          : OUT std_logic_vector (7 DOWNTO 0);
        z, c, o, n : OUT std_logic);
    END COMPONENT;

    COMPONENT IORegister IS PORT (
        rst, wr : IN std_logic;
        chanel  : IN integer RANGE 0 TO 1;
        input   : IN std_logic_vector(15 DOWNTO 0);
        output  : OUT std_logic_vector(15 DOWNTO 0);
        val_in  : IN std_logic_vector(7 DOWNTO 0);
        val_out : OUT std_logic_vector(7 DOWNTO 0));
    END COMPONENT;
    SIGNAL z, c, o, n : std_logic;

    SIGNAL wr : std_logic;

    SIGNAL io_out  : std_logic_vector(7 DOWNTO 0);
    SIGNAL alu_out : std_logic_vector(7 DOWNTO 0);
BEGIN

    uALU : ALU PORT MAP(
        cmd => code_to_alu(pipin.code),
        a   => pipin.first,
        b   => pipin.second,
        s   => alu_out,
        z   => z,
        c   => c,
        o   => o,
        n   => n);

    wr <= '1' WHEN pipin.code = op_display AND clk = '0' ELSE
        '0';

    uIOReg : IORegister PORT MAP(
        rst     => rst,
        wr      => wr,
        chanel  => conv_integer(pipin.first),
        input   => io_input,
        output  => io_output,
        val_in  => pipin.second,
        val_out => io_out);

    pipout.code <= pipin.code;

    pipout.output <= pipin.output;

    pipout.first <=
    (0 => n, OTHERS => '0') WHEN pipin.code = op_lower_than ELSE
    (0 => NOT n, OTHERS => '0') WHEN pipin.code = op_greater_than ELSE
    (0 => z, OTHERS => '0') WHEN pipin.code = op_equal_to ELSE
    alu_out WHEN code_to_alu(pipin.code) /= alu_nop ELSE
    io_out WHEN pipin.code = op_read ELSE
    pipin.first;

    pipout.second <= pipin.second;

END ARCHITECTURE;