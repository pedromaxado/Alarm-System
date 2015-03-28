-------------------------------------------------------------------------------------------------------------
--Controlador para verificar o tempo e a senha para definir o estado do alarme (ligado, desligado, disparado)
-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY PW_INSERTION_CONTROLER IS
			
	GENERIC (

				MIN_COUNT :		NATURAL := 0;
				MAX_COUNT :		NATURAL := 31;
				MIN_ATTEMPT :	NATURAL := 0;
				MAX_ATTEMPT :	NATURAL := 5
				
			);

	PORT (

			onoff :			IN std_logic;
			count :			IN integer range MIN_COUNT to MAX_COUNT;
			pwcorrect :		IN std_logic;
			attempts :		IN integer range MIN_ATTEMPT to MAX_ATTEMPT;
			danger :		OUT std_logic;
			turn_off :		OUT std_logic
			
		);

END ENTITY;

ARCHITECTURE ARCH_PW_INSERTION_CONTROLER OF PW_INSERTION_CONTROLER IS

SIGNAL reseter :	std_logic;
SIGNAL dangers :	std_logic;

BEGIN

  PROCESS (count, pwcorrect, attempts, onoff)
  BEGIN
     IF (onoff = '1') THEN
     
		IF (pwcorrect = '1' AND count <= 30) THEN
			dangers <= '0';
			reseter <= '1';
		
		ELSIF ((pwcorrect = '0' AND attempts = MAX_ATTEMPT) AND count < 30) THEN
			dangers <= '1';
			reseter <= '0';
		
		ELSIF (count > 30) THEN
			dangers <= '1';
			reseter <= '0';
			
		END IF;
	 
	 ELSE
		dangers <= '0';
		reseter <= '0';
		
     END IF;
  
  END PROCESS;
  
  danger <= dangers;
  turn_off <= reseter;

END ARCH_PW_INSERTION_CONTROLER;

-------------------------------------------------