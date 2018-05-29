module astavel
#(
	parameter C = 25'd10
)	

(
	input  clk,	
	output reg clk_out	
);

reg [1:0] q;
reg [24:0] cnt;


always @ (posedge clk) begin

	if (q == 2'd0 || q == 2'd2)
		cnt <= cnt + 1'b1;
	else
		cnt <= 25'd0;	case (q)
		2'd0   : if (cnt < C)  	q <= 2'd0;  else 	q <= 2'd1;							 
		2'd1   : q <= 2'd2;
   	2'd2   : if (cnt < C)   q <= 2'd2;  else 	q <= 2'd3;
		2'd3   : q <= 2'd0;			
		default: q <= 2'd0;              
	endcase	
end

always @ (*) begin
	case (q)
		2'd0   : clk_out <= 1'b0;
		2'd1   : clk_out <= 1'b0;
		2'd2   : clk_out <= 1'b1;
		2'd3   : clk_out <= 1'b1;		
		default: clk_out <= 1'b0;	
	endcase	
end

endmodule
