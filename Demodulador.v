module Demodulador 
(
	input clk,
	input VppmIn,
	input [31:0] signalFrequency,
	output reg dataRead
	
);

reg initFlag;
reg [24:0] cont;
reg readPoint;

initial begin
initFlag = 1'b0;
readPoint = 1'b0;
cont = 25'd0;
end

//Trigger
always @ (posedge VppmIn) begin
initFlag <= 1'b1;
end

//Leitura
always @ (posedge clk) begin
if(initFlag) begin
if(cont == 25'd0) begin
dataRead <= ~VppmIn;
readPoint <= 1'b1;
end
else
readPoint <= 1'b0;
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

