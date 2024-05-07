
LIBRARY ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
-- 153 cells
-- 33 io port
-- 172 net

entity Registre is
    Port ( rst : in STD_LOGIC;
           write : in STD_LOGIC;
           read1 : in STD_LOGIC_VECTOR (3 downto 0);
           read2 : in STD_LOGIC_VECTOR (3 downto 0);
           write_add : in STD_LOGIC_VECTOR (3 downto 0);
           input : in STD_LOGIC_VECTOR (7 downto 0);
           output1 : out STD_LOGIC_VECTOR (7 downto 0);
           output2 : out STD_LOGIC_VECTOR (7 downto 0));
end Registre;

architecture Behavioral of Registre is

type ttab is array (0 to 15) of std_logic_vector (7 downto 0);

signal reg : ttab;

begin
   
    output2 <= reg(conv_integer(read2));
    output1 <= reg(conv_integer(read1));
    
     
    process (write)
    begin
        if rst='1' then
            reg <= (others => (others => '0'));
        elsif write='1' then
             reg(conv_integer(write_add)) <= input;
        end if;
     end process;    

end Behavioral;
