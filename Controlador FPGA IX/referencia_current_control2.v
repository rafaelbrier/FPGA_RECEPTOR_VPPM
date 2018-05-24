module referencia_current_control2
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
			 4'd1: vref = 64'h3FF0000000000000;
			 4'd2: vref = 64'h4000000000000000;
			 4'd3: vref = 64'h4008000000000000;
			 4'd4: vref = 64'h4010000000000000;
			 4'd5: vref = 64'h4014000000000000;
			 4'd6: vref = 64'h4018000000000000;
			 4'd7: vref = 64'h401C000000000000;
			 4'd8: vref = 64'h4020000000000000;
			 4'd9: vref = 64'h4022000000000000;
			4'd10: vref = 64'h4024000000000000;
			4'd11: vref = 64'h4026000000000000;
			4'd12: vref = 64'h4028000000000000;
			4'd13: vref = 64'h402A000000000000;
			4'd14: vref = 64'h402C000000000000;
			4'd15: vref = 64'h4083600000000000;//64'h408363A2E8BA2E8C;//usar essa 500m*4095/3,3  // um é arredondado para indteiro adc
		 default: vref = 64'd0;
	  endcase
	end

endmodule
