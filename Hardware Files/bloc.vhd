library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
USE ieee.math_real.ALL;


entity bloc is
	
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
end entity;




architecture RTL of bloc is
	
	--Copied
	constant DEVICE	: std_logic_vector(6 downto 0):= "1001000";		  
	constant ADDR		: std_logic_vector(7 downto 0):= "00000001";		  
	constant CONFIG	: std_logic_vector(7 downto 0):= "01100000";	
	constant ADDR_lect		: std_logic_vector(7 downto 0):= "00000000";	
	
	constant DATA_WITH	: integer := 8;
	
	constant INPUT_CLK_KHZ 			: integer := 50;
	constant BUS_CLK_MHZ 			: integer := 400;
	constant INPUT_CLK_MULTIPLIER : integer := 100;
	constant BUS_CLK_MULTIPLIER 	: integer := 1;
	
	component I2C_M is
		generic (
										--input clock speed from user logic in KHz
			 input_clk				: integer := INPUT_CLK_KHZ;		
										--speed the I2C_M bus (scl) will run at in MHz 
			 bus_clk					: integer := BUS_CLK_MHZ;		   
										--input clock speed from user logic in KHz
			 input_clk_multiplier: integer := INPUT_CLK_MULTIPLIER;			
			 bus_clk_multiplier	: integer := BUS_CLK_MULTIPLIER
		);
		 port(
			 clk       : in     std_logic;                    --system clock
			 reset_n   : in     std_logic;                    --active low reset
			 ena       : in     std_logic;                    --latch in command
			 addr      : in     std_logic_vector(7 downto 0) ; --address of target slave
			 rw        : in     std_logic;                    --'0' is write, '1' is read
			 data_wr   : in     std_logic_vector(7 downto 0); --data to write to slave
			 reg_rdy	  : out	  std_logic :='0';				  --ready send the register
			 val_rdy	  : out	  std_logic :='0';				  --ready send value of the register
			 busy      : out    std_logic :='0';              --indicates transaction in progress
			 data_rd   : out    std_logic_vector(7 downto 0); --data read from slave
			 ack_error : out 	  std_logic;                    --flag if improper acknowledge from slave
			 sda       : inout  std_logic;                    --serial data output of I2C_M bus
			 scl       : inout  std_logic  --serial clock output of I2C_M bus
		);                   
	end component;
	
	--signal clk_50				: std_logic:= '0';                    
									--active low reset
	signal rst_n				: std_logic:= '0';                  
									--latch in command
	signal i2c_m_ena			: std_logic;
									--address of target slave
	signal i2c_m_addr_wr		: std_logic_vector(7 downto 0):= (others=> '0'); 
									--'0' is write, '1' is read
	signal i2c_M_rw			: std_logic;
									--data to write to slave
	signal i2c_m_data_wr		: std_logic_vector(7 downto 0):= (others=> '0'); 
									--ready send the register
	signal i2c_m_reg_rdy				: std_logic :='0';				  
									--ready send value of the register
	signal i2c_m_val_rdy				: std_logic :='0';				  
									--indicates transaction in progress
	signal i2c_m_busy			: std_logic :='0';              
									--data read from slave
	signal i2c_m_data_rd		: std_logic_vector(7 downto 0):= (others => '0');
									--flag if improper acknowledge from slave	
	signal ack_error			: std_logic:= '0';   
	signal scl			: std_logic;   
	--end copied
	
	-- Build an enumerated type for the state machine
	type state_type is (s0, s1, s2, s3,s5,s6,s7,s8,s9,s11,s13,s14);

	-- Register to hold the current state
	signal state : state_type;
	
