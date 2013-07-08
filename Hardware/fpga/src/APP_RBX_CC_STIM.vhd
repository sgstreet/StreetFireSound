-- -------------------------------------------------------
-- FILE: APP_RBX_CC_STIM.vhd
-- Date: 3-15-04
-- Author: R. Bauer 
--
-- Purpose: Provides XSCALE stimulii to the StreetRacer CPU Card  
-- RBX Companion Chip (FPGA)  
--
-- Note: This module is NOT syntheziable! It if for simulation only !!!
--
-- Revision: 1.0	
--
-- History: 
--
--	3-9-04 Modified IO directions and added I2S tests, REB
--	3-8-04 Added new SLINK TESTS
--	2-19-04 Added SLINK FIFO TESTS
--	2-13-04 Active High Reset
--	2-12-04 Modified SLINK Signal Names	
--	Converted to App Board Version, 1-27-04, REB	
--	12-27-03 Added Interrupt Control Tests
--    12-2-03 Added DQM Support
--	0.0 -> initial draft 11-25-03 R. Bauer
--
--
-- -------------------------------------------------------

LIBRARY ieee;

--------------------3-9
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
--------------------3-9

--USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
--USE ieee.numeric_bit.ALL;
--USE ieee.std_logic_unsigned.conv_integer;
--USE ieee.std_logic_arith.conv_std_logic_vector;
USE std.textio.ALL;


--------------------3-9
--library unisim;
--use unisim.ALL;
--------------------------

ENTITY APP_RBX_CC_STIM is
	
Port(	
	XS_MD		: inout	std_logic_vector(31 downto 0);-- data (MD) bus
	XS_MA		:out	std_logic_vector(22 downto 0);	-- address (MA) bus
	XS_CS1n	:out	std_logic;	-- CPU Static Chip Select 1 / GPIO[15]
	XS_CS2n	:out	std_logic;	-- CPU Static Chip Select 2 / GPIO[78]
	XS_CS3n	:out	std_logic;	-- CPU Static Chip Select 3 / GPIO[79]
	XS_CS4n	:out	std_logic;	-- CPU Static Chip Select 4 / GPIO[80]
	XS_CS5n	:out	std_logic;	-- CPU Static Chip Select 5 / GPIO[33]
	XS_nOE	:out	std_logic;	-- CPU Memory output enable
	XS_nPWE	:out	std_logic;	-- CPU Memory write enable or GPIO49
	XS_RDnWR	:out	std_logic;	-- CPU Read/Write for static interface
	XS_DQM	:out	std_logic_vector(3 downto 0);	-- Var Lat IO Wr Byte En
	XS_RDY	:in	std_logic;	--Variable Latency I/O Ready pin. (input to cpu RDY/GPIO[18])
	XS_SDCLK0	:out	std_logic;	-- Synchronous Static Memory clock from CPU
	XS_PWM1 	:out	std_logic;	--XS GPIO17 -use as fpga reset input (or PWM1 from CPU)
	XS_PWM0	:in	std_logic;	--XS GPIO16 -use as interrupt output (or PWM0 from cpu)
	XS_SDCKE0	:out std_logic;	-- SDRAM and/or Sync Static Memory clock enable (SDCKE0) from CPU
	CLK_3_6MHz	:out std_logic;	--3.6 MHz Processor Clock output from CPU Pin A7 (3.6MHz/GPIO[11])
	XS_nIOIS16	:out	std_logic;
	XS_nPWAIT	:out	std_logic;
	XS_nPREG	:out	std_logic;
	XS_nPSKTSEL	:out	std_logic;
	XS_nPCE2	:out	std_logic;
	XS_nPCE1	:out	std_logic;
	XS_nPIOW	:out	std_logic;
	XS_nPIOR	:out	std_logic;
	XS_nPOE		:out	std_logic;
	XS_nACRESET	:out	std_logic;
	XS_DREQ0, 	
	XS_DREQ1:in std_logic;
	XS_BITCLK		:inout std_logic; 	-- GPIO28/AC97 Audio Port or I2S bit clock (input or output) 
	XS_SDATA_IN0	:in	std_logic;	-- GPIO29/AC97 or I2S data Input  (input to cpu)
	XS_SDATA_IN1	:out	std_logic; 	-- GPIO32/AC97 Audio Port data in. I2S sysclk output from cpu
	XS_SDATA_OUT	:out	std_logic; 	-- GPIO30/AC97 Audio Port or I2S data out from cpu
	XS_SYNC		:out	std_logic;	-- GPIO31/AC97 Audio Port or I2S Frame sync signal. (output from cpu)
	SL6_TX: in std_logic; --Triple Connection: CPU/FPGA/EDGE:XS_FF_DCD/GPIO[36]
	SL5_TX: in std_logic; --Triple Connection: CPU/FPGA/EDGE:XS_FF_RI/GPIO[38]
	SL4_TX: in std_logic; --Triple Connection: CPU/FPGA/EDGE:XS_SSP_TXD/GPIO[25]
	IR_TX: in std_logic; --Triple Connection: CPU/FPGA/EDGE:XS_SSP_RXD/GPIO[26]
	FF_RTS: in std_logic; --Triple Connection: CPU/FPGA/EDGE:XS_FF_RTS/gpio41
	LED_4: in std_logic; --Triple Connection: CPU/FPGA/EDGE:XS_SSP_SCLK/GPIO[23]
	SL6_RX: out std_logic; --Triple Connection: CPU/FPGA/EDGE:XS_FF_DTR/GPIO[40]
	SL5_RX: out std_logic; --Triple Connection: CPU/FPGA/EDGE:XS_FF_DSR/GPIO[37]
	SL4_RX: out std_logic; --Triple Connection: CPU/FPGA/EDGE:XS_SSPEXTCLK/GPIO[27]
	IR_RX: out std_logic; --Triple Connection: CPU/FPGA/EDGE:XS_SSP_SFRM/GPIO[24]
	FF_CTS: out std_logic; --Triple Connection: CPU/FPGA/EDGE:XS_FF_CTS/gpio35
	I2S_MCLK_GCK3	:out  std_logic; --LOC="C8" GCK3 
	I2S_SCLK_GCK1	:out  std_logic;	--LOC="T8" GCK1 
	ETH_INT: out std_logic;
	ETH_CYCLE_N: in std_logic; 
	ETH_DATACS_N: in std_logic;
	ETH_RDYRTN_N: in std_logic;
	ETH_W_R_N: in std_logic; 
	ETH_LCLK: in std_logic; 
	ETH_VLBUS_N: in std_logic;
	ETH_LDEV_N: out std_logic;
	ETH_IOWAIT: out std_logic; 
	I2S_MCLK : in std_logic;
	I2S_SCLK : inout std_logic;
	I2S_LRCLK : inout std_logic;
	I2S_SDATA : inout std_logic;
	DA_INT_8405A : out std_logic;
	DA_INT_8415A : out std_logic;
	DAI_ENABLE : in std_logic;
	SL0_TX: in std_logic; 
	SL1_TX: in std_logic; 
	SL2_TX: in std_logic; 
	SL3_TX: in std_logic;
	SL0_RX: out std_logic; 
	SL1_RX: out std_logic; 
	SL2_RX: out std_logic; 
	SL3_RX: out std_logic;
	SW_1 : out std_logic;
	LED_0 : in std_logic; 
	LED_1 : in std_logic; 
	LED_2 : in std_logic; 
	LED_3 : in std_logic; 
	FPGA_EB90: in std_logic; 
	FPGA_EB92: in std_logic; 
	FPGA_EB93: in std_logic; 
	FPGA_EB94: in std_logic; 
	FPGA_EB96: in std_logic; 
	FPGA_EB98: in std_logic
	);	
END APP_RBX_CC_STIM;

Architecture test of APP_RBX_CC_STIM is

-- TEST SELECTION CONSTANTS:

constant TEST_CPB: boolean := TRUE;
constant TEST_ENET: boolean := TRUE;
constant TEST_ICPB: boolean := FALSE; -- must have IR_RX connected to PB_INT(0)at top level to run
-- NOTE that ethernet and slink tests also include interrupt tests for icpb

--3-8-04 new slink tests
constant TEST_SLINK_SHORT: boolean := TRUE; -- set TRUE to enable SHORT SLINK test FOR DELIVERED MODULE (20ms 2ms/ch)(FALSE to disable)
constant TEST_SLINKFIFO_CLEAR: boolean := FALSE; -- set TRUE to enable SLINK FIFO CLEAR block tests (26.5ms)(FALSE to disable)
constant TEST_SLINKRXFIFOS: boolean := FALSE; -- set TRUE to enable SLINK RX FIFOs block tests (54.78ms)(FALSE to disable)
constant TEST_SLINK_TX_FIFOS: boolean := FALSE; -- set TRUE to enable SLINK TX FIFO tests (67ms)(FALSE to disable)
constant TEST_SLINK_WO_FIFOS: boolean := FALSE; -- set TRUE to enable SLINK without FIFOs block tests (FALSE to disable)

constant TEST_I2S: boolean := TRUE; -- set TRUE to enable I2S Control tests (FALSE to disable)


--*******************************************************************************************************
-- VERSION NUMBER:  UPDATE THIS to match top level code
--
constant VERSION_NUMBER:   bit_vector (31 downto 0) := "10110000000000000000000000000001";


-- PERIPHERAL BLOCK CAPABILITY INDICATOR
constant BLOCK_CAPABILITY: bit_vector (31 downto 0) := "00000000000000010000000000111111";
--
--	PB0 - Confguration Peripheral Block (CPB)
--	PB1 - Interrupt Controller Peripheral Block (ICPB)
--	PB2 - SLINK Peripheral Block (SLPB)
--	PB3 - Swith Peripheral Block (SWPB)
--	PB4 - Audio Path Control and I2S Peripheral Block (APCIPB)
--	PB5 - LED Peripheral Block (LEDPB)
--
--	PB16 - Ethernet Interface (LAN91C111)
--
--*******************************************************************************************************

-- TIME RELATED CONSTANTS FOR TEST FPGA CODE
constant clk_period : time := 10 ns;   -- 100 Mhz

constant i2s_mclk_period: time := 88 ns;   -- 11.3 Mhz


constant TAS : time := 10 ns; -- Address setup to CS asserted
constant TCES : time := 20 ns; -- CS setup to Write Enable or Output enable
constant TAH : time := 10 ns; -- Address hold after enable deasserted
constant TCEH : time := 10 ns; -- CS hold after enable deasserted
constant TDHW : time := 10 ns; -- Data hold after write enable deasserted

-- ADDRESS RELATED CONSTANTS For TEST FPGA CODE

-- values for ADDRESS_bv <= "00000000000000000000000";

constant BV_0: bit_vector (22 downto 0) := "00000000000000000000000";
constant BV_4: bit_vector (22 downto 0) := "00000000000000000000100";
constant BV_8: bit_vector (22 downto 0) := "00000000000000000001000";
constant BV_C: bit_vector (22 downto 0) := "00000000000000000001100";

--*******************************************************************************************************
-- REGISTER ADDRESSES: 
--*******************************************************************************************************
-- PB0 (CPB) Registers (cs4) (PB0 at 0x000000)
constant VER_REG_ADDR: 	 bit_vector (22 downto 0) := "00000000000000000000000"; -- 0x000000
constant PBCAP_REG_ADDR: bit_vector (22 downto 0) := "00000000000000000000100"; -- 0x000004
constant PBEN_REG_ADDR:  bit_vector (22 downto 0) := "00000000000000000001000"; -- 0x000008
--*******************************************************************************************************
-- PB1 (ICPB) Registers: (cs4) (PB1 at 0x040000)
constant INT_STAT_REG_ADDR: bit_vector (22 downto 0) := "00001000000000000000000"; -- 0x040000
constant INT_MASK_REG_ADDR: bit_vector (22 downto 0) := "00001000000000000000100"; -- 0x040004
constant INT_ENA_REG_ADDR:  bit_vector (22 downto 0) := "00001000000000000001000"; -- 0x040008
constant INT_CLR_REG_ADDR:  bit_vector (22 downto 0) := "00001000000000000001100"; -- 0x04000C
constant INT_PEN_REG_ADDR:  bit_vector (22 downto 0) := "00001000000000000010000"; -- 0x040010
--*******************************************************************************************************
--3-8-04 new registers:
-- PB2 (SLPB) Registers: (cs4) (PB2 at 0x080000)

-- REGISTER ADDRESSES: 
constant STAT_REG_ADDR_A: bit_vector (22 downto 0) := "00010000000000000000000"; -- 0x080000
constant STAT_REG_ADDR_B: bit_vector (22 downto 0) := "00010000000000000000100"; -- 0x080004
constant MASK_REG_ADDR_A: bit_vector (22 downto 0) := "00010000000000000001000"; -- 0x080008
constant MASK_REG_ADDR_B: bit_vector (22 downto 0) := "00010000000000000001100"; -- 0x08000C
constant CLR_REG_ADDR_A : bit_vector (22 downto 0) := "00010000000000000010000"; -- 0x080010
constant CLR_REG_ADDR_B : bit_vector (22 downto 0) := "00010000000000000010100"; -- 0x080014
constant CTRL_REG_ADDR_A: bit_vector (22 downto 0) := "00010000000000000011000"; -- 0x080018
constant CTRL_REG_ADDR_B: bit_vector (22 downto 0) := "00010000000000000011100"; -- 0x08001C
constant SEND_SL0_ADDR: bit_vector (22 downto 0) := "00010000000000000100000"; -- 0x080020
constant SEND_SL1_ADDR: bit_vector (22 downto 0) := "00010000000000000100100"; -- 0x080024
constant SEND_SL2_ADDR: bit_vector (22 downto 0) := "00010000000000000101000"; -- 0x080028
constant SEND_SL3_ADDR: bit_vector (22 downto 0) := "00010000000000000101100"; -- 0x08002C
constant SEND_SL4_ADDR: bit_vector (22 downto 0) := "00010000000000000110000"; -- 0x080030
constant SEND_SL5_ADDR: bit_vector (22 downto 0) := "00010000000000000110100"; -- 0x080034
constant SEND_SL6_ADDR: bit_vector (22 downto 0) := "00010000000000000111000"; -- 0x080038
constant SEND_SL7_ADDR: bit_vector (22 downto 0) := "00010000000000000111100"; -- 0x08003C
constant RCV_SL0_ADDR : bit_vector (22 downto 0) := "00010000000000001000000"; -- 0x080040
constant RCV_SL1_ADDR : bit_vector (22 downto 0) := "00010000000000001000100"; -- 0x080044
constant RCV_SL2_ADDR : bit_vector (22 downto 0) := "00010000000000001001000"; -- 0x080048
constant RCV_SL3_ADDR : bit_vector (22 downto 0) := "00010000000000001001100"; -- 0x08004C
constant RCV_SL4_ADDR : bit_vector (22 downto 0) := "00010000000000001010000"; -- 0x080050
constant RCV_SL5_ADDR : bit_vector (22 downto 0) := "00010000000000001010100"; -- 0x080054
constant RCV_SL6_ADDR : bit_vector (22 downto 0) := "00010000000000001011000"; -- 0x080058
constant RCV_SL7_ADDR : bit_vector (22 downto 0) := "00010000000000001011100"; -- 0x08005C

