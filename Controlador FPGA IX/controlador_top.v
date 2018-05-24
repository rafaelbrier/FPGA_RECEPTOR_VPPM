module controlador_top
	(	
		input clk,
		output [7:0] y, //LEDS
		output [1:0] z, //canais pwm
		
		//////////// KEY //////////
		input 		     [1:0]		KEY,
		
		//////////// SW //////////
		input [3:0]		SW, // cada canal com seu correspondente binario


		//////////// ADC //////////
		output ADC_CS_N,
		output ADC_SADDR,
		output ADC_SCLK,
		input  ADC_SDAT
	);

//Valores para experimento	
//	wire [25:0] D1 = 26'd500; //D se 50,7% => 507
//	wire [25:0] N1 = 26'd60;// n = 50M/clk
//	wire [25:0] delay1 = 26'd0;// diretamente relacionado com n
//	
//	wire [25:0] D2 = 26'd500; //D se 50,7% => 507
//	wire [25:0] N2 = 26'd60;// n = 50M/clk
//	wire [25:0] delay2 = 26'd180;// n = 50M/clk

//Valores para debug
	wire [25:0] D1 = 26'd2550; //D se 50,7% => 507
	wire [25:0] N1 = 26'd1666;// n = 50M/clk
	wire [25:0] delay1 = 26'd0;// em graus
	
	wire [25:0] D2 = 26'd8770; //D se 50,7% => 507
	wire [25:0] N2 = 26'd1666;// n = 50M/clk
	wire [25:0] delay2 = 26'd270;// em graus
	
//	wire [54:0] Non  = (D*N)/26'd1000; 
//	wire [54:0] Noff = ((26'd1000-D)*N)/26'd1000;
	
	wire c0,c1,c2; // c0 50M, c1 2M, c2 180 2M
	
	PLL1502180 Pll(clk,c0,c1,c2);
	PWM PWM0(c0, N1, D1, delay1, z[0]);
	PWM PWM1(c0, N2, D2, delay2, z[1]);
	ADC_CTRL	ADC1(
						.iRST(KEY[0]),
						.iCLK(c1),
						.iCLK_n(c2),
						.iGO(KEY[1]),
						.iCH(SW[2:0]),
						.oLED(y),
						
						.oDIN(ADC_SADDR),
						.oCS_n(ADC_CS_N),
						.oSCLK(ADC_SCLK),
						.iDOUT(ADC_SDAT)
					);

endmodule
