-------------------------------------------------
--Controlador do estado de perigo
-------------------------------------------------

-------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY DANGER_CONTROLER IS

	PORT (
	
			danger :			IN std_logic;
			turn_off :			IN std_logic;
			DangerOut :			OUT std_logic
		
		);
		
END ENTITY;

ARCHITECTURE ARCH_DANGER_CONTROLER OF DANGER_CONTROLER IS

SIGNAL DangerTurnOff :		std_logic_vector(1 DOWNTO 0);
SIGNAL DangerTmp :			std_logic;

BEGIN

  DangerTurnOff <= danger & turn_off;
  
  PROCESS (DangerTurnOff)
  BEGIN
     
     IF (DangerTurnOff = "00") THEN
		DangerTmp <= '0';
		
	 ELSIF (DangerTurnOff = "01") THEN
		DangerTmp <= '0';
		
	 ELSIF (DangerTurnOff = "10") THEN
		DangerTmp <= '1';
		
	 ELSE
		DangerTmp <= '0';
		
	 END IF;
  
  END PROCESS;
  
  DangerOut <= DangerTmp;

END ARCH_DANGER_CONTROLER;