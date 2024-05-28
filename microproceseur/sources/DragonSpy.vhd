LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE WORK.DRAGON.ALL;

PACKAGE DragonSpy IS
    -- synthesis translate_off
    TYPE ttab IS ARRAY (0 TO 15) OF std_logic_vector (7 DOWNTO 0);
    SIGNAL spy_registers                              : ttab;
    SIGNAL spy_pipe1, spy_pipe2, spy_pipe3, spy_pipe4 : pipe_line;
    SIGNAL spy_pc, spy_jump_addr                      : std_logic_vector(7 DOWNTO 0);
    SIGNAL spy_jump, spy_aller                        : std_logic;
    -- synthesis translate_on
END PACKAGE;