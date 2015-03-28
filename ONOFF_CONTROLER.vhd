-------------------------------------------------
--Contralador do estado de Ligado/Desligado
-------------------------------------------------

-------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ONOFF_CONTROLER IS

	PORT (
		
			turn_off :		IN std_logic;
			onoff :			IN std_logic;
			OnOffOut :		OUT std_logic;
			OnOffAll :		OUT std_logic
			
		);
		
END ENTITY;

ARCHITECTURE ARCH_ONOFF_CONTROLER OF ONOFF_CONTROLER IS

SIGNAL OnOffState : 	std_logic := '0';

BEGIN

  PROCESS (turn_off, onoff, OnOffState)
  BEGIN
  
     IF (onoff = '0' AND onoff'EVENT) THEN
		
		IF(OnOffState = '0') THEN
			OnOffState <= '1';
			
		ELSIF (OnOffState = '1') THEN
			OnOffState <= '1';
			
		END IF;
		
	 END IF;
  
	IF (turn_off = '1') THEN
		OnOffState <= '0';
		  
	END IF;
	 
  END PROCESS;
  
  OnOffOut <= OnOffState;
  OnOffAll <= OnOffState;

END ARCH_ONOFF_CONTROLER;

-------------------------------------------------