begin
	
	rst_n <= reset_n;
	--Copied -- 
	I_I2C_M : I2C_M 	--Instanciation of the entity I2C_M
	port map (	 			 
		clk 			=> clk_50,
		reset_n 		=> rst_n,
		ena 			=> i2c_m_ena,
		addr 			=> i2c_m_addr_wr,
		rw 			=> i2c_M_rw,
		data_wr 		=> i2c_m_data_wr,
		reg_rdy 		=> i2c_m_reg_rdy,
		val_rdy 		=> i2c_m_val_rdy,
		busy 			=> i2c_m_busy,
		data_rd 		=> i2c_m_data_rd,
		ack_error 	=> ack_error,
		sda 			=> GPIO_0_1,
		scl 			=> scl
	);  
	GPIO_0_0 <= scl;

	P_i2c_m_write : process(rst_n,clk_50)	
	variable data_wr: natural range 0 to 2**DATA_WITH-1;
	begin
		if rst_n = '0' then
			state <= s0;
			data_wr := 0;
			i2c_m_addr_wr	<= (others => '1');
			i2c_m_data_wr <= (others => '1'); 
			i2c_m_ena <= '0';   
			i2c_M_rw <= '0'; 
			REG_out <= (others => '0');
			REG_out_2 <= (others => '0');
		elsif rising_edge(clk_50)then
			case state is
				when s0 => 
					if i2c_m_busy = '0' then    
						state <= s1;           			
						i2c_m_addr_wr <= DEVICE & '0'; 
						--data to be written
						i2c_m_data_wr <= ADDR;
					end if;
				when s1 =>   
					i2c_m_ena <= '1';   --Permit to pass in start state
					if i2c_m_reg_rdy = '1' then 
						--Wait to reach state slv_Ack_1
						state <= s2; 
						--i2c_m_data_wr <= CONFIG;
						--i2c_m_data_wr <= std_logic_vector(to_unsigned(CONFIG,DATA_WITH));
					end if;
				when s2 => 
					i2c_m_data_wr <= CONFIG;
					i2c_M_rw <= '0'; --To continue the writing 
					--Wait to reach slv_ack_2 (addr config OK)
					if i2c_m_val_rdy = '1' then    
						i2c_m_ena <= '1'; --keep writing
						state <= s9;      
					end if;
					
				when s9 =>
					if i2c_m_val_rdy = '0' then    
						state <= s3;      
					end if;
					
				when s3 =>
					--Pre write values in registers
					i2c_m_data_wr <= ADDR_lect;
					i2c_m_addr_wr <= DEVICE & '0';
					
					--Wait to reach slv_ack_2 (value config OK)
					i2c_m_ena <= '0'; --keep writing but restart
					if i2c_m_busy = '0' then    
						state <= s13;      
					end if;
				
								
				when s13 =>
					i2c_m_ena <= '1';  
					if i2c_m_reg_rdy = '1' then 
						--Wait to reach state slv_Ack_1
						state <= s14; 
					end if;
					
				when s14 =>
					i2c_m_ena <= '0';
					--Wait to reach slv_ack_2 (addr config OK)
					if i2c_m_busy = '0' then    
						state <= s5;      
					end if;
					
				when s5 => 
					--Restart. Reading
					if i2c_m_busy = '0' then    
						state <= s6;           			
						i2c_m_addr_wr <= DEVICE & '1'; 
						--i2c_m_data_wr <= ADDR;
					end if;	
					
				when s6 =>   
					i2c_m_ena <= '1';   --Permit to pass in start state
					--And permit to start the reading
					if i2c_m_busy = '1' then    
						state <= s7;     
						--wait for the reading to start
					end if;
										
				when s7 =>
					i2c_M_rw	<= '1'; --Here to ask for another reading
					if i2c_m_busy = '0' then 
						--Wait to reach state mstr_ack
						REG_out <= i2c_m_data_rd ;
						state <= s11; 
					end if;
				
				when s11=>
					if i2c_m_busy = '1' then 
						state <= s8; 
					end if;
				
				
				when s8 =>
					i2c_M_rw	<= '0'; --Stop after this reading
					i2c_m_ena <= '0'; --Stop condition
					if i2c_m_busy = '0' then 
						--Wait to reach state mstr_ack
						REG_out_2 <= i2c_m_data_rd ;
						state <= s5; 
					end if;
				
				--Return on the state 3 to do the lecture again
				when OTHERS =>  
					state <= s0; 
			end case; 
		end if;
	end process;
	
	--End copied
	
	
	 
end RTL;
