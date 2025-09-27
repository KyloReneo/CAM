LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE WORK.CAM_PKG.ALL;

ENTITY CAM_TB IS
END CAM_TB;

ARCHITECTURE BEHAV OF CAM_TB IS

    -- COMPONENT DECLARATION OF THE UNIT UNDER TEST (UUT)
    COMPONENT CAM
        PORT(
            UNI_CLK     : IN  STD_LOGIC;
	    UNI_RST     : IN  STD_LOGIC;
	    UNI_KEY_IN  : IN  STD_LOGIC_VECTOR(KEY_IN_SIZE - 1 DOWNTO 0);
	    UNI_WR_EN   : IN  STD_LOGIC;
	    INPUT_DATA  : IN  STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
	    HIT         : OUT STD_LOGIC;
	    OUTPUT_DATA : OUT STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

    -- SIGNALS TO CONNECT TO UUT
    SIGNAL CLK         : STD_LOGIC := '0';
    SIGNAL RST         : STD_LOGIC := '1';
    SIGNAL KEY_IN      : STD_LOGIC_VECTOR(KEY_IN_SIZE - 1 DOWNTO 0);
    SIGNAL WR_EN       : STD_LOGIC := '0';
    SIGNAL INPUT_DATA  : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);
    SIGNAL HIT         : STD_LOGIC;
    SIGNAL OUTPUT_DATA : STD_LOGIC_VECTOR(DATA_SIZE - 1 DOWNTO 0);

    -- Clock period
    CONSTANT CLK_PERIOD : TIME := 10 NS;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    UUT: CAM
        PORT MAP (
            UNI_CLK     => CLK,
            UNI_RST     => RST,
            UNI_KEY_IN  => KEY_IN,
            UNI_WR_EN   => WR_EN,
            INPUT_DATA  => INPUT_DATA,
            HIT         => HIT,
            OUTPUT_DATA => OUTPUT_DATA
        );

    -- Clock generation
    CLK_PROCESS : PROCESS
    BEGIN
        WHILE TRUE LOOP
            CLK <= '0';
            WAIT FOR CLK_PERIOD / 2;
            CLK <= '1';
            WAIT FOR CLK_PERIOD / 2;
        END LOOP;
    END PROCESS;

    -- Stimulus process
    STIM_PROC: PROCESS
    BEGIN
        -- Reset
        RST <= '1';
        WAIT FOR 20 NS;
        RST <= '0';

        -- Write entry 1
        KEY_IN     <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, 22));
        INPUT_DATA <= x"AAAA0001";
        WR_EN      <= '1';
        WAIT FOR CLK_PERIOD;

        -- Write entry 2
        KEY_IN     <= STD_LOGIC_VECTOR(TO_UNSIGNED(2, 22));
        INPUT_DATA <= x"BBBB0002";
        WAIT FOR CLK_PERIOD;

        -- Disable write
        WR_EN <= '0';

        -- Match test for entry 1
        KEY_IN <= STD_LOGIC_VECTOR(TO_UNSIGNED(1, 22));
        WAIT FOR CLK_PERIOD;
        ASSERT (hit = '1') REPORT "Expected HIT for key 0x000001" SEVERITY ERROR;

        -- Match test for entry 2
        KEY_IN <= STD_LOGIC_VECTOR(TO_UNSIGNED(2, 22));
        WAIT FOR CLK_PERIOD;
        ASSERT (hit = '1') REPORT "Expected HIT for key 0x000002" SEVERITY ERROR;

        -- No match test
        KEY_IN <= STD_LOGIC_VECTOR(TO_UNSIGNED(255, 22));
        WAIT FOR CLK_PERIOD;
        ASSERT (HIT = '0') REPORT "Expected MISS for key 0x0000FF" SEVERITY ERROR;

        -- Finish simulation
        WAIT FOR 50 NS;
        ASSERT FALSE REPORT "Testbench completed." SEVERITY NOTE;
        WAIT;
    END PROCESS;

END BEHAV;
