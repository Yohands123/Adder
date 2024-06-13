library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab2_top is port (
   clkin_50			: in	std_logic;
	pb_n				: in	std_logic_vector(3 downto 0);
 	sw   				: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds				: out std_logic_vector(7 downto 0); -- for displaying the switch content
   seg7_data 		: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  	: out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  	: out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab2_top;

architecture SimpleCircuit of LogicalStep_Lab2_top is
--
-- Components Used ---
------------------------------------------------------------------- 
  component SevenSegment port (
   hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
   end component;
	
	component segment7_mux port(
	clk 			: in std_logic := '0'; -- Switchers
	DIN2 			: in std_logic_vector(6 downto 0); 
	DIN1			: in std_logic_vector(6 downto 0); 
	DOUT			: out std_logic_vector(6 downto 0); 
	DIG2			: out std_logic;
	DIG1 			: out std_logic
	); 
	end component; 
	
	component PB_Inverters port(
	pb_n : IN std_logic_vector(3 downto 0); 
	pb   : OUT std_logic_vector(3 downto 0)
	);
	end component; 
	
	component Logical_Processor port(
	logic_in0, logic_in1 					  : in std_logic_Vector(3 downto 0);
	mux_select									  : in std_logic_vector(1 downto 0);
	p_out 										  : out std_logic_vector(3 downto 0) -- The hex Output
	); 
	end component; 
	
	component full_adder_4bit port(
		-- Input Variables 
		BUS0									: in std_logic_vector(3 downto 0);
		BUS1									: in std_logic_vector(3 downto 0);
		
		CARRY_IN								: in std_logic; 
		
		-- Output Variables 
		CARRY_OUT							: out std_logic; 
		SUM									: out std_logic_vector(3 downto 0)
	);
	end component;
	
	component two_to_1_mux port(
		-- Input Variables
		logic_in0, logic_in1 					  : in std_logic_Vector(3 downto 0);
		mux_select									  : in std_logic;
		-- Output Variables 
		p_out 										  : out std_logic_vector(3 downto 0)
	); 
	end component; 
	
	
	
-- Create any signals, or temporary variables to be used
--
--  std_logic_vector is a signal which can be used for logic operations such as OR, AND, NOT, XOR
--
	signal seg7_A		: std_logic_vector(6 downto 0); -- A 7-bit value to represent the corresponding hex. number in terms of values used to represent in the segment display
	signal seg7_B		: std_logic_vector(6 downto 0); -- A 7-bit value to represent the corresponding hex. number in terms of values used to represent in the segment display
	
	signal hex_A		: std_logic_vector(3 downto 0); -- A 4-bit value, that will represent a value dictated by the switches (3 to 0)
	signal hex_B		: std_logic_vector(7 downto 4); -- A 4-bit value, that will represent a value dictated by the switches (7 to 4) 
	
	signal pb         : std_logic_vector(3 downto 0); -- A 4-bit value, containing input values for push buttons from 3 to 0
	
	
	signal SUM_O 		: std_logic_vector(3 downto 0); -- A 4-bit Value; Used as the output value for the Sum from the Adder_Instance
	signal CARRY_O 	: std_logic_vector(3 downto 0); -- A 4-bit value; Used as the Output value for the Carry from the Adder_instance
																	  -- Note: We only assign the first bit the value of the carry output from the adder_instance
																	  -- the rest of the bits are utilized to ensure that the carry represents a hex. num which
																	  -- will be used for converting into the display value for the segment
	
	signal mux_2_to_1_output_1  : std_logic_vector(3 downto 0); -- A 4-bit value; Used as the output value for Mux_1_Instance
	signal mux_2_to_1_output_2  : std_logic_vector(3 downto 0); -- A 4-bit value; Used as the output value for Mux_2_Instance
	
	
-- Here the circuit begins

begin
	-- 
	hex_A <= sw(3 downto 0); 
	-- Assigning hex_A with a 4-bit value; where the 4-bit value is generated on the switches (3 to 0) from the board
	hex_B <= sw(7 downto 4);
	-- Assigning hex_B with a 4-bit value; where the 4-bit value is generated on the switches (7 to 4) from the board
	


	ADDER_INST: full_adder_4bit port map(hex_A, hex_B, '0', CARRY_O(0), SUM_O);  -- Calculating the Sum between the two hex numbers
	-- Returns the Summed value and the carry_ouptu 
	
	
	-- Multiplexers - The multiplexers are used to determine if we should display the sum of the two hex numbers or display the two hex numbers, seperately, beside each other
	MUX_1_INST : two_to_1_mux port map(hex_B, CARRY_O, pb(2), mux_2_to_1_output_1); 
	-- Depending on Pb 2, will return either hex_A [ when pb(2) = 0 ] or the carry_output from the full adder for the 4 bit [ when pb(2) = 1 ] 
	MUX_2_INST : two_to_1_mux port map(hex_A, SUM_O, pb(2), mux_2_to_1_output_2); 
	-- Depending on Pb 2, will return either hex_b [ when pb(2) = 0 ] or the sum_output from the full adder for the 4 bit [ when pb(2) = 1 ]
	-- To Summarize, when the pb(2) is pressed ('1'), it will display the sum of the two hex numbers, otherwise ('0'), it will display the two individual numbers beside each other
	
	-- Converting the Hex numbers into its corresponding segment display number for the output
	INST1: SevenSegment port map(mux_2_to_1_output_2, seg7_A); 
	-- Depending on which value is passed through the multiplexer 1 Instance, will convert that hex. number into its corresponding segment display number for the output 
	INST2: SevenSegment port map(mux_2_to_1_output_1, seg7_B);
	-- Depending on which value is passed through the multiplexer 2 Instance, will convert that hex. number into its corresponding segment display number for the output 
	
	-- Displaying the corresponding values, from Instance 1 and Instance 2, onto the led display 
	INST3: segment7_mux port map(clkin_50, seg7_A, seg7_B,seg7_data(6 downto 0),seg7_char2, seg7_char1); 
	
	-- Inverting the Push Button input values 
	INST4: PB_Inverters port map(pb_n,pb);
	
	-- A Mutiplexer that takes a 2-bit as the selection input and depending on that 2-bit value will determine which bitwise operation will take place between
	-- the two hex. numbers (hex_B and hex_A). The results of the bitwise operation will be displayed on the leds defined. 
	INST5: Logical_Processor port map (hex_B, hex_A,pb(1 downto 0), leds(3 downto 0));
	
	
	
 
end SimpleCircuit;

