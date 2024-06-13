library ieee;
use ieee.std_logic_1164.all;


entity full_adder_1bit is
port (
	INPUT_B								: in std_logic; -- a 1-bit value that will be added
	INPUT_A								: in std_logic; -- a 1-bit value that will be added
	CARRY_IN								: in std_logic; -- a 1-bit value that has been carried over from a previous 1-bit operation 
	FULL_ADDER_CARRY_OUTPUT			: out std_logic; -- a 1-bit value that is the sum of the two bits
	FULL_ADDER_SUM_OUTPUT			: out std_logic  -- a 1-bit value that will represent the carry, if there is one
);

end full_adder_1bit; 



architecture full_adder of full_adder_1bit is 
	
	signal half_carry_out : std_logic;
	signal half_sum_output :std_logic;

begin
	-- This section of code computes the sum of the two inputted values, it returns the sum of the values and a carry if it exists when the computation is completed. 
	half_carry_out <= (INPUT_B AND INPUT_A); 
	half_sum_output <= (INPUT_B XOR INPUT_A);
	FULL_ADDER_CARRY_OUTPUT	<=  (half_carry_out OR (CARRY_IN AND half_sum_output));
	FULL_ADDER_SUM_OUTPUT <= (half_sum_output XOR CARRY_IN);
	
	
			  
end full_adder; 