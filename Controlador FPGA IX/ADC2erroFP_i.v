module ADC2erroFP_i
(
	input                clk, clkFs,//clkFs é clkFs, mas pode ser o clk de amostragem tmb
	input         [11:0] ADC,
	output signed [29:0] corrente,
	input 		  [63:0] vref,
	output        [63:0] e0, 
	output reg           e0ready,
	output [11:0] ADC_filtro
	
); 
	
		
	wire        [63:0] prod, dataADCFP;
	wire signed [12:0] ADCoff;
	reg          [4:0] r;
	
	//registradores filtro
	reg [11:0] x9, x8, x7, x6, x5, x4, x3, x2, x1, x0; 
	reg [24:0] ADC_mean;
	reg MEANready;
	reg [2:0] q;
	
	wire [63:0] gain = 64'h3F5A47A9E2BCF91A;//gain = Vref / 4095 / V/A, V/A = 0,14 , Vref = 3,236V // 3436 para 400ma
	wire signed [12:0] offset = 13'd3210; // offset = offset(ana)*4095/Vref. offset(ana) = 2,55 , Vref = 3,236
	//3216
	assign ADCoff = $signed({1'b0,ADC_mean[11:0]}) - offset;
	// ver o decimal da corrent
	assign corrente = ADCoff * $signed(15'd1604); //*1e-6 //esse numero é o mesmo que tem q estar no mult fp , com 1e-6
	//1630
	assign ADC_filtro = ADC_mean[11:0];
	
	
	initial begin
		 r <= 5'd0;
		 e0ready <= 1'd0;
		 
		 //filtro
		 q <= 3'd0;
		 MEANready <= 1'd0;
		 ADC_mean <= 25'd0;
		 x9 <= 12'd0;
		 x8 <= 12'd0;
		 x7 <= 12'd0;
		 x6 <= 12'd0;
		 x5 <= 12'd0;
		 x4 <= 12'd0;
		 x3 <= 12'd0;
		 x2 <= 12'd0;
		 x1 <= 12'd0;
		 x0 <= 12'd0;
	end
	
	//maquina estados filtro media movel
	always @(posedge clk) begin
		case(q)
			3'd0: begin if (clkFs == 1'd1) begin
								x0 <= ADC; 
								MEANready <= 1'd0;
							   q <= q + 1'd1;
						  end
				  end
			3'd1: begin ADC_mean <= x9 +x8 
										 +x7 +x6 
										 +x5 +x4 
										 +x3 +x2 
										 +x1 +x0; 
										 
						  q <= q + 1'd1;
				  end
		  3'd2: begin 
						  ADC_mean <= ADC_mean/4'd10;
						  x9 <= x8;
						  x8 <= x7;
						  x7 <= x6;
						  x6 <= x5;
						  x5 <= x4;
						  x4 <= x3;
						  x3 <= x2;
						  x2 <= x1;
						  x1 <= x0;
						  q <= q + 1'd1;
				  end 
			3'd3: begin
						MEANready <= 1'd1;
						q <= q + 1'd1;
				  end
			3'd4: begin
						if (clkFs == 1'd1)  q <= q;        
						else q <= 3'd0;
				  end
			default:  q <= q + 1'd1;
		 endcase
	end
		
	
	
	int2FP       s1(1'd0, 1'd1, clk, ADCoff, dataADCFP);
	multFP multt(
	             .aclr(1'd0),
	             .clk_en(1'd1),
	             .clock(clk),
	             .dataa(dataADCFP),
	             .datab(gain),
	             //.nan,
	             //.overflow,
	             .result(prod)
	             //.underflow,
	             //.zero
					 );//delay 5
					 
	 addFP   subb(
					 .aclr(1'd0),
					 .add_sub(1'd0),
					 .clk_en(1'd1),
					 .clock(clk),     //64'd4624633179993497791 -> 14,998
					 .dataa(vref),//({1'b0, 11'b10000000010, 52'b1110000000000000000000000000000000000000000000000000}),//15 em FP(12'd4095*5'd15)/5'd20;
					 .datab(prod),
					 //.nan,
					 //.overflow,
					 .result(e0)
					 //.underflow,
					 //.zero
					 );//delay 7
	
	
	//maquina de estados para enviar para o proximo bloco
	always @(posedge clk) begin
		case(r)	
				5'd0:	begin e0ready <= 1'd0; if (MEANready == 1'd1)  r <= r + 5'd1; else r <= 5'd0; end
			  5'd25:	begin e0ready <= 1'd1;                                      r <= r + 5'd1; end
			  5'd27: begin e0ready <= 1'd0; if (MEANready == 1'd1)  r <= r;        else r <= 5'd0; end
			default: begin e0ready <= e0ready;                                   r <= r + 5'd1; end
		endcase
	end

endmodule
	