module Input

#(
  parameter NBITS = 12
)

(  input      [NBITS-1:0]  addr,
	output reg               out 
);
	
	
reg data [2**NBITS-1:0];       
           
initial begin   //square wave
$readmemb("rom.mif", data);
end

always @ (*) out = data[addr];

endmodule	
	
	