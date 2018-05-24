//Assim que tiver o resultado do ADC, a ação de controle tem um atraso de 29 - 30 pulsos de colk base
// Entrada em double e Saída tmb

module compensadorPF 
	(
		input	            clk_50, iRST, e0ready,
	   input      [63:0] e0in, //tendo como 3.3 V equivalendo a 20 V e ADCbits = 4095d, essa entrada deve ser 20/4095
		
		//tustin a 125k FP	
		input [63:0] B0, //1.413477707006369e-05,      // s^50 = 1.1259e15
						 B1, //1.884636942675158e-06,
						 B2, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
						 A1, //1.974522292993631,      //199356913183280 E14 
						 A2, //-0.974522292993631;     

		
		output signed [26:0] D,
		output reg [5:0] r //gerenciador da maquina de estados
	);
	
	
//tustin a 500k	
//	wire [63:0] B0 = $signed(338939228295820)  //3.38939228295820e-06,      // s^50 = 1.1259e15
//			  	   B1 = $signed(118926045016077)  //1.18926045016077e-07,
//			      B2 = $signed(-327046623794212) //-3.27046623794212e-06, //0.00000327046623794212 = 327046623794212E-20
//			      A1 = $signed(199356913183280)  //1.99356913183280,      //199356913183280 E14 
//			      A2 = $signed(-993569131832798) //-0.993569131832798;


//					//tustin a 125k IINTEGRADOR	
//	wire [63:0] B0 = 64'h3F14F8B588E368F1, //1.413477707006369e-05,      // s^50 = 1.1259e15
//			  	   B1 = 64'h3F14F8B588E368F1, //1.884636942675158e-06,
//			      B2 = 64'd0, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
//			      A1 = 64'h3FF0000000000000, //1.974522292993631,      //199356913183280 E14 
//			      A2 = 64'd0; //-0.974522292993631;     

//teste
//	wire [63:0] B0 = {1'b0,11'b01111111111,52'd0},
//   		  	   B1 = {1'b0,11'b01111111111,52'd0},
//			      B2 = {1'b0,11'b01111111111,52'd0},
//			      A1 = {1'b0,11'b01111111111,52'd0},
//			      A2 = {1'b0,11'b01111111111,52'd0};
	

	reg  [63:0] u1, u2, u0, u00; 
	reg  [63:0] e0, e1, e2;
	//reg         aclear, clk_enn;
	wire [63:0] soma, prod;
	
	reg [63:0] Au1, Au2, Be0, Be1, Be2, Au12, Be01, Au12Be2;//, sfinal;
	
	reg  [2:0] sel_prod;
	reg [63:0] mux_coef;	
	reg [63:0] mux_signal;
	
	reg  [1:0] sel_mis;
	reg [63:0] mux_insumA;
	reg [63:0] mux_insumB;
	
	reg flag;
	
	wire [63:0]produ0;
	
	initial begin
