module compensador
	(
		input	            clk_Fs,
		input      			[31:0] e0, //tendo como 3.3 V equivalendo a 20 V e ADCbits = 4095d, essa entrada deve ser 20/4095 e mult por 10^8
		output reg signed [89:0] u0
		//output reg signed [69:0] u0
	);
	
	//reg signed [69:0]  u1 = 0, u2 = 0;
	reg signed [89:0]  u1 = 0, u2 = 0; 
	reg        [11:0]  e1 = 0, e2 = 0;
	
//tustin a 500k	
//	wire [49:0] B0 = $signed(338939228295820)  //3.38939228295820e-06,      // s^50 = 1.1259e15
//			  	   B1 = $signed(118926045016077)  //1.18926045016077e-07,
//			      B2 = $signed(-327046623794212) //-3.27046623794212e-06, //0.00000327046623794212 = 327046623794212E-20
//			      A1 = $signed(199356913183280)  //1.99356913183280,      //199356913183280 E14 
//			      A2 = $signed(-993569131832798) //-0.993569131832798;

   wire signed [1:0] B0 = $signed(2'd1),
						   B1 = $signed(2'd1),
						   B2 = $signed(2'd1),
						   A1 = $signed(2'd1),
						   A2 = $signed(2'd1);

	//assign u0 = A1*u1 + A2*u2 + B0*e0 + B1*e1 + B2*e2;
	
	
	//Amostragem
	always @(posedge clk_Fs) begin
		// u0 <= sum de 1 a 5(50*32) em bits 
		u0 <= A1*u1 + A2*u2 + B0*$signed(e0) + B1*$signed(e1) + B2*$signed(e2);
		
		u2 <= u1;
		u1 <= u0[30:0];
		e2 <= e1;
		e1 <= e0;
	
	end
	
		

endmodule
