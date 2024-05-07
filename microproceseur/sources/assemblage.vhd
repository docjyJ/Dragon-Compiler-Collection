----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/07/2024 09:35:01 AM
-- Design Name: 
-- Module Name: assemblage - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity assemblage is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC);
end assemblage;

architecture Behavioral of assemblage is
    component conteur8bit is Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sens : in STD_LOGIC;
           load : in STD_LOGIC;
           Din : in STD_LOGIC_VECTOR (7 downto 0);
           Dout : out STD_LOGIC_VECTOR (7 downto 0);
           EN : in STD_LOGIC);
    end component;

    signal      sSensCompteur :  STD_LOGIC;
    signal      sLoadCompteur :  STD_LOGIC;
    signal      sDinCompteur :  STD_LOGIC_VECTOR (7 downto 0);
    signal      sDoutCompteur :  STD_LOGIC_VECTOR (7 downto 0);
    signal      sENCompteur :  STD_LOGIC;


    component  MI is
    Port ( cnt : in STD_LOGIC_VECTOR (7 downto 0);
           Registre1 : out STD_LOGIC_VECTOR (7 downto 0);
           Registre2 :out STD_LOGIC_VECTOR (7 downto 0); 
           ALU : out STD_LOGIC_VECTOR (3 downto 0);
           MemoryWrite : out STD_LOGIC;
           MemoryRead : out STD_LOGIC;
           MemoryAddress : out STD_LOGIC_VECTOR (7 downto 0);                      
           LoadPC : out STD_LOGIC;
           LoadComparePC : out STD_LOGIC;
           Constante : out STD_LOGIC_VECTOR (7 downto 0); 
           WriteBack : out STD_LOGIC;
           WriteAddress : out STD_LOGIC_VECTOR (7 downto 0));
    end component ;
    
    signal sCntMI :  STD_LOGIC_VECTOR (7 downto 0);
    signal sRegistre1MI : STD_LOGIC_VECTOR (7 downto 0);
    signal sRegistre2MI : STD_LOGIC_VECTOR (7 downto 0); 
    signal sALUMI :  STD_LOGIC_VECTOR (3 downto 0);
    signal sMemoryWriteMI :  STD_LOGIC;
    signal sMemoryReadMI :  STD_LOGIC;
    signal sMemoryAddressMI :  STD_LOGIC_VECTOR (7 downto 0);                      
    signal sLoadPCMI :  STD_LOGIC;
    signal sLoadComparePCMI :  STD_LOGIC;
    signal sConstanteMI :  STD_LOGIC_VECTOR (7 downto 0); 
    signal sWriteBackMI :  STD_LOGIC;
    signal sWriteAddressMI :  STD_LOGIC_VECTOR (7 downto 0);


    component Registre is
    Port ( read1 : in STD_LOGIC_VECTOR (3 downto 0);
           read2 : in STD_LOGIC_VECTOR (3 downto 0);
           write_add : in STD_LOGIC_VECTOR (3 downto 0);
           write : in STD_LOGIC;
           rst : in STD_LOGIC;
           input : in STD_LOGIC_VECTOR (7 downto 0);
           output1 : out STD_LOGIC_VECTOR (7 downto 0);
           output2 : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal  sWriteRegistre   :    std_logic;
    signal  sRead1Registre  :    STD_LOGIC_VECTOR (3 downto 0);
    signal  sRead2Registre  :    STD_LOGIC_VECTOR (3 downto 0);
    signal  sWrite_addRegistre  :    STD_LOGIC_VECTOR (3 downto 0);
    signal  sInputRegistre   :    STD_LOGIC_VECTOR (7 downto 0);
    signal  sOutput1Registre :    STD_LOGIC_VECTOR (7 downto 0);
    signal  sOutput2Registre :    STD_LOGIC_VECTOR (7 downto 0);
    
    
    component MuxCompteur is
    Port ( jmpCondIN : in STD_LOGIC;
           jmpIn : in STD_LOGIC;
           cond : in STD_LOGIC_VECTOR (7 downto 0);
           jmpOut : out STD_LOGIC);
    end component;
    
    signal  sJmpCondINMux   :    std_logic;
    signal  sJmpInMux    :    std_logic;
    signal  sCondMux    :    STD_LOGIC_VECTOR (7 downto 0);
    signal  sjmpOutMux    :    std_logic;
    
    
    component ALU is
    Port ( CMD : in STD_LOGIC_VECTOR (3 downto 0);
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           S : out STD_LOGIC_VECTOR (7 downto 0);
           Z : out STD_LOGIC;
           C : out STD_LOGIC;
           O : out STD_LOGIC;
           N : out STD_LOGIC);
    end component;
    
    signal sCMDALU : STD_LOGIC_VECTOR (3 downto 0);
    signal sAALU : STD_LOGIC_VECTOR (7 downto 0);
    signal sBALU : STD_LOGIC_VECTOR (7 downto 0);
    signal sSALU : STD_LOGIC_VECTOR (7 downto 0);
    signal sZALU : STD_LOGIC;
    signal sCALU : STD_LOGIC;
    signal sOALU : STD_LOGIC;
    signal sNALU : STD_LOGIC;
    
    
    component Memoire is
    Port ( rst : in STD_LOGIC;
           write : in STD_LOGIC;
           read : in STD_LOGIC;
           add : in STD_LOGIC_VECTOR (7 downto 0);
           input : in STD_LOGIC_VECTOR (7 downto 0);
           output : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    signal  sWriteMemoire   :    std_logic;
    signal  sReadMemoire    :    std_logic;
    signal  sAddMemoire     :    STD_LOGIC_VECTOR (7 downto 0);
    signal  sinputMemoire   :    STD_LOGIC_VECTOR (7 downto 0);
    signal  soutputMemoire  :    STD_LOGIC_VECTOR (7 downto 0);
    

    signal sALUPipe1 :  STD_LOGIC_VECTOR (3 downto 0);
    signal sMemoryWritePipe1 :  STD_LOGIC;
    signal sMemoryReadPipe1 :  STD_LOGIC;
    signal sMemoryAddressPipe1 :  STD_LOGIC_VECTOR (7 downto 0);                      
    signal sLoadPCPipe1 :  STD_LOGIC;
    signal sLoadComparePCPipe1 :  STD_LOGIC;
    signal sConstantePipe1 :  STD_LOGIC_VECTOR (7 downto 0); 
    signal sWriteBackPipe1 :  STD_LOGIC;
    signal sWriteAddressPipe1 :  STD_LOGIC_VECTOR (7 downto 0);
    
    signal sMemoryWritePipe2 :  STD_LOGIC;
    signal sMemoryReadPipe2 :  STD_LOGIC;
    signal sMemoryAddressPipe2 :  STD_LOGIC_VECTOR (7 downto 0);                      
    signal sWriteBackPipe2 :  STD_LOGIC;
    signal sWriteAddressPipe2 :  STD_LOGIC_VECTOR (7 downto 0);
    
    signal sWriteBackPipe3 :  STD_LOGIC;
    signal sWriteAddressPipe3 :  STD_LOGIC_VECTOR (7 downto 0);
    
begin
    Compteur : conteur8bit port Map  (
        clk =>clk,
        rst => rst,
        sens => sSensCompteur,
        load => sLoadCompteur,
        Din => sDinCompteur,
        Dout => sDoutCompteur,
        EN => sENCompteur
    );

    Translateur: Mi port map (
        cnt => sCntMI,
        Registre1 => sRegistre1MI,
        Registre2 => sRegistre2MI,
        ALU => sALUMI,
        MemoryWrite => sMemoryWriteMI,
        MemoryRead => sMemoryReadMI,
        MemoryAddress => sMemoryAddressMI,
        LoadPC => sLoadPCMI,
        LoadComparePC => sLoadComparePCMI,
        Constante => sConstanteMI,
        WriteBack => sWriteBackMI,
        WriteAddress => sWriteAddressMI
    );
    
    RegistreProcesseur : Registre port map(
        rst => rst,
        write => sWriteRegistre,
        read1 => sRead1Registre, 
        read2 => sRead2Registre, 
        write_add => sWrite_addRegistre, 
        input => sInputRegistre,
        output1 => sOutput1Registre,
        output2 => sOutput2Registre
    );
    
    Mux : MuxCompteur port map(
        jmpCondIN => sJmpCondINMux,
        jmpIn => sJmpINMux,
        cond => sCondMux,
        jmpOut => sJmpOutMux
    );
     
     ALUProcesseur: ALU port map (
        CMD => sCMDALU,
        A => sAALU,
        B => sBALU,
        S => sSALU,
        Z => sZALU,
        C => sCALU,
        O => sOALU,
        N => sNALU
     );
     
     MemoireDonne : Memoire port map(
        rst => rst,
        read => sReadMemoire,
        add => sAddMemoire,
        write => sWriteMemoire, 
        input => sInputMemoire, 
        output => sOutputMemoire
     );

    sCntMI <= sDoutCompteur; 
    --pour etre sur que le calcule du jump se fera avant la clock du compteur
    sJmpCondINMux <= sLoadComparePCPipe1;
    sJmpINMux <= sLoadPCPipe1;
    sCondMux <= sOutput1Registre;
    
    
    process (clk)
    begin
        sRead1Registre <= sRegistre1MI;
        sRead2Registre <= sRegistre2MI;
        
        sALUPipe1 <= sALUMI;
        sMemoryWritePipe1 <= sMemoryWriteMI;
        sMemoryReadPipe1 <= sMemoryReadMI;
        sMemoryAddressPipe1 <= sMemoryAddressMI;
        sLoadPCPipe1 <= sLoadPCMI;
        sLoadComparePCPipe1 <= sLoadComparePCMI;
        sConstantePipe1 <= sConstanteMI;
        sWriteBackPipe1<= sWriteBackMI;
        sWriteAddressPipe1 <= sWriteAddressMI;
        
        --TODO : vider le pip de 1
        sCMDALU <= sALUPipe1;
        sAALU <= sOutput1Registre;
        sBALU <= sOutput2Registre;        
        
        sLoadCompteur <= sJmpOutMux;
        sDinCompteur <= sConstantePipe1;
        
        sMemoryWritePipe2 <= sMemoryWritePipe1;
        sMemoryReadPipe2 <= sMemoryReadPipe1;
        sMemoryAddressPipe2 <= sMemoryAddressPipe1;
        sWriteBackPipe2<= sWriteBackPipe1;
        sWriteAddressPipe2 <= sWriteAddressPipe1;
        
        sReadMemoire <= sMemoryReadPipe2 ;
        sAddMemoire <= sMemoryAddressPipe2;
        sWriteMemoire <= sMemoryWritePipe2;
        sInputMemoire <= sSALU;
        
        sWriteBackPipe3 <= sWriteBackPipe2;
        sWriteAddressPipe3 <= sWriteAddressPipe2;
        
        sWrite_addRegistre <= sWriteAddressPipe3;
        sWriteRegistre <= sWriteBackPipe3;
        sInputRegistre <= sOutputMemoire;
        
    end process;
end Behavioral;
