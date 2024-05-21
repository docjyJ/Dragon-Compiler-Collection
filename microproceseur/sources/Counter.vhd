library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.ALL;
use IEEE.std_logic_unsigned.ALL;

entity Counter is
    Port (CLK: in STD_LOGIC;
          RST: in STD_LOGIC;
          DIR: in STD_LOGIC;
          LOD: in STD_LOGIC;
          Din: in STD_LOGIC_VECTOR (7 downto 0);
          Dout: out STD_LOGIC_VECTOR (7 downto 0);
          EN: in STD_LOGIC);
end Counter;

architecture Behavioral of Counter is
    signal mem: STD_LOGIC_VECTOR (7 downto 0);
begin
    process (clk) is
    begin
        if CLK = '1' and EN = '1' then
            if (RST = '1') then
                mem <= x"00";
            elsif (LOD = '1') then
                mem <= Din;
            elsif (DIR = '0') then
                mem <=   mem - 1;
            else
                mem <=   mem + 1;
            end if;
        end if;
    end process;

    Dout <= mem;

end Behavioral;
