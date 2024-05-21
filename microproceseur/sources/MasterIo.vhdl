LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;

entity MasterIO is
    Port (CLK: in STD_LOGIC;
          BTNL: in STD_LOGIC;
          BTNR: in STD_LOGIC;
          BTNU: in STD_LOGIC;
          BTND: in STD_LOGIC;
          SW: in STD_LOGIC_VECTOR(15 downto 0);
          LD: out STD_LOGIC_VECTOR(15 downto 0);
          AN: out STD_LOGIC_VECTOR(7 downto 0);
          C: out STD_LOGIC_VECTOR(6 downto 0);
          DP: out STD_LOGIC);
end MasterIO;

architecture Behavioral of MasterIO is
    component Counter is
        Port (CLK: in STD_LOGIC;
              RST: in STD_LOGIC;
              DIR: in STD_LOGIC;
              LOD: in STD_LOGIC;
              Din: in STD_LOGIC_VECTOR (7 downto 0);
              Dout: out STD_LOGIC_VECTOR (7 downto 0);
              EN: in STD_LOGIC);
    end component;

    signal RST: STD_LOGIC;
    signal DIR: STD_LOGIC;
    signal EN: STD_LOGIC;
    signal Din: STD_LOGIC_VECTOR(7 downto 0);
begin
    RST <= BTNU;
    EN <= SW(0);
    DIR <= SW(1);
    Din <= (others => '0');

    counter0: Counter port map(CLK, RST, DIR, BTNL, Din, LD(7 downto 0), EN);
    counter1: Counter port map(LD(7), RST, DIR, BTNR, Din, LD(15 downto 8), EN);

end Behavioral;
