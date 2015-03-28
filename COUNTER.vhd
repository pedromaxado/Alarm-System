-------------------------------------------------
--Contador para temporizar a inserção da senha
-------------------------------------------------

-------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY COUNTER IS

	GENERIC (
	
				MIN_COUNT :	  NATURAL := 0;
				MAX_COUNT :   NATURAL := 31
				
			);
	
	PORT (
	
			enable :	IN std_logic;
			reset :		IN std_logic;
			clk :		IN std_logic;
			count :		OUT integer range MIN_COUNT to MAX_COUNT
			
		);

END ENTITY;

ARCHITECTURE ARCH_COUNTER OF COUNTER IS

SIGNAL cnt : integer range MIN_COUNT to MAX_COUNT;

BEGIN

  PROCESS (clk, cnt, reset)
     
  BEGIN
  
	 IF (RISING_EDGE(clk)) THEN
		
		IF (enable = '1') THEN
			cnt <= cnt + 1;
			
		END IF;
		
	 END IF;
	 
	 IF (reset = '1') THEN
		cnt <= 0;
		
	 END IF;
	 
	 count <= cnt;
  
  END PROCESS;

END ARCH_COUNTER;

-------------------------------------------------