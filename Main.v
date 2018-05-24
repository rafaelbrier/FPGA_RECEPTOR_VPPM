module Main

#( parameter NBADD = 8,
   parameter NBITS1 = 16,
   parameter NBITS2 = 12
	)

(
	input                         clk,
	//input  signed     [NBITS2:0] adcRead,
	output reg signed [NBITS1-1:0] filteredOut

);

//ORDEM DO FILTRO 96 --- coeficientes multiplicados por 10000
parameter filtOrd = 8'd96;

reg [NBADD-1:0] jj;        //endereço memoria de coeficientes
reg [NBADD-1:0] pt;        //endereço memoria de entrada
reg [NBADD+4-1:0] kk;      //endereço memoria de saida
initial jj = 0;
initial pt = 0;
initial kk = 0;

reg signed [2*NBITS1-1:0] acc;

//MEMORIA DE COEFICIENTES ---------------------------------------------------------------
wire signed [NBITS1:0] coeff_out;
Coeff #(NBADD, NBITS1)Coeff(jj, coeff_out);

//MEMORIA DE ENTRADA --------------------------------------------------------------------
reg inBuff_wt;
wire signed [NBITS2:0] adcRead;     //TESTE
initial inBuff_wt = 1'b0;

wire signed [NBITS2:0]  inBuff_out; 
inBuff #(NBADD, NBITS2)inBuff(clk, inBuff_wt, adcRead, pt, inBuff_out);

//MEMORIA DE SAÍDA ---------------------------------------------------------------------
reg outBuff_wt;
initial outBuff_wt = 1'b0;

wire signed [NBITS1:0] outBuff_out;
outBuff #(NBADD+4, NBITS1)outBuff(clk, outBuff_wt, acc, kk, outBuff_out);


//TEST ---
 Sine Sine(kk, adcRead);

//FILTRAGEM -----------------------------------------------------------------------------
reg [1:0]delay;
initial delay = 0;
//ESTADOS
reg [3:0] q;
always @ (posedge clk) begin
case (q)
		4'd0   : q <= 4'd1;
		4'd1   : if(delay == 2)              q <= 4'd2;		else      q<= 4'd1;
		4'd2   : if (jj >= filtOrd-1)        q <= 4'd3;    else      q<= 4'd1;
		4'd3   : if (outBuff_wt == 1'b1)     q <= 4'd4;    else      q<= 4'd3;
		4'd4   : if (kk <= 2**(NBITS2-4))    q <= 4'd0;    else      q<= 4'd4;
		//4'd5   : q<=4'd0;
		default:                             q <= 4'd0;
	endcase	

end

//PROCESSMENTO
always @ (posedge clk) begin
if (q == 4'd0) begin  //Estado 0-------------------------------------------------
inBuff_wt = 1'b1;     //Escrever dado de entrada na posição pt do Buffer de entrada (inBuff(pt))
acc <= 0;             //Zera o acumulador
jj <= 0;              //Zera addr do coeff
end

else if (q == 4'd1) begin // Estado 1--------------------------------------------
inBuff_wt = 1'b0;     //Memória de entrada em modo leitura

if (delay == 2) begin
acc <= acc + inBuff_out*coeff_out; //Incrementa acumulador (Filtragem)
end

delay <= delay + 1'b1;
end

else if (q == 4'd2) begin //Estado 2 ---------------------------------------------
jj <= jj + 1'b1; //Incrementa variável jj (endereço da memoria de coeficiente)
if (pt == 0)      
pt <= filtOrd - 1'b1;  //Ponteiro do buffer circular (endereço da memoria de dados)
else
pt <= pt - 1'b1;

delay <=0;
end

else if (q == 4'd3) begin //Estado 3 ------------------------------------------------
outBuff_wt = 1'b1;   //Escrever dado de saída na posição kk do Buffer de saída (outBuff(kk))
acc <= acc/100; 
end

else if (q == 4'd4) begin //Estado 4 ------------------------------------------------
outBuff_wt = 1'd0;    //Não escreve mais na memoria de saída
filteredOut <= acc[NBITS1-1:0];  //Escrever em tempo real resultdo filtrado na saída
kk <= kk + 1'b1;

if (pt > filtOrd -1)
pt <= 0;
else
pt <= pt + 1'b1;
end

else if (q == 4'd5 ) begin
kk <= 0;
outBuff_wt = 1'd0;

end
end



endmodule