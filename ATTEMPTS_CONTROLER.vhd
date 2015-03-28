---------------------------------------------------------
--Controlador externo de tentativas de inserção de senha
---------------------------------------------------------

---------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY ATTEMPTS_CONTROLER IS
		
	GENERIC (
				MIN_ATTEMPT :	NATURAL := 0;
				MAX_ATTEMPT :	NATURAL := 5
			);

	PORT (
	
			pw :			IN std_logic_vector(5 DOWNTO 0);
			inpw :			IN std_logic;
			onoff :			IN std_logic;
			pwcorrect :		OUT std_logic;
			attempts :		OUT integer range MIN_ATTEMPT to MAX_ATTEMPT
			
		);
		
END ENTITY;

ARCHITECTURE ARCH_ATTEMPTS_CONTROLER OF ATTEMPTS_CONTROLER IS

SIGNAL rightpw :		std_logic;
CONSTANT correctpw :	std_logic_vector(5 DOWNTO 0) := "101101";
SIGNAL attempt : integer range MIN_ATTEMPT to MAX_ATTEMPT;

BEGIN

  PROCESS (pw, inpw, onoff, rightpw, attempt)
  BEGIN
  
  IF (onoff = '1') THEN
  
     IF (FALLING_EDGE(inpw)) THEN
			
		IF (pw /= correctpw) THEN
			attempt <= attempt + 1;
			rightpw <= '0';
				
		ELSIF (pw = correctpw) THEN
			attempt <= 0;
			rightpw <= '1';
				
		END IF;
			
     END IF;
	
  ELSIF (onoff = '0') THEN
	attempt <= 0;
	rightpw <= '0';
			
  END IF;
	
  attempts <= attempt;
  pwcorrect <= rightpw;
	
  END PROCESS;

END ARCH_ATTEMPTS_CONTROLER;

---------------------------------------------------------