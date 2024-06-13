library ieee;
use ieee.std_logic_1164.all;


entity Logical_Processor is
port (
	logic_in0, logic_in1 					  : in std_logic_Vector(3 downto 0); -- The Two Input values being compared
	mux_select									  : in std_logic_vector(1 downto 0); -- a 2-bit value that value depends on which bitwise operation will be used
	p_out 										  : out std_logic_vector(3 downto 0) -- The hex Output
);

end Logical_Processor; 



architecture Processor_Logic of Logical_Processor is 

begin
-- Referring to the table in the Lab report, if the mux_select signal bit value matches with its corresponding value, it will run the selected bitwise operation 
with mux_select(1 downto 0) select
p_out <= (logic_in0 AND logic_in1) when "00",  
			  (logic_in0 OR logic_in1) when "01", 
			  (logic_in0 XOR logic_in1) when "10", 
			  (logic_in0 XNOR logic_in1) when "11";
			  
end Processor_Logic; 