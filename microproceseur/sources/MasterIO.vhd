LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY MasterIO IS PORT (
    clk, btnL, btnR  : IN std_logic;
    btnU, btnD, btnC : IN std_logic;
    sw               : IN std_logic_vector(15 DOWNTO 0);
    led              : OUT std_logic_vector(15 DOWNTO 0);
    an               : OUT std_logic_vector(3 DOWNTO 0);
    seg              : OUT std_logic_vector(6 DOWNTO 0);
    dp               : OUT std_logic);
END MasterIO;

ARCHITECTURE Behavioral OF MasterIO IS
    TYPE pipe_line IS RECORD
        code    : std_logic_vector(7 DOWNTO 0);
        input_a : std_logic_vector(7 DOWNTO 0);
        input_b : std_logic_vector(7 DOWNTO 0);
        output  : std_logic_vector(3 DOWNTO 0);
    END RECORD pipe_line;

    SIGNAL rst  : std_logic;
    SIGNAL jump : std_logic;

    COMPONENT FetchStage IS PORT (
        clk, rst, en, lod : IN std_logic;
        go_to             : IN std_logic_vector(7 DOWNTO 0);
        code, input_a     : OUT std_logic_vector(7 DOWNTO 0);
        output, input_b   : OUT std_logic_vector(3 DOWNTO 0));
    END COMPONENT;

    SIGNAL fetch_out_pipe : pipe_line;
    SIGNAL decode_in_pipe : pipe_line;

    COMPONENT DecodeStage IS PORT (
        rst                : IN std_logic;
        code, input_a      : IN std_logic_vector(7 DOWNTO 0);
        input_b            : IN std_logic_vector(3 DOWNTO 0);
        output_a, output_b : OUT std_logic_vector(7 DOWNTO 0);
        jump               : OUT std_logic);
    END COMPONENT;

    SIGNAL decode_out_pipe : pipe_line;
    SIGNAL execute_in_pipe : pipe_line;

    COMPONENT ExecuteStage IS PORT (
        rst                    : IN std_logic;
        code, input_a, input_b : IN std_logic_vector(7 DOWNTO 0);
        output_a               : OUT std_logic_vector(7 DOWNTO 0));
    END COMPONENT;

    SIGNAL execute_out_pipe : pipe_line;

BEGIN

    rst <= btnl OR btnr OR btnu OR btnd OR btnc;

    fetch : FetchStage PORT MAP(
        clk     => clk,
        rst     => rst,
        en      => '1',
        lod     => jump,
        go_to   => decode_in_pipe.input_a,
        output  => fetch_out_pipe.output(3 DOWNTO 0),
        code    => fetch_out_pipe.code,
        input_a => fetch_out_pipe.input_a,
        input_b => fetch_out_pipe.input_b(3 DOWNTO 0));

    decode : DecodeStage PORT MAP(
        rst      => rst,
        code     => decode_in_pipe.code,
        input_a  => decode_in_pipe.input_a,
        input_b  => decode_in_pipe.input_b,
        output_a => decode_out_pipe.input_a,
        output_b => decode_out_pipe.input_b,
        jump     => jump);

    execute : ExecuteStage PORT MAP(
        rst      => rst,
        code     => execute_in_pipe.code,
        input_a  => execute_in_pipe.input_a,
        input_b  => execute_in_pipe.input_b,
        output_a => execute_out_pipe.input_a);

    led <= decode_in_pipe.output(15 DOWNTO 0);
    an  <= "1111";
    seg <= "0000000";
    dp  <= '0';

    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            fetch_out_pipe   <= (OTHERS => (OTHERS => '0'));
            decode_in_pipe   <= (OTHERS => (OTHERS => '0'));
            decode_out_pipe  <= (OTHERS => (OTHERS => '0'));
            execute_in_pipe  <= (OTHERS => (OTHERS => '0'));
            execute_out_pipe <= (OTHERS => (OTHERS => '0'));
        ELSIF clk'event AND clk = '1' THEN
            decode_in_pipe  <= fetch_out_pipe;
            execute_in_pipe <= decode_out_pipe;
        END IF;

    END PROCESS;

END Behavioral;