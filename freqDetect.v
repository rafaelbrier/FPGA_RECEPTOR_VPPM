module freqDetect
#(
	parameter bitsToWait = 3'd1 //Bits para esperar
)
(
	input clk,
	input reset,
	input signalIn,	
	output reg [31:0] frequency
);

parameter clockFreq = 32'd200000000;

reg startCountFlag;
reg freqIsSet;
reg [2:0] avrCount;
reg [31:0] freqCount;
reg freqCalcComplete;

initial begin
startCountFlag = 1'b0;
avrCount = 3'd0;
freqIsSet = 1'b0;
freqCount = 32'd0;
freqCalcComplete = 1'b0;
end

//Seguindo protocolo de começar com vários sequência de bits 0.
always @ (posedge signalIn) begin
if (reset) begin
freqIsSet <= 1'b0;
startCountFlag <= 1'b0;
avrCount <= 3'd0;
end
else if(!freqIsSet) begin
if(avrCount < bitsToWait) begin
startCountFlag <= 1'b1;
avrCount <= avrCount + 1'b1;
end
else begin
startCountFlag <= 1'b0;
avrCount <= 1'b0;
freqIsSet <= 1'b1;
end
end
end

always @ (posedge clk) begin
if(startCountFlag)
freqCount <= freqCount + 1'b1;
else if (frequency != 32'd0)
freqCount <= 32'd0;
end

always @ (posedge clk) begin
if(freqIsSet && freqCalcComplete) begin
frequency <= bitsToWait*clockFreq/freqCount;
freqCalcComplete <= 1'b0;
end
else if (!freqIsSet)
freqCalcComplete <= 1'b1;
end

endmodule