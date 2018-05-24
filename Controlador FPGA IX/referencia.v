module referencia
(
	input [3:0] sw,
	output reg [63:0] vref
);
	initial begin
		vref <= 64'd0;
	end
	
	always @(*) begin

		case (sw)
			 4'd0: vref = 64'd0;
			 4'd1: vref = 64'd0;
			 4'd2: vref = 64'd0;
			 4'd3: vref = 64'd0;
			 4'd4: vref = 64'd0;
			 4'd5: vref = 64'd0;
			 4'd6: vref = 64'd0;
			 4'd7: vref = 64'd0;
			 4'd8: vref = 64'd0;
			 4'd9: vref = 64'd0;
			4'd10: vref = 64'd0;
			4'd11: vref = 64'd0;
			4'd12: vref = 64'h3FB999999999999A;//100ma
			4'd13: vref = 64'h3FC999999999999A;//200ma
			4'd14: vref = 64'h3FD999999999999A;//400ma
			4'd15: vref = 64'h3FD3333333333333;//300ma
		 default: vref = 64'd0;
	  endcase
	end

endmodule
