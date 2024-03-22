library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Counter is
    Port (
        CLK: in std_logic;
        RST: in std_logic;
        LOAD: in std_logic;
        SENS: in std_logic;
        EN: in std_logic;
        DI: in std_logic_vector (7 downto 0);
        DO: out std_logic_vector (7 downto 0)
    );
end Counter;

architecture Behavioral of Counter is
    signal count: std_logic_vector (7 downto 0);
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RST = '0' then
                count <= (others => '0');
            elsif LOAD = '1' then
                count <= DI;
            elsif EN = '1' then
                if SENS = '0' then
                    count <= count + 1;
                else
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;
    DO <= count;
end Behavioral;