module outBuff

#( parameter NBADD = 12,
   parameter NBITS = 16
)

(  input 						        clk, wt,
   input signed  	   [2*NBITS -1:0]  in,
	input             [NBADD -1:0]  addr,
	output reg signed [2*NBITS -1:0]  out 
	);
	
	
reg signed [NBITS -1:0] outValue [2**NBADD-1:0];       
           
initial begin   // OutBuff


end

always @ (*) out = outValue[addr];

always @ (posedge clk) if(wt) outValue[addr] <= in;

endmodule	
	
	