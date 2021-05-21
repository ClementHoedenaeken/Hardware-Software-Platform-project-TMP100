library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
USE ieee.math_real.ALL;

entity bloc_TB is
end entity;




architecture RTL of bloc_TB is
	
  constant clk_period : time := 10 ns;
	
	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3, s4, s5,s6,s7,s8);

	-- Register to hold the current state
	signal STATE : state_type;
	
	signal clk_50 : std_logic := '0';
	signal reset_n : std_logic;
	signal REG_out: std_logic_vector(7 downto 0);
	signal REG_out_2: std_logic_vector(7 downto 0);
	signal GPIO_0_0 : std_logic;
	signal GPIO_0_1: std_logic;
	
	
	
	component bloc is
		
		port
		(
			-- Input ports
			clk_50	: in  std_logic;
			reset_n : in std_logic;
			--REG1	: in  std_logic_vector(8 downto 0);
			--REG2	: in  std_logic_vector(8 downto 0);
			--REG3	: in  std_logic_vector(8 downto 0);
			REG_out	: out  std_logic_vector(7 downto 0);
			REG_out_2 : out std_logic_vector(7 downto 0);
			GPIO_0_0: out std_logic; --SCL
			--Inout ports
			GPIO_0_1: inout std_logic --SDA
			
		);
	end component;
	
begin
	
	
	UUT : bloc 	--Instanciation of the entity I2C_M
	port map (	 			 
		clk_50 => clk_50,
		reset_n =>reset_n,		
		REG_out => REG_out,	
		REG_out_2 => REG_out_2,
		GPIO_0_0 => GPIO_0_0,		
		GPIO_0_1 =>GPIO_0_1
	); 
	
	process
	begin
		wait for  clk_period;
		clk_50 <= not clk_50; 
	end process;
	 
	process
	begin
	reset_n <= '0';
		wait for  clk_period*10;
	reset_n <= '1';
	wait;
	end process;
end RTL;
