`timescale 1 ns / 1 ns

module ADC2erroFP_tb();


	reg                clk, ADCready;//clkFs é adcready
	reg         [11:0] ADC;
	wire signed [29:0] corrente;
	reg 		  [63:0] vref;
	wire        [63:0] e0; 
	wire            e0ready;
	wire [11:0] ADC_filtro;

		
	initial begin
		clk <= 1'd0;
		ADCready <= 1'd0;
		ADC <= 12'd3050;
		vref <= 64'h3FD3333333333333;
	
//		#20 clk <= 1'b1;
//		#100 rst <= 1'b0;
//		
//		#7000 en <= 1'b0;
//		#50 en <= 1'b1;

	end
	
	always #1 clk <= ~clk; //#10 so existe em simulaÃ§Ã£o //sempre a cada 10 ns faz a simulaÃ§Ã£o
	always #200 ADC <= ADC + 1'd1;
	always #100 ADCready <= ~ADCready;
	//always #6000 ud <= ~ud;
	
	//bibinho viado tem TOC
	//thiago com h de viado EL BIGODON faltou aula hj
	//Bleno nunca vem na aula, ou chega atrasado.
		
	ADC2erroFP_i a1
(
	 clk, ADCready,//clkFs é adcready
	 ADC,
	 corrente,
	 vref,
	 e0, 
	 e0ready,
	 ADC_filtro
	
); 

endmodule

