module DemodComFreq
#( 
	parameter numberOfBitProtocolBegin = 4'd7
)
(
	input clk,
	input VppmIn,
	input freqAvailable,
	input [31:0] signalFrequency,
	output reg readPoint,
	output reg dataRead	
);

reg initFlag;
reg [24:0] cont;
reg protocolBegin;
reg [3:0] protocolCont;


initial begin
initFlag = 1'b0;
readPoint = 1'b0;
cont = 25'd0;
protocolCont = 4'b0;
end

//protocolBegin
always @ (posedge VppmIn) begin
if(protocolCont < numberOfBitProtocolBegin-1) begin
protocolCont<= protocolCont + 1'b1;
protocolBegin <= 1'b0;
end
else 
protocolBegin <= 1'b1;
end

//Trigger
always @ (posedge clk) begin
if(protocolBegin && freqAvailable )
initFlag <= 1'b1;
end

//Leitura
always @ (posedge clk) begin
if(initFlag) begin
if(cont == 25'd0) begin
dataRead <= ~VppmIn;
readPoint <= 1'b1;
end
else begin
readPoint <= 1'b0;
end
end
end


//Contador
always @ (posedge clk) begin
if(initFlag) begin
if(cont <= signalFrequency)
cont <= cont + 1'b1;
else
cont <= 1'b0;
end
end
endmodule

