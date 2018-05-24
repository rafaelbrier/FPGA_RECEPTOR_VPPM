module PWM_clk_PLL2 (input clk_50, output PWMout);

	wire [7:0] c;
	wire cx1, cx2; 
	reg cx3;
	reg [2:0] sel_c;
	reg  PWM_clk;
	
	initial begin
		PWM_clk <= 1'd0;
		sel_c <= 3'd0;
	end
	
	PLLbase   Pb (clk_50, c[0], c[1], c[2], c[3]);
	PLLbase2  Pb2(clk_50, c[4], c[5], c[6], c[7]);
//	ctrlblk  cb41(sel_c[1:0], c[0], c[4], c[1], c[5], cx1);
//	ctrlblk  cb42(sel_c[1:0], c[2], c[6], c[3], c[7], cx2);
//	//ctrlblk2  cb2(sel_c[2], cx1, cx2, cx3);
//	
//	always @(*) begin
//		case (sel_c[2])
//			1'd0: cx3 <= cx1;
//			1'd1: cx3 <= cx2;
//		endcase
//	end
	
	PWM p111(	
		 PWM_clk, 1'd0,//reseta em alto e na verdade o clear é sincrono com clk base
		  26'd1598, 26'd5000, 26'd0,//relacioando ao tempo, duty cycle e atraso
		PWMout//onda PWM_clk
		
//		output reg [25:0] cnt, //divisao
//		output reg [25:0] cnt0, //contador de atraso inicial
//		output reg flag_cnt0//flag para delay
	);
	
	always @(*) begin
		case (sel_c)
			3'd0: cx3 <= c[0];
			3'd1: cx3 <= c[4];
			3'd2: cx3 <= c[1];
			3'd3: cx3 <= c[5];
			3'd4: cx3 <= c[2];
			3'd5: cx3 <= c[6];
			3'd6: cx3 <= c[3];
			3'd7: cx3 <= c[7];
		endcase
	end

	always @(posedge cx3) begin
		sel_c <= sel_c + 1'd1;
		if (PWM_clk == 0)
			PWM_clk <= 1;
		else
			PWM_clk <= 0;
	end
	
	
	
endmodule