--*******************************************************************************************************
--3-9-04 APCIPB Registers:(cs4) (PB4 at 0x100000)

constant I2S_CNTL_REG_ADDR: bit_vector (22 downto 0) := "00100000000000000000000"; -- 0x100000
constant I2S_STAT_REG_ADDR: bit_vector (22 downto 0) := "00100000000000000000100"; -- 0x100004
--*******************************************************************************************************


signal CLK: std_logic;
signal Ref_CLK :std_logic;
signal Ref_RST_N :std_logic;

signal READ_DATA_IN,READ_DATA:std_logic_vector(31 downto 0);
signal FAIL_FLAG: std_logic;

procedure PRINT(s : in string) is variable l: line;
  begin
    std.textio.write(l,s);
    writeline(output,l);
end procedure PRINT;

procedure VPRINT(i : in integer) is variable l: line;
  begin
    std.textio.write(l,i);
    writeline(output,l);
end procedure VPRINT;
--
procedure WAIT_CYCLE_RISING(i : integer) is
	begin
	for i in 1 to i loop
		wait until rising_edge(Ref_CLK);
	end loop;
end procedure WAIT_CYCLE_RISING;

procedure WAIT_CYCLE_FALLING(i : integer) is
	begin
	for i in 1 to i loop
		wait until falling_edge(Ref_CLK);
	end loop;
end procedure WAIT_CYCLE_FALLING;

	signal WRITE_databv,WRITE_databv2,TEST_databv,TEST_databv2: bit_vector(31 downto 0); 
	signal ADDRESS_bv: bit_vector(22 downto 0 );
	signal address_out :std_logic_vector(22 downto 0);	
	signal address_out1, address_out2,address_out3,address_out4:std_logic_vector(22 downto 0);
	signal DATA_BYTE_EN: bit_vector(3 downto 0);
	signal SLV_0,SLV_4,SLV_8,SLV_C:std_logic_vector(22 downto 0);

	signal CHANNEL_I_TS,CHANNEL_I_RS,CHANNEL_I_TI,CHANNEL_I_RI,CHANNEL_I_TC,CHANNEL_I_LI,
			CHANNEL_I_CLR_TX_FIFO,CHANNEL_I_CLR_RX_FIFO,CHANNEL_I_ENA_TX,
			CHANNEL_I_ENA_RX: bit_vector(31 downto 0); 
	signal CHANNEL_I_SEND_ADDR,CHANNEL_I_RCV_ADDR: bit_vector(22 downto 0 )  ;


	signal RXFIFO_I_EMPTY:std_logic;
	signal TEST_DATA: std_logic_vector(31 downto 0);

	signal DAI_MCLK,DAI_MCLK_D2,DAI_SCLK,DAI_LRCLK,DAI_SDATA:std_logic;
	
	signal XS_SYNC_CTR :std_logic_vector(5 downto 0);
	signal mclkx2_ref:std_logic;
	signal XS_SYNC_out: std_logic;
	signal DAI_MCLK_CTR:std_logic_vector(12 downto 0);
	signal I2S_DATA_CTR:std_logic_vector(12 downto 0);

----------------------------------------------------------------------
-- LOGIC BEGINS HERE:
----------------------------------------------------------------------
BEGIN

SLV_0 <= to_stdlogicvector(BV_0);
SLV_4 <= to_stdlogicvector(BV_4);
SLV_8 <= to_stdlogicvector(BV_8);
SLV_C <= to_stdlogicvector(BV_C);


XS_SDCLK0 <= CLK;
CLK <= Ref_CLK;
XS_PWM1 <= not Ref_RST_N;  --XS_PWM1 is GPIO from CPU changed to active high reset 2-13-04, reb

-- STATIC PULLUPS and/or PULLDOWNS
-- pull these signals statically high/low for simulation

XS_MD	<= (others => 'H'); --CPU Memory data (MD) bus
XS_MA	<= (others => 'H'); --CPU Memory address (MA) bus
XS_CS1n	 <='H';	-- CPU Static Chip Select 1 / GPIO[15]
XS_CS2n	<='H'; -- CPU Static Chip Select 2 / GPIO[78]
XS_CS3n	<='H'; 	-- CPU Static Chip Select 3 / GPIO[79]
XS_CS4n	<='H'; 	-- CPU Static Chip Select 4 / GPIO[80]
XS_CS5n	<='H'; 	-- CPU Static Chip Select 5 / GPIO[33]
XS_nOE	<='H'; 	-- CPU Memory output enable
XS_nPWE	<='H'; 	-- CPU Memory write enable or GPIO49
XS_RDnWR<='H'; -- CPU Read/Write for static interface
XS_DQM	<= (others => 'H'); -- Variable Latency IO Write Byte Enables

-- XS_PWM1 <='H'; 	--XS GPIO17 -use as active low fpga reset input (or PWM1 from CPU)
XS_SDCKE0 <= 'L';

FF_CTS <= 'L'; --Triple Connection: CPU/FPGA/EDGE:XS_FF_RTS/gpio41


I2S_MCLK_GCK3 <= 'L'; --LOC="C8" GCK3 
I2S_SCLK_GCK1 <= 'L'; --LOC="T8" GCK1 
ETH_INT <= 'L'; 
ETH_LDEV_N <= 'L'; 
ETH_IOWAIT <= 'L'; 
I2S_SDATA <= 'Z';
DA_INT_8405A <= 'L'; 
DA_INT_8415A <= 'L'; 

SW_1 <= 'L'; 

I2S_SDATA <= 'Z';
XS_SDATA_IN1 <= 'Z';
XS_SDATA_OUT <= 'Z';	
XS_SYNC <= 'Z';	
XS_BITCLK <= 'Z';
I2S_SCLK <= 'Z';
I2S_LRCLK <= 'Z';
	
--3-8-04 SLINK LOOPBACK moved to stim file
--SL0_RX <= 'Z'; 
--SL1_RX <= 'Z'; 
--SL2_RX <= 'Z'; 
--SL3_RX <= 'Z'; 
--SL4_RX <= 'Z'; --Triple Connection: CPU/FPGA/EDGE:XS_SSP_TXD/GPIO[25]
--SL5_RX <= 'Z'; --Triple Connection: CPU/FPGA/EDGE:XS_FF_RI/GPIO[38]
--SL6_RX <= 'Z'; --Triple Connection: CPU/FPGA/EDGE:XS_FF_DCD/GPIO[36]
--IR_RX <= 'Z'; --Triple Connection: CPU/FPGA/EDGE:XS_SSP_RXD/GPIO[26]

SLINK_SIM: PROCESS(SL0_TX,SL1_TX,SL2_TX,SL3_TX,SL4_TX,SL5_TX,SL6_TX,IR_TX) 
BEGIN 	
SL0_RX <= SL0_TX after 27 ns;
SL1_RX <= SL1_TX after 27 ns;
SL2_RX <= SL2_TX after 27 ns;
SL3_RX <= SL3_TX after 27 ns;
SL4_RX <= SL4_TX after 27 ns;
SL5_RX <= SL5_TX after 27 ns;
SL6_RX <= SL6_TX after 27 ns;
IR_RX <= IR_TX after 27 ns;
END PROCESS;

 
INITIAL_RESET: PROCESS
BEGIN 
	Ref_RST_N <= '0','1' after 100 ns;
	wait;		
END PROCESS;

INPUT_CLOCK: PROCESS 
BEGIN 	
	Ref_CLK <= '0','1' after clk_period/2;
	wait for clk_period;	
END PROCESS;

Genthis: for i in  0 to 31 generate
CONVERT_PULLS: PROCESS(READ_DATA_IN)
BEGIN
if READ_DATA_IN(i) = 'H' or READ_DATA_IN(i) = '1' then READ_DATA(i)<= '1';
elsif READ_DATA_IN(i) ='L' or READ_DATA_IN(i) = '0' then READ_DATA(i) <= '0';
elsif READ_DATA_IN(i) = 'Z' then READ_DATA(i) <= 'Z';
end if;
END PROCESS;
end generate;


------------------------------------------------------------
--3-9-04
--I2S Clocks
------------------------------------------------------------
DAI_SCLK <= DAI_MCLK_CTR(1); -- divide DAI_MCLK by 4
DAI_LRCLK <= DAI_MCLK_CTR(7); --divide DAI_MCLK by 64*4
--DAI_SDATA <= '1'; -- constant all 1's
--DAI_SDATA <= DAI_MCLK_CTR(4); -- alternating 0000111100001111... pattern
--DAI_SDATA <= DAI_MCLK_CTR(3); -- alternating 0011001100110011... pattern
--DAI_SDATA <= DAI_MCLK_CTR(2); -- alternating 0101010101010101... pattern

--DAI_SDATA <= DAI_MCLK_CTR(4); -- alternating 0000111100001111... pattern
--DAI_SDATA <=  (DAI_MCLK_CTR(4) XOR DAI_MCLK_CTR(2)); -- alternating 0101101001011010... pattern


---- DAI_SDATA <= not DAI_MCLK_CTR(2) XOR DAI_MCLK_CTR(7) ; -- alternating 0101010101010101... pattern

--DAI_SDATA <= not DAI_MCLK_CTR(8); -- all 1's for both LR then all 0's alternating on each lrclk transition

DAI_SDATA <= I2S_DATA_CTR(3);

-- MCLK x2 
mclkx2_ref_GEN: PROCESS
BEGIN
mclkx2_ref <= '1','0' after i2s_mclk_period/4;
wait for i2s_mclk_period/2;	
END PROCESS;

