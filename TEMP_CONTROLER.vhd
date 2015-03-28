-------------------------------------------------
--Controlador Externo do Sensor de Temperatura
-------------------------------------------------

-------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TEMP_CONTROLER IS

	PORT (
			
			temp :		IN std_logic_vector(7 DOWNTO 0);
			fire:		OUT std_logic
			
		);
	
END ENTITY;

ARCHITECTURE ARCH_TEMP_CONTROLER OF TEMP_CONTROLER IS
BEGIN

  PROCESS (temp)
  BEGIN
  
	IF (temp > "00010101") THEN -- 30 = 00011001
		fire <= '1';
	
	ELSE
		fire <= '0';
	
	END IF;	
	 
  END PROCESS;

END ARCH_TEMP_CONTROLER;

-------------------------------------------------