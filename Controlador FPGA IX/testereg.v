module testereg
(input clk, key, key2, input [1:0] sel, in,  output reg q, output reg [1:0] a, b, c, d);

always @(posedge clk) begin
	if (key2 == 1'd1)
		if (key == 1'd1)
			q <= 1'd1;
		else
			q <= 1'd0;
	
end

always @(posedge clk) begin
	case (sel)
		2'd0: a<=in;
		2'd1: b<=in;
		2'd2: c<=in;
		2'd3: d<=in;
	endcase
end
endmodule