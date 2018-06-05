module ram
#(
	parameter NBADD = 12,
	parameter NBITS = 1
)
(
	input                   clk, wt,
	input      [NBADD-1:0]  addr,
	input      [NBITS-1:0]  in,
	output reg [NBITS-1:0]  out
);

reg [NBITS-1:0] mem [2**NBADD-1:0];

initial begin   // Inicialização das variáveis
$readmemb("ram.mif",mem);		
  
end

always @ (*) out = mem[addr];

always @ (posedge clk) if(wt) mem[addr] <= in;

endmodule	