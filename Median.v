module Median
#(
	parameter NBADD = 8,
   parameter NBITS1 = 16,
   parameter NBITS2 = 12,
	parameter N = 8'd96
)
(
	input clk,
	input             [NBADD +4:0] inCount,
	input signed      [NBITS1-1:0] dataIn,
	output reg signed [NBITS1-1:0] dataOut
	);

reg signed [2*NBITS2:0] acc;
reg acc_flag;
initial acc_flag = 1'b1;


//Estado
reg [3:0] q;
always @ (posedge clk) begin
case (q)
		4'd0   :   if(inCount > N)  		  		q <= 4'd1;        else q <= 4'd0;	 
		4'd1   :   if(inCount < 2**NBITS2 - 1) q <= 4'd1;        else q <= 4'd2;	
		4'd2   :   										q <= 4'd3;        
		4'd3   :   if(inCount == 4'd0)         q <= 4'd0;        else q <= 4'd3;
		default: q <= 4'd0;
	endcase
end

always @ (posedge clk) begin
if (q == 4'd0) begin
acc <= 0;
end

else if ( q == 4'd1) begin
if(acc_flag == inCount[0]) begin
acc <= acc + dataIn;
acc_flag = ~acc_flag;
end
end

else if ( q == 4'd2) begin
acc <= acc/(2**NBITS2-N);
end

else if ( q == 4'd3) begin
dataOut <= acc[NBITS1-1:0];
end

end

endmodule