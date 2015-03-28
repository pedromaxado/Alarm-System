-------------------------------------------------
--Alarm System ==> TOP LEVEL
-------------------------------------------------

-------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY AlarmSystemTop IS

	PORT (
		
				-- PORTAS DO MEU SISTEMA --
				
				pw :			IN STD_LOGIC_VECTOR(5 DOWNTO 0);
				SWITCH_1 :		IN STD_LOGIC;	--M9
				SWITCH_2 :		IN STD_LOGIC;	--R14
				SWITCH_3 :		IN STD_LOGIC;	--T15
				SWITCH_4 :		IN STD_LOGIC;	--R16
				LED_1 :			OUT STD_LOGIC;	-- T13
				LED_2 :			OUT STD_LOGIC;	-- R13
				LED_3 :			OUT STD_LOGIC;	-- P13
				
				-----------------------------
				
				-- PORTAS DO SISTEMA MAX1111
				
				SysClk : 		IN STD_LOGIC;
				ADC_DOUT :		IN STD_LOGIC;	 -- A11 <-> PINO 11
				ADC_CLK :  		OUT STD_LOGIC;   -- D12 <-> PINO 15
				ADC_CSN :  		OUT STD_LOGIC;   -- C12 <-> PINO 14
				ADC_DIN :  		OUT STD_LOGIC;   -- B12 <-> PINO 13
				ADC_SSTRB :		OUT STD_LOGIC;   -- A12 <-> PINO 12
				ADC_SHDN : 		OUT STD_LOGIC;   -- B11 <-> PINO 6
				LED_4 :			OUT STD_LOGIC	 -- T12
				
				-----------------------------
				
		);
		
END ENTITY;

ARCHITECTURE ARCH_AlarmSystemTop OF AlarmSystemTop IS

COMPONENT CLOCK_GENERATOR IS

	PORT (
				SysClk: 	IN STD_LOGIC;
				Reset:  	IN STD_LOGIC;
				Enable: 	IN STD_LOGIC;
				Clock:  	OUT STD_LOGIC
		);
		
END COMPONENT;

COMPONENT FIRE_CONTROLER IS

	PORT (	
				fire :		IN std_logic;
				pw :		IN std_logic_vector(5 DOWNTO 0);
				onoff :		IN std_logic;
				FireOut :	OUT std_logic	
		);
		
END COMPONENT;

COMPONENT ONOFF_CONTROLER IS

	PORT (
			turn_off :		IN std_logic;
			onoff :			IN std_logic;
			OnOffOut :		OUT std_logic;
			OnOffAll :		OUT std_logic
		);
		
END COMPONENT;

COMPONENT DANGER_CONTROLER IS

	PORT (
			danger :		IN std_logic;
			turn_off :		IN std_logic;
			DangerOut :		OUT std_logic	
		);
		
END COMPONENT;

COMPONENT PW_INSERTION_CONTROLER IS

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

END COMPONENT;

COMPONENT ATTEMPTS_CONTROLER IS
		
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
		
END COMPONENT;

COMPONENT COUNTER IS

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

END COMPONENT;

COMPONENT DOOR_SENSOR IS

	PORT (
			onoff :     IN std_logic;
			ds :        IN std_logic;
			reset :		IN std_logic;
			sbopened :	OUT std_logic
		);
		
END COMPONENT;

COMPONENT TEMP_CONTROLER IS

	PORT (
			
			temp :		IN std_logic_vector(7 DOWNTO 0);
			fire:		OUT std_logic
			
		);
	
END COMPONENT;

COMPONENT FPGA_ADCMAX1111 IS

	PORT(	
       
			-- Control Interface
			StartRead: IN STD_LOGIC;    -- Solicita iniciar a conversão (Borda de Subida)
			Done:      OUT STD_LOGIC;   -- Informa que a conversão terminou (Borda de Subida)
			Data:      OUT STD_LOGIC_VECTOR(7 DOWNTO 0); -- Valor lido do conversor
			SysClk:    IN STD_LOGIC;    -- Clock do sistema
		
			-- SPI Interface
			ADC_CLK:   OUT STD_LOGIC;   -- D12 <-> PINO 15
			ADC_CSN:   OUT STD_LOGIC;   -- C12 <-> PINO 14
			ADC_DIN:   OUT STD_LOGIC;   -- B12 <-> PINO 13
			ADC_DOUT:  IN  STD_LOGIC;   -- A11 <-> PINO 11
			ADC_SSTRB: OUT STD_LOGIC;   -- A12 <-> PINO 12
			ADC_SHDN:  OUT STD_LOGIC    -- B11 <-> PINO 6
			
       );
       
END COMPONENT FPGA_ADCMAX1111;

COMPONENT CLOCK_GENERATOR_1HZ IS

	PORT (
       
			SysClk: IN STD_LOGIC;
			Reset:  IN STD_LOGIC;
			Enable: IN STD_LOGIC;
			Clock:  OUT STD_LOGIC
			
		);
		
END COMPONENT CLOCK_GENERATOR_1HZ;

COMPONENT TIME_CONTROLER IS
		
	GENERIC (
				MIN_TIME :		NATURAL := 0;
				MAX_TIME : 		NATURAL := 2
				
			);

	PORT (
				turn_off :		IN std_logic;
				clk :			IN std_logic;
				desligar :		OUT std_logic	
		);
		
