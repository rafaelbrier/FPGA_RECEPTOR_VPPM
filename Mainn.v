module Mainn

#(
   parameter NBITS = 12 
)
(
	input  clk,
	input bitRead

);

wire [NBITS:0] inCount;
wire inputRead;
wire clk_50, iCLK, iCLK_n, clk_200; 
wire clk_defFreq;
wire dataRead;
wire [31:0] freqCalculada1, freqCalculada2, freqCalculada3, freqCalculada4;
reg [31:0] vppmFrequencyDetected;

//PLL----------------------------------------------------------------------------------------
PLL32 PLL(clk, clk_50, iCLK, iCLK_n, clk_200);
//-------------------------------------------------------------------------------------------


//PARA SIMULAÇÃO---------------------------------------------------------------------------------
//Astavel (Parameter = 200MHz/(Freq*2) - 2)(Atual 10MHz)------------------------------------------------------
astavel #(25'd8)Astavel(clk_200, clk_defFreq);
//-------------------------------------------------------------------------------------------
//Counter------------------------------------------------------------------------------------
Counter #(NBITS)contador(clk_defFreq, inCount);
//-------------------------------------------------------------------------------------------
//Input(Gera sinal VPPM com freq = Astavel/2)(Atual 5MHz)--------------------------------------------------------------------
Input #(NBITS)Input(inCount, inputRead);
//-------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------


//Detectar Frequência--------------------------------------------------------------------------
freqDetect #(3'd1)freqDetector1(clk_200, inputRead, freqCalculada1);
freqDetect #(3'd2)freqDetector2(clk_200, inputRead, freqCalculada2);
freqDetect #(3'd3)freqDetector3(clk_200, inputRead, freqCalculada3);
freqDetect #(3'd4)freqDetector4(clk_200, inputRead, freqCalculada4);
//Calcular média (máximo 4 vezes, para menores colocar 0 no freqCalculada respectivo)
Median     #(3'd4)calcMedia(clk_200, freqCalculada1, freqCalculada2, freqCalculada3,
																							freqCalculada4);
//---------------------------------------------------------------------------------------------


//Demodulador (Parameter = 200MHz/SinalFreq - 2)(SinalFreq = AstavelFreq/2)--------------------------------------
Demodulador DemodVPPM(clk_200, inputRead, 32'd38, dataRead);
//---------------------------------------------------------------------------------------------

endmodule


