LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

ENTITY StoreStage IS PORT (
    rst    : IN std_logic;
    pipin  : IN pipe_line;
    pipout : OUT pipe_line);
END ENTITY StoreStage;

ARCHITECTURE StoreStage OF StoreStage IS
    COMPONENT DataMemory IS PORT (
        rst, wr      : IN std_logic;
        addr, val_in : IN std_logic_vector (7 DOWNTO 0);
        val_out      : OUT std_logic_vector (7 DOWNTO 0));
    END COMPONENT;

    SIGNAL wr : std_logic;
BEGIN
    wr <= '1' WHEN pipin.code = op_store ELSE
        '0';

    data : DataMemory PORT MAP(
        rst     => rst,
        wr      => wr,
        addr    => pipin.second,
        val_in  => pipin.first,
        val_out => pipout.first);

END ARCHITECTURE StoreStage;