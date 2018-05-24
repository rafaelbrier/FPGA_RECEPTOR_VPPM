module inBuff

#( parameter NBADD = 8,
   parameter NBITS = 12
)

(  input 						 clk, wt,
   input signed [NBITS:0]  in,
	input        [NBADD -1:0]  addr,
	output reg signed [NBITS:0]  out 
	);
	
	
reg signed [NBITS:0] adcValue [2**NBADD-1:0];       
           
initial begin   // 


end

always @ (*) out = adcValue[addr];

always @ (posedge clk) if(wt) adcValue[addr] <= in;

endmodule	
	
	