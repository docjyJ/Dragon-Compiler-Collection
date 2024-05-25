LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

ENTITY MasterIO IS PORT (
    clk, clk_100, btnL, btnR : IN std_logic;
    btnU, btnD, btnC         : IN std_logic;
    sw                       : IN std_logic_vector(15 DOWNTO 0);
    led                      : OUT std_logic_vector(15 DOWNTO 0);
    an                       : OUT std_logic_vector(3 DOWNTO 0);
    seg                      : OUT std_logic_vector(6 DOWNTO 0);
    dp                       : OUT std_logic);
END MasterIO;

ARCHITECTURE Behavioral OF MasterIO IS
    SIGNAL rst  : std_logic;
    SIGNAL jump : std_logic;

    COMPONENT IOManager IS PORT (
        clk, rst, test : IN std_logic;
        rd, wr         : IN std_logic_vector(15 DOWNTO 0);
        led            : OUT std_logic_vector(15 DOWNTO 0);
        an             : OUT std_logic_vector(3 DOWNTO 0);
        seg            : OUT std_logic_vector(6 DOWNTO 0);
        dp             : OUT std_logic);
    END COMPONENT;

    COMPONENT FetchStage IS PORT (
        clk, rst, en, lod : IN std_logic;
        go_to             : IN std_logic_vector(7 DOWNTO 0);
        pipeline          : OUT pipe_line);
    END COMPONENT;

    SIGNAL fetch_out_pipe : pipe_line;
    SIGNAL decode_in_pipe : pipe_line;

    COMPONENT DecodeStage IS PORT (
        rst    : IN std_logic;
        pipin  : IN pipe_line;
        pipout : OUT pipe_line;
        jump   : OUT std_logic);
    END COMPONENT;

    SIGNAL decode_out_pipe : pipe_line;
    SIGNAL execute_in_pipe : pipe_line;

    COMPONENT ExecuteStage IS PORT (
        rst    : IN std_logic;
        pipin  : IN pipe_line;
        pipout : OUT pipe_line);
    END COMPONENT;

    SIGNAL execute_out_pipe : pipe_line;

BEGIN

    IO : IOManager PORT MAP(
        clk  => clk_100,
        rst  => rst,
        test => btnD,
        rd   => sw,
        wr   => x"0000",
        led  => led,
        an   => an,
        seg  => seg,
        dp   => dp);

    rst <= btnu;

    fetch : FetchStage PORT MAP(
        clk      => clk,
        rst      => rst,
        en       => '1',
        lod      => jump,
        go_to    => decode_in_pipe.first(7 DOWNTO 0),
        pipeline => fetch_out_pipe);

    decode : DecodeStage PORT MAP(
        rst    => rst,
        pipin  => decode_in_pipe,
        pipout => decode_out_pipe,
        jump   => jump);

    execute : ExecuteStage PORT MAP(
        rst    => rst,
        pipin  => execute_in_pipe,
        pipout => execute_out_pipe);

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