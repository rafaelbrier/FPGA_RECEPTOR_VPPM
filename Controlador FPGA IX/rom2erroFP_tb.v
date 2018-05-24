`timescale 1 ns / 1 ns

module rom2erroFP_tb();

	reg             clk, clk_Fs;
	wire            [63:0] e0;
	wire       e0ready;
	
	wire  [10:0] add;
	wire  [16:0] vref;
	wire signed [11:0] dataROM;
	wire [12:0] dataa;
	wire   [3:0] r;
		
	initial begin
		clk <= 1'b0;
		clk_Fs <= 1'b0;
	
//		#20 clk <= 1'b1;
//		#100 rst <= 1'b0;
//		
//		#7000 en <= 1'b0;
//		#50 en <= 1'b1;

	end
	
	always #10 clk <= ~clk; //#10 so existe em simulaÃ§Ã£o //sempre a cada 10 ns faz a simulaÃ§Ã£o
	always #4000 clk_Fs <= ~clk_Fs;
	//always #6000 ud <= ~ud;
	
	//bibinho viado tem TOC
	//thiago com h de viado EL BIGODON faltou aula hj
	//Bleno nunca vem na aula, ou chega atrasado.
		
	rom2erroFP2 r2eFp
(
                 clk, clk_Fs,
	      e0,
	      e0ready,
	
	 add,vref,dataROM,dataa,r
	
//	output reg  [12:0] add,
//	output reg  [16:0] vref,
//	output wire signed [11:0] dataROM,
//	output wire [12:0] dataa,
//	output reg   [3:0] r
);

endmodule

