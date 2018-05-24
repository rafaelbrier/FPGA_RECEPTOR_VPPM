module PWM2_TOP
(

		input clk, sclear,//reseta em alto e na verdade o clear é sincrono com clk base
		input  [25:0] N, D, delay1, delay2,//relacioando ao tempo, duty cycle e atraso
		output q1, q2//onda pwm

);

PWMv2 p1(clk, ~sclear, N, D, delay1, q1);
PWMv2 p2(clk, ~sclear, N, D, delay2, q2);

endmodule