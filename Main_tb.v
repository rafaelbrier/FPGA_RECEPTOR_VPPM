module Main_tb();

reg clk;

initial begin
	clk = 1'b0;
end

always #10 clk <= ~clk;

//reg [11:0] in;
//wire signed[15:0] out;

//always @ (posedge clk) in<= in + 1'b1;

Mainn Mainn(clk);

endmodule