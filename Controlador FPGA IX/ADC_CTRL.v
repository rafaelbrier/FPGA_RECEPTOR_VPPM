module ADC_CTRL	(	
					iRST,
					iCLK,
					iCLK_n,
					iGO,
					iCH,
					oLED,
					iDR,
					
					oDIN,
					oCS_n,
					oSCLK,
					iDOUT
				);
					
input				iRST;//key0
input				iCLK;
input				iCLK_n;//atrasado 180
input				iGO;//key1
input	[2:0]		iCH;//SW
output	[11:0]		oLED;//saida lembra de por pra 12 bits
output iDR;
// controle adc
output				oDIN;
output				oCS_n;
output				oSCLK;
input					iDOUT;

reg					data;
reg					go_en;
wire		[2:0]		ch_sel;
reg					sclk;
reg		[3:0]		cont;
reg		[3:0]		m_cont;
reg		[11:0]		adc_data;
reg		[11:0]		led;
reg 					dataReady;

initial begin
	go_en <= 1'd1;
end


assign	oCS_n		=	~go_en; //1 se reseta e 0 se ativaer
assign	oSCLK		=	(go_en)? iCLK:1; // se ativo, sai clock
assign	oDIN		=	data;
assign	ch_sel		=	iCH;
assign	oLED		=	led;
assign iDR = dataReady;

always@(posedge iGO or negedge iRST) //reset ou botao
begin
	if(!iRST)
		go_en	<=	0;
	else
	begin
	if(iGO)
			go_en	<=	1;
	end
end

always@(posedge iCLK or negedge go_en)
begin
	if(!go_en) //reset resetaa contador
		cont	<=	0;
	else
	begin
		if(iCLK) //iclk conta o contador
			cont	<=	cont + 1;
	end
end

always@(posedge iCLK_n)
begin
	if(iCLK_n) //m cont sempre ta atrasado de 1 do cont
		m_cont	<=	cont;
end

always@(posedge iCLK_n or negedge go_en)//isso ée um multiplex pros canais
begin
	if(!go_en)
		data	<=	0; // data 1 bit, reseta
	else
	begin
		if(iCLK_n)
		begin // data recebe cada dip sw e vai pro oDIN do adc SADDR
			if (cont == 2)
				data	<=	iCH[2];
			else if (cont == 3)
				data	<=	iCH[1];
			else if (cont == 4)
				data	<=	iCH[0];
			else
				data	<=	0;
		end
	end
end

always@(posedge iCLK or negedge go_en)
begin
	if(!go_en)
	begin
		adc_data	<=	0;
		led			<=	12'd0;
		dataReady <= 1'd0;
	end
	else
	begin
		if(iCLK)
		begin //para cada leitura tem um atrasao do 4 dps le 12 bits
			if      (m_cont == 3) 
				adc_data[11]	<=	iDOUT;
			else if (m_cont == 4) 
				adc_data[10]	<=	iDOUT;
			else if (m_cont == 5)
				adc_data[9]	<=	iDOUT;
			else if (m_cont == 6)
				adc_data[8]		<=	iDOUT;
			else if (m_cont == 7)
				adc_data[7]		<=	iDOUT;
			else if (m_cont == 8)
				adc_data[6]		<=	iDOUT;
			else if (m_cont == 9)
				adc_data[5]		<=	iDOUT;
			else if (m_cont == 10)
				adc_data[4]		<=	iDOUT;
			else if (m_cont == 11)
				adc_data[3]		<=	iDOUT;
			else if (m_cont == 12)
				adc_data[2]		<=	iDOUT;
			else if (m_cont == 13)
				adc_data[1]		<=	iDOUT;
			else if (m_cont == 14)
				adc_data[0]		<=	iDOUT;
			else if (m_cont == 15) 
				dataReady <= 1'd0;
			else if (m_cont == 1) begin
				led	<=	adc_data;
				dataReady <= 1'd1;
			end
		end
	end
end

endmodule