module ADC2erroFP_control2
(
	input              clk, clk_Fs,//clkFs é adcready
	input       [11:0] ADC,
	input 		[63:0] vref,
	output      [63:0] e0, 
	output reg         e0ready
	
); 
	wire [63:0] prod, dataADCFP;
	reg          [4:0] r;
	
	initial begin
		 r <= 5'd0;
		 e0ready <= 1'd0;
	end
	
	int2FP       s1(1'd0, 1'd1, clk, {1'b0,ADC}, dataADCFP);
	
					 
	 addFP   subb(
					 .aclr(1'd0),
					 .add_sub(1'd0),
					 .clk_en(1'd1),
					 .clock(clk),     //64'd4624633179993497791 -> 14,998
					 .dataa(vref), // vref deve ser vref * 4095/3,3 em double
					 .datab(dataADCFP),
					 //.nan,
					 //.overflow,
					 .result(e0)
					 //.underflow,
					 //.zero
					 );//delay 7
	
	
	//maquina de estados para enviar para o proximo bloco
	always @(posedge clk) begin
		case(r)	
				5'd0:	begin e0ready <= 1'd0; if (clk_Fs == 1'd1)  r <= r + 5'd1; else r <= 5'd0; end
			  //5'd18:	begin e0ready <= 1'd1;                                      r <= r + 5'd1; end
			  5'd20:	begin e0ready <= 1'd1;                                      r <= r + 5'd1; end
			  5'd21: begin e0ready <= 1'd0; if (clk_Fs == 1'd1)  r <= r;        else r <= 5'd0; end
			default: begin e0ready <= e0ready;                                   r <= r + 5'd1; end
		endcase
	end

endmodule
	