END COMPONENT;

COMPONENT CLOCK_GENERATOR_20HZ IS

	PORT(
			SysClk: IN STD_LOGIC;
			Reset:  IN STD_LOGIC;
			Enable: IN STD_LOGIC;
			Clock:  OUT STD_LOGIC
		);
		
END COMPONENT CLOCK_GENERATOR_20HZ;
  
  SIGNAL Sclk :			STD_LOGIC;
  SIGNAL Sclk2 :		STD_LOGIC;
  SIGNAL Sclk3 :		STD_LOGIC;
  SIGNAL Finished : 	STD_LOGIC;
  SIGNAL DataS : 		STD_LOGIC_VECTOR(7 DOWNTO 0);
  SIGNAL ADCClk : 		STD_LOGIC;
  SIGNAL ADCCSN : 		STD_LOGIC;
  SIGNAL ADCDIN : 		STD_LOGIC;
  SIGNAL ADCDOUT : 		STD_LOGIC;
  SIGNAL ADCSSTRB : 	STD_LOGIC;
  SIGNAL ADCSHDN : 		STD_LOGIC;
  SIGNAL FireSI :		STD_LOGIC;
  SIGNAL FireSO :		STD_LOGIC;
  SIGNAL InpwSI :		STD_LOGIC;
  SIGNAL InpwfSI :		STD_LOGIC;
  SIGNAL OnOffS :		STD_LOGIC;
  SIGNAL DsSI :			STD_LOGIC;
  SIGNAL SbOpenedS :	STD_LOGIC;
  SIGNAL CountS :		INTEGER RANGE 0 TO 31;
  SIGNAL TurnOffS :		STD_LOGIC;
  SIGNAL PwSI :			STD_LOGIC_VECTOR(5 DOWNTO 0);
  SIGNAL PwCorrectS :	STD_LOGIC;
  SIGNAL AttemptSS :	INTEGER RANGE 0 TO 5;
  SIGNAL DangerS :		STD_LOGIC;
  SIGNAL DangerSO :		STD_LOGIC;
  SIGNAL OnOffSI :		STD_LOGIC;
  SIGNAL OnOffSO :		STD_LOGIC;
  SIGNAL DesligarS :	STD_LOGIC;

BEGIN

  c1 : CLOCK_GENERATOR_20HZ PORT MAP (
									Sclk,
									'0',
									'1',
									Sclk2
								);
								
  c2 : FPGA_ADCMAX1111 PORT MAP (
									Sclk2,
									Finished,
									DataS,
									SysClk,
									ADCClk,
									ADCCSN,
									ADCDIN,
									ADCDOUT,
									ADCSSTRB,
									ADCSHDN
								);
								
  c3 : TEMP_CONTROLER PORT MAP (
									DataS,
									FireSI
								);
								
  c4 : FIRE_CONTROLER PORT MAP (
									FireSI,
									PwSI,
									InpwfSI,
									FireSO
								);
  
  c5 : CLOCK_GENERATOR_1HZ PORT MAP (
									Sclk,
									'0',
									'1',
									Sclk3
									);
									
  c6 : DOOR_SENSOR PORT MAP (
									OnOffS,
									DsSI,
									TurnOffS,
									SbOpenedS
							);
							
  c7 : COUNTER PORT MAP (
									SbOpenedS,
									TurnOffS,
									Sclk3,
									CountS
						);
  
  c8 : ATTEMPTS_CONTROLER PORT MAP (
									
									PwSI,
									InpwSI,
									OnOffS,
									PwCorrectS,
									AttemptSS
									
									);
									
  c9 : PW_INSERTION_CONTROLER PORT MAP (
									
									OnOffS,
									CountS,
									PwCorrectS,
									AttemptSS,
									DangerS,
									TurnOffS
									
										);
										
  c10 : DANGER_CONTROLER PORT MAP (
									DangerS,
									TurnOffS,
									DangerSO
								  );

  c11 : ONOFF_CONTROLER PORT MAP (
									TurnOffS,
									OnOffSI,
									OnOffSO,
									OnOffS
								);

  --ASSINALAMENTO DE SINAIS DO MAX1111
  								
  Sclk <= SysClk;
  LED_4 <= NOT(Finished);
  ADCDOUT <= ADC_DOUT;
  ADC_CLK <= ADCCLK;
  ADC_CSN <= ADCCSN;
  ADC_DIN <= ADCDIN;
  ADC_SSTRB <= ADCSSTRB;
  ADC_SHDN <= ADCSHDN;
  
  ----------------------------------------
  
  --ASSINALAMENTO DE SINAIS DO MEU SISTEMA
  OnOffSI <= SWITCH_1;
  PwSI <= pw;
  InpwSI <= SWITCH_2;
  InpwfSI <= SWITCH_4;
  DsSI <= SWITCH_3;
  LED_3 <= NOT(FireSO);
  LED_2 <= NOT(DangerSO);
  LED_1 <= NOT(OnOffSO);
  
  ----------------------------------------
								  
END ARCH_AlarmSystemTop;

-------------------------------------------------