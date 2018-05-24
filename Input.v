module Input

#(
   parameter NBADD = 12,
   parameter NBITS = 12
)

(  input      [NBADD -1:0]  addr,
	output reg signed [NBITS:0]  out 
);
	
	
reg signed [NBITS:0] data [2**NBADD+10:0];       
           
initial begin   //square wave
$readmemh("ENTRADA.hex", data);
end

always @ (*) out = data[addr];

endmodule	
	
	