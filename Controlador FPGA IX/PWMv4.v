//TIREI O NNNNNNNNNNN_REG Lá embaixo

//TIRAR O REGISTRO DO NON PARA TER MAIS EFICIENCIA
module PWMv4

	(	
		input clk, sclear,//reseta em alto e na verdade o clear é sincrono com clk base
		input [25:0] N, 
		input [13:0]D, 
		input [8:0] delay,//relacioando ao tempo, duty cycle e atraso
		output reg q//onda pwm
	);
	
	wire [25:0] period;
	assign period = N + 2'd2;
	
	//calculos para arredondamento
	wire [39:0] Non1 = D*period; 
	wire [39:0] Non2 = Non1/14'd10000;//sem arredondar
	wire [39:0] Non3 = Non2*14'd10000;
	wire signed [40:0] Non4 = $signed({1'd0,Non1})-$signed({1'd0,Non3});
	reg  [39:0] Non; //arredondado;
	
	
	//wire [54:0] delayn = (delay*(N+26'd2))/26'd360;
	
	wire [34:0] delayn1 = delay*period; 
	wire [34:0] delayn2 = delayn1/9'd360;//sem arredondar
	wire [34:0] delayn3 = delayn2*9'd360;
	wire signed [35:0] delayn4 = $signed({1'd0,delayn1})-$signed({1'd0,delayn3});
	reg  [34:0] delayn; //arredondado;
	
	reg [25:0] cnt; //contador do duty
	
	
	wire [26:0] delayNon;
	assign delayNon = delayn[25:0] + Non[25:0];
	reg signed [27:0] newNon;
	
	initial begin
		q <= 1'b0;
		cnt <= 26'd0;
	end
	
	
	
	
	
	
	
	
	//arredondamento certo 
	always @(*) begin
		if(Non4 >= $signed(41'd5000))
			Non <= Non2 + 1'd1;
		else
			Non <= Non2;
	end
	
	always @(*) begin
		if(delayn4 >= $signed(36'd180))
			delayn <= delayn2 + 1'd1;
		else
			delayn <= delayn2;
	end
	
	//mux para calcular se o duty passa do  tamanho do perio (N+2) ao aplicar dlay
		
	always @(*) begin
		if (delayNon > {1'd0,period})
			newNon <= $signed({1'd0,delayNon}) - $signed({2'd0,period});
		else
			newNon <= $signed(28'd0);
	end
	
	always @(*) begin
		if (cnt < delayn[25:0]) //se estiver no tempo do delay
												//se cnt menor que a diferença do duty + delay com o periodo
			q <= (cnt < newNon[25:0]);		// ou seja, excede o periodo a soma
		else                //caso dps do delay, trabalha normal + delay
			q <= (cnt < delayNon[25:0]);
			
	end
	
	//gerador de onda triangular
	always @(posedge clk /*or posedge flag_cnt0*/) begin
			if (sclear == 1'd0) //delay acabou  
				if (cnt <= N)//periodo
					cnt <= cnt + 26'd1;
				else
					cnt <= 26'd0;
			else//reset
				cnt <= 26'd0;
	end
	//assign q = (cnt < Non);
	//assign y = q;//led saida gpio
	
endmodule
                                                                                                                                                                                