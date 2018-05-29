module Counter
#(
   parameter NBITS = 12
)
(
	input clk,
	output reg [NBITS:0]countValue
);



always @ (posedge clk) begin
if(countValue <= 2**NBITS)
countValue <= countValue + 1'b1;
else
countValue <= 1'b0;
end


endmodule