STATE_MACH_CLK: process(mclkx2_ref,DAI_ENABLE,DAI_MCLK) begin
if (DAI_ENABLE = '0') then DAI_MCLK <= '1';
elsif (mclkx2_ref'event and mclkx2_ref = '0') then 
		DAI_MCLK <= not DAI_MCLK; -- divide by 2
end if;
end process STATE_MACH_CLK;



DAI_MCLK_CTR_GEN: PROCESS(DAI_ENABLE,DAI_MCLK,DAI_MCLK_CTR  )
BEGIN
if DAI_ENABLE = '0' then DAI_MCLK_CTR <= (others => '1');
elsif (DAI_MCLK 'event and DAI_MCLK  = '0') then 
	DAI_MCLK_CTR <= DAI_MCLK_CTR + "00000000001" ; 
end if;
END PROCESS;


I2S_DATA_CTR_GEN: PROCESS(DAI_ENABLE,DAI_SCLK,I2S_DATA_CTR)
BEGIN
if DAI_ENABLE = '0' then I2S_DATA_CTR <= (others => '0');
elsif (DAI_SCLK 'event and DAI_SCLK  = '0') then
	if I2S_DATA_CTR = "0000000111011" then I2S_DATA_CTR <= (others => '0'); 
 	else	I2S_DATA_CTR <= I2S_DATA_CTR + "00000000001" ; 
	end if;
end if;
END PROCESS;


--I2S APP BOARD TRISTATE CONTROL:

I2S_SCLK_GEN: PROCESS(DAI_ENABLE,DAI_SCLK)
BEGIN
if DAI_ENABLE = '0' then I2S_SCLK <= 'Z';
else I2S_SCLK <= DAI_SCLK;
end if;
END PROCESS;

I2S_LRCLK_GEN: PROCESS(DAI_ENABLE,DAI_LRCLK)
BEGIN
if DAI_ENABLE = '0' then I2S_LRCLK <= 'Z';
else I2S_LRCLK <= DAI_LRCLK;
end if;
END PROCESS;

I2S_SDATA_GEN: PROCESS(DAI_ENABLE,DAI_SDATA)
BEGIN
if DAI_ENABLE = '0' then I2S_SDATA <= 'Z';
else I2S_SDATA <= DAI_SDATA;
end if;
END PROCESS;

I2S_MCLK_GCK3_GEN: PROCESS(DAI_ENABLE,DAI_MCLK)
BEGIN
if DAI_ENABLE = '0' then I2S_MCLK_GCK3<= 'Z';
else I2S_MCLK_GCK3	<= DAI_MCLK; --LOC="C8" GCK3 
end if;
END PROCESS;

I2S_SCLK_GCK1_GEN: PROCESS(DAI_ENABLE,DAI_SCLK)
BEGIN
if DAI_ENABLE = '0' then I2S_SCLK_GCK1 <= 'Z';
else I2S_SCLK_GCK1 <= DAI_SCLK; --LOC="T8" GCK1 
end if;
END PROCESS;

XS_SYNC_CTR_GEN: PROCESS(DAI_ENABLE,XS_BITCLK,XS_SYNC_CTR)
BEGIN
if DAI_ENABLE = '0' then XS_SYNC_CTR <= (others => '1');
elsif (XS_BITCLK'event and XS_BITCLK = '0') then 
	XS_SYNC_CTR <= XS_SYNC_CTR - "000001" ; 
end if;
END PROCESS;

XS_SYNC_GEN: PROCESS(DAI_ENABLE,XS_SYNC_CTR )
BEGIN
if DAI_ENABLE = '0' then XS_SYNC <= 'Z';
else XS_SYNC <= not XS_SYNC_CTR(5); 
end if;
END PROCESS;




------------------------------------------------------------


--*************************************************************************************
--*************************************************************************************

do_the_test: PROCESS is
	variable INPUT_adrint: INTEGER range 0 to 8388607;	
	variable WRITE_dataint : INTEGER range 0 to 65535;	
--3-9-04	variable INPUT_adrus: UNSIGNED (22 downto 0);
--3-9-04	variable WRITE_dataus: UNSIGNED (31 downto 0);
	variable tmpx32,tmpy32,tmpz32		 : std_logic_vector(31 downto 0); --32 bit temp. holder
	variable tmpx,tmpy			 : std_logic;	-- 1 bit temp holder

--*************************************************************************************************
--*************************************************************************************************
Procedure CPU_RD(
		CS: in string;
		BYTE_EN: in bit_vector(3 downto 0);
	  	CPU_ADDR: in bit_vector(22 downto 0);  
		DOUT: out std_logic_vector(31 downto 0)) is
	
	variable adr: bit_vector(22 downto 0) ;	
	variable dta: bit_vector(31 downto 0) ;
	
begin
	adr	:= CPU_ADDR;
	address_out <= to_stdlogicvector(adr);

	wait until rising_edge(Ref_CLK); 
	if (XS_RDY = 'L' or XS_RDY = '0') then
		wait until (XS_RDY = 'H' or XS_RDY = '1');
		wait until rising_edge(Ref_CLK);
	end if;
	 	
	if (XS_RDY = 'H' or XS_RDY = '1') then
		XS_RDnWR<='1'; 
		XS_MA(22 downto 0) <= address_out(22 downto 0) ;
		XS_DQM	<= to_stdlogicvector(BYTE_EN); -- Variable Latency IO Write Byte Enables	
		if    (CS = "cs1") then XS_CS1n <= '0' after (TAS); 
		elsif (CS = "cs2") then XS_CS2n <= '0' after (TAS); 		
		elsif (CS = "cs3") then XS_CS3n <= '0' after (TAS);
		elsif (CS = "cs4") then XS_CS4n <= '0' after (TAS);
		elsif (CS = "cs5") then XS_CS5n <= '0' after (TAS);
		end if;
		XS_nOE <= '0' after (TCES);
	else 	assert (TRUE) report ("XS_RDY signal unexpectedly active. Read Aborted!")
		severity (error);
	end if;	

	WAIT_CYCLE_RISING(8);	
	
	if (XS_RDY = 'L' or XS_RDY = '0') then
		wait until (XS_RDY = 'H' or XS_RDY = '1');
		wait until rising_edge(Ref_CLK);
	end if;
	
	if (XS_RDY = 'H' or XS_RDY = '1') then
		
		DOUT := XS_MD; -- take data from bus 
		XS_nOE <= '1' ;
		XS_CS1n <= '1' after (TCEH);
		XS_CS2n <= '1' after (TCEH);
		XS_CS3n <= '1' after (TCEH);
		XS_CS4n <= '1' after (TCEH);
		XS_CS5n <= '1' after (TCEH); 
		XS_DQM <= (others => 'H') after (TCEH);
		XS_MA(22 downto 0) <= (others => '1') after (TAH);
	else 	assert (TRUE) report ("XS_RDY signal unexpectedly active. Read Aborted!")
		severity (error);
	end if;
	
	WAIT_CYCLE_FALLING(2);
					
End Procedure CPU_RD;

--*************************************************************************************************
--*************************************************************************************************
Procedure CPU_WRITE(
		CS: in string;
		BYTE_EN: in bit_vector(3 downto 0);
		CPU_ADDR: in bit_vector(22 downto 0); 
	  	DIN: in bit_vector(31 downto 0)) is
	  	
	variable adr: bit_vector(22 downto 0) ;	
	variable dta: bit_vector(31 downto 0);
	
begin
	dta	:= DIN;
	adr	:= CPU_ADDR;
	address_out <= to_stdlogicvector(adr); 

	wait until falling_edge(Ref_CLK); 
	if (XS_RDY = 'L' or XS_RDY = '0') then
		wait until (XS_RDY = 'H' or XS_RDY = '1');
		wait until rising_edge(Ref_CLK);
	end if;
		
if (XS_RDY = 'H' or XS_RDY = '1') then
		XS_RDnWR<='0'; 
		XS_MA(22 downto 0) <= address_out(22 downto 0) ;
		XS_DQM	<= to_stdlogicvector(BYTE_EN); -- Variable Latency IO Write Byte Enables	
		if    (CS = "cs1") then XS_CS1n <= '0' after (TAS); 
		elsif (CS = "cs2") then XS_CS2n <= '0' after (TAS); 		
		elsif (CS = "cs3") then XS_CS3n <= '0' after (TAS);
		elsif (CS = "cs4") then XS_CS4n <= '0' after (TAS);
		elsif (CS = "cs5") then XS_CS5n <= '0' after (TAS);
		end if;
		XS_MD <= to_stdlogicvector(DIN) ;
		XS_nPWE <= '0' after (TCES);
	else 	assert (TRUE) report ("XS_RDY signal unexpectedly active. Write Aborted!")
		severity (error);
	end if;	

	WAIT_CYCLE_RISING(8);	
	wait until rising_edge(Ref_CLK);
	
	if (XS_RDY = 'L' or XS_RDY = '0') then
		wait until (XS_RDY = 'H' or XS_RDY = '1');
		wait until rising_edge(Ref_CLK);
	end if;	
		
	if (XS_RDY = 'H' or XS_RDY = '1') then	
		XS_nPWE <= '1';
		XS_MD <= (others => 'H') after TDHW; 
		XS_CS1n <= '1' after (TCEH);
		XS_CS2n <= '1' after (TCEH);
		XS_CS3n <= '1' after (TCEH);
		XS_CS4n <= '1' after (TCEH);
		XS_CS5n <= '1' after (TCEH); 
		XS_DQM	<= (others => 'H') after (TCEH);
		XS_MA(22 downto 0) <= (others => '1') after (TAH);	
		XS_RDnWR<='1' after (TAH);	 

	else 	assert (TRUE) report ("XS_RDY signal unexpectedly active. Write Aborted!")
		severity (error);
	end if;	

	WAIT_CYCLE_FALLING(2);

End Procedure CPU_WRITE;

--********************************************************************************





--********************************************************************************
-- Test Sequence:
--********************************************************************************
--********************************************************************************


	BEGIN	-- logic for process "do_the_test"

PRINT(" Starting Streetfire FPGA Test Code Verification !!!");
	PRINT(" ");

IR_RX <= 'Z';

XS_MD	<= (others => 'H'); --CPU Memory data (MD) bus
XS_MA	<= (others => 'H'); --CPU Memory address (MA) bus
XS_RDnWR<='1'; -- CPU Read/Write for static interface
XS_nPWE	<='1'; 
XS_nOE	<='1';
XS_CS1n	 <='1';
XS_CS2n	<='1'; 
XS_CS3n	<='1'; 
XS_CS4n	<='1'; 
XS_CS5n	<='1'; 
CLK_3_6MHz	<= '0';
XS_nPOE	<= '0';
XS_nPREG	<= '0';
XS_nPIOW	<= '0';
XS_nPIOR	<= '0';
XS_nPCE2	<= '0';
XS_nPCE1	<= '0';
XS_nIOIS16	<= '0';
XS_nPWAIT	<= '0';
XS_nPSKTSEL	<= '0';
XS_nACRESET	<= '0';
	
--SL6_RX <= '0'; --Triple Connection: CPU/FPGA/EDGE:XS_FF_DCD/GPIO[36]
--SL5_RX <= '0'; --Triple Connection: CPU/FPGA/EDGE:XS_FF_RI/GPIO[38]
--SL4_RX <= '0'; --Triple Connection: CPU/FPGA/EDGE:XS_SSP_TXD/GPIO[25]
--IR_RX <= '0'; --Triple Connection: CPU/FPGA/EDGE:XS_SSP_RXD/GPIO[26]
FF_CTS <= '0'; --Triple Connection: CPU/FPGA/EDGE:XS_FF_RTS/gpio41
--3-9-04 I2S_MCLK_GCK3 <= '0'; --LOC="C8" GCK3 
--3-9-04 I2S_SCLK_GCK1 <= '0'; --LOC="T8" GCK1 
ETH_LDEV_N <= '0'; 
ETH_IOWAIT <= '0';
ETH_INT <= '0'; 
DA_INT_8405A <= '0'; 
DA_INT_8415A <= '0'; 
I2S_SDATA <= 'Z';
--SL0_RX <= '0'; 
--SL1_RX <= '0'; 
--SL2_RX <= '0'; 
--SL3_RX <= '0'; 
SW_1 <= '0'; 

	
wait until rising_edge(Ref_RST_N); -- wait for reset to end
WAIT_CYCLE_FALLING(20);

FAIL_FLAG <= '0';

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- PB0: Configuration Peripheral Block Test:
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

CPB_TEST: for I in 1 to 1 loop
exit CPB_TEST  when TEST_CPB = FALSE;



--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
--       Version REGISTER (VER_REG) TEST 
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Read of VER_REG
TEST_databv <= VERSION_NUMBER;
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, VER_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED VERSION REGISTER Readback");	FAIL_FLAG <= '1';
end if;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
--       Peripheral Block Capability REGISTER (PBCAP_REG) TEST 
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- Read of PBCAP_REG
TEST_databv <= BLOCK_CAPABILITY;  

DATA_BYTE_EN <= "0000";
CPU_RD("cs4", DATA_BYTE_EN, PBCAP_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PBCAP REGISTER Readback");	FAIL_FLAG <= '1';
end if;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
--       Peripheral Block Enable REGISTER (PBEN_REG) TEST 
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

-- Write data to PBEN_REG (Chip select 4 x8 PBEN_REG_ADDR)
WRITE_databv <= BLOCK_CAPABILITY;
DATA_BYTE_EN <= "0000";

CPU_WRITE("cs4",DATA_BYTE_EN, PBEN_REG_ADDR, WRITE_databv);

-- Readback PBEN_REG
CPU_RD("cs4", DATA_BYTE_EN, PBEN_REG_ADDR, DOUT => tmpy32);	

READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(WRITE_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PBEN REGISTER Readback");	FAIL_FLAG <= '1';
end if;


-------------------------------------------------
-- Announce Status of Fail Flag on Each Loop
-------------------------------------------------
WAIT_CYCLE_RISING(5);
	
if FAIL_FLAG = '0' then 
	PRINT(" PASSED CPB_TEST Verification :  ");
else 	PRINT("FAILED CPB_TEST Verification :  ");
end if;


end loop CPB_TEST;

--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- LAN91C111 (E0) INTERFACE TEST:
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
ENET_TEST: for I in 1 to 1 loop
exit ENET_TEST  when TEST_ENET = FALSE;

--**********************************
-- ETHERNET RESET
--**********************************

-- Disable Ethernet (on PB16) to reset
-- Write data to PBEN_REG (Chip select 4 x8 PBEN_REG_ADDR)
WRITE_databv <= x"00000000";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, PBEN_REG_ADDR, WRITE_databv);

-- Enable Ethernet to bring out of reset
-- Write data to PBEN_REG (Chip select 4 x8 PBEN_REG_ADDR)
WRITE_databv <= x"00010001";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, PBEN_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);	

--**********************************
-- ETHERNET REGISTER 0 Test
--**********************************

-- Write data to LAN91C111 (PB16) address 0
WRITE_databv <= x"4E4E4E4E";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs5", DATA_BYTE_EN,BV_0 ,WRITE_databv);
-- Readback from address 0
CPU_RD("cs5", DATA_BYTE_EN,BV_0, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(WRITE_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED LAN91C111 Register 0 Readback");	FAIL_FLAG <= '1';
end if;
WAIT_CYCLE_RISING(5);	

--**********************************
-- ETHERNET REGISTER 8 Test
--**********************************

-- Write data to LAN91C111 (PB16) address 8
WRITE_databv <= x"E8E8E8E8";
CPU_WRITE("cs5",DATA_BYTE_EN,BV_8 ,WRITE_databv);
-- Readback from address 8
CPU_RD("cs5",DATA_BYTE_EN, BV_8, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(WRITE_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED LAN91C111 Register 8 Readback");	FAIL_FLAG <= '1';
end if;
WAIT_CYCLE_RISING(5);	

--**********************************
-- ETHERNET REGISTER 4 Test
--**********************************
-- Lower Word enable
DATA_BYTE_EN <= "1100"; -- lower 16 bits selected
WRITE_databv <= x"55555555";
-- Write data to LAN91C111 (PB16) address 4
CPU_WRITE("cs5",DATA_BYTE_EN,BV_4 ,WRITE_databv);
-- Upper Word Enable
DATA_BYTE_EN <= "0011"; -- lower 16 bits selected
WRITE_databv2 <= x"AAAAAAAA";
-- Write data to LAN91C111 (PB16) address 4
CPU_WRITE("cs5",DATA_BYTE_EN,BV_4 ,WRITE_databv2);


-- Readback from address 4
--TEST_databv(31 downto 16) <= WRITE_databv2(31 downto 16);
--TEST_databv(15 downto 0) <= WRITE_databv(15 downto 0);

CPU_RD("cs5",DATA_BYTE_EN, BV_4, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
--if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
if READ_DATA = to_stdlogicvector(WRITE_databv2) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED LAN91C111 Register 4 Readback");	FAIL_FLAG <= '1';
end if;
WAIT_CYCLE_RISING(5);

-------------------------------------------------
-- Announce Status of Fail Flag on Each Loop
-------------------------------------------------
WAIT_CYCLE_RISING(5);
	
if FAIL_FLAG = '0' then 
	PRINT(" PASSED ENET_TEST Verification :  ");

else 	PRINT("FAILED ENET_TEST Verification :  ");

end if;
	

end loop ENET_TEST;


--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
--       INTERRUPT CONTROLLER PB TEST 
--&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
-- PB1 (ICPB) Registers: (cs4) (PB1 at 0x040000)
-- INT_STAT_REG_ADDR -- 0x040000
-- INT_MASK_REG_ADDR -- 0x040004
-- INT_ENA_REG_ADDR  -- 0x040008
-- INT_CLR_REG_ADDR  -- 0x04000C
-- INT_PEN_REG_ADDR  -- 0x040010

ICPB_TEST: for I in 1 to 1 loop
exit ICPB_TEST  when TEST_ICPB = FALSE;

-- Since enet not enabled, interrupt should be low - i.e. no interrrupts active
-- Set temporary interrupt inputs inactive 

-- Comment in following line to run interrupt test
IR_RX <= '0';  -- IR_RX is assigned (directly) to PB_INT(0) for test purposes
ETH_INT <= '0';  -- ETH_INT from IC, sync'd in Ethernet module, assigned to PB_INT(16)

-- ENABLE INTERRUPT CONTROLLER PB:
-- enable PB0 (CPB), PB1(ICPB), and PB16 (ETHPB)
-- Write data to PBEN_REG (Chip select 4 x8 PBEN_REG_ADDR)
WRITE_databv <= x"00010003";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, PBEN_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);	

-- Read pending interrupt register,INT_PEN_REG_ADDR (should read 0)
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_PEN_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Pending REGISTER Readback");	FAIL_FLAG <= '1';
end if;

-- Clear all interrupt latches
-- Write all 1's to interrupt clear register at cs4, INT_CLR_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);


-- Verify No Interrupt Output
if	XS_PWM0	= '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INITIAL INTERRUPT OUTPUT CLEAR");	FAIL_FLAG <= '1';
end if;


-- Read Interrupt Status register,INT_STAT_REG_ADDR, (should read 0)

TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Status REGISTER Initial Readback");	FAIL_FLAG <= '1';
end if;

-- Unmask All interrupts, write all 1's to INT_MASK_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_MASK_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Readback MAsk REgister (compare to value just written)
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_MASK_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(WRITE_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Mask REGISTER Initial Readback");	FAIL_FLAG <= '1';
end if;

-- Enable All interrupts, write all 1's to INT_ENA_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_ENA_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Readback Enable register (compare to value just written)
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_ENA_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(WRITE_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Enable REGISTER Initial Readback");	FAIL_FLAG <= '1';
end if;

-- Assert test interrupt (this should produce interrupt output after a clock or so)

-- Comment in following line to run interrupt test
IR_RX	<= '1'; -- assigned to PB_INT(0)


-- Read Interrupt Pending Register (should reflect these asserted interrupts)

TEST_databv <= x"00000001";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_PEN_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Pending REGISTER Readback After Interrupt Assertion");
	FAIL_FLAG <= '1';
end if;

-- Read Interrupt Status REgister (should reflect these asserted interrupts)
TEST_databv <= x"00000001";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Status REGISTER Readback After Interrupt Assertion");
	FAIL_FLAG <= '1';
end if;

-- Verify Interrupt Output
if	XS_PWM0	= '1' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INITIAL INTERRUPT OUTPUT ASSERTION");	FAIL_FLAG <= '1';
end if;


-- Disable interrupts using enable register
-- Write 0's to enable register,INT_ENA_REG_ADDR
WRITE_databv <= x"00000000";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_ENA_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Verify Interrupt Status unchanged
TEST_databv <= x"00000001";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Status REGISTER Readback After Interrupt Disable");
	FAIL_FLAG <= '1';
end if;

-- Mask asserted interrupts
-- write 0's to bits 7,15,23,31
WRITE_databv <= x"FFFFFFFE";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_MASK_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Verify Interrupt Output deasserts after masking
if	XS_PWM0	= '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INITIAL INTERRUPT OUTPUT DEASSERTION");	FAIL_FLAG <= '1';
end if;


-- Clear latched interupts
-- Write all 1's to interrupt clear register at cs4, INT_CLR_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Verify Status register reflects clearing
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Status REGISTER Readback After Interrupt Clear");
	FAIL_FLAG <= '1';
end if;

-- Re-enable interrupts and verify that the continuously pending interrupts are not latched
-- Enable All interrupts, write all 1's to INT_ENA_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_ENA_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Verify Status register still cleared after reenabling
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Status REGISTER Readback After Interrupts re-enabled");
	FAIL_FLAG <= '1';
end if;

-- Unmask All interrupts, write all 1's to INT_MASK_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_MASK_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Unassert and reassert test interrupt to get positive edge

-- De-Assert test interrupt (this should produce interrupt output after a clock or so)

-- Comment in following line to run interrupt test
IR_RX	<= '0'; -- assigned to PB_INT(0)

WAIT_CYCLE_RISING(5);
-- Assert test interrupt (this should produce interrupt output after a clock or so)

-- Comment in following line to run interrupt test
IR_RX	<= '1'; -- assigned to PB_INT(0)


-- Verify re-asserted interrupts latched
-- Read Interrupt Status REgister (should reflect these asserted interrupts)
TEST_databv <= x"00000001";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Status REGISTER Readback After Interrupt RE-Assertion");
	FAIL_FLAG <= '1';
end if;

-- CLEAR TEST INTERRUPT AND TEST ETHERNET INTERRUPT INPUT (ETH_INT)

-- Clear latched interupts
-- Write all 1's to interrupt clear register at cs4, INT_CLR_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Verify Interrupts Cleared:
-- Verify Status register reflects clearing
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Status REGISTER Readback After Second Interrupt Clear");
	FAIL_FLAG <= '1';
end if;

-- Verify Interrupt output deasserted:
-- Verify Interrupt Output deasserts after clearing 
if	XS_PWM0	= '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SECOND INTERRUPT OUTPUT DEASSERTION");	FAIL_FLAG <= '1';
end if;


-- Assert Ethernet Interrupt (as if it were coming from chip)

ETH_INT <= '1';
WAIT_CYCLE_FALLING(5);
WAIT_CYCLE_RISING(5);

-- Verify Interrupt Output asserted
if	XS_PWM0	= '1' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED ETHERNET INTERRUPT OUTPUT ASSERTION");	FAIL_FLAG <= '1';
end if;

-- Verify Status REgister reflects ethernet interrupt
-- Read Interrupt Status REgister (should reflect these asserted interrupts)
TEST_databv <= x"00010000";  -- INterrupt 16 is ethernet interrupt
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED Interrupt Status REGISTER Readback After Ethernet Interrupt Assertion");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- Announce Status of Fail Flag on Each Loop
-------------------------------------------------
WAIT_CYCLE_RISING(5);
	
if FAIL_FLAG = '0' then 
	PRINT(" PASSED ICPB_TEST Verification :  ");

else 	PRINT("FAILED ICPB_TEST Verification :  ");

end if;

end loop ICPB_TEST;
--*********************************************************************************
--*********************************************************************************


--*********************************************************************************
--*********************************************************************************
--TEST_SLINK_SHORT
--*********************************************************************************
--*********************************************************************************
SLINK_SHORT_TEST: for I in 0 to 7 loop
exit SLINK_SHORT_TEST when TEST_SLINK_SHORT = FALSE;

--------------------------------------------------
-- Register Bit and address changes over 8 channels:
--------------------------------------------------
if I = 0 then 
	CHANNEL_I_TS 		<= x"01000000";
	CHANNEL_I_RS 		<= x"00010000";
	CHANNEL_I_TC 		<= x"00000100";
	CHANNEL_I_LI 		<= x"00000001";
	CHANNEL_I_CLR_TX_FIFO 	<= x"01000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00010000";
	CHANNEL_I_ENA_TX 		<= x"00000100";
	CHANNEL_I_ENA_RX 		<= x"00000001";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL0_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL0_ADDR;
elsif I = 1 then
	CHANNEL_I_TS 		<= x"02000000";
	CHANNEL_I_RS 		<= x"00020000";
	CHANNEL_I_TC 		<= x"00000200";
	CHANNEL_I_LI 		<= x"00000002";
	CHANNEL_I_CLR_TX_FIFO 	<= x"02000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00020000";
	CHANNEL_I_ENA_TX 		<= x"00000200";
	CHANNEL_I_ENA_RX 		<= x"00000002";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL1_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL1_ADDR;

elsif I = 2 then
	CHANNEL_I_TS 		<= x"04000000";
	CHANNEL_I_RS 		<= x"00040000";
	CHANNEL_I_TC 		<= x"00000400";
	CHANNEL_I_LI 		<= x"00000004";
	CHANNEL_I_CLR_TX_FIFO 	<= x"04000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00040000";
	CHANNEL_I_ENA_TX 		<= x"00000400";
	CHANNEL_I_ENA_RX 		<= x"00000004";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL2_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL2_ADDR;

elsif I = 3 then
	CHANNEL_I_TS 		<= x"08000000";
	CHANNEL_I_RS 		<= x"00080000";
	CHANNEL_I_TC 		<= x"00000800";
	CHANNEL_I_LI 		<= x"00000008";
	CHANNEL_I_CLR_TX_FIFO 	<= x"08000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00080000";
	CHANNEL_I_ENA_TX 		<= x"00000800";
	CHANNEL_I_ENA_RX 		<= x"00000008";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL3_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL3_ADDR;

elsif I = 4 then
	CHANNEL_I_TS 		<= x"10000000";
	CHANNEL_I_RS 		<= x"00100000";
	CHANNEL_I_TC 		<= x"00001000";
	CHANNEL_I_LI 		<= x"00000010";
	CHANNEL_I_CLR_TX_FIFO 	<= x"10000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00100000";
	CHANNEL_I_ENA_TX 		<= x"00001000";
	CHANNEL_I_ENA_RX 		<= x"00000010";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL4_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL4_ADDR;

elsif I = 5 then
	CHANNEL_I_TS 		<= x"20000000";
	CHANNEL_I_RS 		<= x"00200000";
	CHANNEL_I_TC 		<= x"00002000";
	CHANNEL_I_LI 		<= x"00000020";
	CHANNEL_I_CLR_TX_FIFO 	<= x"20000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00200000";
	CHANNEL_I_ENA_TX 		<= x"00002000";
	CHANNEL_I_ENA_RX 		<= x"00000020";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL5_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL5_ADDR;

elsif I = 6 then
	CHANNEL_I_TS 		<= x"40000000";
	CHANNEL_I_RS 		<= x"00400000";
	CHANNEL_I_TC 		<= x"00004000";
	CHANNEL_I_LI 		<= x"00000040";
	CHANNEL_I_CLR_TX_FIFO 	<= x"40000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00400000";
	CHANNEL_I_ENA_TX 		<= x"00004000";
	CHANNEL_I_ENA_RX 		<= x"00000040";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL6_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL6_ADDR;

elsif I = 7 then
	CHANNEL_I_TS 		<= x"80000000";
	CHANNEL_I_RS 		<= x"00800000";
	CHANNEL_I_TC 		<= x"00008000";
	CHANNEL_I_LI 		<= x"00000080";
	CHANNEL_I_CLR_TX_FIFO 	<= x"80000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00800000";
	CHANNEL_I_ENA_TX 		<= x"00008000";
	CHANNEL_I_ENA_RX 		<= x"00000080";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL7_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL7_ADDR;

end if;
--------------------------------------------------

-------------------------------------------------
-- PB0: CPB:  Enable Interrupt and SLINK Peripheral Blocks
-------------------------------------------------
-- Write data to PBEN_REG (Chip select 4 x8 PBEN_REG_ADDR)
WRITE_databv <= x"00000007";  -- "0111" in lsnibble enables PB0,1,2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, PBEN_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-------------------------------------------------
-- PB1: ICPB:  Enable and unmask PB2 Interrupt in Interrupt Controller
-------------------------------------------------
-- Clear all interrupt latches
-- Write all 1's to interrupt clear register at cs4, INT_CLR_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Enable PB2 interrupt, write 1 to bit 2 in INT_ENA_REG_ADDR
WRITE_databv <= x"00000004";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_ENA_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Unmask PB2 interrupt, write 1 to bit 2 in INT_MASK_REG_ADDR
WRITE_databv <= x"00000004";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_MASK_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Read Interrupt Status register,INT_STAT_REG_ADDR, (should read 0)
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PB2 Interrupt Status REGISTER Initial Readback");	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- PB2: SLPB:  SLINK INITIALIZATION
-------------------------------------------------
-- Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);

-- Verify SLINK Status Registers Cleared
-- STATUS REGISTER A
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK INTERRUPT Status REGISTER A Initial Clear");	FAIL_FLAG <= '1';
end if;
-- STATUS REGISTER B
TEST_databv <= x"0000ffff"; --all rx fifos empty, all lines idle
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK  Status REGISTER B Initial Read");  
FAIL_FLAG <= '1';
end if;

-- Verify Interrupt to CPU is inactive
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF ICPB INTERRUPT OUTPUT PRIOR TO SLINK CHANNEL TEST");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- Write 1 LOW Values to TX  
-------------------------------------------------
-- (Each Count is 10 us)
DATA_BYTE_EN <= "0000"; -- all selected
WRITE_databv <= x"00000007"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);

-------------------------------------------------
-- VERIFY TX FIFO COUNT FOR Channel I
-------------------------------------------------
-- FIFO COUNT WILL BE 1 
TEST_databv <= x"01000007";  --fifo count in upper byte, last data in lower
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INITIAL TX FIFO COUNT VERIFICATION ");	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- Enable TX and RX Channel I in SLINK Control REgister
-------------------------------------------------
WRITE_databv <= CHANNEL_I_ENA_TX or CHANNEL_I_ENA_RX;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CTRL_REG_ADDR_A, WRITE_databv);


-------------------------------------------------
-- WAIT FOR RX FIFO to be non-empty and read data
-------------------------------------------------

-- read STATUS REGISTER B:
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
-- TC is same bit position as RE
TEST_DATA <= to_stdlogicvector(CHANNEL_I_TC);
if ((READ_DATA_IN and TEST_DATA) = x"00000000") then RXFIFO_I_EMPTY <= '0';
else RXFIFO_I_EMPTY <= '1';
end if;

WAIT_CYCLE_FALLING(4);


if RXFIFO_I_EMPTY = '1' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RXFIFO EMPTY INITIAL STATUS");	FAIL_FLAG <= '1';
end if;

WAIT4RXNOTEMPTY1: while RXFIFO_I_EMPTY = '1' loop

DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
-- TC is same bit position as RE
TEST_DATA <= to_stdlogicvector(CHANNEL_I_TC);
if ((READ_DATA_IN and TEST_DATA) = x"00000000") then RXFIFO_I_EMPTY <= '0';
else RXFIFO_I_EMPTY <= '1';
end if;

end loop WAIT4RXNOTEMPTY1;

-- REad RX DATA 1:
TEST_databv <= x"00000007";  --FIFO COUNT WILL BE 1-1=0, FIRST DATA IN LSB
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta 1 REadback");	FAIL_FLAG <= '1';
end if;
--------------------------------------------------------------------------------------------------

-------------------------------------------------
-- WAIT FOR RX FIFO to be non-empty and read data
-------------------------------------------------

-- read STATUS REGISTER B:
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
-- TC is same bit position as RE
TEST_DATA <= to_stdlogicvector(CHANNEL_I_TC);
if ((READ_DATA_IN and TEST_DATA) = x"00000000") then RXFIFO_I_EMPTY <= '0';
else RXFIFO_I_EMPTY <= '1';
end if;

WAIT_CYCLE_FALLING(4);


if RXFIFO_I_EMPTY = '1' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RXFIFO EMPTY post read STATUS");	FAIL_FLAG <= '1';
end if;

WAIT4RXNOTEMPTY2: while RXFIFO_I_EMPTY = '1' loop

DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
-- TC is same bit position as RE
TEST_DATA <= to_stdlogicvector(CHANNEL_I_TC);
if ((READ_DATA_IN and TEST_DATA) = x"00000000") then RXFIFO_I_EMPTY <= '0';
else RXFIFO_I_EMPTY <= '1';
end if;

end loop WAIT4RXNOTEMPTY2;

-- REad RX DATA 2:
TEST_databv <= x"00000000";  --FIFO COUNT WILL BE 1-1=0, FIRST DATA IN LSB
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta 2 REadback");	FAIL_FLAG <= '1';
end if;
--------------------------------------------------------------------------------------------------

-------------------------------------------------
-- WAIT FOR LINE IDLE
-------------------------------------------------

-- Unmask LI Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_LI; -- CH0 LI interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);


-- Wait for INT_LI(I) to assert
wait until (XS_PWM0 = '1');

-- Verify INT_LI Interrupt Status
-- in addition to LI, TS will not assert (already did prior to reading first set of data)
-- in addition to LI, RS will assert (as rx fifo fills, rxfifo almost full =3)

--TEST_databv <= CHANNEL_I_LI or CHANNEL_I_RS; -- if rxfifo almost full=3
TEST_databv <= CHANNEL_I_LI ; -- if rxfifo almost full=120


DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_LI SLINK Status REGISTER Readback AFTER Expected LI INTERRUPT");	FAIL_FLAG <= '1';
end if;

--Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

--Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);

--Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER LI INTERRUPT");
	FAIL_FLAG <= '1';
end if;




-------------------------------------------------
-- Announce Status of Fail Flag on Each Loop
-------------------------------------------------
WAIT_CYCLE_RISING(5);
	
if FAIL_FLAG = '0' then 
	PRINT(" PASSED SHORT SLINK Verification for Channel:  ");
	VPRINT(I);

else 	PRINT("FAILED SHORT SLINK Verification for Channel:  ");
	VPRINT(I);
end if;

end loop SLINK_SHORT_TEST;
--*********************************************************************************
--*********************************************************************************



--*********************************************************************************
--*********************************************************************************
--TEST_SLINKFIFO_CLEAR
--*********************************************************************************
--*********************************************************************************
SLINKFIFO_CLEAR_TEST: for I in 0 to 7 loop
exit SLINKFIFO_CLEAR_TEST when TEST_SLINKFIFO_CLEAR = FALSE;

--------------------------------------------------
-- Register Bit and address changes over 8 channels:
--------------------------------------------------
if I = 0 then 
	CHANNEL_I_TS 		<= x"01000000";
	CHANNEL_I_RS 		<= x"00010000";
	CHANNEL_I_TC 		<= x"00000100";
	CHANNEL_I_LI 		<= x"00000001";
	CHANNEL_I_CLR_TX_FIFO 	<= x"01000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00010000";
	CHANNEL_I_ENA_TX 		<= x"00000100";
	CHANNEL_I_ENA_RX 		<= x"00000001";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL0_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL0_ADDR;
elsif I = 1 then
	CHANNEL_I_TS 		<= x"02000000";
	CHANNEL_I_RS 		<= x"00020000";
	CHANNEL_I_TC 		<= x"00000200";
	CHANNEL_I_LI 		<= x"00000002";
	CHANNEL_I_CLR_TX_FIFO 	<= x"02000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00020000";
	CHANNEL_I_ENA_TX 		<= x"00000200";
	CHANNEL_I_ENA_RX 		<= x"00000002";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL1_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL1_ADDR;

elsif I = 2 then
	CHANNEL_I_TS 		<= x"04000000";
	CHANNEL_I_RS 		<= x"00040000";
	CHANNEL_I_TC 		<= x"00000400";
	CHANNEL_I_LI 		<= x"00000004";
	CHANNEL_I_CLR_TX_FIFO 	<= x"04000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00040000";
	CHANNEL_I_ENA_TX 		<= x"00000400";
	CHANNEL_I_ENA_RX 		<= x"00000004";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL2_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL2_ADDR;

elsif I = 3 then
	CHANNEL_I_TS 		<= x"08000000";
	CHANNEL_I_RS 		<= x"00080000";
	CHANNEL_I_TC 		<= x"00000800";
	CHANNEL_I_LI 		<= x"00000008";
	CHANNEL_I_CLR_TX_FIFO 	<= x"08000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00080000";
	CHANNEL_I_ENA_TX 		<= x"00000800";
	CHANNEL_I_ENA_RX 		<= x"00000008";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL3_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL3_ADDR;

elsif I = 4 then
	CHANNEL_I_TS 		<= x"10000000";
	CHANNEL_I_RS 		<= x"00100000";
	CHANNEL_I_TC 		<= x"00001000";
	CHANNEL_I_LI 		<= x"00000010";
	CHANNEL_I_CLR_TX_FIFO 	<= x"10000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00100000";
	CHANNEL_I_ENA_TX 		<= x"00001000";
	CHANNEL_I_ENA_RX 		<= x"00000010";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL4_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL4_ADDR;

elsif I = 5 then
	CHANNEL_I_TS 		<= x"20000000";
	CHANNEL_I_RS 		<= x"00200000";
	CHANNEL_I_TC 		<= x"00002000";
	CHANNEL_I_LI 		<= x"00000020";
	CHANNEL_I_CLR_TX_FIFO 	<= x"20000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00200000";
	CHANNEL_I_ENA_TX 		<= x"00002000";
	CHANNEL_I_ENA_RX 		<= x"00000020";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL5_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL5_ADDR;

elsif I = 6 then
	CHANNEL_I_TS 		<= x"40000000";
	CHANNEL_I_RS 		<= x"00400000";
	CHANNEL_I_TC 		<= x"00004000";
	CHANNEL_I_LI 		<= x"00000040";
	CHANNEL_I_CLR_TX_FIFO 	<= x"40000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00400000";
	CHANNEL_I_ENA_TX 		<= x"00004000";
	CHANNEL_I_ENA_RX 		<= x"00000040";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL6_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL6_ADDR;

elsif I = 7 then
	CHANNEL_I_TS 		<= x"80000000";
	CHANNEL_I_RS 		<= x"00800000";
	CHANNEL_I_TC 		<= x"00008000";
	CHANNEL_I_LI 		<= x"00000080";
	CHANNEL_I_CLR_TX_FIFO 	<= x"80000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00800000";
	CHANNEL_I_ENA_TX 		<= x"00008000";
	CHANNEL_I_ENA_RX 		<= x"00000080";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL7_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL7_ADDR;

end if;
--------------------------------------------------

-------------------------------------------------
-- PB0: CPB:  Enable Interrupt and SLINK Peripheral Blocks
-------------------------------------------------
-- Write data to PBEN_REG (Chip select 4 x8 PBEN_REG_ADDR)
WRITE_databv <= x"00000007";  -- "0111" in lsnibble enables PB0,1,2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, PBEN_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-------------------------------------------------
-- PB1: ICPB:  Enable and unmask PB2 Interrupt in Interrupt Controller
-------------------------------------------------
-- Clear all interrupt latches
-- Write all 1's to interrupt clear register at cs4, INT_CLR_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Enable PB2 interrupt, write 1 to bit 2 in INT_ENA_REG_ADDR
WRITE_databv <= x"00000004";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_ENA_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Unmask PB2 interrupt, write 1 to bit 2 in INT_MASK_REG_ADDR
WRITE_databv <= x"00000004";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_MASK_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Read Interrupt Status register,INT_STAT_REG_ADDR, (should read 0)
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PB2 Interrupt Status REGISTER Initial Readback");	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- PB2: SLPB:  SLINK INITIALIZATION
-------------------------------------------------
-- Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);

-- Verify SLINK Status Registers Cleared
-- STATUS REGISTER A
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK INTERRUPT Status REGISTER A Initial Clear");	FAIL_FLAG <= '1';
end if;
-- STATUS REGISTER B
TEST_databv <= x"0000ffff"; --all rx fifos empty, all lines idle
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK  Status REGISTER B Initial Read");	FAIL_FLAG <= '1';
end if;

-- Verify Interrupt to CPU is inactive
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF ICPB INTERRUPT OUTPUT PRIOR TO SLINK CHANNEL TEST");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- Write 8 Values to TX  (RX_FIFO_ALMOST_FULL SET LOW AT 3 FOR SIM)
-------------------------------------------------
-- (Each Count is 10 us)
DATA_BYTE_EN <= "0000"; -- all selected
WRITE_databv <= x"0000000A"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000B"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000C"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000D"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"00000000"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000A"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000B"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000C"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);

-------------------------------------------------
-- VERIFY TX FIFO COUNT FOR Channel I
-------------------------------------------------
-- FIFO COUNT WILL BE 8 
TEST_databv <= x"0800000C";  --fifo count in upper byte, last data in lower
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INITIAL TX FIFO COUNT VERIFICATION ");	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- CLEAR TX FIFO FOR Channel I
-------------------------------------------------

WRITE_databv <= CHANNEL_I_CLR_TX_FIFO ;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CTRL_REG_ADDR_A, WRITE_databv);

WRITE_databv <= (others => '0');
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CTRL_REG_ADDR_A, WRITE_databv);

-------------------------------------------------
-- VERIFY TX FIFO COUNT FOR Channel I
-------------------------------------------------
-- FIFO COUNT WILL BE 0 
TEST_databv <= x"0000000C";  --fifo count in upper byte, last data in lower
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED TX FIFO COUNT VERIFICATION AFTER TX FIFO CLEARED");	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- PB2: SLPB:  SLINK REINITIALIZATION
-------------------------------------------------
-- Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);

