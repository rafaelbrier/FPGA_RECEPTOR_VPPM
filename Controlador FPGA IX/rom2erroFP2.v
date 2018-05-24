module rom2erroFP2
(
	input              clk, clk_Fs,
	input 		[63:0] vref,
	output reg         Rst,
	output      [63:0] e0, 
//	output reg [63:0] e0teste,
	output reg         e0ready,
	
	output wire [11:0] dataROM,
	output reg  [9:0] add///////////////////////
); 
	wire [63:0] prod;
	//wire signed [26:0] D;
	reg          [4:0] r;
	wire [63:0] dataROMFP;
	
	initial begin
		 add <= 10'd0;/////////////////////
		 r <= 5'd0;
		 e0ready <= 1'd0;
//		 e0teste <= 64'h402E000000000000;
		 Rst <= 1'd0;
	end
	
	
	rom7500x12 rom1(~clk, add, dataROM);
	int2FP       s1(1'd0, 1'd1, clk, {1'b0,dataROM}, dataROMFP);
	multFP multt(
	             .aclr(1'd0),
	             .clk_en(1'd1),
	             .clock(clk),
	             .dataa(dataROMFP),
	             .datab(64'h3F7401401401409A),//20/4095 em FP
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
	
	//assign dataa = $signed({1'd0,vref[11:0]}) - $signed({1'd0,dataROM});
	
	always @(posedge clk_Fs) begin
		if(add == 10'd1023) begin////////////
			add <= 10'd0;/////////////		
			Rst <= 1'd1;
		end
		else begin
			add <= add + 10'd1;////////////////////////
			Rst <= 1'd0;
		end
			
//		if (add >= 10'd370)//-------------------------
//			e0teste <= 64'd0;
//		else
//			e0teste <= 64'h402E000000000000;
	end
	//maquina de estados para enviar para o proximo bloco
	always @(posedge clk) begin
		case(r)	
				5'd0:	begin e0ready <= 1'd0; if (clk_Fs == 1'd1)  r <= r + 5'd1; else r <= 5'd0; end
			  //5'd18:	begin e0ready <= 1'd1;                                      r <= r + 5'd1; end
			  5'd25:	begin e0ready <= 1'd1;                                      r <= r + 5'd1; end
			  5'd26: begin e0ready <= 1'd0; if (clk_Fs == 1'd1)  r <= r;        else r <= 5'd0; end
			default: begin e0ready <= e0ready;                                   r <= r + 5'd1; end
		endcase
	end

endmodule
	