`timescale 1 ns / 1 ns

module compensadorPF_tb();

	reg	            clk_50, clk_Fs;
		reg      [63:0] e0; //tendo como 3.3 V equivalendo a 20 V e ADCbits = 4095d, essa entrada deve ser 20/4095
		wire [63:0] u0;
		wire signed [26:0] D;
		
	initial begin
		clk_50 <= 1'b0;
		clk_Fs <= 1'b0;
		e0 <= {1'b0,11'b01111111111,52'd0};
	
//		#20 clk <= 1'b1;
//		#100 rst <= 1'b0;
//		
//		#7000 en <= 1'b0;
//		#50 en <= 1'b1;

	end
	
	always #10 clk_50 <= ~clk_50; //#10 so existe em simulaÃ§Ã£o //sempre a cada 10 ns faz a simulaÃ§Ã£o
	always #4000 clk_Fs <= ~clk_Fs;
	//always #6000 ud <= ~ud;
	
	//bibinho viado tem TOC
	//thiago com h de viado EL BIGODON faltou aula hj
	//Bleno nunca vem na aula, ou chega atrasado.
		
	compensadorPF cP(clk_50, clk_Fs, e0, u0, D);

endmodule

