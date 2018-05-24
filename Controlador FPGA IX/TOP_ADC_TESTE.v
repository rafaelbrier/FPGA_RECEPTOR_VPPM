module TOP_ADC_TESTE 
(
	//input clk, 
	input clk,
	//input iRST, iGO,
	//input [3:0] sw,
	//output [25:0] duty,
	//output PWMout,
	//output [5:0] r,
	
	output wire [11:0] dataADC,
	output signed [12:0] result,
	output signed [29:0] prod,
	output iDR,
	//ADC
	output				oDIN,
	output				oCS_n,
	output				oSCLK,
	input					iDOUT
);
	//wire signed [26:0] D; 
	//wire [63:0] vref, e0;
	wire [63:0] dataADCFP;
	wire signed [14:0] gain = 15'd6268;//3,26/4095/VA , VA = 114m isso tudo x 1e6
	wire signed [12:0] offset = 13'd3041;//2,4*4095/3,26 ou valores experimentais
	wire e0ready, clk_50, iCLK, iCLK_n, clk_200; 
	
	PLL1502180 PLL1(clk, clk_50, iCLK, iCLK_n, clk_200);
	ADC_CTRL	ADC1(1'd1, iCLK, iCLK_n, 1'd1, 3'b000, dataADC, iDR, oDIN, oCS_n, oSCLK, iDOUT);
	assign result = $signed({1'd0,dataADC})-offset;
	
	assign prod = result * gain; //prod na vdd é x 1e-6
	
	
endmodule
