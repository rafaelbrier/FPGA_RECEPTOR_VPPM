module RMS
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

reg signed [2*NBITS1+4:0] acc;
reg signed [2*NBITS1:0] square;
reg signed [NBITS1-1:0] x_now, x_old; 
reg [3:0] incre_count;
reg acc_flag;
initial acc_flag = 1'b1;


//Estado
reg [3:0] q;
always @ (posedge clk) begin
case (q)
		4'd0   :   if(inCount > N)  		  		q <= 4'd1;        else q <= 4'd0;
	   4'd1   :	                    		  		q <= 4'd2;
		4'd2   :                    		  		q <= 4'd3;
		4'd3   :   if(inCount < 2**NBITS2) 		q <= 4'd1;        else q <= 4'd4;
		4'd4   :                           		q <= 4'd5;
		4'd5   :                           		q <= 4'd6;
		4'd6   :                          		q <= 4'd7;
		4'd7   :   if(incre_count < 4'd15) 		q <= 4'd6;        else q <= 4'd8;
		4'd8   :   if(inCount == 4'd0)         q <= 4'd0;        else q <= 4'd8;
		default: q <= 4'd0;
	endcase
end

always @ (posedge clk) begin
if (q == 4'd0) begin
acc <= 0;
square <= 0;
x_now <=0;
x_old <=0;
incre_count <= 0;
end
else if ( q == 4'd1) begin
square <= dataIn*dataIn;
end

else if ( q == 4'd2) begin
if(acc_flag == inCount[0]) begin
acc <= acc + square;
acc_flag = ~acc_flag;
end
end

else if ( q == 4'd4) begin
acc <= acc/(2**NBITS2-N);
end

else if ( q == 4'd5) begin
x_old <= acc/(2**NBITS2);
end

else if ( q == 4'd6) begin
x_now <= (x_old + acc/x_old)/2;
end

else if ( q == 4'd7) begin
x_old <= x_now;
incre_count <= incre_count + 1'b1;
end

else if ( q == 4'd8) begin
dataOut <= x_now;
end

end

endmodule