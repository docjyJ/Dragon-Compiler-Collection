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
    signal CLK2: STD_LOGIC;
    signal D0: STD_LOGIC_VECTOR(7 downto 0);
    signal D1: STD_LOGIC_VECTOR(7 downto 0);
    signal D2: STD_LOGIC_VECTOR(7 downto 0);
begin
    RST <= BTNU;
    EN <= SW(0);
    DIR <= SW(1);
    D0 <= (others => '0');
    CLK2 <= D1(7);
    LD(7 downto 0) <= D1;
    LD(15 downto 8) <= D2; 

    counter0: Counter port map(CLK, RST, DIR, BTNL, D0, D1, EN);
    counter1: Counter port map(CLK2, RST, DIR, BTNR, D0, D2, EN);

end Behavioral;
