library ieee;
use ieee.std_logic_1164.all;


entity two_to_1_mux is
port (
	logic_in0, logic_in1 					  : in std_logic_Vector(3 downto 0); -- 4-bit values that will be used as the input 
	mux_select									  : in std_logic; -- a 1-bit value that will determine which input passes through 
	p_out 										  : out std_logic_vector(3 downto 0) -- The hex Output
);

end two_to_1_mux; 



architecture mux_logic of two_to_1_mux is 

begin
-- Depending on the mux_select value, will determine which of the inputed object will pass through 
with mux_select select
p_out <= (logic_in0) when '0', 
			 (logic_in1) when '1';
			  
end mux_logic; 