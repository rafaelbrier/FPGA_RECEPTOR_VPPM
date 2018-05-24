module saturator
(	
	//input iRST,
	input signed [26:0] D,
	output reg [25:0] duty
);

	always @(*) begin
//		if (!iRST)
//			duty <= 26'd0;
		if (D > $signed(27'd8000))
			duty <= 26'd8000;
		else if (D < $signed(27'd0))
			duty <= 26'd0;
		else
			duty <= D[25:0];
	end
		
endmodule
