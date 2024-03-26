library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RegisterBank is
    Port (
        read1: in STD_LOGIC_VECTOR (2 downto 0);
        read2: in STD_LOGIC_VECTOR (2 downto 0);
        write: in STD_LOGIC_VECTOR (2 downto 0);
        input: in STD_LOGIC_VECTOR (7 downto 0);
        output1: out STD_LOGIC_VECTOR (7 downto 0);
        output2: out STD_LOGIC_VECTOR (7 downto 0)
    );
end RegisterBank;

architecture Behavioral of RegisterBank is

    type ttab is array (15 downto 0) of std_logic_vector (7 downto 0);

    signal reg : ttab;
begin
    process (read1,write)
    begin
        if read1 = write_add and write ='1' then
            output1 <= input;
        else
            output1 <= reg(to_integer( unsigned(read1)));
        end if;
    end process;

     process (read2,write)
     begin
        if read2 = write_add and write ='1' then
            output2 <= input;
        else
            output2 <= reg(to_integer( unsigned(read2)));
        end if;
    end process;

    process (write)
    begin
        reg(to_integer( unsigned(write_add))) <= input;
    end process;

end Behavioral;