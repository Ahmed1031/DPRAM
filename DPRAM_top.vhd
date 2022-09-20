
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;


Entity DPRAM_top is
  PORT(
		  CLOCK_A      : IN std_logic;                       -- 20 MHz Clock for side A
		  CLOCK_B      : IN std_logic;                       -- 20 MHz Clock for side B
		  Address_A    : IN STD_LOGIC_VECTOR (7 DOWNTO 0);   -- Address side A 
		  Address_B    : IN STD_LOGIC_VECTOR (7 DOWNTO 0);   -- Address side B
		  iData_A      : IN STD_LOGIC_VECTOR (15 DOWNTO 0);  -- Data input side A
		  iData_B      : IN STD_LOGIC_VECTOR (15 DOWNTO 0);  -- Data input side A
		  Out_Data_A   : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- Data output A
		  Out_Data_B   : OUT STD_LOGIC_VECTOR (15 DOWNTO 0); -- Data output B
		  CE_a, CE_b   : IN std_logic;                       -- CE 
		  RWn_a, RWn_b : IN std_logic;                       -- RW
		  OEn_a, OEn_b : IN std_logic 
		  );
End DPRAM_top;		  

Architecture DPRAM_RTL of DPRAM_top is

COMPONENT DPRAM_ip IS
	PORT
	(
		address_a		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		address_b		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock_a		: IN STD_LOGIC  := '1';
		clock_b		: IN STD_LOGIC ;
		data_a		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		data_b		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		wren_a		: IN STD_LOGIC  := '0';
		wren_b		: IN STD_LOGIC  := '0';
		q_a		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		q_b		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT DPRAM_ip;





SIGNAL wren_a_sig, wren_b_sig : STD_LOGIC;

Begin 

-- Write : CER = '0' and RWn = '0' and OEn = '1'
-- Read  : CER = '0' and RWn = '1' and OEn = '0'

wren_a_sig <= '0' when (CE_a = '0' and RWn_a = '1' and OEn_a ='0') else '1' when (CE_a = '0' and RWn_a = '0' and OEn_a ='1');

wren_b_sig <= '0' when (CE_b = '0' and RWn_b = '1' and OEn_b ='0') else '1' when (CE_b = '0' and RWn_b = '0' and OEn_b ='1'); 


DPRAM_test : DPRAM_ip
port map (
			address_a  =>  Address_A,  
			address_b  =>  Address_B,
			clock_a	  =>  CLOCK_A,
			clock_b	  =>  CLOCK_B,
			data_a	  =>  iData_A,
			data_b	  =>  iData_B,
			wren_a	  =>  wren_a_sig,
			wren_b	  =>  wren_b_sig,
			q_a		  =>  Out_Data_A,
			q_b		  =>  Out_Data_B
			);
			
END ARCHITECTURE DPRAM_RTL;			
