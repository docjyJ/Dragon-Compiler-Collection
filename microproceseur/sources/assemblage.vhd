LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY assemblage IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC);
END assemblage;

ARCHITECTURE Behavioral OF assemblage IS
    COMPONENT Counter IS PORT (clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        dir : IN STD_LOGIC;
        load : IN STD_LOGIC;
        Din : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
        Dout : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
        EN : IN STD_LOGIC);
    END COMPONENT;

    SIGNAL sSensCompteur : STD_LOGIC;
    SIGNAL sLoadCompteur : STD_LOGIC;
    SIGNAL sDinCompteur : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sDoutCompteur : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sENCompteur : STD_LOGIC;
    COMPONENT InstructionMemory IS
        PORT (
            cnt        : IN STD_LOGIC_VECTOR (7 TO 0);
            reg_a      : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            reg_b      : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            alu_code   : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
            data_wr    : OUT STD_LOGIC;
            data_rd    : OUT STD_LOGIC;
            data_addr  : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            jump       : OUT STD_LOGIC;
            branch     : OUT STD_LOGIC;
            number     : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            write_back : OUT STD_LOGIC;
            reg_s      : OUT STD_LOGIC_VECTOR (3 DOWNTO 0));
    END COMPONENT;

    SIGNAL sCntMI : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sRegistre1MI : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL sRegistre2MI : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL sALUMI : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL sMemoryWriteMI : STD_LOGIC;
    SIGNAL sMemoryReadMI : STD_LOGIC;
    SIGNAL sMemoryAddressMI : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sLoadPCMI : STD_LOGIC;
    SIGNAL sLoadComparePCMI : STD_LOGIC;
    SIGNAL sConstanteMI : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sWriteBackMI : STD_LOGIC;
    SIGNAL sWriteAddressMI : STD_LOGIC_VECTOR (3 DOWNTO 0);
    COMPONENT Registre IS
        PORT (
            read1     : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            read2     : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            write_add : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            write     : IN STD_LOGIC;
            rst       : IN STD_LOGIC;
            input     : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            output1   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            output2   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
    END COMPONENT;

    SIGNAL sWriteRegistre : STD_LOGIC;
    SIGNAL sRead1Registre : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL sRead2Registre : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL sWrite_addRegistre : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL sInputRegistre : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sOutput1Registre : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sOutput2Registre : STD_LOGIC_VECTOR (7 DOWNTO 0);
    COMPONENT MuxCompteur IS
        PORT (
            jmpCondIN : IN STD_LOGIC;
            jmpIn     : IN STD_LOGIC;
            cond      : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            jmpOut    : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL sJmpCondINMux : STD_LOGIC;
    SIGNAL sJmpInMux : STD_LOGIC;
    SIGNAL sCondMux : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sjmpOutMux : STD_LOGIC;
    COMPONENT ALU IS
        PORT (
            CMD : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            A   : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            B   : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            S   : OUT STD_LOGIC_VECTOR (7 DOWNTO 0);
            Z   : OUT STD_LOGIC;
            C   : OUT STD_LOGIC;
            O   : OUT STD_LOGIC;
            N   : OUT STD_LOGIC);
    END COMPONENT;

    SIGNAL sCMDALU : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL sAALU : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sBALU : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sSALU : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sZALU : STD_LOGIC;
    SIGNAL sCALU : STD_LOGIC;
    SIGNAL sOALU : STD_LOGIC;
    SIGNAL sNALU : STD_LOGIC;
    COMPONENT Memoire IS
        PORT (
            rst    : IN STD_LOGIC;
            write  : IN STD_LOGIC;
            read   : IN STD_LOGIC;
            add    : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            input  : IN STD_LOGIC_VECTOR (7 DOWNTO 0);
            output : OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
    END COMPONENT;

    SIGNAL sWriteMemoire : STD_LOGIC;
    SIGNAL sReadMemoire : STD_LOGIC;
    SIGNAL sAddMemoire : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sinputMemoire : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL soutputMemoire : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sALUPipe1 : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL sMemoryWritePipe1 : STD_LOGIC;
    SIGNAL sMemoryReadPipe1 : STD_LOGIC;
    SIGNAL sMemoryAddressPipe1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sLoadPCPipe1 : STD_LOGIC;
    SIGNAL sLoadComparePCPipe1 : STD_LOGIC;
    SIGNAL sConstantePipe1 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sWriteBackPipe1 : STD_LOGIC;
    SIGNAL sWriteAddressPipe1 : STD_LOGIC_VECTOR (3 DOWNTO 0);

    SIGNAL sMemoryWritePipe2 : STD_LOGIC;
    SIGNAL sMemoryReadPipe2 : STD_LOGIC;
    SIGNAL sMemoryAddressPipe2 : STD_LOGIC_VECTOR (7 DOWNTO 0);
    SIGNAL sWriteBackPipe2 : STD_LOGIC;
    SIGNAL sWriteAddressPipe2 : STD_LOGIC_VECTOR (3 DOWNTO 0);

    SIGNAL sWriteBackPipe3 : STD_LOGIC;
    SIGNAL sWriteAddressPipe3 : STD_LOGIC_VECTOR (3 DOWNTO 0);

    SIGNAL flush : STD_LOGIC_VECTOR (1 DOWNTO 0);

BEGIN
    Compteur : Counter PORT MAP(
        clk  => clk,
        rst  => rst,
        dir => sSensCompteur,
        load => sLoadCompteur,
        Din  => sDinCompteur,
        Dout => sDoutCompteur,
        EN   => sENCompteur
    );

    Translateur : InstructionMemory PORT MAP(
        cnt        => sCntMI,
        reg_a      => sRegistre1MI,
        reg_b      => sRegistre2MI,
        alu_code   => sALUMI,
        data_wr    => sMemoryWriteMI,
        data_rd    => sMemoryReadMI,
        data_addr  => sMemoryAddressMI,
        jump       => sLoadPCMI,
        branch     => sLoadComparePCMI,
        number     => sConstanteMI,
        write_back => sWriteBackMI,
        reg_s      => sWriteAddressMI
    );

    RegistreProcesseur : Registre PORT MAP(
        rst       => rst,
        write     => sWriteRegistre,
        read1     => sRead1Registre,
        read2     => sRead2Registre,
        write_add => sWrite_addRegistre,
        input     => sInputRegistre,
        output1   => sOutput1Registre,
        output2   => sOutput2Registre
    );

    Mux : MuxCompteur PORT MAP(
        jmpCondIN => sJmpCondINMux,
        jmpIn     => sJmpINMux,
        cond      => sCondMux,
        jmpOut    => sJmpOutMux
    );

    ALUProcesseur : ALU PORT MAP(
        CMD => sCMDALU,
        A   => sAALU,
        B   => sBALU,
        S   => sSALU,
        Z   => sZALU,
        C   => sCALU,
        O   => sOALU,
        N   => sNALU
    );

    MemoireDonne : Memoire PORT MAP(
        rst    => rst,
        read   => sReadMemoire,
        add    => sAddMemoire,
        write  => sWriteMemoire,
        input  => sInputMemoire,
        output => sOutputMemoire
    );

    sCntMI <= sDoutCompteur;
    sSensCompteur <= '1';
    sENCompteur <= '1';

    --pour etre sur que le calcule du jump se fera avant la clock du compteur
    sJmpCondINMux <= sLoadComparePCPipe1;
    sJmpINMux <= sLoadPCPipe1;
    sCondMux <= sOutput1Registre;
    flush <= "00" WHEN rst = '1';

    PROCESS (clk)
    BEGIN
        IF (rising_edge (clk)) THEN
            sRead1Registre <= sRegistre1MI;
            sRead2Registre <= sRegistre2MI;

            sALUPipe1 <= sALUMI;
            sMemoryWritePipe1 <= sMemoryWriteMI;
            sMemoryReadPipe1 <= sMemoryReadMI;
            sMemoryAddressPipe1 <= sMemoryAddressMI;
            sLoadPCPipe1 <= sLoadPCMI;
            sLoadComparePCPipe1 <= sLoadComparePCMI;
            sConstantePipe1 <= sConstanteMI;
            sWriteBackPipe1 <= sWriteBackMI;
            sWriteAddressPipe1 <= sWriteAddressMI;

            IF (flush = "00") THEN
                sCMDALU <= sALUPipe1;
                sAALU <= sOutput1Registre;
                sBALU <= sOutput2Registre;

                sLoadCompteur <= sJmpOutMux;
                sDinCompteur <= sConstantePipe1;

                IF (sJmpOutMux = '1') THEN
                    flush <= "10";
                END IF;
                sMemoryWritePipe2 <= sMemoryWritePipe1;
                sMemoryReadPipe2 <= sMemoryReadPipe1;
                sMemoryAddressPipe2 <= sMemoryAddressPipe1;
                sWriteBackPipe2 <= sWriteBackPipe1;
                sWriteAddressPipe2 <= sWriteAddressPipe1;

            ELSIF (flush = "10") THEN
                flush <= "01";
            ELSE
                flush <= "00";
            END IF;

            sReadMemoire <= sMemoryReadPipe2;
            sAddMemoire <= sMemoryAddressPipe2;
            sWriteMemoire <= sMemoryWritePipe2;
            sInputMemoire <= sSALU;

            sWriteBackPipe3 <= sWriteBackPipe2;
            sWriteAddressPipe3 <= sWriteAddressPipe2;

            sWrite_addRegistre <= sWriteAddressPipe3;
            sWriteRegistre <= sWriteBackPipe3;
            sInputRegistre <= sOutputMemoire;

        END IF;
    END PROCESS;
END Behavioral;
