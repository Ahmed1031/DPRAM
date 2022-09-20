LIBRARY IEEE, MODELSIM_LIB;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.env.stop;

LIBRARY STD;
USE MODELSIM_LIB.UTIL.ALL;
-------------------------
-- Author : Ahmed Asim Ghouri 
-- Version : 1.1 
-- Changes : changing the frequency of read side B 
---------------------------------------------------
ENTITY tb_DPRAM IS
END ENTITY;

ARCHITECTURE rtl_test OF tb_DPRAM IS

SIGNAL		tb_clk_a     :  STD_LOGIC;
SIGNAL		tb_clk_b     :  STD_LOGIC;	
SIGNAL		tb_CEa, tb_CEb, tb_RWna, tb_RWnb, tb_OEna, tb_OEnb :  STD_LOGIC;	
SIGNAL		tb_wrenb     :  STD_LOGIC;	
SIGNAL		tb_Data_out_a    :  STD_LOGIC_VECTOR(15 DOWNTO 0);
SIGNAL		tb_Data_out_b    :  STD_LOGIC_VECTOR(15 DOWNTO 0);        
SIGNAL		tb_Data_in_a     :  STD_LOGIC_VECTOR(15 DOWNTO 0);           
SIGNAL		tb_Data_in_b     :  STD_LOGIC_VECTOR(15 DOWNTO 0);        
SIGNAL		tb_Address_a     :  STD_LOGIC_VECTOR(7 DOWNTO 0);        
SIGNAL		tb_Address_b     :  STD_LOGIC_VECTOR(7 DOWNTO 0);
CONSTANT 	clk_period       :  time := 50 ns;

begin 


DPRAM_test : entity work.DPRAM_top(DPRAM_RTL)
port map (
						    
	CLOCK_A 	 =>  tb_clk_a,
	CLOCK_B 	 =>  tb_clk_b,
	Address_A	 =>  tb_Address_a, 
	Address_B	 =>  tb_Address_b,
	iData_A  	 =>  tb_Data_in_a, 
	iData_B  	 =>  tb_Data_in_b,
	Out_Data_A	 =>  tb_Data_out_a,  
	Out_Data_B   =>	 tb_Data_out_b, 	 
	CE_a         =>  tb_CEa,
	CE_b  		 =>  tb_CEb, 
    RWn_a        =>  tb_RWna,
	RWn_b        =>  tb_RWnb,
    OEn_a        =>  tb_OEna,
	OEn_b        =>  tb_OEnb
	);
------------------------	
Side_A_Clock :PROCESS        
BEGIN
   tb_clk_a <= '0';
	   WAIT FOR clk_period/2; 
   tb_clk_a <= '1';
	   WAIT FOR clk_period/2;
END PROCESS Side_A_Clock;	
------------------------
Side_B_Clock :PROCESS        
BEGIN
  	tb_clk_b <= '0';
    WAIT FOR clk_period/5; 
   tb_clk_b <= '1';
   WAIT FOR clk_period/5;
END PROCESS Side_B_Clock;	
	
	
-- Read Wite Process 
Read_Write: PROCESS BEGIN
-- First Write on side A 
		wait until tb_clk_a = '1';
		tb_CEa  <= '0';
		tb_RWna <= '0';
		tb_OEna <= '1';
		tb_Address_a <= x"02";
		tb_Data_in_a <= x"A0A0";
		wait until tb_clk_a = '0';
		wait until tb_clk_a = '1';
		tb_CEa  <= '1';
		tb_RWna <= '1';
		tb_OEna <= '1';
		tb_Address_a <= x"00";
		tb_Data_in_a <= x"0000";
		wait for 100 ns;
		--
		wait until tb_clk_a = '1';
		tb_CEa  <= '0';
		tb_RWna <= '0';
		tb_OEna <= '1';
		tb_Address_a <= x"04";
		tb_Data_in_a <= x"1F23";
		wait until tb_clk_a = '0';
		wait until tb_clk_a = '1';
		tb_CEa  <= '1';
		tb_RWna <= '1';
		tb_OEna <= '1';
		tb_Address_a <= x"00";
		tb_Data_in_a <= x"0000";
		wait for 100 ns;
--------------------------------
-- Read from side B 
        wait until tb_clk_b = '1';
		tb_CEb  <= '0';
		tb_RWnb <= '1';
		tb_OEnb <= '0';
		tb_Address_b  <= x"02";
		tb_Data_out_b <= (others=>'Z');
		wait until tb_clk_a = '0';
		wait until tb_clk_a = '1';
		tb_CEb  <= '1';
		tb_RWnb <= '1';
		tb_OEnb <= '1';
		tb_Address_b <= x"00";
		wait for 100 ns;
		--
		wait until tb_clk_b = '1';
		tb_CEb  <= '0';
		tb_RWnb <= '1';
		tb_OEnb <= '0';
		tb_Address_b <= x"04";
		tb_Data_out_b <= (others=>'Z');
		wait until tb_clk_b = '0';
		wait until tb_clk_b = '1';
		tb_CEb  <= '1';
		tb_RWnb <= '1';
		tb_OEnb <= '1';
		tb_Address_b <= x"00";
		wait for 100 ns;
		---------------
		assert false report ">>>> Read Write Finished <<<<" severity failure;
        stop;
	
	
END PROCESS;
END rtl_test;
