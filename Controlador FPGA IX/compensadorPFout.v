//Assim que tiver o resultado do ADC, a ação de controle tem um atraso de 29 - 30 pulsos de colk base
// Entrada em double e Saída tmb

module compensadorPFout
	(
		input	               clk_50, iRST, e0ready,
		input         [63:0] e0, //tendo como 3.3 V equivalendo a 20 V e ADCbits = 4095d, essa entrada deve ser 20/4095
		output reg    [63:0] u0,
		output signed [26:0] D,
		
	output reg  [63:0] u1, u2, 
	output reg  [63:0] e1, e2,
	
	output reg [63:0] Au1, Au2, Be0, Be1, Be2, Au12, Be01, Au12Be2//, sfinal;
	
	);
	
	reg         aclear, clk_enn;
	wire [63:0] soma, prod;
	
//tustin a 500k	
//	wire [63:0] B0 = $signed(338939228295820)  //3.38939228295820e-06,      // s^50 = 1.1259e15
//			  	   B1 = $signed(118926045016077)  //1.18926045016077e-07,
//			      B2 = $signed(-327046623794212) //-3.27046623794212e-06, //0.00000327046623794212 = 327046623794212E-20
//			      A1 = $signed(199356913183280)  //1.99356913183280,      //199356913183280 E14 
//			      A2 = $signed(-993569131832798) //-0.993569131832798;

//tustin a 125k FP	
//	wire [63:0] B0 = 64'h3EEDA48CF7D36861, //1.413477707006369e-05,      // s^50 = 1.1259e15
//			  	   B1 = 64'h3EBF9E743B8C2B0F, //1.884636942675158e-06,
//			      B2 = 64'hBEE9B0BE7061E2FE, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
//			      A1 = 64'h3FFF97A4B01A16D6, //1.974522292993631,      //199356913183280 E14 
//			      A2 = 64'hBFEF2F4960342DAC; //-0.974522292993631;     

					//tustin a 125k FP binario	
	wire [63:0] B0 = 64'b0011111011101101101001001000110011110111110100110110100000000000, //1.413477707006369e-05,      // s^50 = 1.1259e15
			  	   B1 = 64'b0011111010111111100111100111010000111011100011000010110000000000, //1.884636942675158e-06,
			      B2 = 64'b1011111011101001101100001011111001110000011000011110000000000000, //-1.225014012738853e-05, //0.00000327046623794212 = 327046623794212E-20
			      A1 = 64'b0011111111111111100101111010010010110000000110100001011000000000, //1.974522292993631,      //199356913183280 E14 
			      A2 = 64'b1011111111101111001011110100100101100000001101000011000000000000; //-0.974522292993631;     

//teste
//	wire [63:0] B0 = {1'b0,11'b01111111111,52'd0},
//   		  	   B1 = {1'b0,11'b01111111111,52'd0},
//			      B2 = {1'b0,11'b01111111111,52'd0},
//			      A1 = {1'b0,11'b01111111111,52'd0},
//			      A2 = {1'b0,11'b01111111111,52'd0};
					
	
	reg  [2:0] sel_prod;
	reg [63:0] mux_coef;	
	reg [63:0] mux_signal;
	
	reg  [1:0] sel_mis;
	reg [63:0] mux_insumA;
	reg [63:0] mux_insumB;
	
	reg [4:0] r; //gerenciador da maquina de estados
	reg flag;
	
	reg q;//apenas serve para a cada amostra fazer um processo de soma
	wire [63:0]produ0;
	
	initial begin
		aclear <= 1'd1; 
		clk_enn <= 1'd0;
		r <= 5'd28; //gerenciador da maquina de estados
		flag <= 1'd0;
		q <= 1'd0;//apenas serve para a cada amostra fazer um processo de soma
		u0 <= 64'd0;
		u1 <= 64'd0;
		u2 <= 64'd0;
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
					 .aclr(aclear),
					 .add_sub(1'd1),
					 .clk_en(clk_enn),
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
	             .aclr(aclear),
	             .clk_en(clk_enn),
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
	             .dataa(u0),
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
	
	//mux_insum--------------------------------------	
	always @(*) begin
		case(sel_mis)
			2'd0: begin mux_insumA <=  Au1; mux_insumB <=     Au2; end
			2'd1: begin mux_insumA <=  Be0; mux_insumB <=     Be1; end
			2'd2: begin mux_insumA <= Au12; mux_insumB <=     Be2; end
			2'd3: begin mux_insumA <= Be01; mux_insumB <= Au12Be2; end
			default: begin mux_insumA <= 64'd0; mux_insumB <= 64'd0; end
		endcase
	end
	//mux_insum--------------------------------------	
	
	//Maquina de estados para realizar u0 <= A1*u1 + A2*u2 + B0*e0 + B1*$e1 + B2*e2; com multiplexaçao
	always @(negedge clk_50 /*or negedge iRST*/) begin
//		if(~iRST) begin
//			aclear <= 1'd1; 
//			clk_enn <= 1'd0;
//			r <= 5'd28; //gerenciador da maquina de estados
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
			case(r)
					5'd0: begin                 sel_prod <= 3'd0; r <= r + 1'd1;            end
					5'd1: begin                 sel_prod <= 3'd1; r <= r + 1'd1;            end
					5'd2: begin                 sel_prod <= 3'd2; r <= r + 1'd1;            end
					5'd3: begin                 sel_prod <= 3'd3; r <= r + 1'd1;            end
					5'd4: begin                 sel_prod <= 3'd4; r <= r + 1'd1;            end
					5'd5: begin 					      Au1 <= prod; r <= r + 1'd1;            end
					5'd6: begin sel_mis <= 2'd0;     Au2 <= prod; r <= r + 1'd1;            end
					5'd7: begin                      Be0 <= prod; r <= r + 1'd1;            end
					5'd8: begin sel_mis <= 2'd1;     Be1 <= prod; r <= r + 1'd1;            end
					5'd9: begin                      Be2 <= prod; r <= r + 1'd1;            end
				  5'd13: begin sel_mis <= 2'd2;    Au12 <= soma; r <= r + 1'd1;            end
				  5'd15: begin                     Be01 <= soma; r <= r + 1'd1;            end
				  5'd20: begin sel_mis <= 2'd3; Au12Be2 <= soma; r <= r + 1'd1;            end
				  5'd27: begin  
									u0 <= soma;
									u2 <= u1;
									u1 <= soma;//guarda o u0 dde antes, nao de agora <- DEU MERDA, arrumado agora
									e2 <= e1;
									e1 <= e0; 
									
									r <= r + 1'd1; 
									flag <= q; 
							end
				  //estado inicial de idle
				  5'd28: begin 
								if (flag == q) begin 
									aclear = 1'd1;
									clk_enn = 1'd0;
									r <= 5'd28;
								end
								else begin 
									aclear = 1'd0;
									clk_enn = 1'd1;
									r <= 5'd0;
								end	
							end
				default: begin r <= r + 1'd1; end
			endcase	
		//end
	end
					
	//assign u0 = A1*u1 + A2*u2 + B0*e0 + B1*e1 + B2*e2;
	//Amostragem
	always @(posedge e0ready) begin
		//q serve para flag da operaçao
		case(q)
			   1'd0: begin q <= 1'd1; end
			   1'd1: begin q <= 1'd0; end
			default:       q <= 1'd0;
		endcase
	end
	
	

endmodule
