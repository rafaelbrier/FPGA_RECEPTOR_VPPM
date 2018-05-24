//TIRAR O REGISTRO DO NON PARA TER MAIS EFICIENCIA
module PWMv2

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
	
	reg  [25:0] N_reg;
	wire [25:0] period;
	assign period = N + 2'd2;
	
	//calculos para arredondamento
	wire [54:0] Non1 = D*period; 
	wire [54:0] Non2 = Non1/14'd10000;//sem arredondar
	wire [54:0] Non3 = Non2*14'd10000;
	wire [55:0] Non4 = $signed({1'd0,Non1})-$signed({1'd0,Non3});
	reg  [54:0] Non; //arredondado;
	
	
	//wire [54:0] delayn = (delay*(N+26'd2))/26'd360;
	
	wire [54:0] delayn1 = delay*period; 
	wire [54:0] delayn2 = delayn1/14'd360;//sem arredondar
	wire [54:0] delayn3 = delayn2*14'd360;
	wire [55:0] delayn4 = $signed({1'd0,delayn1})-$signed({1'd0,delayn3});
	reg  [54:0] delayn; //arredondado;
	
	reg [25:0] cnt; //contador do duty
	
	
	wire signed [26:0] delayNon;
	assign delayNon = $signed({1'd0,delayn[25:0]}) + $signed({1'd0,Non[25:0]});
	wire signed [26:0] newNon = delayNon - $signed({1'd0,period});
	
	initial begin
		Non <= 55'd0;
		N_reg <= 26'd0;
		q <= 1'b0;
		cnt <= 26'd0;
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
	
	//mux para calcular se o duty passa do  tamanho do perio (N+2) ao aplicar dlay
		
//	always @(*) begin
//		if (delayNon > $signed({1'd0,period}))
//			newNon <= delayNon - $signed({1'd0,period});
//		else
//			newNon <= 27'd0;
//	end
//	
//	always @(*) begin
//		if (cnt < delayn[25:0]) //se estiver no tempo do delay
//												//se cnt menor que a diferença do duty + delay com o periodo
//			q <= (cnt < newNon[25:0]);		// ou seja, excede o periodo a soma
//		else                //caso dps do delay, trabalha normal + delay
//			q <= (cnt < delayNon[25:0]);
//			
//	end
	
	always @(*) begin
		if (delayNon > $signed({1'd0,period}))//se o tempo de delay mais o tempo de duty ultrapassarem o periodo, 101
			
			if (cnt < delayn[25:0]) //se estiver no tempo do delay
				q <= (cnt < newNon[25:0]);		// recebe 1 até que o duty excedente do periodo acabe
			else                //caso dps do delay
				q <= 1'd1; //sempre dps do delay vai ser um
		else//se o tempo de delay mais o tempo de duty n ultrapassarem o periodo, 010
			if (cnt < delayn[25:0]) //se estiver no tempo do delay
				q <= 1'd0;		// smpre 0 antes delay
			else// dps do delay
				q <= (cnt < delayNon[25:0]);//recebe 1 até que acabe o tempo do duty
	end
	
	//gerador de onda triangular
	always @(posedge clk /*or posedge flag_cnt0*/) begin

			//Garante a freq
			if (sclear == 1'd0) begin //delay acabou  
				if (cnt <= N_reg) begin//periodo
					cnt <= cnt + 26'd1;
				end
				else begin
					N_reg <= N[25:0];//garante a nao mudança no meio
					cnt <= 26'd0;
				end
			end
			else begin //reset
				cnt <= 26'd0; 
				N_reg <= N[25:0]; 
			end
//		end
	end
	//assign q = (cnt < Non);
	//assign y = q;//led saida gpio
	
endmodule
                                                                                                                                                                                