-- Verify SLINK Status Registers Cleared
-- STATUS REGISTER A
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK INTERRUPT Status REGISTER A AFTER REINITIALIZATION");	FAIL_FLAG <= '1';
end if;
-- STATUS REGISTER B
TEST_databv <= x"0000ffff"; --all rx fifos empty, all lines idle
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK  Status REGISTER B AFTER REINITIALIZATION");	FAIL_FLAG <= '1';
end if;

-- Verify Interrupt to CPU is inactive
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF ICPB INTERRUPT OUTPUT AFTER REINITIALIZATION");
	FAIL_FLAG <= '1';
end if;


-------------------------------------------------
-- Enable TX and RX Channel I in SLINK Control REgister
-------------------------------------------------
WRITE_databv <= CHANNEL_I_ENA_TX or CHANNEL_I_ENA_RX;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CTRL_REG_ADDR_A, WRITE_databv);

-------------------------------------------------
-- Write 3 Values to TX
-------------------------------------------------
-- (Each Count is 10 us)
DATA_BYTE_EN <= "0000"; -- all selected
WRITE_databv <= x"00000009"; -- x 10us
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"00000008"; -- x 10us
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"00000007"; -- x 10us
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);

-------------------------------------------------
-- WAIT FOR LINE IDLE
-------------------------------------------------

