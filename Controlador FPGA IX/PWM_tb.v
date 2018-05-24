`timescale 1 ns / 1 ns

module PWM_tb();

		reg clk;
		reg  [25:0] D;//relacioando ao tempo, duty cycle e atraso
		wire q,s;
		
		reg r;
		
//		output reg [25:0] cnt, //divisao
//		output reg [25:0] cnt0, //contador de atraso inicial
//		output reg flag_cnt0//flag para delay
	
	initial begin
		clk <= 1'b0;
		D <= 26'd0;
		r <= 1'd0;
//		#1000000 D <= 26'd2000;
//		#1000000 D <= 26'd8000;
//		#1000000 D <= 26'd5000;
//		#1000000 D <= 26'd6945;
//		#1000000 D <= 26'd10;
//		#1000000 D <= 26'd9555;
//		#1000000 D <= 26'd7777;
//		#1000000 D <= 26'd7538;
//		#1000000 D <= 26'd200;
//		#20 clk <= 1'b1;
//		#100 rst <= 1'b0;
//		
//		#7000 en <= 1'b0;
//		#50 en <= 1'b1;

	end
	always #8000 begin 
	if (r == 1'd0) begin
		D <= 8500; 
		r <= 1'd1;
	end
	else begin
		D <= 5000;
		r <= 1'd0;
	end
	end
	always #2 clk <= ~clk; //#10 so existe em simulaÃ§Ã£o //sempre a cada 10 ns faz a simulaÃ§Ã£o
	
	//always #6000 ud <= ~ud;
	
	//bibinho viado tem TOC
	//thiago com h de viado EL BIGODON faltou aula hj
	//Bleno nunca vem na aula, ou chega atrasado.
		
	PWM PW11(clk, 1'd1, 26'd6, D, 26'd180, q);
	PWM PW22(clk, 1'd1, 26'd6, D, 26'd0, s);
	
endmodule

