-------------------------------------------------
--Controlador do estado da saída FireOut
-------------------------------------------------

-------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FIRE_CONTROLER IS

	PORT (	
		
				fire :			IN std_logic;
				pw :			IN std_logic_vector(5 DOWNTO 0);
				onoff :			IN std_logic;
				FireOut :		OUT std_logic
				
		);
		
END ENTITY;

ARCHITECTURE ARCH_FIRE_CONTROLER OF FIRE_CONTROLER IS

CONSTANT FIRE_PW : 		std_logic_vector(5 DOWNTO 0) := "100101";
SIGNAL FireOutS :		std_logic;
SIGNAL estado :			std_logic := '0';

BEGIN

  PROCESS (fire, pw, onoff, estado)
  BEGIN		
  
	IF (FALLING_EDGE(onoff)) THEN
	 
		IF (estado = '0') THEN
			estado <= '1';
			
		ELSIF (pw = FIRE_PW AND estado = '1') THEN
			estado <= '0';
			
		END IF;
	 
	END IF;
	 
	IF (estado = '0') THEN
		FireOutS <= '0';
			
	ELSE
		FireOutS <= fire;
		
	END IF;
  
  END PROCESS;
  
  FireOut <= FireOutS;

END ARCH_FIRE_CONTROLER;

-------------------------------------------------