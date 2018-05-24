`timescale 1 ns / 1 ns

module controlador_top_v2_tb();

	reg clk;
	reg [3:0] sw; 
	wire [11:0] dataROM;
	wire [9:0] add;
	wire [25:0] duty;
	wire       PWMout;
	
	initial begin
		clk <= 1'b0;
//		clk_Fs <= 1'b0;
//		clk200 <= 1'b0;
		sw <= 4'd15;
//		#7000000 
//		sw <= 4'd12;
//		#20 clk <= 1'b1;
//		#100 rst <= 1'b0;
//		
//		#7000 en <= 1'b0;
//		#50 en <= 1'b1;

	end
	
//	always #2 clk200 <= ~clk200;
	always #10 clk <= ~clk; //#10 so existe em simulaÃ§Ã£o //sempre a cada 10 ns faz a simulaÃ§Ã£o
//	always #4000 clk_Fs <= ~clk_Fs;
	//always #6000 ud <= ~ud;
	
	//bibinho viado tem TOC
	//thiago com h de viado EL BIGODON faltou aula hj
	//Bleno nunca vem na aula, ou chega atrasado.
		
	controlador_top_vROM co2(clk, sw,  dataROM, add, duty, PWMout);

endmodule

