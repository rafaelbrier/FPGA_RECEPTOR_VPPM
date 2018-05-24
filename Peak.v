module Peak
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
	
reg signed [NBITS1-1:0] peak_Now;
reg sample_flag;
initial sample_flag = 1'b1;


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
peak_Now <= 0;
end

else if ( q == 4'd1) begin
if(sample_flag == inCount[0]) begin
if (peak_Now < dataIn) peak_Now <= dataIn;
sample_flag = ~sample_flag;
end
end

else if ( q == 4'd3) begin
dataOut <= peak_Now;
end

end
endmodule