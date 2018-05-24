module TOP_ADC_TESTE2 //corrente e filtrp
(
	//input clk, 
	input clk,
	
	output wire [11:0] dataADC,
	output [11:0] ADC_filtro,
	output signed [29:0] corrente,
	output iDR, e0ready, PWMout1, PWMout2,
	//ADC
	output				oDIN,
	output				oCS_n,
	output				oSCLK,
	input					iDOUT
);
	//wire signed [26:0] D; 
	wire [63:0] vref, e0;
	wire [63:0] dataADCFP;
	wire clk_50, iCLK, iCLK_n, clk_200, clk_Fs; 
	
	PLL32 PLL1(clk, clk_50, iCLK, iCLK_n, clk_200);
	ADC_CTRL	ADC1(1'd1, iCLK, iCLK_n, 1'd1, 3'b000, dataADC, iDR, oDIN, oCS_n, oSCLK, iDOUT);
	PWM p1(clk_200, 1'd1, 26'd19998, 26'd5000, 26'd0, clk_Fs); // gerar a FS
	
	//pwm malha aberta 50k
	PWM pwm1(clk_200, 1'd1, 26'd3998, 26'd5000, 26'd0, PWMout1);
	
	ADC2erroFP_i e1(clk_50, clk_Fs,//clkFs é adcready
	                 dataADC, corrente, 64'h3FD3333333333333, e0, e0ready, ADC_filtro);
	
	assign PWMout2 = PWMout1;
endmodule
