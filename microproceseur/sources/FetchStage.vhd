LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY FetchStage IS PORT (
    clk, rst, en, lod : IN std_logic;
    go_to_address     : IN std_logic_vector(7 DOWNTO 0);
    instruction       : OUT std_logic_vector(7 DOWNTO 0));
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

    SIGNAL pc : std_logic_vector(7 DOWNTO 0);
BEGIN
    program_counter : Counter PORT MAP(
        clk => clk,
        rst => rst,
        en  => en,
        dir => '1',
        lod => lod,
        a   => go_to_address,
        s   => pc);

    instruction_memory : InstructionMemory PORT MAP(
        addr => pc,
        data => instruction);
END ARCHITECTURE behavioral;
