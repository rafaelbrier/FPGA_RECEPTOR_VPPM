module controlador_top_vteste 
(
	//input clk, 
	input clk, key0,//key0 é um reset pro controladro
	input [3:0] sw,
	output [25:0] duty,
	output PWMout1,PWMout2,
	output [5:0] r,
	
	output wire [11:0] dataADC, ADC_filtro,
	output [29:0] corrente,
	//ADC
	output				oDIN,
	output				oCS_n,
	output				oSCLK,
	input					iDOUT
);
	wire signed [26:0] D; 
	wire [63:0] vref, e0;
	wire e0ready, clk_50, iCLK, iCLK_n, iDR, clk_200, clk_Fs, degrau; 
	reg [3:0] sw2; //para o teste degrau
	
	//wire [25:0] duty1;
	
	//tustin a 125k FP	
//	wire [63:0] B0 = 64'h3EEDA48CF7D36861, //1.413477707006369e-05,      // s^50 = 1.1259e15
//			  	   B1 = 64'h3EBF9E743B8C2B0F, //1.884636942675158e-06,
//			      B2 = 64'hBEE9B0BE7061E2FE, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
//			      A1 = 64'h3FFF97A4B01A16D6, //1.974522292993631,      //199356913183280 E14 
//			      A2 = 64'hBFEF2F4960342DAC; //-0.974522292993631;     

//	//tustin a 125k FP	corrente PI para controle normal 
//	wire [63:0] B0 = 64'h3F926E978D4FDF3B, //1.413477707006369e-05,      // s^50 = 1.1259e15
//			  	   B1 = 64'hBF60624DD2F1A9FC, //1.884636942675158e-06,
//			      B2 = 64'd0, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
//			      A1 = 64'h3FF0000000000000, //1.974522292993631,      //199356913183280 E14 
//			      A2 = 64'd0; //-0.974522292993631;
				
			//tustin a 125k FP	corrente I para controle normal 2000/s
	wire [63:0] B0 = 64'h3F80624DD2F1A9FC, //1.413477707006369e-05,      // s^50 = 1.1259e15
			  	   B1 = 64'h3F80624DD2F1A9FC, //1.884636942675158e-06,
			      B2 = 64'd0, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
			      A1 = 64'h3FF0000000000000, //1.974522292993631,      //199356913183280 E14 
			      A2 = 64'd0; //-0.974522292993631;	

////tustin a 125k FP	corrente PI para controle normal 10 e 10000
//	wire [63:0] B0 = 64'h4024147AE147AE14, //1.413477707006369e-05,      // s^50 = 1.1259e15
//			  	   B1 = 64'hC023EB851EB851EB, //1.884636942675158e-06,
//			      B2 = 64'd0, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
//			      A1 = 64'h3FF0000000000000, //1.974522292993631,      //199356913183280 E14 
//			      A2 = 64'd0; //-0.974522292993631;	


	PLL32 PLL1(clk, clk_50, iCLK, iCLK_n, clk_200);
	ADC_CTRL	ADC1(1'd1, iCLK, iCLK_n, 1'd1, 3'b000, dataADC, iDR, oDIN, oCS_n, oSCLK, iDOUT);//aatuais 200k
	//ADC2erroFP A2e(clk_50, iDR, dataADC, vref, e0, e0ready);
	
	
	PWMv4 pFs(clk_200, 1'd0, 26'd1598, 14'd5000, 9'd0, clk_Fs); // gerar a FS //atuais 125k
	
	ADC2erroFP_i e1(clk_50, clk_Fs,//clkFs é adcready
	                 dataADC, corrente, vref, e0, e0ready, ADC_filtro);
	
	referencia r1(sw, vref);//sw para referencia por chave e sw2 por teste degrau!!!!!!!!!!!
	compensadorPF cP(clk_50, ~key0, e0ready, e0, B0, B1, B2, A1, A2, D, r);
	saturator s1(D, duty);
	PWMv4 PWM1(clk_200, 1'd0, 26'd3998, duty[13:0], 9'd0, PWMout1);//mudar para duty1 modo normal, duty 1
	
	//multiplexar o duty1 e duty2 para o duty
//	always @(posedge clk_50) begin
//		if(degrau == 1'd0)
//			duty <= 26'd0; //0%
//		else
//			duty <= duty1;
//	end
	
	//teste degrau - IGNORAR
	PWMv4 deg(clk_200, 1'd0, 26'd3999998, 14'd5000, 9'd0, degrau);//125 hz
	always @(posedge clk_50) begin
		if (degrau == 1'd1)
			sw2 <= 4'd15;
		else
			sw2 <= 4'd0;
	end
	
	assign PWMout2 = PWMout1;
	
endmodule
