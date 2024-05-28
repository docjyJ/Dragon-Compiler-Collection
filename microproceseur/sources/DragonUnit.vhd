LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;
USE WORK.DRAGONSPY.ALL;

ENTITY DragonUnit IS PORT (
    clk, btnL, btnR  : IN std_logic;
    btnU, btnD, btnC : IN std_logic;
    sw               : IN std_logic_vector(15 DOWNTO 0);
    led              : OUT std_logic_vector(15 DOWNTO 0);
    an               : OUT std_logic_vector(3 DOWNTO 0);
    seg              : OUT std_logic_vector(6 DOWNTO 0);
    dp               : OUT std_logic);
END ENTITY;

ARCHITECTURE Behavioral OF DragonUnit IS
    SIGNAL rst, jump, en, data : std_logic;
    SIGNAL io_output : std_logic_vector(15 DOWNTO 0);

    COMPONENT DigitalIO IS PORT (
        clk, rst, test, mode : IN std_logic;
        rd, wr               : IN std_logic_vector(15 DOWNTO 0);
        led                  : OUT std_logic_vector(15 DOWNTO 0);
        an                   : OUT std_logic_vector(3 DOWNTO 0);
        seg                  : OUT std_logic_vector(6 DOWNTO 0);
        dp                   : OUT std_logic);
    END COMPONENT;

    COMPONENT FetchStage IS PORT (
        clk, rst, en, lod : IN std_logic;
        go_to             : IN std_logic_vector(7 DOWNTO 0);
        pipeline          : OUT pipe_line);
    END COMPONENT;

    SIGNAL fetch_out_pipe : pipe_line;
    SIGNAL decode_in_pipe : pipe_line;

    COMPONENT DecodeStage IS PORT (
        clk, rst     : IN std_logic;
        pipin, pipwr : IN pipe_line;
        pipout       : OUT pipe_line;
        jump         : OUT std_logic);
    END COMPONENT;

    SIGNAL decode_out_pipe : pipe_line;
    SIGNAL execute_in_pipe : pipe_line;

    COMPONENT ExecuteStage IS PORT (
        clk, rst  : IN std_logic;
        io_input  : IN std_logic_vector(15 DOWNTO 0);
        io_output : OUT std_logic_vector(15 DOWNTO 0);
        pipin     : IN pipe_line;
        pipout    : OUT pipe_line);
    END COMPONENT;

    SIGNAL execute_out_pipe : pipe_line;
    SIGNAL store_in_pipe    : pipe_line;

    COMPONENT StoreStage IS PORT (
        clk, rst : IN std_logic;
        pipin    : IN pipe_line;
        pipout   : OUT pipe_line);
    END COMPONENT;

    SIGNAL store_out_pipe : pipe_line;
    SIGNAL back_in_pipe   : pipe_line;
BEGIN
    -- synthesis translate_off
    spy_pipe1     <= decode_in_pipe;
    spy_pipe2     <= execute_in_pipe;
    spy_pipe3     <= store_in_pipe;
    spy_pipe4     <= back_in_pipe;
    spy_jump      <= jump;
    spy_jump_addr <= decode_out_pipe.first;
    -- synthesis translate_on
    data <= '1' WHEN ((fetch_out_pipe.first = decode_out_pipe.output 
                OR fetch_out_pipe.second = decode_out_pipe.output) 
                AND (have_write_back(decode_out_pipe.code)='1')) 
    
                OR ((fetch_out_pipe.first = execute_out_pipe.output 
                OR fetch_out_pipe.second = execute_out_pipe.output ) 
                AND (have_write_back(execute_out_pipe.code)='1')) 
                
                ELSE '0';
    -- aléa data 
    
    
    rst <= btnu;

    IO : DigitalIO PORT MAP(
        clk  => clk,
        rst  => rst,
        test => btnD,
        mode => btnL,
        rd   => sw,
        wr   => io_output,
        led  => led,
        an   => an,
        seg  => seg,
        dp   => dp);

    fetch : FetchStage PORT MAP(
        clk      => clk,
        rst      => rst,
        en       => en,
        lod      => jump,
        go_to    => decode_out_pipe.first,
        pipeline => fetch_out_pipe);

    decode : DecodeStage PORT MAP(
        clk    => clk,
        rst    => rst,
        pipin  => decode_in_pipe,
        pipout => decode_out_pipe,
        pipwr  => back_in_pipe,
        jump   => jump);

    execute : ExecuteStage PORT MAP(
        clk       => clk,
        rst       => rst,
        io_input  => sw,
        io_output => io_output,
        pipin     => execute_in_pipe,
        pipout    => execute_out_pipe);

    store : StoreStage PORT MAP(
        clk    => clk,
        rst    => rst,
        pipin  => store_in_pipe,
        pipout => store_out_pipe);

    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            decode_in_pipe  <= (OTHERS => (OTHERS => '0'));
            execute_in_pipe <= (OTHERS => (OTHERS => '0'));
            store_in_pipe   <= (OTHERS => (OTHERS => '0'));
            back_in_pipe    <= (OTHERS => (OTHERS => '0'));
        ELSIF rising_edge(clk) THEN
            IF jump = '1' THEN
                decode_in_pipe <= (OTHERS => (OTHERS => '0'));
            ELSE
                decode_in_pipe <= fetch_out_pipe;
            END IF;
            
            IF (data='1') THEN
                decode_in_pipe <= (OTHERS => (OTHERS => '0'));
                en <='0';
            ELSE         
                en <='1';
                execute_in_pipe <= decode_out_pipe;
            END IF;
            
            store_in_pipe   <= execute_out_pipe;
            back_in_pipe    <= store_out_pipe;
        END IF;

    END PROCESS;

END ARCHITECTURE;