-- Unmask LI Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_LI; -- CH0 LI interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);


-- Wait for INT_LI(I) to assert
wait until (XS_PWM0 = '1');

-- Verify INT_LI Interrupt Status
-- in addition to LI, TS will not assert (already did prior to reading first set of data)
-- in addition to LI, RS will assert (as rx fifo fills, rxfifo almost full =3)

--TEST_databv <= CHANNEL_I_LI or CHANNEL_I_RS; -- if rxfifo almost full=3
TEST_databv <= CHANNEL_I_LI ; -- if rxfifo almost full=120


DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_LI SLINK Status REGISTER Readback AFTER Expected LI INTERRUPT");	FAIL_FLAG <= '1';
end if;

--Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

--Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);

--Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER LI INTERRUPT");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  CHECK STATUS REGISTER B TO VERIFY RX FIFO NOT EMPTY STATUS
-------------------------------------------------
-- read STATUS REGISTER B:
-- all channels now idle
-- AND CHANNEL_I RECIEVE FIFO IS NOT EMPTY (BUT ALL OTHERS ARE)
TEST_databv <= (x"000000FF")or (not CHANNEL_I_TC and x"0000FF00"); --RE AND TC ARE SAME BIT POSITION 
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK Status REGISTER B BEFORE READING LAST FIVE RX DATA");	
FAIL_FLAG <= '1';
end if;


-------------------------------------------------
-- Read 1ST RX Data (OF 4)
-------------------------------------------------

-- REad RX DATA 
TEST_databv <= x"03000009";  --FIFO COUNT WILL BE 4-1=3, LAST DATA IN LSB
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1st SL RX DAta REadback");	
FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- CLEAR RX FIFO FOR Channel I
-------------------------------------------------

WRITE_databv <= CHANNEL_I_CLR_RX_FIFO or CHANNEL_I_ENA_TX or CHANNEL_I_ENA_RX ; --LEAVE CHANNEL ENABLED
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CTRL_REG_ADDR_A, WRITE_databv);

WRITE_databv <= CHANNEL_I_ENA_TX or CHANNEL_I_ENA_RX ;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CTRL_REG_ADDR_A, WRITE_databv);

-------------------------------------------------
-- VERIFY RX FIFO CLEAR - READ RX Data 
-------------------------------------------------

-- REad RX DATA 
TEST_databv <= x"00000008";  --FIFO COUNT WILL BE 0, NEXT DATA IN LSB, 
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1st SL RX DAta REadback AFTER CLEARING RX FIFO");	
FAIL_FLAG <= '1';
end if;



-------------------------------------------------
-- Announce Status of Fail Flag on Each Loop
-------------------------------------------------
WAIT_CYCLE_RISING(5);
	
if FAIL_FLAG = '0' then 
	PRINT(" PASSED SLINK FIFO CLEAR Verification for Channel:  ");
	VPRINT(I);

else 	PRINT("FAILED SLINK FIFO CLEAR Verification for Channel:  ");
	VPRINT(I);
end if;

end loop SLINKFIFO_CLEAR_TEST;
--*********************************************************************************
--*********************************************************************************



--*********************************************************************************
--*********************************************************************************
--TEST_SLINKRXFIFOS: 
--*********************************************************************************
--*********************************************************************************
SLINKRXFIFOS_TEST: for I in 0 to 7 loop
exit SLINKRXFIFOS_TEST when TEST_SLINKRXFIFOS = FALSE;

--------------------------------------------------
-- Register Bit and address changes over 8 channels:
--------------------------------------------------
if I = 0 then 
	CHANNEL_I_TS 		<= x"01000000";
	CHANNEL_I_RS 		<= x"00010000";
	CHANNEL_I_TC 		<= x"00000100";
	CHANNEL_I_LI 		<= x"00000001";
	CHANNEL_I_CLR_TX_FIFO 	<= x"01000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00010000";
	CHANNEL_I_ENA_TX 		<= x"00000100";
	CHANNEL_I_ENA_RX 		<= x"00000001";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL0_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL0_ADDR;
elsif I = 1 then
	CHANNEL_I_TS 		<= x"02000000";
	CHANNEL_I_RS 		<= x"00020000";
	CHANNEL_I_TC 		<= x"00000200";
	CHANNEL_I_LI 		<= x"00000002";
	CHANNEL_I_CLR_TX_FIFO 	<= x"02000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00020000";
	CHANNEL_I_ENA_TX 		<= x"00000200";
	CHANNEL_I_ENA_RX 		<= x"00000002";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL1_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL1_ADDR;

elsif I = 2 then
	CHANNEL_I_TS 		<= x"04000000";
	CHANNEL_I_RS 		<= x"00040000";
	CHANNEL_I_TC 		<= x"00000400";
	CHANNEL_I_LI 		<= x"00000004";
	CHANNEL_I_CLR_TX_FIFO 	<= x"04000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00040000";
	CHANNEL_I_ENA_TX 		<= x"00000400";
	CHANNEL_I_ENA_RX 		<= x"00000004";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL2_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL2_ADDR;

elsif I = 3 then
	CHANNEL_I_TS 		<= x"08000000";
	CHANNEL_I_RS 		<= x"00080000";
	CHANNEL_I_TC 		<= x"00000800";
	CHANNEL_I_LI 		<= x"00000008";
	CHANNEL_I_CLR_TX_FIFO 	<= x"08000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00080000";
	CHANNEL_I_ENA_TX 		<= x"00000800";
	CHANNEL_I_ENA_RX 		<= x"00000008";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL3_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL3_ADDR;

elsif I = 4 then
	CHANNEL_I_TS 		<= x"10000000";
	CHANNEL_I_RS 		<= x"00100000";
	CHANNEL_I_TC 		<= x"00001000";
	CHANNEL_I_LI 		<= x"00000010";
	CHANNEL_I_CLR_TX_FIFO 	<= x"10000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00100000";
	CHANNEL_I_ENA_TX 		<= x"00001000";
	CHANNEL_I_ENA_RX 		<= x"00000010";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL4_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL4_ADDR;

