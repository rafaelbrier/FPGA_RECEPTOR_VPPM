module testeNumeros
	(input clk, output reg [11:0]y, output reg signed [11:0] z, output reg signed [23:0] w);
	
	reg [1:0] q;
	
	always @(posedge clk) begin
	
			case (q)
				2'd0: begin y <= 12'd200; z <= $signed(-12'd200); w <= 0; q <= q + 1'd1; end
				2'd1: begin w <= $signed(y)*z; q <= q + 1'd1; end
				2'd2: begin y <= $signed(12'd200); z <= -12'd200; w <= 0; q <= q + 1'd1; end
				2'd3: begin w <= y*z; q <= q + 1'd1; end
			endcase
	
	end

endmodule
//conclusoes
//um numero negativo vezes um unsigned num baramento signed da unsigned
// certo w <= $signed(y)*z;, errado w <= y*z;