//		aclear <= 1'd1; 
//		clk_enn <= 1'd0;
//		r <= 6'd29; //gerenciador da maquina de estados
		r <= 6'd52;
		flag <= 1'd0;
		u0 <= 64'd0;
		u1 <= 64'd0;
		u2 <= 64'd0;
		e0 <= 64'd0;
		e1 <= 64'd0;
		e2 <= 64'd0;
		Au1 <= 64'd0; Au2<= 64'd0; Be0<= 64'd0; Be1<= 64'd0; Be2<= 64'd0; Au12<= 64'd0; Be01<= 64'd0; Au12Be2<= 64'd0;
		sel_prod <= 3'd0;
		mux_coef <= 64'd0;	
		mux_signal <= 64'd0;
		sel_mis <= 2'd0;
		mux_insumA <= 64'd0;
		mux_insumB <= 64'd0;
	end
				
	addFP   add1(
					 .aclr(1'd0),
					 .add_sub(1'd1),
					 .clk_en(1'd1),
					 .clock(clk_50),
					 .dataa(mux_insumA),
					 .datab(mux_insumB),
					 //.nan,
					 //.overflow,
					 .result(soma)
					 //.underflow,
					 //.zero
					 );//delay 7
	multFP mult1(
	             .aclr(1'd0),
	             .clk_en(1'd1),
	             .clock(clk_50),
	             .dataa(mux_coef),
	             .datab(mux_signal),
	             //.nan,
	             //.overflow,
	             .result(prod)
	             //.underflow,
	             //.zero
					 );//delay 5
					 
					//mult do D 
	multFP mult2(
	             .aclr(1'd0),
	             .clk_en(1'd1),
	             .clock(clk_50),
	             .dataa(u00),
	             .datab(64'h40C3880000000000),//10000
	             //.nan,
	             //.overflow,
	             .result(produ0)
	             //.underflow,
	             //.zero
					 );//delay 5
	//u0prod to D				 
	FP2int Fi(//delay 6
				.aclr(1'd0),
				.clk_en(1'd1),
				.clock(clk_50),
				.dataa(produ0),
				//.nan,
				//.overflow,
				.result(D)
				//.underflow);
				);
	//mux_signal-------------------------------------
	always @(*) begin
		case(sel_prod)
			3'd0: begin mux_signal <= u1; mux_coef <= A1; end
			3'd1: begin mux_signal <= u2; mux_coef <= A2; end
			3'd2: begin mux_signal <= e0; mux_coef <= B0; end
			3'd3: begin mux_signal <= e1; mux_coef <= B1; end
			3'd4: begin mux_signal <= e2; mux_coef <= B2; end
			default: begin mux_signal <= 64'd0; mux_coef <= 64'd0; end
		endcase
	end
	//mux_signal-------------------------------------
	

//=============================================================================	
//	//old
//	//mux_insum--------------------------------------	
//	always @(*) begin
//		case(sel_mis)
//			2'd0: begin mux_insumA <=  Au1; mux_insumB <=     Au2; end
//			2'd1: begin mux_insumA <=  Be0; mux_insumB <=     Be1; end
//			2'd2: begin mux_insumA <= Au12; mux_insumB <=     Be2; end
//			2'd3: begin mux_insumA <= Be01; mux_insumB <= Au12Be2; end
//			default: begin mux_insumA <= 64'd0; mux_insumB <= 64'd0; end
//		endcase
//	end
//	//mux_insum--------------------------------------	
	
	//new
	//mux_insum--------------------------------------	
	always @(*) begin
		case(sel_mis)
			2'd0: begin mux_insumA <=  Au1; mux_insumB <=     Au2; end
			2'd1: begin mux_insumA <= Au12; mux_insumB <=     Be0; end
			2'd2: begin mux_insumA <= Au12; mux_insumB <=     Be1; end
			2'd3: begin mux_insumA <= Au12; mux_insumB <=     Be2; end
			default: begin mux_insumA <= 64'd0; mux_insumB <= 64'd0; end
		endcase
	end
	//mux_insum--------------------------------------
	
	
	//saturador do u0
	
	//teste de saturação FP
	always @(*) begin
		if (u0[63] == 1'd0)
			if (u0[62:52] > 11'b01111111111)//se >1,99999
				u00 <= 64'h3FF0000000000000;
			else
				u00 <= u0;
		else
			u00 <= 64'd0;
	end
	
						
	//assign u0 = A1*u1 + A2*u2 + B0*e0 + B1*e1 + B2*e2;
	//Amostragem
	
	//Maquina de estados para realizar u0 <= A1*u1 + A2*u2 + B0*e0 + B1*$e1 + B2*e2; com multiplexaçao
	always @(negedge clk_50 /*or posedge iRST*/) begin
		if(iRST == 1'd1) begin
			//aclear <= 1'd1; 
			//clk_enn <= 1'd0;
			r <= 6'd52; //gerenciador da maquina de estados
			flag <= e0ready;
			u0 <= 64'd0;
			u1 <= 64'd0;
			u2 <= 64'd0;
			e0 <= 64'd0;
			e1 <= 64'd0;
			e2 <= 64'd0;
			Au1 <= 64'd0; Au2<= 64'd0; Be0<= 64'd0; Be1<= 64'd0; Be2<= 64'd0; Au12<= 64'd0; Be01<= 64'd0; Au12Be2<= 64'd0;
			sel_prod <= 3'd0;
			sel_mis <= 2'd0;
		end
		else begin 

			//real new2
			case(r)
					6'd0:  begin               sel_mis <= 2'd0; sel_prod <= 3'd0; r <= r + 1'd1; flag <= e0ready; end
					6'd7:  begin Au1 <= prod;  sel_mis <= 2'd0; sel_prod <= 3'd1; r <= r + 1'd1; flag <= e0ready; end
					6'd14: begin Au2 <= prod;  sel_mis <= 2'd0; sel_prod <= 3'd2; r <= r + 1'd1; flag <= e0ready; end
					6'd21: begin Be0 <= prod;  sel_mis <= 2'd0; sel_prod <= 3'd3; r <= r + 1'd1; flag <= e0ready; end
					6'd23: begin Au12 <= soma; sel_mis <= 2'd1; sel_prod <= 3'd3; r <= r + 1'd1; flag <= e0ready; end
					6'd28: begin Be1 <= prod;  sel_mis <= 2'd1; sel_prod <= 3'd4; r <= r + 1'd1; flag <= e0ready; end
				   6'd32: begin Au12 <= soma; sel_mis <= 2'd2; sel_prod <= 3'd4; r <= r + 1'd1; flag <= e0ready; end
					6'd35: begin Be2 <= prod;  sel_mis <= 2'd2; sel_prod <= 3'd4; r <= r + 1'd1; flag <= e0ready; end
				   6'd41: begin Au12 <= soma; sel_mis <= 2'd3; sel_prod <= 3'd4; r <= r + 1'd1; flag <= e0ready; end
				  
				   6'd50: begin  
								sel_mis <= 2'd0; sel_prod <= 3'd0;
								
								u0 <= soma;
								u2 <= u1;
								e2 <= e1;
								
								r <= r + 1'd1; 
								flag <= e0ready; 
				   end
					6'd51: begin  
								sel_mis <= 2'd0; sel_prod <= 3'd0;
								e1 <= e0;
								
								r <= r + 1'd1; 
								flag <= e0ready;
				   end 
				  //estado inicial de idle
				  6'd52: begin
								sel_mis <= 2'd0; sel_prod <= 3'd0;
								e0 <= e0in; //grava a entrada enquanto noa esta fazendo as contas
								u1 <= u00;//guarda o u0 dde antes, nao de agora <- tava errado. agora guarda certo u00 é o valor depois de saturrado
								if (flag == e0ready)  
									r <= 6'd52;
								else  
									r <= 6'd0;
									
								flag <= flag;
				   end
				default: begin sel_mis <= sel_mis; sel_prod <= sel_prod; r <= r + 1'd1; flag <= e0ready; end
			endcase
			//			//fast
////			case(r)
////					6'd0: begin                 sel_prod <= 3'd0; r <= r + 1'd1;            end
////					6'd1: begin                 sel_prod <= 3'd1; r <= r + 1'd1;            end
////					6'd2: begin                 sel_prod <= 3'd2; r <= r + 1'd1;            end
////					6'd3: begin                 sel_prod <= 3'd3; r <= r + 1'd1;            end
////					6'd4: begin                 sel_prod <= 3'd4; r <= r + 1'd1;            end
////					6'd5: begin 					      Au1 <= prod; r <= r + 1'd1;            end
////					6'd6: begin sel_mis <= 2'd0;     Au2 <= prod; r <= r + 1'd1;            end
////					6'd7: begin                      Be0 <= prod; r <= r + 1'd1;            end
////					6'd8: begin sel_mis <= 2'd1;     Be1 <= prod; r <= r + 1'd1;            end
////					6'd9: begin                      Be2 <= prod; r <= r + 1'd1;            end
////				  6'd13: begin sel_mis <= 2'd2;    Au12 <= soma; r <= r + 1'd1;            end
////				  6'd15: begin                     Be01 <= soma; r <= r + 1'd1;            end
////				  6'd20: begin sel_mis <= 2'd3; Au12Be2 <= soma; r <= r + 1'd1;            end
////				  6'd27: begin  
////									u0 <= soma;
////									u2 <= u1;
////									e2 <= e1;
////									
////									r <= r + 1'd1; 
////									flag <= q; 
////							end
////					6'd28: begin  
////									u1 <= u0;//guarda o u0 dde antes, nao de agora <- tava errado. agora guarda certo
////									e1 <= e0; 
////									
////									r <= r + 1'd1; 
////							end
////				  //estado inicial de idle
////				  6'd29: begin 
////								if (flag == q) begin 
//////									aclear = 1'd1;
//////									clk_enn = 1'd0;
////									r <= 6'd29;
////								end
////								else begin 
//////									aclear = 1'd0;
//////									clk_enn = 1'd1;
////									r <= 6'd0;
////								end	
////							end
////				default: begin r <= r + 1'd1; end
////			endcase	

		end
	end

	
	

endmodule












//
////Assim que tiver o resultado do ADC, a ação de controle tem um atraso de 29 - 30 pulsos de colk base
//// Entrada em double e Saída tmb
//
//module compensadorPF 
//	(
//		input	            clk_50, iRST, e0ready,
//	   input      [63:0] e0, //tendo como 3.3 V equivalendo a 20 V e ADCbits = 4095d, essa entrada deve ser 20/4095
//		
//		//tustin a 125k FP	
//		input [63:0] B0, //1.413477707006369e-05,      // s^50 = 1.1259e15
//						 B1, //1.884636942675158e-06,
//						 B2, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
//						 A1, //1.974522292993631,      //199356913183280 E14 
//						 A2, //-0.974522292993631;     
//
//		
//		output signed [26:0] D,
//		output reg [5:0] r //gerenciador da maquina de estados
//	);
//	reg  [63:0] u1, u2, u0; 
//	reg  [63:0] e1, e2;
//	//reg         aclear, clk_enn;
//	wire [63:0] soma, prod;
//	
////tustin a 500k	
////	wire [63:0] B0 = $signed(338939228295820)  //3.38939228295820e-06,      // s^50 = 1.1259e15
////			  	   B1 = $signed(118926045016077)  //1.18926045016077e-07,
////			      B2 = $signed(-327046623794212) //-3.27046623794212e-06, //0.00000327046623794212 = 327046623794212E-20
////			      A1 = $signed(199356913183280)  //1.99356913183280,      //199356913183280 E14 
////			      A2 = $signed(-993569131832798) //-0.993569131832798;
//
//
////					//tustin a 125k IINTEGRADOR	
////	wire [63:0] B0 = 64'h3F14F8B588E368F1, //1.413477707006369e-05,      // s^50 = 1.1259e15
////			  	   B1 = 64'h3F14F8B588E368F1, //1.884636942675158e-06,
////			      B2 = 64'd0, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
////			      A1 = 64'h3FF0000000000000, //1.974522292993631,      //199356913183280 E14 
////			      A2 = 64'd0; //-0.974522292993631;     
//
////teste
////	wire [63:0] B0 = {1'b0,11'b01111111111,52'd0},
////   		  	   B1 = {1'b0,11'b01111111111,52'd0},
////			      B2 = {1'b0,11'b01111111111,52'd0},
////			      A1 = {1'b0,11'b01111111111,52'd0},
////			      A2 = {1'b0,11'b01111111111,52'd0};
//					
//	reg [63:0] Au1, Au2, Be0, Be1, Be2, Au12, Be01, Au12Be2;//, sfinal;
//	
//	reg  [2:0] sel_prod;
//	reg [63:0] mux_coef;	
//	reg [63:0] mux_signal;
//	
//	reg  [1:0] sel_mis;
//	reg [63:0] mux_insumA;
//	reg [63:0] mux_insumB;
//	
//	reg flag;
//	
//	reg q;//apenas serve para a cada amostra fazer um processo de soma
//	wire [63:0]produ0;
//	
//	initial begin
////		aclear <= 1'd1; 
////		clk_enn <= 1'd0;
////		r <= 6'd29; //gerenciador da maquina de estados
//		r <= 6'd52;
//		flag <= 1'd0;
//		q <= 1'd0;//apenas serve para a cada amostra fazer um processo de soma
//		u0 <= 64'd0;
//		u1 <= 64'd0;
//		u2 <= 64'd0;
//		e1 <= 64'd0;
//		e2 <= 64'd0;
//		Au1 <= 64'd0; Au2<= 64'd0; Be0<= 64'd0; Be1<= 64'd0; Be2<= 64'd0; Au12<= 64'd0; Be01<= 64'd0; Au12Be2<= 64'd0;
//		sel_prod <= 3'd0;
//		mux_coef <= 64'd0;	
//		mux_signal <= 64'd0;
//		sel_mis <= 2'd0;
//		mux_insumA <= 64'd0;
//		mux_insumB <= 64'd0;
//	end
//				
//	addFP   add1(
//					 .aclr(1'd0),
//					 .add_sub(1'd1),
//					 .clk_en(1'd1),
//					 .clock(clk_50),
//					 .dataa(mux_insumA),
//					 .datab(mux_insumB),
//					 //.nan,
//					 //.overflow,
//					 .result(soma)
//					 //.underflow,
//					 //.zero
//					 );//delay 7
//	multFP mult1(
//	             .aclr(1'd0),
//	             .clk_en(1'd1),
//	             .clock(clk_50),
//	             .dataa(mux_coef),
//	             .datab(mux_signal),
//	             //.nan,
//	             //.overflow,
//	             .result(prod)
//	             //.underflow,
//	             //.zero
//					 );//delay 5
//					 
//					//mult do D 
//	multFP mult2(
//	             .aclr(1'd0),
//	             .clk_en(1'd1),
//	             .clock(clk_50),
//	             .dataa(u0),
//	             .datab(64'h40C3880000000000),//10000
//	             //.nan,
//	             //.overflow,
//	             .result(produ0)
//	             //.underflow,
//	             //.zero
//					 );//delay 5
//	//u0prod to D				 
//	FP2int Fi(//delay 6
//				.aclr(1'd0),
//				.clk_en(1'd1),
//				.clock(clk_50),
//				.dataa(produ0),
//				//.nan,
//				//.overflow,
//				.result(D)
//				//.underflow);
//				);
//	//mux_signal-------------------------------------
//	always @(*) begin
//		case(sel_prod)
//			3'd0: begin mux_signal <= u1; mux_coef <= A1; end
//			3'd1: begin mux_signal <= u2; mux_coef <= A2; end
//			3'd2: begin mux_signal <= e0; mux_coef <= B0; end
//			3'd3: begin mux_signal <= e1; mux_coef <= B1; end
//			3'd4: begin mux_signal <= e2; mux_coef <= B2; end
//			default: begin mux_signal <= 64'd0; mux_coef <= 64'd0; end
//		endcase
//	end
//	//mux_signal-------------------------------------
//	
//
////valores fixos
//	//mux_signal-------------------------------------
////	always @(*) begin
////		case(sel_prod)
////			3'd0: begin mux_signal <= 64'h3FB47AE147AE147B; mux_coef <= 64'h3FF0000000000000; end
////			3'd1: begin mux_signal <= 64'h3FB70A3D70A3D70A; mux_coef <= 64'h3FF0000000000000; end
////			3'd2: begin mux_signal <= 64'h3FB999999999999A; mux_coef <= 64'h3FF0000000000000; end
////			3'd3: begin mux_signal <= 64'h3FC999999999999A; mux_coef <= 64'h3FF0000000000000; end
////			3'd4: begin mux_signal <= 64'h3FD3333333333333; mux_coef <= 64'h3FF0000000000000; end
////			default: begin mux_signal <= 64'd0; mux_coef <= 64'h3FF0000000000000; end
////		endcase
////	end
//	
//	//valores fixos negativo incluso
//	//mux_signal-------------------------------------
////	always @(*) begin
////		case(sel_prod)
////			3'd0: begin mux_signal <= 64'h3FD0A3D70A3D70A4; mux_coef <= 64'h3FF0000000000000; end
////			3'd1: begin mux_signal <= 64'h3FB70A3D70A3D70A; mux_coef <= 64'hBFF0000000000000; end
////			3'd2: begin mux_signal <= 64'h3FB999999999999A; mux_coef <= 64'h3FF0000000000000; end
////			3'd3: begin mux_signal <= 64'h3FE999999999999A; mux_coef <= 64'h3FF0000000000000; end
////			3'd4: begin mux_signal <= 64'h3FD3333333333333; mux_coef <= 64'hBFF0000000000000; end
////			default: begin mux_signal <= 64'd0; mux_coef <= 64'd0; end
////		endcase
////	end
//	
////	reg [2:0] sel_X = 3'd0,
////	reg [63:0] X1 = 64'd0, X2 = 64'd0, X3 = 64'd0, X4 = 64'd0, X5 = 64'd0;
////	//mux_signal-------------------------------------
////	always @(*) begin
////		case(sel_X)
////			3'd0: begin X1 <= 64'h3FB47AE147AE147B; X2 <= 64'h3FB70A3D70A3D70A; X3 <= 64'h3FB999999999999A; X4 <= 64'h3FC999999999999A; X5 <= 64'h3FD3333333333333; end
////			3'd1: begin X5 <= 64'h3FB47AE147AE147B; X1 <= 64'h3FB70A3D70A3D70A; X2 <= 64'h3FB999999999999A; X3 <= 64'h3FC999999999999A; X4 <= 64'h3FD3333333333333; end
////			3'd2: begin X4 <= 64'h3FB47AE147AE147B; X5 <= 64'h3FB70A3D70A3D70A; X1 <= 64'h3FB999999999999A; X2 <= 64'h3FC999999999999A; X3 <= 64'h3FD3333333333333; end
////			3'd3: begin X3 <= 64'h3FB47AE147AE147B; X4 <= 64'h3FB70A3D70A3D70A; X5 <= 64'h3FB999999999999A; X1 <= 64'h3FC999999999999A; X2 <= 64'h3FD3333333333333; end
////			3'd4: begin X2 <= 64'h3FB47AE147AE147B; X3 <= 64'h3FB70A3D70A3D70A; X4 <= 64'h3FB999999999999A; X5 <= 64'h3FC999999999999A; X1 <= 64'h3FD3333333333333; end
////			default: begin X1 <= 64'd0; X2 <= 64'd0; X3 <= 64'd0; X4 <= 64'd0; X5 <= 64'd0; end
////		endcase
////	end
////	//valores fixos
////	//mux_signal-------------------------------------
////	always @(*) begin
////		case(sel_prod)
////			3'd0: begin mux_signal <= X1; mux_coef <= 64'h3EEDA48CF7D36861; end
////			3'd1: begin mux_signal <= X2; mux_coef <= 64'h3EBF9E743B8C2B0F; end
////			3'd2: begin mux_signal <= X3; mux_coef <= 64'hBEE9B0BE7061E2FE; end
////			3'd3: begin mux_signal <= X4; mux_coef <= 64'h3FFF97A4B01A16D6; end
////			3'd4: begin mux_signal <= X5; mux_coef <= 64'hBFEF2F4960342DAC; end
////			default: begin mux_signal <= 64'd0; mux_coef <= 64'h3FF0000000000000; end
////		endcase
////	end
////	//mux_signal-------------------------------------
////=============================================================================	
////	//old
////	//mux_insum--------------------------------------	
////	always @(*) begin
////		case(sel_mis)
////			2'd0: begin mux_insumA <=  Au1; mux_insumB <=     Au2; end
////			2'd1: begin mux_insumA <=  Be0; mux_insumB <=     Be1; end
////			2'd2: begin mux_insumA <= Au12; mux_insumB <=     Be2; end
////			2'd3: begin mux_insumA <= Be01; mux_insumB <= Au12Be2; end
////			default: begin mux_insumA <= 64'd0; mux_insumB <= 64'd0; end
////		endcase
////	end
////	//mux_insum--------------------------------------	
//	
//	//new
//	//mux_insum--------------------------------------	
//	always @(*) begin
//		case(sel_mis)
//			2'd0: begin mux_insumA <=  Au1; mux_insumB <=     Au2; end
//			2'd1: begin mux_insumA <= Au12; mux_insumB <=     Be0; end
//			2'd2: begin mux_insumA <= Au12; mux_insumB <=     Be1; end
//			2'd3: begin mux_insumA <= Au12; mux_insumB <=     Be2; end
//			default: begin mux_insumA <= 64'd0; mux_insumB <= 64'd0; end
//		endcase
//	end
//	//mux_insum--------------------------------------
//	
//	//Maquina de estados para realizar u0 <= A1*u1 + A2*u2 + B0*e0 + B1*$e1 + B2*e2; com multiplexaçao
//	always @(negedge clk_50 /*or posedge iRST*/) begin
//		if(iRST == 1'd1) begin
//			//aclear <= 1'd1; 
//			//clk_enn <= 1'd0;
//			r <= 6'd52; //gerenciador da maquina de estados
//			flag <= q;
//			u0 <= 64'd0;
//			u1 <= 64'd0;
//			u2 <= 64'd0;
//			e1 <= 64'd0;
//			e2 <= 64'd0;
//			Au1 <= 64'd0; Au2<= 64'd0; Be0<= 64'd0; Be1<= 64'd0; Be2<= 64'd0; Au12<= 64'd0; Be01<= 64'd0; Au12Be2<= 64'd0;
//			sel_prod <= 3'd0;
//			sel_mis <= 2'd0;
//		end
//		else begin 
//			//real new3
////			case(r)
////					 6'd0: begin                                					sel_prod <= 3'd0; r <= r + 1'd1; end
////					 6'd1: begin                    				  					sel_prod <= 3'd1; r <= r + 1'd1; end
////					 6'd5: begin Au1 <= prod;                   					                  r <= r + 1'd1; end
////					 6'd6: begin Au2 <= prod;               sel_mis <= 2'd0; sel_prod <= 3'd2; r <= r + 1'd1; end
////				   6'd13: begin Be0 <= prod; Au12 <= soma; sel_mis <= 2'd1; sel_prod <= 3'd3; r <= r + 1'd1; end
////		         6'd20: begin Be1 <= prod; Au12 <= soma; sel_mis <= 2'd2; sel_prod <= 3'd4; r <= r + 1'd1; end
////		         6'd27: begin Be2 <= prod; Au12 <= soma; sel_mis <= 2'd3;                   r <= r + 1'd1; end
////		
////					 6'd34: begin  
////									u0 <= soma;
////									u2 <= u1;
////									e2 <= e1;
////									
////									r <= r + 1'd1; 
////									flag <= q; 
////							end
////					6'd35: begin  
////									u1 <= u0;//guarda o u0 dde antes, nao de agora <- tava errado. agora guarda certo
////									e1 <= e0; 
////									
////									r <= r + 1'd1; 
////							end
////				  //estado inicial de idle
////				  6'd36: begin 
////								if (flag == q)  
////									r <= 6'd36;
////								else  
////									r <= 6'd0;
////							end
////				default: begin r <= r + 1'd1; end
////			endcase
//			//real new2.1
////			case(r)
////					6'd0: begin                               sel_prod <= 3'd0; r <= r + 1'd1;            end
////					6'd6: begin  Au1 <= prod;                 sel_prod <= 3'd1; r <= r + 1'd1;            end
////					6'd12: begin Au2 <= prod; sel_mis <= 2'd0;sel_prod <= 3'd2; r <= r + 1'd1;            end
////					6'd19: begin Be0 <= prod;                 sel_prod <= 3'd3; r <= r + 1'd1;           end
////					6'd20: begin Au12 <= soma;sel_mis <= 2'd1;                   r <= r + 1'd1;            end
////					6'd27: begin Be1 <= prod;                 sel_prod <= 3'd4; r <= r + 1'd1;            end
////				   6'd28: begin Au12 <= soma;sel_mis <= 2'd2;                   r <= r + 1'd1;             end
////					6'd35: begin Be2 <= prod;                                   r <= r + 1'd1;            end
////				   6'd36: begin Au12 <= soma;sel_mis <= 2'd3;                   r <= r + 1'd1;            end
////				  
////					 6'd42: begin  
////									u0 <= soma;
////									u2 <= u1;
////									e2 <= e1;
////									
////									r <= r + 1'd1; 
////									flag <= q; 
////							end
////					6'd43: begin  
////									u1 <= u0;//guarda o u0 dde antes, nao de agora <- tava errado. agora guarda certo
////									e1 <= e0; 
////									
////									r <= r + 1'd1; 
////							end
////				  //estado inicial de idle
////				  6'd44: begin 
////								if (flag == q)  
////									r <= 6'd44;
////								else  
////									r <= 6'd0;
////							end
////				default: begin r <= r + 1'd1; end
////			endcase
//			//real new2
//			case(r)
//					6'd0: begin                               sel_prod <= 3'd0; r <= r + 1'd1;            end
//					6'd7: begin  Au1 <= prod;                 sel_prod <= 3'd1; r <= r + 1'd1;            end
//					6'd14: begin Au2 <= prod; sel_mis <= 2'd0;sel_prod <= 3'd2; r <= r + 1'd1;            end
//					6'd21: begin Be0 <= prod;                 sel_prod <= 3'd3; r <= r + 1'd1;           end
//					6'd23: begin Au12 <= soma;sel_mis <= 2'd1;                   r <= r + 1'd1;            end
//					6'd28: begin Be1 <= prod;                 sel_prod <= 3'd4; r <= r + 1'd1;            end
//				   6'd32: begin Au12 <= soma;sel_mis <= 2'd2;                   r <= r + 1'd1;             end
//					6'd35: begin Be2 <= prod;                                   r <= r + 1'd1;            end
//				   6'd41: begin Au12 <= soma;sel_mis <= 2'd3;                   r <= r + 1'd1;            end
//				  
//					 6'd50: begin  
//									u0 <= soma;
//									u2 <= u1;
//									e2 <= e1;
//									
//									r <= r + 1'd1; 
//									flag <= q; 
//							end
//					6'd51: begin  
//									e1 <= e0; 
//									
//									//teste de saturação FP
//									if (u0[63] == 1'd0)
//										if (u0[62:52] > 11'b01111111111)//se >1,99999
//											u0 <= 64'h3FF0000000000000;
//										else
//											u0 <= u0;
//									else
//										u0 <= 64'd0;
//									
//									r <= r + 1'd1; 
//							end
//				  //estado inicial de idle
//				  6'd52: begin 
//								u1 <= u0;//guarda o u0 dde antes, nao de agora <- tava errado. agora guarda certo
//								if (flag == q)  
//									r <= 6'd52;
//								else  
//									r <= 6'd0;
//							end
//				default: begin r <= r + 1'd1; end
//			endcase
//			//fast
////			case(r)
////					6'd0: begin                 sel_prod <= 3'd0; r <= r + 1'd1;            end
////					6'd1: begin                 sel_prod <= 3'd1; r <= r + 1'd1;            end
////					6'd2: begin                 sel_prod <= 3'd2; r <= r + 1'd1;            end
////					6'd3: begin                 sel_prod <= 3'd3; r <= r + 1'd1;            end
////					6'd4: begin                 sel_prod <= 3'd4; r <= r + 1'd1;            end
////					6'd5: begin 					      Au1 <= prod; r <= r + 1'd1;            end
////					6'd6: begin sel_mis <= 2'd0;     Au2 <= prod; r <= r + 1'd1;            end
////					6'd7: begin                      Be0 <= prod; r <= r + 1'd1;            end
////					6'd8: begin sel_mis <= 2'd1;     Be1 <= prod; r <= r + 1'd1;            end
////					6'd9: begin                      Be2 <= prod; r <= r + 1'd1;            end
////				  6'd13: begin sel_mis <= 2'd2;    Au12 <= soma; r <= r + 1'd1;            end
////				  6'd15: begin                     Be01 <= soma; r <= r + 1'd1;            end
////				  6'd20: begin sel_mis <= 2'd3; Au12Be2 <= soma; r <= r + 1'd1;            end
////				  6'd27: begin  
////									u0 <= soma;
////									u2 <= u1;
////									e2 <= e1;
////									
////									r <= r + 1'd1; 
////									flag <= q; 
////							end
////					6'd28: begin  
////									u1 <= u0;//guarda o u0 dde antes, nao de agora <- tava errado. agora guarda certo
////									e1 <= e0; 
////									
////									r <= r + 1'd1; 
////							end
////				  //estado inicial de idle
////				  6'd29: begin 
////								if (flag == q) begin 
//////									aclear = 1'd1;
//////									clk_enn = 1'd0;
////									r <= 6'd29;
////								end
////								else begin 
//////									aclear = 1'd0;
//////									clk_enn = 1'd1;
////									r <= 6'd0;
////								end	
////							end
////				default: begin r <= r + 1'd1; end
////			endcase	
//			//slow
////			case(r)
////					6'd0: begin                 sel_prod <= 3'd0; r <= r + 1'd1; end
////					6'd1: begin                 sel_prod <= 3'd0; r <= r + 1'd1; end
////					
////					6'd2: begin                 sel_prod <= 3'd1; r <= r + 1'd1; end
////					6'd3: begin                 sel_prod <= 3'd1; r <= r + 1'd1; end
////					
////					6'd4: begin                 sel_prod <= 3'd2; r <= r + 1'd1; end
////					6'd5: begin                 sel_prod <= 3'd2; r <= r + 1'd1; end
////					
////					6'd6: begin  Au1 <= prod;   sel_prod <= 3'd3; r <= r + 1'd1; end
////					6'd7: begin                 sel_prod <= 3'd3; r <= r + 1'd1; end
////					
////					6'd8: begin  Au2 <= prod;  sel_mis <= 2'd0; sel_prod <= 3'd4; r <= r + 1'd1; end
////					6'd9: begin                sel_mis <= 2'd0; sel_prod <= 3'd4; r <= r + 1'd1; end
////					
////					  6'd10: begin Be0 <= prod;                     r <= r + 1'd1; end
////					  6'd12: begin Be1 <= prod;    sel_mis <= 2'd1; r <= r + 1'd1; end
////					  6'd13: begin                 sel_mis <= 2'd1; r <= r + 1'd1; end
////					  6'd14: begin Be2 <= prod;                     r <= r + 1'd1; end
////					  6'd16: begin Au12 <= soma; sel_mis <= 2'd2; r <= r + 1'd1; end
////					  6'd17: begin               sel_mis <= 2'd2; r <= r + 1'd1; end
////					  6'd20: begin Be01 <= soma;                  r <= r + 1'd1; end
////					  6'd24: begin Au12Be2 <= soma; sel_mis <= 2'd3; r <= r + 1'd1; end
////					  6'd25: begin                  sel_mis <= 2'd3; r <= r + 1'd1; end
////				  6'd31: begin  
////									u0 <= soma;
////									u2 <= u1;
////									e2 <= e1;
////									
////									r <= r + 1'd1; 
////									flag <= q; 
////							end
////							6'd32: begin  
////									u1 <= u0;//guarda o u0 dde antes, nao de agora <- tava errado. agora guarda certo
////									
////									e1 <= e0; 
////									
////									r <= r + 1'd1; 
////									flag <= q; 
////							end
////				  //estado inicial de idle
////				  6'd33: begin 
////								if (flag == q) begin 
////									aclear = 1'd1;
////									clk_enn = 1'd0;
////									r <= 6'd33;
////								end
////								else begin 
////									aclear = 1'd0;
////									clk_enn = 1'd1;
////									r <= 6'd0;
////								end	
////							end
////				default: begin r <= r + 1'd1; end
////			endcase	
//		end
//	end
//					
//	//assign u0 = A1*u1 + A2*u2 + B0*e0 + B1*e1 + B2*e2;
//	//Amostragem
//	always @(posedge e0ready) begin
//		//q serve para flag da operaçao
////		if (sel_X < 3'd4)
////			sel_X <= sel_X + 1'd1;
////		else
////			sel_X <= 3'd0;
//		case(q)
//			   1'd0: begin q <= 1'd1; end
//			   1'd1: begin q <= 1'd0; end
//			default:       q <= 1'd0;
//		endcase
//	end
//	
//	
//
//endmodule
