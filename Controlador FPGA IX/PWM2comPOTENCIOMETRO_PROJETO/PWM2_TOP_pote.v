module PWM2_TOP_pote
(

		input clk, sclear,//reseta em alto e na verdade o clear é sincrono com clk base
		input [3:0] sw,
		output q1, q2//onda pwm

);
reg [25:0] N1, D1, P1, q1;
reg [25:0] N2, D2, P2, q2;
wire [25:0] ADC26 = {14'd0,ADC};

PWMv2 pw1(clk, ~sclear, N1, D1, P1, q1);
PWMv2 pw2(clk, ~sclear, N2, D2, P2, q2);
//arrumar aqui
ADC_CTRL	(	
					iRST,
					iCLK,
					iCLK_n,
					iGO,
					iCH,
					oLED,
					iDR,
					
					oDIN,
					oCS_n,
					oSCLK,
					iDOUT
				);

always @ (posedge clk) begin
	case (sw)
		4'b0100: begin N1 <= ADC26; end
		4'b0010: begin D1 <= (ADC26*25'd10000)/25'd4095; end
		4'b0001: begin P1 <= (ADC26*25'd359)/25'd4095; end
		4'b1100: begin N1 <= (ADC26*25'd359)/25'd4095; end
		4'b1010: begin D1 <= (ADC26*25'd10000)/25'd4095; end
		4'b1001: begin P1 <= ADC26 end
	endcase
end

endmodule