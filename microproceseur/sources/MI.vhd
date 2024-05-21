----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/03/2024 01:25:13 PM
-- Design Name: 
-- Module Name: MI - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MI is
    Port ( cnt : in STD_LOGIC_VECTOR (7 to 0);
           --cnt : in STD_LOGIC_VECTOR (31 downto 0);
           Registre1 : out STD_LOGIC_VECTOR (3 downto 0);
           Registre2 :out STD_LOGIC_VECTOR (3 downto 0); 
           ALU : out STD_LOGIC_VECTOR (3 downto 0);
           MemoryWrite : out STD_LOGIC;
           MemoryRead : out STD_LOGIC;
           MemoryAddress : out STD_LOGIC_VECTOR (7 downto 0);                      
           LoadPC : out STD_LOGIC;
           LoadComparePC : out STD_LOGIC;
           Constante : out STD_LOGIC_VECTOR (7 downto 0); 
           WriteBack : out STD_LOGIC;
           WriteAddress : out STD_LOGIC_VECTOR (3 downto 0));

end MI;

architecture Behavioral of MI is
    constant op_add :           std_logic_vector (7 downto 0) := x"01";
    constant op_multiply :      std_logic_vector (7 downto 0) := x"02";
    constant op_subtract :      std_logic_vector (7 downto 0) := x"03";
    constant op_divide :        std_logic_vector (7 downto 0) := x"04";
    constant op_copy :          std_logic_vector (7 downto 0) := x"05";
    constant op_define :        std_logic_vector (7 downto 0) := x"06";
    constant op_jump :          std_logic_vector (7 downto 0) := x"07";
    constant op_branch :        std_logic_vector (7 downto 0) := x"08";
    constant op_lower_than :    std_logic_vector (7 downto 0) := x"09";
    constant op_greater_than :  std_logic_vector (7 downto 0) := x"0A";
    constant op_equal_to :      std_logic_vector (7 downto 0) := x"0B";
    constant op_display :       std_logic_vector (7 downto 0) := x"0C";
    constant op_load :          std_logic_vector (7 downto 0) := x"10";
    constant op_store :         std_logic_vector (7 downto 0) := x"11";
    constant op_negate :        std_logic_vector (7 downto 0) := x"30";
    constant op_modulo :        std_logic_vector (7 downto 0) := x"31";
    constant op_bitwise_and :   std_logic_vector (7 downto 0) := x"50";
    constant op_bitwise_or :    std_logic_vector (7 downto 0) := x"51";
    constant op_bitwise_not :   std_logic_vector (7 downto 0) := x"52";
    constant op_bitwise_xor :   std_logic_vector (7 downto 0) := x"53";

    type ttab is array (255 downto 0) of std_logic_vector (31 downto 0);
    signal mem_inst : ttab;
    
    signal inst : std_logic_vector (31 downto 0);
    signal op_code : std_logic_vector (7 downto 0);
begin
    inst <= mem_inst(conv_integer(cnt));
    --inst <= cnt;
    
    mem_inst(1) <= x"01020304";
    mem_inst(2) <= x"07060304";
    mem_inst(3) <= x"090A0309";
    mem_inst(4) <= x"50010105";
    
    op_code <= inst(31 downto 24);
    
    with op_code select
        ALU <= "1100" when op_add,
                "1110" when op_multiply,
                "1101" when op_subtract,
                "1111" when op_divide,
                "0101" when op_equal_to,
                "1101" when op_negate,
                "0010" when op_bitwise_and,
                "0000" when op_bitwise_or,
                "0001" when op_bitwise_not,
                "0100" when op_bitwise_xor,
              (others => '1') when others;
              
    
    MemoryAddress <= inst(23 downto 16);
    MemoryWrite <= '1' when op_code = op_store else '0';
    MemoryRead <= '1' when op_code = op_load else '0';
    
    with op_code select                       
        WriteBack <= '1' when  op_add | op_multiply | op_subtract | op_divide |
                            op_copy | op_define | op_negate | op_modulo | op_bitwise_and |
                            op_bitwise_or | op_bitwise_not | op_bitwise_xor,
                     '0' when others;
    
    Registre1 <= inst(19 downto 16) when op_code = op_display else inst(11 downto 8);
    Registre2 <= inst(3 downto 0);
    WriteAddress <= inst(19 downto 16);
    
    with op_code select                       
        Constante <= inst(23 downto 16) when  op_jump | op_branch, 
                     inst(15 downto 8) when  op_define, 
                     (others => '1') when others;
    
    LoadPC <= '1' when op_code = op_jump else '0';
    LoadComparePC <= '1' when op_code = op_branch else '0';
    

end Behavioral;
