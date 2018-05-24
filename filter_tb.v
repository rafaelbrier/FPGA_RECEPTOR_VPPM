module Main_tb();

reg clk;

initial begin
	clk = 1'b0;
end

always #10 clk <= ~clk;

reg [11:0] in;
wire [11:0] sineout;
wire[15:0] out;

always @ (posedge clk) in<= in + 1'b1;

Sine Sine(in, sineout);

Main Main(clk, sineout, out);

endmodule