elsif I = 5 then
	CHANNEL_I_TS 		<= x"20000000";
	CHANNEL_I_RS 		<= x"00200000";
	CHANNEL_I_TC 		<= x"00002000";
	CHANNEL_I_LI 		<= x"00000020";
	CHANNEL_I_CLR_TX_FIFO 	<= x"20000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00200000";
	CHANNEL_I_ENA_TX 		<= x"00002000";
	CHANNEL_I_ENA_RX 		<= x"00000020";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL5_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL5_ADDR;

elsif I = 6 then
	CHANNEL_I_TS 		<= x"40000000";
	CHANNEL_I_RS 		<= x"00400000";
	CHANNEL_I_TC 		<= x"00004000";
	CHANNEL_I_LI 		<= x"00000040";
	CHANNEL_I_CLR_TX_FIFO 	<= x"40000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00400000";
	CHANNEL_I_ENA_TX 		<= x"00004000";
	CHANNEL_I_ENA_RX 		<= x"00000040";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL6_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL6_ADDR;

elsif I = 7 then
	CHANNEL_I_TS 		<= x"80000000";
	CHANNEL_I_RS 		<= x"00800000";
	CHANNEL_I_TC 		<= x"00008000";
	CHANNEL_I_LI 		<= x"00000080";
	CHANNEL_I_CLR_TX_FIFO 	<= x"80000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00800000";
	CHANNEL_I_ENA_TX 		<= x"00008000";
	CHANNEL_I_ENA_RX 		<= x"00000080";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL7_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL7_ADDR;

end if;
--------------------------------------------------

-------------------------------------------------
-- PB0: CPB:  Enable Interrupt and SLINK Peripheral Blocks
-------------------------------------------------
-- Write data to PBEN_REG (Chip select 4 x8 PBEN_REG_ADDR)
WRITE_databv <= x"00000007";  -- "0111" in lsnibble enables PB0,1,2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, PBEN_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-------------------------------------------------
-- PB1: ICPB:  Enable and unmask PB2 Interrupt in Interrupt Controller
-------------------------------------------------
-- Clear all interrupt latches
-- Write all 1's to interrupt clear register at cs4, INT_CLR_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Enable PB2 interrupt, write 1 to bit 2 in INT_ENA_REG_ADDR
WRITE_databv <= x"00000004";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_ENA_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Unmask PB2 interrupt, write 1 to bit 2 in INT_MASK_REG_ADDR
WRITE_databv <= x"00000004";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_MASK_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Read Interrupt Status register,INT_STAT_REG_ADDR, (should read 0)
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PB2 Interrupt Status REGISTER Initial Readback");	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- PB2: SLPB:  SLINK INITIALIZATION
-------------------------------------------------
-- Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);

-- Verify SLINK Status Registers Cleared
-- STATUS REGISTER A
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK INTERRUPT Status REGISTER A Initial Clear");	FAIL_FLAG <= '1';
end if;
-- STATUS REGISTER B
TEST_databv <= x"0000ffff"; --all rx fifos empty, all lines idle
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK  Status REGISTER B Initial Read");	FAIL_FLAG <= '1';
end if;

-- Verify Interrupt to CPU is inactive
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF ICPB INTERRUPT OUTPUT PRIOR TO SLINK CHANNEL TEST");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- Write 8 Values to TX  (RX_FIFO_ALMOST_FULL SET LOW AT 3 FOR SIM)
-------------------------------------------------
-- (Each Count is 10 us)
DATA_BYTE_EN <= "0000"; -- all selected
WRITE_databv <= x"0000000A"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000B"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000C"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000D"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"00000000"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000A"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000B"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000C"; 
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);

-------------------------------------------------
-- VERIFY TX FIFO COUNT FOR Channel I
-------------------------------------------------
-- FIFO COUNT WILL BE 8 
TEST_databv <= x"0800000C";  --fifo count in upper byte, last data in lower
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INITIAL TX FIFO COUNT VERIFICATION ");	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- Enable TX and RX Channel I in SLINK Control REgister
-------------------------------------------------
WRITE_databv <= CHANNEL_I_ENA_TX or CHANNEL_I_ENA_RX;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CTRL_REG_ADDR_A, WRITE_databv);

-------------------------------------------------
--  WAIT FOR INT_RS INTERRUPT
-------------------------------------------------
-- INT_RS IS DRIVEN BY RX FIFO ALMOST FULL (3)
-- Unmask RS Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_RS; -- CH0 RS interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);

-- Wait for INT_RS(I) to assert
wait until (XS_PWM0 = '1');

-- Verify PB2 Interrupt Status 
TEST_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PB2 Interrupt Status REGISTER Readback AFTER First RS INTERRUPT");	FAIL_FLAG <= '1';
end if;

-- Verify INT_RS Interrupt Status
TEST_databv <= CHANNEL_I_RS or CHANNEL_I_TS;  --TX SERVICE (FIFO ALMOST EMPTY) also asserts
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_RS SLINK Status REGISTER Readback AFTER First RS INTERRUPT");	FAIL_FLAG <= '1';
end if;

-- Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

--Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);

-- Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER First RS INTERRUPT");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  CHECK STATUS REGISTER B TO VERIFY RX FIFO NOT EMPTY STATUS
-------------------------------------------------
-- read STATUS REGISTER B:
-- all channels EXCEPT CHANNEL_I now idle
-- all channels except CHANNEL_I have empty RX fifos  (RE is same as TC bit position)
TEST_databv <= (not CHANNEL_I_LI and x"000000FF")or (not CHANNEL_I_TC and x"0000FF00");  
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK Status REGISTER B BEFORE READING FIRST FOUR RX DATA");	
FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  READBACK FOUR RX VALUES (FIFO COUNT OF 3 MEANS 4 AVAIL)
-------------------------------------------------

DATA_BYTE_EN <= "0000";
TEST_databv <= x"0300000A";  
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1st SL RX Data 1 REadback ");FAIL_FLAG <= '1';
end if;
TEST_databv <= x"0200000B";  
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1st SL RX Data  2 REadback ");FAIL_FLAG <= '1';
end if;
TEST_databv <= x"0100000C";  
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1st SL RX Data 3 REadback ");FAIL_FLAG <= '1';
end if;
TEST_databv <= x"0000000D";  
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1st SL RX Data 4 REadback ");FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  CHECK STATUS REGISTER B TO VERIFY FIFO EMPTY STATUS
-------------------------------------------------
-- read STATUS REGISTER B:
-- all channels EXCEPT CHANNEL_I now idle
-- AND CHANNEL_I RECIEVE FIFO IS NEWLY EMPTY (AS ARE ALL OTHERS)
TEST_databv <= (not CHANNEL_I_LI and x"000000FF") or x"0000FF00";   --
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK Status REGISTER B After READING FIRST FOUR RX DATA");	
FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- WAIT FOR LINE IDLE
-------------------------------------------------

-- Unmask LI Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_LI; -- CH0 LI interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);


-- Wait for INT_LI(I) to assert
wait until (XS_PWM0 = '1');

-- Verify INT_LI Interrupt Status
-- in addition to LI, TS will not assert (already did prior to reading first set of data)
-- in addition to LI, RS will assert (as rx fifo fills, rxfifo almost full =4)
TEST_databv <= CHANNEL_I_LI or CHANNEL_I_RS;
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_LI SLINK Status REGISTER Readback AFTER Expected LI INTERRUPT");	FAIL_FLAG <= '1';
end if;

--Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

--Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);

--Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER LI INTERRUPT");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  CHECK STATUS REGISTER B TO VERIFY RX FIFO NOT EMPTY STATUS
-------------------------------------------------
-- read STATUS REGISTER B:
-- all channels now idle
-- AND CHANNEL_I RECIEVE FIFO IS NOT EMPTY (BUT ALL OTHERS ARE)
TEST_databv <= (x"000000FF")or (not CHANNEL_I_TC and x"0000FF00"); --RE AND TC ARE SAME BIT POSITION 
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK Status REGISTER B BEFORE READING LAST FIVE RX DATA");	
FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  READBACK 4  RX VALUES (LAST VALUE IS 0, DUE TO TX UNDERFLOW)
-------------------------------------------------
-- FIFO COUNT WILL BE FOUR

DATA_BYTE_EN <= "0000";
TEST_databv <= x"04000000";  
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1st SL RX Data 5 REadback ");FAIL_FLAG <= '1';
end if;
TEST_databv <= x"0300000A";  
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1st SL RX Data  6 REadback ");FAIL_FLAG <= '1';
end if;
TEST_databv <= x"0200000B";  
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1st SL RX Data 7 REadback ");FAIL_FLAG <= '1';
end if;
TEST_databv <= x"0100000C";  
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1st SL RX Data 8 REadback ");FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  CHECK STATUS REGISTER B TO VERIFY RX FIFO NOT EMPTY STATUS
-------------------------------------------------
-- read STATUS REGISTER B:
-- all channels now idle
-- AND CHANNEL_I RECIEVE FIFO IS NOT EMPTY (BUT ALL OTHERS ARE)
TEST_databv <= (x"000000FF")or (not CHANNEL_I_TC and x"0000FF00"); --RE AND TC ARE SAME BIT POSITION 
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK Status REGISTER B BEFORE READING LAST RX DATA");	
FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  READBACK LAST  RX VALUES (LAST VALUE IS 0, DUE TO TX UNDERFLOW)
-------------------------------------------------

TEST_databv <= x"00000000";  
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1st SL RX Data 9 REadback ");FAIL_FLAG <= '1';
end if;


-------------------------------------------------
--  CHECK STATUS REGISTER B TO VERIFY FIFO EMPTY STATUS
-------------------------------------------------
-- read STATUS REGISTER B:
-- all channels now idle
-- AND RECIEVE FIFO NEWLY EMPTY (ALL CHANNELS)
TEST_databv <= (x"000000FF") or x"0000FF00";   
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK Status REGISTER B After READING LAST FIVE RX DATA");	
FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- Announce Status of Fail Flag on Each Loop
-------------------------------------------------
WAIT_CYCLE_RISING(5);
	
if FAIL_FLAG = '0' then 
	PRINT(" PASSED SLINK RX FIFO Verification for Channel:  ");
	VPRINT(I);

else 	PRINT("FAILED SLINK RX FIFO Verification for Channel:  ");
	VPRINT(I);
end if;

end loop SLINKRXFIFOS_TEST ;
--*********************************************************************************
--*********************************************************************************




--*********************************************************************************
--*********************************************************************************
--TEST_SLINK WITH TX FIFO
--*********************************************************************************
--*********************************************************************************
SLINK_TEST_TX_FIFOS: for I in 0 to 7 loop
exit SLINK_TEST_TX_FIFOS when TEST_SLINK_TX_FIFOS = FALSE;

--------------------------------------------------
-- Register Bit and address changes over 8 channels:
--------------------------------------------------
if I = 0 then 
	CHANNEL_I_TS 		<= x"01000000";
	CHANNEL_I_RS 		<= x"00010000";
	CHANNEL_I_TC 		<= x"00000100";
	CHANNEL_I_LI 		<= x"00000001";
	CHANNEL_I_CLR_TX_FIFO 	<= x"01000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00010000";
	CHANNEL_I_ENA_TX 		<= x"00000100";
	CHANNEL_I_ENA_RX 		<= x"00000001";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL0_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL0_ADDR;
elsif I = 1 then
	CHANNEL_I_TS 		<= x"02000000";
	CHANNEL_I_RS 		<= x"00020000";
	CHANNEL_I_TC 		<= x"00000200";
	CHANNEL_I_LI 		<= x"00000002";
	CHANNEL_I_CLR_TX_FIFO 	<= x"02000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00020000";
	CHANNEL_I_ENA_TX 		<= x"00000200";
	CHANNEL_I_ENA_RX 		<= x"00000002";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL1_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL1_ADDR;

elsif I = 2 then
	CHANNEL_I_TS 		<= x"04000000";
	CHANNEL_I_RS 		<= x"00040000";
	CHANNEL_I_TC 		<= x"00000400";
	CHANNEL_I_LI 		<= x"00000004";
	CHANNEL_I_CLR_TX_FIFO 	<= x"04000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00040000";
	CHANNEL_I_ENA_TX 		<= x"00000400";
	CHANNEL_I_ENA_RX 		<= x"00000004";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL2_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL2_ADDR;

elsif I = 3 then
	CHANNEL_I_TS 		<= x"08000000";
	CHANNEL_I_RS 		<= x"00080000";
	CHANNEL_I_TC 		<= x"00000800";
	CHANNEL_I_LI 		<= x"00000008";
	CHANNEL_I_CLR_TX_FIFO 	<= x"08000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00080000";
	CHANNEL_I_ENA_TX 		<= x"00000800";
	CHANNEL_I_ENA_RX 		<= x"00000008";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL3_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL3_ADDR;

elsif I = 4 then
	CHANNEL_I_TS 		<= x"10000000";
	CHANNEL_I_RS 		<= x"00100000";
	CHANNEL_I_TC 		<= x"00001000";
	CHANNEL_I_LI 		<= x"00000010";
	CHANNEL_I_CLR_TX_FIFO 	<= x"10000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00100000";
	CHANNEL_I_ENA_TX 		<= x"00001000";
	CHANNEL_I_ENA_RX 		<= x"00000010";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL4_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL4_ADDR;

elsif I = 5 then
	CHANNEL_I_TS 		<= x"20000000";
	CHANNEL_I_RS 		<= x"00200000";
	CHANNEL_I_TC 		<= x"00002000";
	CHANNEL_I_LI 		<= x"00000020";
	CHANNEL_I_CLR_TX_FIFO 	<= x"20000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00200000";
	CHANNEL_I_ENA_TX 		<= x"00002000";
	CHANNEL_I_ENA_RX 		<= x"00000020";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL5_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL5_ADDR;

elsif I = 6 then
	CHANNEL_I_TS 		<= x"40000000";
	CHANNEL_I_RS 		<= x"00400000";
	CHANNEL_I_TC 		<= x"00004000";
	CHANNEL_I_LI 		<= x"00000040";
	CHANNEL_I_CLR_TX_FIFO 	<= x"40000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00400000";
	CHANNEL_I_ENA_TX 		<= x"00004000";
	CHANNEL_I_ENA_RX 		<= x"00000040";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL6_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL6_ADDR;

elsif I = 7 then
	CHANNEL_I_TS 		<= x"80000000";
	CHANNEL_I_RS 		<= x"00800000";
	CHANNEL_I_TC 		<= x"00008000";
	CHANNEL_I_LI 		<= x"00000080";
	CHANNEL_I_CLR_TX_FIFO 	<= x"80000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00800000";
	CHANNEL_I_ENA_TX 		<= x"00008000";
	CHANNEL_I_ENA_RX 		<= x"00000080";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL7_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL7_ADDR;

end if;
--------------------------------------------------

