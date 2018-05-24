module controlador_top_vROM 
( 
	input clk,
	input [3:0] sw, 
	output [11:0] dataROM,
	output [9:0] add,
	output [25:0] duty,
	output wire PWMout
	
);
	wire  [5:0] r;///////////////////////
   wire e0ready;
	wire Rst;
	wire [63:0] e0;
	wire signed [26:0] D;
	wire clk_50, clk_125k, clk_200;
	wire [63:0] vref;
	
//	//tustin a 125k FP	
//	wire [63:0] B0 = 64'h3EEDA48CF7D36861, //1.413477707006369e-05,      // s^50 = 1.1259e15
//			  	   B1 = 64'h3EBF9E743B8C2B0F, //1.884636942675158e-06,
//			      B2 = 64'hBEE9B0BE7061E2FE, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
//			      A1 = 64'h3FFF97A4B01A16D6, //1.974522292993631,      //199356913183280 E14 
//			      A2 = 64'hBFEF2F4960342DAC; //-0.974522292993631;     
//					
	//tustin a 125k FP	corrente PI para controle 2
	wire [63:0] B0 = 64'h3F40A569B17481B2, //1.413477707006369e-05,      // s^50 = 1.1259e15
			  	   B1 = 64'hBF401F31F46ED245, //1.884636942675158e-06,
			      B2 = 64'd0, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
			      A1 = 64'h3FF0000000000000, //1.974522292993631,      //199356913183280 E14 
			      A2 = 64'd0; //-0.974522292993631;     

	
	PLLROM PL1(clk, clk_50, clk_125k, clk_200);
//	referencia r1(sw, vref);
	referencia_current_control2 r1(sw, vref);
//	rom2erroFP2 r2e(clk_50, clk_125k, vref, /*64'h402E000000000000,*/ Rst, e0, e0ready, dataROM, add);
	rom2erroFP_control2 r2e(clk_50, clk_125k, vref, /*64'h402E000000000000,*/ Rst, e0, e0ready, dataROM, add);
	compensadorPF cP(clk_50, Rst, e0ready, e0, B0, B1, B2, A1, A2, D, r);
	saturator s1(D, duty);
	PWM PWM1(clk_200, 1'd1, 26'd998, duty, 26'd0, PWMout);
	
	//habilitar romwerro, vref, e parametros para velho ocntroladotr
endmodule
