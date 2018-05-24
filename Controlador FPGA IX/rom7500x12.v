module rom7500x12//na verdade tem 8192x12

	#(
		parameter FILE_NAME = "Io_c2.mif"
	)
	(
		input clk,
		input [9:0] add,///////////////
		output reg [11:0] data
	);

	//(* FILE_NAME *) ///////////////
	reg [11:0] mem [1023:0]; // numero de bits e numero de registradores

	initial begin
		$readmemb(FILE_NAME, mem);
	end

	always @ (posedge clk) begin
		data <= mem[add]; //o add é de 0 a 7 em binario, endereço da memoria
	end

endmodule