-------------------------------------------------
-- PB0: CPB:  Enable Interrupt and SLINK Peripheral Blocks
-------------------------------------------------
-- Write data to PBEN_REG (Chip select 4 x8 PBEN_REG_ADDR)
WRITE_databv <= x"00000007";  -- "0111" in lsnibble enables PB0,1,2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, PBEN_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-------------------------------------------------
-- PB1: ICPB:  Enable and unmask PB2 Interrupt in Interrupt Controller
-------------------------------------------------
-- Clear all interrupt latches
-- Write all 1's to interrupt clear register at cs4, INT_CLR_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Enable PB2 interrupt, write 1 to bit 2 in INT_ENA_REG_ADDR
WRITE_databv <= x"00000004";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_ENA_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Unmask PB2 interrupt, write 1 to bit 2 in INT_MASK_REG_ADDR
WRITE_databv <= x"00000004";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_MASK_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Read Interrupt Status register,INT_STAT_REG_ADDR, (should read 0)
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PB2 Interrupt Status REGISTER Initial Readback");	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- PB2: SLPB:  SLINK INITIALIZATION
-------------------------------------------------
-- Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);

-- Verify SLINK Status Registers Cleared
-- STATUS REGISTER A:  
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK INTERRUPT Status REGISTER A Initial Clear");	FAIL_FLAG <= '1';
end if;
-- STATUS REGISTER B:
--  STAT_RO  STAT_TF  STAT_RE  STAT_PI  (FOR NON-FIFO TEST)
--TEST_databv <= x"000000FF";  --prior to RX FIFO 
TEST_databv <= x"0000FFFF";  --with RX FIFO
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK INTERRUPT Status REGISTER B Initial Clear");	
FAIL_FLAG <= '1';
end if;

-- Verify Interrupt to CPU is inactive
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF ICPB INTERRUPT OUTPUT PRIOR TO SLINK CHANNEL TEST");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- TX CHANNEL TEST 1: WRITE VALUES TO FIFO AND THEN ENABLE
-------------------------------------------------

-- Write 10 VAlues to TX Fifo
DATA_BYTE_EN <= "0000"; -- all selected
WRITE_databv <= x"0000000A"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000B"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000C"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000D"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000E"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000F"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"00000000"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000A"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000B"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);
WRITE_databv <= x"0000000C"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);

-------------------------------------------------
-- VERIFY TX FIFO COUNT FOR Channel I
-------------------------------------------------
-- FIFO COUNT WILL BE 10 
TEST_databv <= x"0A00000C";  --fifo count in upper byte, last data in lower
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INITIAL TX FIFO COUNT VERIFICATION ");	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- Enable TX and RX Channel I in SLINK Control REgister
-------------------------------------------------
WRITE_databv <= CHANNEL_I_ENA_TX or CHANNEL_I_ENA_RX;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CTRL_REG_ADDR_A, WRITE_databv);

-------------------------------------------------
-- WAIT FOR TS INTERRUPT 1 
-------------------------------------------------
-- TX ALMOST EMPTY COUNT IS SET TO 3 FOR SIMULATION
-- WAIT FOR INT_TS TO ASSERT (DATA 6 SHOULD BE AVAILABLE TO READ FOR VERIFICATION)

-- Unmask TS Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_TS; -- CH0 RS interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);

-- Wait for INT_TS(I) to assert
wait until (XS_PWM0 = '1');

-- Verify PB2 Interrupt Status 
TEST_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PB2 Interrupt Status REGISTER Readback AFTER First TS INTERRUPT");	FAIL_FLAG <= '1';
end if;

-- Verify INT_TS Interrupt Status
--3-2-04 TEST_databv <= CHANNEL_I_TS;
TEST_databv <= CHANNEL_I_TS or CHANNEL_I_RS; -- RS_INT will also assert (fifo almost full or non fifo version)
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_TS SLINK Status REGISTER Readback AFTER First TS INTERRUPT");	FAIL_FLAG <= '1';
end if;

-- Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Clear INT_TS SL Interrupt
WRITE_databv <= CHANNEL_I_TS;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER First TS INTERRUPT");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  READ FIRST RX DATA 
-------------------------------------------------
-- REad RCV_SL0
--TEST_databv <= x"0000000E";  -- for non RX fifo version 6TH data was x0F
TEST_databv <= x"0400000A";  -- for RX fifo version 1st data was x0A, rx fifo count at this point is 4
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED 1ST SL RX DAta REadback ");	
FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- Wait for LINE IDLE INTERRUPT 
-------------------------------------------------

-- Unmask LI Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_LI; -- CH0 LI interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);


-- Wait for INT_LI(I) to assert
wait until (XS_PWM0 = '1');

-- Verify INT_LI Interrupt Status
--3-2-04 TEST_databv <= CHANNEL_I_LI;
TEST_databv <= CHANNEL_I_LI or CHANNEL_I_RS;  -- if RS fifo not implemented, RS_INT will also assert 
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_LI SLINK Status REGISTER Readback AFTER Expected LI INTERRUPT");	FAIL_FLAG <= '1';
end if;

--Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

--Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_B, WRITE_databv);

--Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER RS INTERRUPT 2");
	FAIL_FLAG <= '1';
end if;


-------------------------------------------------
--  READ REMAINING 10 RX DATA (RX FIFO VERSION ONLY)
-------------------------------------------------
TEST_databv <= x"0900000B";  -- TOTAL OF 11 RCVD, ONE ALREADY READ => -1 =>FIFO COUNT OF 9,
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta REadback 2");	FAIL_FLAG <= '1';
end if;

TEST_databv <= x"0800000C";  
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta REadback 3 ");	FAIL_FLAG <= '1';
end if;

TEST_databv <= x"0700000D";  
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta REadback 4");	FAIL_FLAG <= '1';
end if;

TEST_databv <= x"0600000E";  
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED  SL RX DAta REadback 5");	FAIL_FLAG <= '1';
end if;

TEST_databv <= x"0500000F";  
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta REadback 6 ");	FAIL_FLAG <= '1';
end if;

TEST_databv <= x"04000000"; 
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta REadback 7 ");	FAIL_FLAG <= '1';
end if;

TEST_databv <= x"0300000A";  
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta REadback 8");	FAIL_FLAG <= '1';
end if;

TEST_databv <= x"0200000B";  
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta REadback 9");	FAIL_FLAG <= '1';
end if;

TEST_databv <= x"0100000C";  
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta REadback 10 ");	FAIL_FLAG <= '1';
end if;

TEST_databv <= x"00000000";  
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32; WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta REadback 11");	FAIL_FLAG <= '1';
end if;


-- read STATUS REGISTER B:

--TEST_databv <= x"000000FF";  -- all channels now idle - non RXfifo version has RX Fifo Empty not asserted
TEST_databv <= x"0000FFFF";  -- all channels now idle - RXFIFO version has all RE bits set too

DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK INTERRUPT Status REGISTER B After EXPECTED LINE IDLE INTERRUPT");	
FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- Announce Status of Fail Flag on Each Loop
-------------------------------------------------
WAIT_CYCLE_RISING(5);
	
if FAIL_FLAG = '0' then 
	PRINT(" PASSED SLINK Verification with TX FIFOS for Channel:  ");
	VPRINT(I);

else 	PRINT("FAILED SLINK Verification with TX FIFOS for Channel:  ");
	VPRINT(I);
end if;


end loop SLINK_TEST_TX_FIFOS;



--*********************************************************************************
--*********************************************************************************
--TEST_SLINK WITHOUT FIFO
--*********************************************************************************
--*********************************************************************************
SLINK_TEST_WO_FIFOS: for I in 0 to 7 loop
exit SLINK_TEST_WO_FIFOS when TEST_SLINK_WO_FIFOS = FALSE;

--------------------------------------------------
-- Register Bit and address changes over 8 channels:
--------------------------------------------------
if I = 0 then 
	CHANNEL_I_TS 		<= x"01000000";
	CHANNEL_I_RS 		<= x"00010000";
	CHANNEL_I_TC 		<= x"00000100";
	CHANNEL_I_LI 		<= x"00000001";
	CHANNEL_I_CLR_TX_FIFO 	<= x"01000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00010000";
	CHANNEL_I_ENA_TX 		<= x"00000100";
	CHANNEL_I_ENA_RX 		<= x"00000001";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL0_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL0_ADDR;
elsif I = 1 then
	CHANNEL_I_TS 		<= x"02000000";
	CHANNEL_I_RS 		<= x"00020000";
	CHANNEL_I_TC 		<= x"00000200";
	CHANNEL_I_LI 		<= x"00000002";
	CHANNEL_I_CLR_TX_FIFO 	<= x"02000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00020000";
	CHANNEL_I_ENA_TX 		<= x"00000200";
	CHANNEL_I_ENA_RX 		<= x"00000002";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL1_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL1_ADDR;

elsif I = 2 then
	CHANNEL_I_TS 		<= x"04000000";
	CHANNEL_I_RS 		<= x"00040000";
	CHANNEL_I_TC 		<= x"00000400";
	CHANNEL_I_LI 		<= x"00000004";
	CHANNEL_I_CLR_TX_FIFO 	<= x"04000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00040000";
	CHANNEL_I_ENA_TX 		<= x"00000400";
	CHANNEL_I_ENA_RX 		<= x"00000004";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL2_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL2_ADDR;

elsif I = 3 then
	CHANNEL_I_TS 		<= x"08000000";
	CHANNEL_I_RS 		<= x"00080000";
	CHANNEL_I_TC 		<= x"00000800";
	CHANNEL_I_LI 		<= x"00000008";
	CHANNEL_I_CLR_TX_FIFO 	<= x"08000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00080000";
	CHANNEL_I_ENA_TX 		<= x"00000800";
	CHANNEL_I_ENA_RX 		<= x"00000008";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL3_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL3_ADDR;

elsif I = 4 then
	CHANNEL_I_TS 		<= x"10000000";
	CHANNEL_I_RS 		<= x"00100000";
	CHANNEL_I_TC 		<= x"00001000";
	CHANNEL_I_LI 		<= x"00000010";
	CHANNEL_I_CLR_TX_FIFO 	<= x"10000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00100000";
	CHANNEL_I_ENA_TX 		<= x"00001000";
	CHANNEL_I_ENA_RX 		<= x"00000010";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL4_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL4_ADDR;

elsif I = 5 then
	CHANNEL_I_TS 		<= x"20000000";
	CHANNEL_I_RS 		<= x"00200000";
	CHANNEL_I_TC 		<= x"00002000";
	CHANNEL_I_LI 		<= x"00000020";
	CHANNEL_I_CLR_TX_FIFO 	<= x"20000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00200000";
	CHANNEL_I_ENA_TX 		<= x"00002000";
	CHANNEL_I_ENA_RX 		<= x"00000020";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL5_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL5_ADDR;

elsif I = 6 then
	CHANNEL_I_TS 		<= x"40000000";
	CHANNEL_I_RS 		<= x"00400000";
	CHANNEL_I_TC 		<= x"00004000";
	CHANNEL_I_LI 		<= x"00000040";
	CHANNEL_I_CLR_TX_FIFO 	<= x"40000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00400000";
	CHANNEL_I_ENA_TX 		<= x"00004000";
	CHANNEL_I_ENA_RX 		<= x"00000040";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL6_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL6_ADDR;

elsif I = 7 then
	CHANNEL_I_TS 		<= x"80000000";
	CHANNEL_I_RS 		<= x"00800000";
	CHANNEL_I_TC 		<= x"00008000";
	CHANNEL_I_LI 		<= x"00000080";
	CHANNEL_I_CLR_TX_FIFO 	<= x"80000000";
	CHANNEL_I_CLR_RX_FIFO 	<= x"00800000";
	CHANNEL_I_ENA_TX 		<= x"00008000";
	CHANNEL_I_ENA_RX 		<= x"00000080";
	CHANNEL_I_SEND_ADDR 	<= SEND_SL7_ADDR;
	CHANNEL_I_RCV_ADDR  	<= RCV_SL7_ADDR;

end if;
--------------------------------------------------

-------------------------------------------------
-- PB0: CPB:  Enable Interrupt and SLINK Peripheral Blocks
-------------------------------------------------
-- Write data to PBEN_REG (Chip select 4 x8 PBEN_REG_ADDR)
WRITE_databv <= x"00000007";  -- "0111" in lsnibble enables PB0,1,2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, PBEN_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-------------------------------------------------
-- PB1: ICPB:  Enable and unmask PB2 Interrupt in Interrupt Controller
-------------------------------------------------
-- Clear all interrupt latches
-- Write all 1's to interrupt clear register at cs4, INT_CLR_REG_ADDR
WRITE_databv <= x"FFFFFFFF";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Enable PB2 interrupt, write 1 to bit 2 in INT_ENA_REG_ADDR
WRITE_databv <= x"00000004";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_ENA_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Unmask PB2 interrupt, write 1 to bit 2 in INT_MASK_REG_ADDR
WRITE_databv <= x"00000004";
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_MASK_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);
-- Read Interrupt Status register,INT_STAT_REG_ADDR, (should read 0)
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PB2 Interrupt Status REGISTER Initial Readback");	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- PB2: SLPB:  SLINK INITIALIZATION
-------------------------------------------------
-- Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);

-- Verify SLINK Status Registers Cleared
-- STATUS REGISTER A:  
TEST_databv <= x"00000000";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK INTERRUPT Status REGISTER A Initial Clear");	FAIL_FLAG <= '1';
end if;
-- STATUS REGISTER B:
--  STAT_RO  STAT_TF  STAT_RE  STAT_PI  (FOR NON-FIFO TEST)
TEST_databv <= x"000000FF";
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK INTERRUPT Status REGISTER B Initial Clear");	
FAIL_FLAG <= '1';
end if;

-- Verify Interrupt to CPU is inactive
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF ICPB INTERRUPT OUTPUT PRIOR TO SLINK CHANNEL TEST");
	FAIL_FLAG <= '1';
end if;
-------------------------------------------------
-- Enable TX and RX Channel I in SLINK Control REgister
-------------------------------------------------
WRITE_databv <= CHANNEL_I_ENA_TX or CHANNEL_I_ENA_RX;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CTRL_REG_ADDR_A, WRITE_databv);

-------------------------------------------------
-- Write First Count to TX Channel I
-------------------------------------------------
DATA_BYTE_EN <= "0000"; -- all selected
WRITE_databv <= x"0000000A"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);

-------------------------------------------------
-- WAIT FOR TS INTERRUPT 1 TO WRITE NEXT TX DATA
-------------------------------------------------
-- Unmask TS Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_TS; -- CH0 RS interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);

-- Wait for INT_TS(I) to assert
wait until (XS_PWM0 = '1');

-- Verify PB2 Interrupt Status 
TEST_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PB2 Interrupt Status REGISTER Readback AFTER First TS INTERRUPT");	FAIL_FLAG <= '1';
end if;

