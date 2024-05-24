LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY assemblage IS
    PORT (
        clk : IN std_logic;
        rst : IN std_logic);
END assemblage;

ARCHITECTURE Behavioral OF assemblage IS
    COMPONENT Counter IS PORT (
        clk, rst     : IN std_logic;
        en, dir, lod : IN std_logic;
        a            : IN std_logic_vector (7 DOWNTO 0);
        s            : OUT std_logic_vector (7 DOWNTO 0));
    END COMPONENT;

    COMPONENT InstructionMemory IS PORT (
        cnt                      : IN std_logic_vector (7 DOWNTO 0);
        reg_a, reg_b, reg_s      : OUT std_logic_vector (3 DOWNTO 0);
        alu_code                 : OUT std_logic_vector (3 DOWNTO 0);
        number, data_addr        : OUT std_logic_vector (7 DOWNTO 0);
        data_wr, data_rd         : OUT std_logic;
        write_back, jump, branch : OUT std_logic);
    END COMPONENT;

    COMPONENT Registers IS PORT (
        rst            : IN std_logic;
        addr_a, addr_b : IN std_logic_vector (3 DOWNTO 0);
        val_a, val_b   : OUT std_logic_vector (7 DOWNTO 0);
        wr             : IN std_logic;
        addr_wr        : IN std_logic_vector (3 DOWNTO 0);
        val_wr         : IN std_logic_vector (7 DOWNTO 0));
    END COMPONENT;

    COMPONENT MuxCompteur IS
        PORT (
            jmpCondIN : IN std_logic;
            jmpIn     : IN std_logic;
            cond      : IN std_logic_vector (7 DOWNTO 0);
            jmpOut    : OUT std_logic);
    END COMPONENT;

    COMPONENT ALU IS PORT (
        cmd        : IN std_logic_vector (3 DOWNTO 0);
        a, b       : IN std_logic_vector (7 DOWNTO 0);
        s          : OUT std_logic_vector (7 DOWNTO 0);
        z, c, o, n : OUT std_logic);
    END COMPONENT;

    COMPONENT Memoire IS
        PORT (
            rst    : IN std_logic;
            write  : IN std_logic;
            read   : IN std_logic;
            add    : IN std_logic_vector (7 DOWNTO 0);
            input  : IN std_logic_vector (7 DOWNTO 0);
            output : OUT std_logic_vector (7 DOWNTO 0));
    END COMPONENT;

    SIGNAL sSensCompteur : std_logic;
    SIGNAL sLoadCompteur : std_logic;
    SIGNAL sDinCompteur  : std_logic_vector (7 DOWNTO 0);
    SIGNAL sDoutCompteur : std_logic_vector (7 DOWNTO 0);
    SIGNAL sENCompteur   : std_logic;

    SIGNAL sCntMI           : std_logic_vector (7 DOWNTO 0);
    SIGNAL sRegistre1MI     : std_logic_vector (3 DOWNTO 0);
    SIGNAL sRegistre2MI     : std_logic_vector (3 DOWNTO 0);
    SIGNAL sALUMI           : std_logic_vector (3 DOWNTO 0);
    SIGNAL sMemoryWriteMI   : std_logic;
    SIGNAL sMemoryReadMI    : std_logic;
    SIGNAL sMemoryAddressMI : std_logic_vector (7 DOWNTO 0);
    SIGNAL sLoadPCMI        : std_logic;
    SIGNAL sLoadComparePCMI : std_logic;
    SIGNAL sConstanteMI     : std_logic_vector (7 DOWNTO 0);
    SIGNAL sWriteBackMI     : std_logic;
    SIGNAL sWriteAddressMI  : std_logic_vector (3 DOWNTO 0);

    SIGNAL sWriteRegistre     : std_logic;
    SIGNAL sRead1Registre     : std_logic_vector (3 DOWNTO 0);
    SIGNAL sRead2Registre     : std_logic_vector (3 DOWNTO 0);
    SIGNAL sWrite_addRegistre : std_logic_vector (3 DOWNTO 0);
    SIGNAL sInputRegistre     : std_logic_vector (7 DOWNTO 0);
    SIGNAL sOutput1Registre   : std_logic_vector (7 DOWNTO 0);
    SIGNAL sOutput2Registre   : std_logic_vector (7 DOWNTO 0);

    SIGNAL sJmpCondINMux : std_logic;
    SIGNAL sJmpInMux     : std_logic;
    SIGNAL sCondMux      : std_logic_vector (7 DOWNTO 0);
    SIGNAL sjmpOutMux    : std_logic;

    SIGNAL sCMDALU : std_logic_vector (3 DOWNTO 0);
    SIGNAL sAALU   : std_logic_vector (7 DOWNTO 0);
    SIGNAL sBALU   : std_logic_vector (7 DOWNTO 0);
    SIGNAL sSALU   : std_logic_vector (7 DOWNTO 0);
    SIGNAL sZALU   : std_logic;
    SIGNAL sCALU   : std_logic;
    SIGNAL sOALU   : std_logic;
    SIGNAL sNALU   : std_logic;

    SIGNAL sWriteMemoire       : std_logic;
    SIGNAL sReadMemoire        : std_logic;
    SIGNAL sAddMemoire         : std_logic_vector (7 DOWNTO 0);
    SIGNAL sinputMemoire       : std_logic_vector (7 DOWNTO 0);
    SIGNAL soutputMemoire      : std_logic_vector (7 DOWNTO 0);
    SIGNAL sALUPipe1           : std_logic_vector (3 DOWNTO 0);
    SIGNAL sMemoryWritePipe1   : std_logic;
    SIGNAL sMemoryReadPipe1    : std_logic;
    SIGNAL sMemoryAddressPipe1 : std_logic_vector (7 DOWNTO 0);
    SIGNAL sLoadPCPipe1        : std_logic;
    SIGNAL sLoadComparePCPipe1 : std_logic;
    SIGNAL sConstantePipe1     : std_logic_vector (7 DOWNTO 0);
    SIGNAL sWriteBackPipe1     : std_logic;
    SIGNAL sWriteAddressPipe1  : std_logic_vector (3 DOWNTO 0);

    SIGNAL sMemoryWritePipe2   : std_logic;
    SIGNAL sMemoryReadPipe2    : std_logic;
    SIGNAL sMemoryAddressPipe2 : std_logic_vector (7 DOWNTO 0);
    SIGNAL sWriteBackPipe2     : std_logic;
    SIGNAL sWriteAddressPipe2  : std_logic_vector (3 DOWNTO 0);

    SIGNAL sWriteBackPipe3    : std_logic;
    SIGNAL sWriteAddressPipe3 : std_logic_vector (3 DOWNTO 0);

    SIGNAL flush : std_logic_vector (1 DOWNTO 0);

