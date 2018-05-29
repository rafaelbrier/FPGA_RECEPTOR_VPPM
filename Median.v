module Median
#(
	parameter NumberOfSamples = 3'd1
   
)
(
	input clk,	
	input [31:0] freq1, freq2, freq3, freq4,
	output reg [31:0] freqMedia
	
);

reg calc;

initial begin
calc = 1'b1;
freqMedia = 32'd0;
end

always @ (posedge clk) begin
if(calc)
freqMedia <= (freq1 + freq2 + freq3 + freq4)/NumberOfSamples;
end

always @ (posedge clk) begin
if(freqMedia != 32'd0)
calc<=1'b0;
end


endmodule
