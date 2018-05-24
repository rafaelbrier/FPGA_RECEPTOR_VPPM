module rom2erroFP
(

	input             clk, clk_Fs,
	output     [63:0] e0,
	output reg        e0ready,
	output wire signed [12:0] dataa
	
//	output reg  [10:0] add,
//	output reg  [16:0] vref,
//	output wire [11:0] dataROM,
//	output wire signed [12:0] dataa,
//	output reg   [3:0] r
);
	reg         [10:0] add;////////////////////
	reg         [16:0] vref;
	wire        [11:0] dataROM;
//	wire signed [12:0] dataa;
	reg          [3:0] r;

	initial begin
		 add <= 11'd2047;/////////////////////
		 vref <= (12'd4095*5'd15)/5'd20;
		 r <= 4'd0;
		 e0ready <= 1'd0;
	end
	
	
	rom7500x12 rom1(~clk, add, dataROM);
	int2FP       s1(1'd0, 1'd1, clk, dataa, e0);
	
	assign dataa = $signed({1'd0,vref[11:0]}) - $signed({1'd0,dataROM});
	
	always @(posedge clk_Fs) begin
		add <= add + 11'd1;////////////////////////
	end
	//maquina de estados
	always @(posedge clk) begin
		case(r)	
		   4'd0: begin e0ready <= 1'd0; if (clk_Fs == 1'd1)  r <= r + 4'd1; else r <= 4'd0; end
			4'd6: begin e0ready <= 1'd1; r <= r + 4'd1; end
			4'd8: begin e0ready <= 1'd0; if (clk_Fs == 1'd1)  r <= r; else r <= 4'd0; end
			default begin e0ready <= e0ready; r <= r + 4'd1; end
		endcase
	end

endmodule
	