-- Verify INT_TS Interrupt Status
TEST_databv <= CHANNEL_I_TS;
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_TS SLINK Status REGISTER Readback AFTER First TS INTERRUPT");	FAIL_FLAG <= '1';
end if;

-- Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Clear INT_TS SL Interrupt
WRITE_databv <= CHANNEL_I_TS;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER First TS INTERRUPT");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- Write Count 2 to TX Channel I
-------------------------------------------------

DATA_BYTE_EN <= "0000"; -- all selected
WRITE_databv <= x"0000000B"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);

-------------------------------------------------
--  Wait for INT_RS Interrupt TO INDICATE RX DATA 1 AVAILABLE
-------------------------------------------------
-- Unmask RS Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_RS; -- CH0 RS interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);

-- Wait for INT_RS(I) to assert
wait until (XS_PWM0 = '1');

-- Verify PB2 Interrupt Status 
TEST_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PB2 Interrupt Status REGISTER Readback AFTER First RS INTERRUPT");	FAIL_FLAG <= '1';
end if;

-- Verify INT_RS Interrupt Status
TEST_databv <= CHANNEL_I_RS;
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_RS SLINK Status REGISTER Readback AFTER First RS INTERRUPT");	FAIL_FLAG <= '1';
end if;

-- Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Clear INT_RS SL Interrupt
WRITE_databv <= CHANNEL_I_RS;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER First RS INTERRUPT");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  READ FIRST RX DATA
-------------------------------------------------
-- REad RCV_SL0
TEST_databv <= x"0000000A";  -- FIrst data was x0A
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED First SL RX DAta REadback");	
FAIL_FLAG <= '1';
end if;

-------------------------------------------------
-- WAIT FOR TS INTERRUPT 2 (after which, you can write more data)
-------------------------------------------------
-- Unmask TS Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_TS; -- CH0 RS interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);

-- Wait for INT_TS(I) to assert
wait until (XS_PWM0 = '1');

-- Verify PB2 Interrupt Status 
TEST_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PB2 Interrupt Status REGISTER Readback AFTER TS INTERRUPT 2");	FAIL_FLAG <= '1';
end if;

-- Verify INT_TS Interrupt Status
TEST_databv <= CHANNEL_I_TS;
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_TS SLINK Status REGISTER Readback AFTER TS INTERRUPT 2");	FAIL_FLAG <= '1';
end if;

-- Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Clear INT_TS SL Interrupt
WRITE_databv <= CHANNEL_I_TS;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER TS INTERRUPT 2");
	FAIL_FLAG <= '1';
end if;

--*********************************************************
-- Optional Zero Count Termination
--*********************************************************
-------------------------------------------------
-- Optional Write of 0 Count
-------------------------------------------------
DATA_BYTE_EN <= "0000"; -- all selected
WRITE_databv <= x"00000000"; -- (Each Count is 10 us)
CPU_WRITE("cs4",DATA_BYTE_EN, CHANNEL_I_SEND_ADDR , WRITE_databv);

--*********************************************************


------------------------------------------------
--  Wait for 2nd INT_RS Interrupt TO INDICATE RX DATA AVAILABLE
-------------------------------------------------
-- Unmask RS Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_RS; -- CH0 RS interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);


-- Wait for INT_RS(I) to assert
wait until (XS_PWM0 = '1');

-- Verify INT_RS Interrupt Status
TEST_databv <= CHANNEL_I_RS;
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_RS SLINK Status REGISTER Readback AFTER RS INTERRUPT 2");	FAIL_FLAG <= '1';
end if;

--Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Clear INT_RS SL Interrupt
WRITE_databv <= CHANNEL_I_RS;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);
WAIT_CYCLE_RISING(5);


--Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER RS INTERRUPT 2");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  READ SECOND RX DATA
-------------------------------------------------
-- REad SECOND RX DATA
TEST_databv <= x"0000000B";  
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta 2 REadback");	
FAIL_FLAG <= '1';
end if;



--*********************************************************
-- include when optional termination written
-------------------------------------------------
-- Wait for TS INTERRUPT 3
-------------------------------------------------
-- Unmask TS Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_TS; -- CH0 RS interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);

-- Wait for INT_TS(I) to assert
wait until (XS_PWM0 = '1');

-- Verify PB2 Interrupt Status 
TEST_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, INT_STAT_REG_ADDR, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED PB2 Interrupt Status REGISTER Readback AFTER TS INTERRUPT 3");	FAIL_FLAG <= '1';
end if;

-- Verify INT_TS Interrupt Status
TEST_databv <= CHANNEL_I_TS;
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_TS SLINK Status REGISTER Readback AFTER TS INTERRUPT 3");	FAIL_FLAG <= '1';
end if;

-- Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Clear INT_TS SL Interrupt
WRITE_databv <= CHANNEL_I_TS;
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER TS INTERRUPT 3");
	FAIL_FLAG <= '1';
end if;
------------------------------------------------


--*********************************************************


-------------------------------------------------
--  Wait for INT_RS Interrupt 3 TO INDICATE RX DATA AVAILABLE
-------------------------------------------------
-- Unmask RS Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_RS; -- CH0 RS interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);


-- Wait for INT_RS(I) to assert
wait until (XS_PWM0 = '1');

-- Verify INT_RS Interrupt Status
TEST_databv <= CHANNEL_I_RS;
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_RS SLINK Status REGISTER Readback AFTER RS INTERRUPT 3");	FAIL_FLAG <= '1';
end if;

--Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

--Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_B, WRITE_databv);

--Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER RS INTERRUPT 3");
	FAIL_FLAG <= '1';
end if;

-------------------------------------------------
--  READ RX DATA 3
-------------------------------------------------
TEST_databv <= x"00000000";  
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, CHANNEL_I_RCV_ADDR  , DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SL RX DAta 3 REadback");	
FAIL_FLAG <= '1';
end if;

-- STATUS REGISTER B:
--  STAT_RO  STAT_TF  STAT_RE  STAT_PI  (FOR NON-FIFO TEST)
-- Channel I will still be non-idle => STAT_PI =>1
TEST_databv <= x"000000FF" and (not CHANNEL_I_LI) ;
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK INTERRUPT Status REGISTER B After RX Data 3 REad");	
FAIL_FLAG <= '1';
end if;
-------------------------------------------------

-------------------------------------------------
-- Wait for Channel to go idle
-------------------------------------------------

-- Wait 180 SCLKS (500 CLK_I /SCLK)
-- WAIT_CYCLE_FALLING(90000);

-- Unmask LI Interrupts (for CHANNEL_I)
WRITE_databv <= CHANNEL_I_LI; -- CH0 LI interrupts unmasked
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, MASK_REG_ADDR_A, WRITE_databv);


-- Wait for INT_LI(I) to assert
wait until (XS_PWM0 = '1');

-- Verify INT_LI Interrupt Status
TEST_databv <= CHANNEL_I_LI;
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_A, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED INT_LI SLINK Status REGISTER Readback AFTER Expected LI INTERRUPT");	FAIL_FLAG <= '1';
end if;

--Clear PB2 Interrupt
WRITE_databv <= x"00000004";  -- PB2 Interrupt on bit 2
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, INT_CLR_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

--Clear all SLINK Interrupts
WRITE_databv <= x"FFFFFFFF"; -- all selected
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_A, WRITE_databv);
CPU_WRITE("cs4",DATA_BYTE_EN, CLR_REG_ADDR_B, WRITE_databv);

--Verify Interrupt to CPU is inactive again
if XS_PWM0 = '0' then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED RESET OF INTERRUPT OUTPUT AFTER RS INTERRUPT 2");
	FAIL_FLAG <= '1';
end if;

-- read STATUS REGISTER B:

TEST_databv <= x"000000FF";  -- all channels now idle
DATA_BYTE_EN <= "0000";
CPU_RD("cs4",DATA_BYTE_EN, STAT_REG_ADDR_B, DOUT => tmpy32);	
READ_DATA_IN <= tmpy32;
WAIT_CYCLE_FALLING(2);
if READ_DATA = to_stdlogicvector(TEST_databv) then FAIL_FLAG <= FAIL_FLAG;
else PRINT(" FAILED SLINK INTERRUPT Status REGISTER B After Waiting 3D After RX Data 3 REad");	
FAIL_FLAG <= '1';
end if;


-------------------------------------------------
-- Announce Status of Fail Flag on Each Loop
-------------------------------------------------
WAIT_CYCLE_RISING(5);
	
if FAIL_FLAG = '0' then 
	PRINT(" PASSED SLINK Verification WITHOUT FIFOS for Channel:  ");
	VPRINT(I);

else 	PRINT("FAILED SLINK Verification WITHOUT FIFOS for Channel:  ");
	VPRINT(I);
end if;


end loop SLINK_TEST_WO_FIFOS;

--*********************************************************************************
--*********************************************************************************


--*********************************************************************************
-- TEST_I2S:
--*********************************************************************************

I2S_TEST: for I in 0 to 7 loop
exit I2S_TEST when TEST_I2S = FALSE;

XS_SDATA_IN1 <= 'Z';  --MCLK
XS_BITCLK <= 'Z';	    --SCLK
XS_SDATA_OUT <= 'Z';  --SDATA
XS_SYNC <= 'Z';	    --LRCLK


-------------------------------------------------
-- PB0: CPB:  Enable APCIPB Peripheral Block
-------------------------------------------------
-- Write data to PBEN_REG (Chip select 4 x8 PBEN_REG_ADDR)
WRITE_databv <= x"0001003F";  -- x"1003F "
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, PBEN_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-------------------------------------------------
-- Set DAI_ENABLE FOR PLAYBACK
-------------------------------------------------
WRITE_databv <= x"00000001";  -- CNTL_REG(0) = not DAI_ENABLE, DAI_ENABLE = 0 => Playback
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, I2S_CNTL_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-------------------------------------------------
-- Setup Initial Xscale I2S outputs:
-------------------------------------------------
--	XS_BITCLK		:inout std_logic; 	-- GPIO28/AC97 Audio Port or I2S bit clock (input or output) 
--	XS_SDATA_IN0	:in	std_logic;	-- GPIO29/AC97 or I2S data Input  (input to cpu)
--	XS_SDATA_IN1	:out	std_logic; 	-- GPIO32/AC97 Audio Port data in. I2S sysclk output from cpu
--	XS_SDATA_OUT	:out	std_logic; 	-- GPIO30/AC97 Audio Port or I2S data out from cpu
--	XS_SYNC		:out	std_logic;	-- GPIO31/AC97 Audio Port or I2S Frame sync signal. (output from cpu)


XS_SDATA_IN1 <= '1';  --MCLK
XS_BITCLK <= '1';	    --SCLK
XS_SDATA_OUT <= '0';  --SDATA
XS_SYNC <= '1';	    --LRCLK

WAIT_CYCLE_RISING(1);

-------------------------------------------------
-- READBACK APP BOARD initial INPUTS:
-------------------------------------------------
--	I2S_MCLK : in std_logic;
--	I2S_SCLK : inout std_logic;
--	I2S_SDATA : inout std_logic;
--	I2S_LRCLK : inout std_logic;

if I2S_MCLK = '1' and I2S_SCLK = '1' and I2S_SDATA = '0' and I2S_LRCLK = '1' then 
		FAIL_FLAG <= FAIL_FLAG;
		PRINT(" PASSED I2S PLAYBACK INITIAL VALUE READBACK ");
else 		FAIL_FLAG <= '1';
		PRINT(" FAILED I2S PLAYBACK INITIAL VALUE READBACK ");	
end if;

-------------------------------------------------
-- Setup Xscale I2S output pattern 2:
-------------------------------------------------
XS_SDATA_IN1 <= '0';  --MCLK
XS_BITCLK <= '0';	    --SCLK
XS_SDATA_OUT <= '1';  --SDATA
XS_SYNC <= '0';	    --LRCLK

WAIT_CYCLE_RISING(1);

-------------------------------------------------
-- READBACK APP BOARD Playback pattern 2:
-------------------------------------------------
--	I2S_MCLK : in std_logic;
--	I2S_SCLK : inout std_logic;
--	I2S_SDATA : inout std_logic;
--	I2S_LRCLK : inout std_logic;

if I2S_MCLK = '0' and I2S_SCLK = '0' and I2S_SDATA = '1' and I2S_LRCLK = '0' then 
		FAIL_FLAG <= FAIL_FLAG;
		PRINT(" PASSED I2S PLAYBACK PATTERN 2 READBACK ");
else 		FAIL_FLAG <= '1';
		PRINT(" FAILED I2S PLAYBACK PATTERN 2 READBACK ");	
end if;


-------------------------------------------------
-- SET CLOCKS TO HIGH Z for RECORD TESTS
-------------------------------------------------
XS_SDATA_IN1 <= 'Z';  --MCLK
XS_BITCLK <= 'Z';	    --SCLK
XS_SDATA_OUT <= 'Z';  --SDATA
XS_SYNC <= 'Z';	    --LRCLK


-------------------------------------------------
-- Set DAI_ENABLE FOR RECORD
-------------------------------------------------
WRITE_databv <= x"00000000";  -- CNTL_REG(0) = 0 => DAI_ENABLE = 1 => Record
DATA_BYTE_EN <= "0000"; -- all selected
CPU_WRITE("cs4",DATA_BYTE_EN, I2S_CNTL_REG_ADDR, WRITE_databv);
WAIT_CYCLE_RISING(5);

-- When DAI_ENABLE = '1', DAI_MCLK_CTR COUNTS UP, on falling edge of DAI_MCLK (88ns)
--DAI_SCLK <= DAI_MCLK_CTR(1); -- divide DAI_MCLK by 4
--DAI_LRCLK <= DAI_MCLK_CTR(5); --divide DAI_MCLK by 64
--DAI_SDATA <= DAI_MCLK_CTR(2); -- alternating 0000111100001111... pattern

-------------------------------------------------
-- Verify Correct DAta Out of XS_SDATA_IN0 into CPU
-------------------------------------------------
--NEED TO CODE:  VERIFY IN WAVEFORM FOR NOW , 3-9-04 REB

WAIT;

-------------------------------------------------
-- Announce Status of Fail Flag on Each Loop
-------------------------------------------------
WAIT_CYCLE_RISING(5);
	
if FAIL_FLAG = '0' then 
	PRINT(" PASSED I2S_TEST");
	VPRINT(I);

else 	PRINT("FAILED I2S_TEST");
	VPRINT(I);
end if;


end loop I2S_TEST;

--*********************************************************************************
--*********************************************************************************


--*********************************************************************************

WAIT_CYCLE_RISING(5);
	
if FAIL_FLAG = '0' then PRINT(" PASSED StreetRacer RBX Companion Chip (FPGA) Verification!");
else 	PRINT("FAILED StreetRacer RBX Companion Chip (FPGA) Verification!");
end if;
	
wait;		--to wait here forever	(comment out to repeat)

END PROCESS do_the_test; 
	  
END test;  --End Architecture test of APP_RBX_CC_STIM
--