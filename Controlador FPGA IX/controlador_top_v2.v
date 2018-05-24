module controlador_top_v2 
(
	input clk, 
	//input clk_50, clk_125k, clk_200,
	input [3:0] sw,
	output [25:0] duty,
	output [11:0] dataROM,
   output wire [63:0] e0,
	output wire PWMout
	
);
	
	wire [63:0] u0, e0teste;
	wire e0ready;
	wire signed [26:0] D;
	wire [63:0] vref;
	wire clk_50, clk_125k, clk_200;
	
	PLLROM PL1(clk, clk_50, clk_125k, clk_200);
	referencia r1(sw, vref);
	rom2erroFP2 r2e(clk_50, clk_125k, 64'h402E000000000000, e0, e0teste, e0ready, dataROM);
	compensadorPF cP(clk_50, 1'd1, e0ready, e0, u0, D);
	saturator s1(D, duty);
	PWM PWM1(clk_200, 1'd1, 26'd998, duty, 26'd0, PWMout);
	
endmodule
