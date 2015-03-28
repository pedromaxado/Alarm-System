-------------------------------------------------
--Controlador externo do sensor da porta
-------------------------------------------------

-------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DOOR_SENSOR IS

	PORT (

			onoff :     IN std_logic;
			ds :        IN std_logic;
			reset : 	IN std_logic;
			sbopened :	OUT std_logic
			
		);

END ENTITY;

ARCHITECTURE ARCH_DOOR_SENSOR OF DOOR_SENSOR IS
BEGIN

  PROCESS (ds, onoff, reset)
  BEGIN
	  
	 IF (FALLING_EDGE(ds)) THEN
		 
		IF (onoff = '1') THEN
			sbopened <= '1';
		 
		ELSIF (onoff = '0') THEN
			sbopened <= '0';
				
		END IF;
			
	 END IF;
	 
	 IF (reset = '1') THEN
		sbopened <= '0';
		
	 END IF;
		 
  END PROCESS;

END ARCH_DOOR_SENSOR;

------------------------------------------------