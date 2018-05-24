//TIRAR O REGISTRO DO NON PARA TER MAIS EFICIENCIA
module PWM

	(	
		input clk, sclear,//reseta em alto e na verdade o clear é sincrono com clk base
		input  [25:0] N, D, delay,//relacioando ao tempo, duty cycle e atraso
		output reg q//onda pwm
		
//		output reg [25:0] cnt, //divisao
//		output reg [25:0] cnt0, //contador de atraso inicial
//		output reg flag_cnt0//flag para delay
	);
	// N nao precisa mais ser apenas par
	//f = 200M/(N+2) N qq coisa
	
	//calculos para arredondamento
	wire [54:0] Non1 = D*(N+26'd2); 
	wire [54:0] Non2 = Non1/14'd10000;//sem arredondar
	wire [54:0] Non3 = Non2*14'd10000;
	wire [55:0] Non4 = $signed({1'd0,Non1})-$signed({1'd0,Non3});
	reg  [54:0] Non; //arredondado;
	reg  [25:0] Non_reg;
	
	
	//wire [54:0] delayn = (delay*(N+26'd2))/26'd360;
	
	wire [54:0] delayn1 = delay*(N+26'd2); 
	wire [54:0] delayn2 = delayn1/14'd360;//sem arredondar
	wire [54:0] delayn3 = delayn2*14'd360;
	wire [55:0] delayn4 = $signed({1'd0,delayn1})-$signed({1'd0,delayn3});
	reg  [54:0] delayn; //arredondado;
	
	reg [25:0] cnt; //contador do duty
	reg [25:0] cnt0; //contador de atraso inicial
	reg flag_cnt0;//flag para delay
	
	initial begin
		Non <= 55'd0;
		Non_reg <= 26'd0;
		q <= 1'b0;
		cnt <= 26'd0;
		cnt0 <= 26'd0;
		flag_cnt0 <= 1'd0;
	end
	
	//arredondamento certo 
	always @(*) begin
		if(Non4 >= $signed(56'd5000))
			Non <= Non2 + 1'd1;
		else
			Non <= Non2;
	end
	
	always @(*) begin
		if(delayn4 >= $signed(56'd180))
			delayn <= delayn2 + 1'd1;
		else
			delayn <= delayn2;
	end
	
	//delay inicial
	always @(posedge clk /*or negedge sclear*/) begin
		if (sclear == 1'd0) begin
			if (flag_cnt0 == 1'd0) begin
				if (cnt0 >= delayn[25:0])
					flag_cnt0 <= 1'd1;
				else
					cnt0 <= cnt0 + 1'd1;
			end
		end
		else begin
			flag_cnt0 <= 1'd0; cnt0 <= 26'd0;
		end
	end
	
	//pwm, começa dps do delay
	always @(posedge clk /*or posedge flag_cnt0*/) begin
		
//		if (sclear == 1'd1) begin
//			q <= 1'd0; 
//			cnt <= 26'd0; 
//			Non_reg <= Non[25:0]; 
//		end
//		else begin//reset
			//Garante a freq
			if (flag_cnt0 == 1'd1) begin //delay acabou  
				if (cnt < (N+26'd1)) begin//periodo
					if (cnt < Non_reg) begin//duty
						q <= 1'b1;
						cnt <= cnt + 26'd1;
					end
					else begin
						q <= 1'b0;
						cnt <= cnt + 26'd1;
					end
				end
				else begin
					Non_reg <= Non[25:0];//garante a nao mudança no meio
					cnt <= 26'd0;
				end
			end
			else begin //reset
				q <= 1'd0; 
				cnt <= 26'd0; 
				Non_reg <= Non[25:0]; 
			end
//		end
	end
	
	//assign y = q;//led saida gpio
	
endmodule
                                                                                                                                                                                