/*Esquema de protocolo proposto: 
--Sequência de 10 bits alternados para detecção de frequência: 1010101010
--Após a detecção da frequência, a sinalização do início da mensagem se da com
uma borda de subida, ou seja, transição 0->1.
--A mensagem terá um tamanho fixo Nbits_MSG = 128bits.
--Após os 128bits da mensagem, a mesma será considerada como recebida.
--Uma nova percepção de borda de subida 0->1 inicia a recepção de outra mensagem,
ou seja, a frequência será calculada novamente através dos 10bits inicias e assim
sucessivamente.
*/


module Mainn

#( parameter NBADD = 8,
   parameter NBITS1 = 16,
   parameter NBITS2 = 2,
	parameter N = 8'd96
	)

(
	input  clk
	

);

wire [NBADD+4:0] inCount;
wire signed [NBITS2:0] inputRead;
wire clk_50, iCLK, iCLK_n, clk_200; 

//PLL----------------------------------------------------------------------------------------
PLL32 PLL(clk, clk_50, iCLK, iCLK_n, clk_200);
//-------------------------------------------------------------------------------------------

//Input(Simulação_Apenas)--------------------------------------------------------------------
Input Input(inCount, inputRead);
//-------------------------------------------------------------------------------------------





endmodule



//wire [NBADD+4:0] inCount;
//wire signed [NBITS2:0] adcRead;
//wire signed [NBITS1-1:0] filteredOut;
//output signed [NBITS1-1:0] rms_value,
//output signed [NBITS1-1:0] avr_value,
//output signed [NBITS1-1:0] peak_value

//FIR_Filter #(NBADD,NBITS1,NBITS2)FIR_Filter(clk, adcRead, filteredOut, inCount);
//RMS #(NBADD,NBITS1,NBITS2,N)RMS(clk, inCount, filteredOut, rms_value);
//Median #(NBADD,NBITS1,NBITS2,N)Median(clk,inCount,filteredOut, avr_value);
//Peak #(NBADD,NBITS1,NBITS2,N)Peak(clk,inCount,filteredOut, peak_value);