module PWM_top_teste
(

	input clk, key0, 
	output PWMout1//, PWMout2

);

wire clk200;
PLL1502180 Pll1(.inclk0(clk),.c3(clk200));
PWM p1(clk200, ~key0, 26'd4616515, 26'd8595, 26'd0, PWMout1);
//PWM p2(clk200, ~key0, 26'd198, 26'd1180, 26'd180, PWMout2);

endmodule
