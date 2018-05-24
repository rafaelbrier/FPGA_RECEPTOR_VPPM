module Coeff

#(
   parameter NBADD = 8,
   parameter NBITS = 16
)

(  input      [NBADD -1:0]  addr,
	output reg signed [NBITS:0]  out 
);
	
	
reg signed [NBITS:0] coeff [2**NBADD-1:0];       
           
initial begin   // coeff *10000  rounder
coeff[0]  =    17'd16				;
coeff[1]  =    17'd14				;
coeff[2]  =   -17'd24				;
coeff[3]  =   -17'd92				;
coeff[4]  =   -17'd136				;
coeff[5]  =   -17'd103				;
coeff[6]  =   -17'd13				;
coeff[7]  =    17'd50				;	
coeff[8]  =    17'd29				;
coeff[9]  =   -17'd35				;
coeff[10] =   -17'd50				;		
coeff[11] =    17'd6					;
coeff[12] =    17'd55				;
coeff[13] =    17'd25				;
coeff[14] =   -17'd45				;
coeff[15] =   -17'd54				;
coeff[16] =    17'd18				;
coeff[17] =    17'd70				;
coeff[18] =    17'd21				;
coeff[19] =   -17'd66				;
coeff[20] =   -17'd63				;
coeff[21] =    17'd36				;
coeff[22] =    17'd93				;
coeff[23] =    17'd14				;
coeff[24] =   -17'd96				;
coeff[25] =   -17'd74				;
coeff[26] =    17'd65				;
coeff[27] =    17'd123				;
coeff[28] =   -17'd1					;
coeff[29] =   -17'd142				;
coeff[30] =   -17'd84				;
coeff[31] =    17'd114				;
coeff[32] =    17'd166				;
coeff[33] =   -17'd32				;
coeff[34] =   -17'd216				;
coeff[35] =   -17'd93				;
coeff[36] =    17'd202				;
coeff[37] =    17'd238				;
coeff[38] =   -17'd102				;
coeff[39] =   -17'd362				;
coeff[40] =   -17'd99				;
coeff[41] =    17'd416				;
coeff[42] =    17'd412				;
coeff[43] =   -17'd325				;
coeff[44] =   -17'd886				;
coeff[45] =   -17'd103				;
coeff[46] =    17'd1982				;
coeff[47] =    17'd3825				;
coeff[48] =    17'd3825				;
coeff[49] =    17'd1982				;
coeff[50] =   -17'd103				;
coeff[51] =   -17'd886				;
coeff[52] =   -17'd325				;
coeff[53] =    17'd412				;
coeff[54] =    17'd416				;
coeff[55] =   -17'd99				;
coeff[56] =   -17'd362				;
coeff[57] =   -17'd102				;
coeff[58] =    17'd238				;
coeff[59] =    17'd202				;
coeff[60] =   -17'd93				;
coeff[61] =   -17'd216				;
coeff[62] =   -17'd32				;
coeff[63] =    17'd166				;
coeff[64] =    17'd114				;
coeff[65] =   -17'd84				;
coeff[66] =   -17'd142				;
coeff[67] =   -17'd1				   ;
coeff[68] =    17'd123				;
coeff[69] =    17'd65				;
coeff[70] =   -17'd74				;
coeff[71] =   -17'd96				;
coeff[72] =    17'd14				;
coeff[73] =    17'd93				;
coeff[74] =    17'd36				;
coeff[75] =   -17'd63				;
coeff[76] =   -17'd66				;
coeff[77] =    17'd21				;
coeff[78] =    17'd70				;
coeff[79] =    17'd18				;
coeff[80] =   -17'd54				;
coeff[81] =   -17'd45				;
coeff[82] =    17'd25				;
coeff[83] =    17'd55				;
coeff[84] =    17'd6				   ;
coeff[85] =   -17'd50			   ;
coeff[86] =   -17'd35				;
coeff[87] =    17'd29				;
coeff[88] =    17'd50				;
coeff[89] =   -17'd13				;
coeff[90] =   -17'd103				;
coeff[91] =   -17'd136				;
coeff[92] =   -17'd92				;
coeff[93] =   -17'd24				;
coeff[94] =    17'd14				;
coeff[95] =    17'd16		     	;   
coeff[96] =    17'd0 		     	;   
coeff[97] =    17'd0 		     	;   
coeff[98] =    17'd0 		     	; 
coeff[99] =    17'd0 		     	; 
coeff[100] =   17'd0 		     	;   


end

always @ (*) out = coeff[addr];

endmodule	
	
	