BEGIN
    Compteur : Counter PORT MAP(
        clk => clk,
        en  => sENCompteur,
        rst => rst,
        dir => sSensCompteur,
        lod => sLoadCompteur,
        a   => sDinCompteur,
        s   => sDoutCompteur
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

    RegistreProcesseur : Registers PORT MAP(
        rst     => rst,
        addr_a  => sRegistre1MI,
        addr_b  => sRegistre2MI,
        val_a   => sOutput1Registre,
        val_b   => sOutput2Registre,
        wr      => sWriteRegistre,
        addr_wr => sWrite_addRegistre,
        val_wr  => sInputRegistre
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

    sCntMI        <= sDoutCompteur;
    sSensCompteur <= '1';
    sENCompteur   <= '1';

    --pour etre sur que le calcule du jump se fera avant la clock du compteur
    sJmpCondINMux <= sLoadComparePCPipe1;
    sJmpINMux     <= sLoadPCPipe1;
    sCondMux      <= sOutput1Registre;
    flush         <= "00" WHEN rst = '1';

    PROCESS (clk)
    BEGIN
        IF (rising_edge (clk)) THEN
            sRead1Registre <= sRegistre1MI;
            sRead2Registre <= sRegistre2MI;

            sALUPipe1           <= sALUMI;
            sMemoryWritePipe1   <= sMemoryWriteMI;
            sMemoryReadPipe1    <= sMemoryReadMI;
            sMemoryAddressPipe1 <= sMemoryAddressMI;
            sLoadPCPipe1        <= sLoadPCMI;
            sLoadComparePCPipe1 <= sLoadComparePCMI;
            sConstantePipe1     <= sConstanteMI;
            sWriteBackPipe1     <= sWriteBackMI;
            sWriteAddressPipe1  <= sWriteAddressMI;

            IF (flush = "00") THEN
                sCMDALU <= sALUPipe1;
                sAALU   <= sOutput1Registre;
                sBALU   <= sOutput2Registre;

                sLoadCompteur <= sJmpOutMux;
                sDinCompteur  <= sConstantePipe1;

                IF (sJmpOutMux = '1') THEN
                    flush <= "10";
                END IF;
                sMemoryWritePipe2   <= sMemoryWritePipe1;
                sMemoryReadPipe2    <= sMemoryReadPipe1;
                sMemoryAddressPipe2 <= sMemoryAddressPipe1;
                sWriteBackPipe2     <= sWriteBackPipe1;
                sWriteAddressPipe2  <= sWriteAddressPipe1;

            ELSIF (flush = "10") THEN
                flush <= "01";
            ELSE
                flush <= "00";
            END IF;

            sReadMemoire  <= sMemoryReadPipe2;
            sAddMemoire   <= sMemoryAddressPipe2;
            sWriteMemoire <= sMemoryWritePipe2;
            sInputMemoire <= sSALU;

            sWriteBackPipe3    <= sWriteBackPipe2;
            sWriteAddressPipe3 <= sWriteAddressPipe2;

            sWrite_addRegistre <= sWriteAddressPipe3;
            sWriteRegistre     <= sWriteBackPipe3;
            sInputRegistre     <= sOutputMemoire;

        END IF;
    END PROCESS;
END Behavioral;